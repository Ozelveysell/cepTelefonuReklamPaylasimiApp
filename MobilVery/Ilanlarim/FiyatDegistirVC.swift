
import UIKit
import FirebaseFirestore

class FiyatDegistirVC: UIViewController {
    
    
    @IBOutlet weak var fiyatText: UITextField!
    
    @IBOutlet weak var label: UILabel!
    var selectedIlanID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.numberOfLines = 3
        label.text = "Dikkat, reklamınızın fiyatını değiştirmek üzeresiniz. Bu eylem geri alınamaz. Fiyatı yalnızca bir kez değiştirme hakkınız vardır."
        
        // Arka plana dokunulduğunda klavyeyi kapatmak için UITapGestureRecognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // Arka plana dokunulduğunda klavyeyi kapatmak için tetiklenen işlev
    @objc func dismissKeyboard() {
        view.endEditing(true) // Klavyeyi kapat
    }
    
    
    @IBAction func kaydetButtonClicked(_ sender: Any) {
        
        
        if fiyatText.text != "" {
                let alertController = UIAlertController(
                    title: "Fiyatı Değiştir",
                    message: "İlanın fiyatını değiştirmek istediğinizden emin misiniz?",
                    preferredStyle: .alert
                )

                let tamamAction = UIAlertAction(title: "Tamam", style: .default) { (_) in
                    if let yeniFiyat = self.fiyatText.text, !yeniFiyat.isEmpty {
                        if let selectedIlanID = self.selectedIlanID {
                            let db = Firestore.firestore()

                            // Belgeyi bulmak için sorgu oluştur
                            let query = db.collection("ilanlar").whereField("ilanId", isEqualTo: selectedIlanID)

                            // Belgeyi al ve güncelle
                            query.getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("Belge alınamadı: \(error.localizedDescription)")
                                } else if let documents = snapshot?.documents, !documents.isEmpty {
                                    let ilanRef = documents[0].reference

                                    // Yeni fiyatı Firestore'da güncelle
                                    ilanRef.updateData(["fiyat": yeniFiyat]) { (updateError) in
                                        if let updateError = updateError {
                                            print("Fiyat güncelleme hatası: \(updateError.localizedDescription)")
                                        } else {
                                            print("Fiyat başarıyla güncellendi.")
                                        }
                                    }
                                } else {
                                    print("Belge bulunamadı veya silinmiş.")
                                }
                            }
                        }
                    }
                }

                let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

                alertController.addAction(tamamAction)
                alertController.addAction(iptalAction)

                present(alertController, animated: true, completion: nil)
            }
        }
    }
