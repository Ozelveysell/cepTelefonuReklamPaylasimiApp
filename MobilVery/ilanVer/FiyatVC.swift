
import UIKit
import FirebaseAuth
import FirebaseFirestore
class FiyatVC: UIViewController {
    
    
    @IBOutlet weak var acilSatilikSwitch: UISwitch!
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var fiyatText: UITextField!
    var acilSatilikMi = false
    
    
    @IBOutlet weak var kaydetVeIlerleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        label.numberOfLines = 10 // İki satıra izin ver
        //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text =       "Ilanınızda 'acil satılıktır' butonunu kullanırken, gerçekten acil bir satışa ihtiyacınızın olduğundan emin olun. Eğer gerçekten acele bir şekilde satmanız gereken bir ürününüz yoksa, bu ifadeyi kullanmaktan kaçının. Ayrıca, bu tür bir ifade kullanarak potansiyel alıcıların dikkatini çektiğinizde, fiyatlandırma politikanızı gözden geçirin. Eğer gerçekten acil bir satış yapmanız gerekiyorsa, ürünü daha rekabetçi bir fiyata sunabilirsiniz."
        
        
        // UIButton'in kenarlarını yuvarlatma
        kaydetVeIlerleButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        kaydetVeIlerleButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        
        
        fiyatText.keyboardType = .numberPad // Sadece rakamları göster
        
        // Arka plana dokunulduğunda klavyeyi kapatmak için UITapGestureRecognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    // Arka plana dokunulduğunda klavyeyi kapatmak için tetiklenen işlev
    @objc func dismissKeyboard() {
        view.endEditing(true) // Klavyeyi kapat
    }
    
    func FirebaseIsimCek(email: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()

        let query = db.collection("kullanicilar").whereField("eposta", isEqualTo: email)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                // Hata durumunda yapılacak işlemleri burada gerçekleştirin
                completion(nil) // Hata durumunda nil döndürün
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("Belgeler bulunamadı veya hata oluştu.")
                // Belgeler bulunamama veya hata durumunda yapılacak işlemleri burada gerçekleştirin
                completion(nil) // Hata durumunda nil döndürün
                return
            }

            // Eğer belge bulunduysa, ilk belgeyi alabiliriz (e-posta adresinin benzersiz olduğunu varsayarsak).
            if let firstDocument = documents.first {
                // "ad" ve "soyad" alanlarını alma
                if let ad = firstDocument["ad"] as? String,
                   let soyad = firstDocument["soyad"] as? String {
                   // Elde edilen ad ve soyadı kullanabiliriz.
                    
                    let adSoyad = ad.lowercased() + " " + soyad.lowercased()
                    completion(adSoyad) // Başarılı sonucu tamamlama kapatıcısına iletin
                } else {
                    completion(nil) // Veriler eksikse nil döndürün
                }
            } else {
                completion(nil) // Belge bulunamazsa nil döndürün
            }
        }
    }
    
    
    
    @IBAction func kaydetVeIlerleButtonClicked(_ sender: Any) {
        if fiyatText.text != "" {
            IlanVeriYoneticisi.paylasilan.fiyat = fiyatText.text!
            print(IlanVeriYoneticisi.paylasilan.fiyat)
            
            let email = Auth.auth().currentUser?.email
            
            self.FirebaseIsimCek(email: email!) { [weak self] adSoyad in
                IlanVeriYoneticisi.paylasilan.adSoyad = adSoyad
                print(IlanVeriYoneticisi.paylasilan.adSoyad)
            }
                IlanVeriYoneticisi.paylasilan.acilSatilikMi = acilSatilikSwitch.isOn
                print(IlanVeriYoneticisi.paylasilan.acilSatilikMi)
                performSegue(withIdentifier: "toIletisimVC", sender: nil)
            } else{
                self.hataMesajiGoster("Lütfen ürününüze ait fiyat kısmını doldurunuz.")
            }
        }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            
            // UISwitch açıkken uyarı mesajı göster
            let alertController = UIAlertController(
                title: "Acil Satılıktır",
                message: "Bu özelliği açtığınızda, ürününüz 'Acil Satılık' olarak işaretlenecektir.",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "Devam Et", style: .default, handler: nil))
            
            
            alertController.addAction(UIAlertAction(title: "İptal", style: .cancel) { _ in
                // UISwitch'i kapatın
                sender.isOn = false
            })
            
            present(alertController, animated: true, completion: nil)
        }
    }
        // Hata mesajını gösteren yardımcı bir fonksiyon
        func hataMesajiGoster(_ mesaj: String) {
            let alertController = UIAlertController(title: "Bilgi", message: mesaj, preferredStyle: .alert)
            //  alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            // Hata mesajını 1 saniye sonra otomatik olarak kapatmak için Timer kullanılıyor
            let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }

