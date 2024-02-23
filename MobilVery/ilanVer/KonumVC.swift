

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class KonumVC: UIViewController , UITextViewDelegate{

    
    @IBOutlet weak var mahalleTextField: UITextField!
    
    @IBOutlet weak var caddeSokakTextField: UITextField!
    
    @IBOutlet weak var siteApartmanTextField: UITextField!
    
    @IBOutlet weak var ilceTextField: UITextField!
    
    @IBOutlet weak var ilTextField: UITextField!

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var ilaniPaylasButton: UIButton!
    
    @IBOutlet weak var label: UILabel!
    var adSoyad: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        
        // Do any additional setup after loading the view.
        label.numberOfLines = 3 // İki satıra izin ver
        //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text = "İlanınızı oluşturmadan önce adres bilgilerinizi dikkatlice kontrol edin. Yazım hataları veya eksik bilgiler, alıcıların ilanınızı bulmalarını zorlaştırabilir."
        
        
        // UIButton'in kenarlarını yuvarlatma
        ilaniPaylasButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        ilaniPaylasButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        
        // Klavye açılma ve kapanma olaylarını dinlemek için bildirimlere abone olun
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Arka plana dokunulduğunda klavyeyi kapatmak için UITapGestureRecognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
          // TextView'i temizle
          textView.text = ""
          return true // Dokunmaya izin ver
      }


 


    @IBAction func ilaniPaylasButtonClicked(_ sender: Any) {
        ilaniPaylasButton.isEnabled = false
        // 3 saniye sonra butonu tekrar etkinleştir
               DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                   self.ilaniPaylasButton.isEnabled = true
               }
        // Mahalle alanını kontrol et
         guard let mahalle = mahalleTextField.text, !mahalle.isEmpty else {
             // Mahalle alanı boş, uyarı mesajı göster
             showAlert("Mahalle alanını doldurun.")
             return
         }
         
         // Cadde/Sokak alanını kontrol et
         guard let caddeSokak = caddeSokakTextField.text, !caddeSokak.isEmpty else {
             // Cadde/Sokak alanı boş, uyarı mesajı göster
             showAlert("Cadde/Sokak alanını doldurun.")
             return
         }
         
         // Site/Apartman alanını kontrol et
         guard let siteApartman = siteApartmanTextField.text, !siteApartman.isEmpty else {
             // Site/Apartman alanı boş, uyarı mesajı göster
             showAlert("Site/Apartman alanını doldurun.")
             return
         }
         
         // İlçe alanını kontrol et
         guard let ilce = ilceTextField.text, !ilce.isEmpty else {
             // İlçe alanı boş, uyarı mesajı göster
             showAlert("İlçe alanını doldurun.")
             return
         }
         
         // İl alanını kontrol et
         guard let il = ilTextField.text, !il.isEmpty else {
             // İl alanı boş, uyarı mesajı göster
             showAlert("İl alanını doldurun.")
             return
         }
        IlanVeriYoneticisi.paylasilan.mahalle = mahalle;
        IlanVeriYoneticisi.paylasilan.sokak = caddeSokak;
        IlanVeriYoneticisi.paylasilan.siteApartman = siteApartman;
        IlanVeriYoneticisi.paylasilan.ilce = ilce;
        IlanVeriYoneticisi.paylasilan.sehir = il;
        
 
        
        let db = Firestore.firestore()

        // Fotoğrafları yüklemeden önce Firestore ilan verilerini hazırlayın
        IlanVeriYoneticisi.paylasilan.epostaAdresi = Auth.auth().currentUser?.email
            
   
            
            var ilanVerisi: [String: Any] = [
                "ilanId": IlanVeriYoneticisi.paylasilan.ilanId,
                "marka": IlanVeriYoneticisi.paylasilan.marka ?? "",
                "model": IlanVeriYoneticisi.paylasilan.model ?? "",
                "renk": IlanVeriYoneticisi.paylasilan.renk ?? "",
                "hafiza": IlanVeriYoneticisi.paylasilan.hafiza ?? "",
                "garanti": IlanVeriYoneticisi.paylasilan.garanti ?? "",
                "takas": IlanVeriYoneticisi.paylasilan.takas ?? "",
                "aciklama": IlanVeriYoneticisi.paylasilan.aciklama ?? "",
                "telefon": IlanVeriYoneticisi.paylasilan.telefon ?? "",
                "baslik": IlanVeriYoneticisi.paylasilan.baslik ?? "",
                "fiyat": IlanVeriYoneticisi.paylasilan.fiyat ?? "",
                "mahalle": IlanVeriYoneticisi.paylasilan.mahalle ?? "",
                "sokak": IlanVeriYoneticisi.paylasilan.sokak ?? "",
                "siteApartman": IlanVeriYoneticisi.paylasilan.siteApartman ?? "",
                "ilce": IlanVeriYoneticisi.paylasilan.ilce ?? "",
                "sehir": IlanVeriYoneticisi.paylasilan.sehir ?? "",
                "epostaAdresi": IlanVeriYoneticisi.paylasilan.epostaAdresi ?? "" ,
                "acilSatilikMi": IlanVeriYoneticisi.paylasilan.acilSatilikMi ?? "False",
                "adSoyad": IlanVeriYoneticisi.paylasilan.adSoyad ?? ""
            ]
       
             // Fotoğrafları yüklemek için bir döngü kullanın
                    let storage = Storage.storage()
                    let storageReference = storage.reference()
                    let mediaFolder = storageReference.child("galeri")
                    
                    var photoURLs: [String] = []
                    
                    for photo in IlanVeriYoneticisi.paylasilan.selectedPhotos {
                        if let data = photo.jpegData(compressionQuality: 0.5) {
                            let uuid = UUID().uuidString
                            let imageReference = mediaFolder.child("\(uuid).jpg")
                            
                            // Fotoğrafı Storage'a yükleyin
                            imageReference.putData(data, metadata: nil) { (metadata, error) in
                                if let error = error {
                                    print("Görsel yükleme hatası: \(error.localizedDescription)")
                                } else {
                                    // Yükleme başarılı olduysa, fotoğrafın URL'sini alın ve diziye ekleyin
                                    imageReference.downloadURL { (url, error) in
                                        if let imageUrl = url?.absoluteString {
                                            photoURLs.append(imageUrl)
                                            // Eğer tüm fotoğraflar yüklendiyse, Firestore verilerini güncelleyin
                                            if photoURLs.count == IlanVeriYoneticisi.paylasilan.selectedPhotos.count {
                                                ilanVerisi["selectedPhotos"] = photoURLs
                                                
                                                // Firestore koleksiyonuna veriyi ekleyin
                                                let ilanlarKoleksiyonu = db.collection("ilanlar")
                                                ilanlarKoleksiyonu.addDocument(data: ilanVerisi) { error in
                                                    if let error = error {
                                                        print("Firestore veri ekleme hatası: \(error.localizedDescription)")
                                                    } else {
                                                        print("Veri başarıyla Firestore'a eklendi.")
                                                        
                                                        ilanVerisi.removeAll() // Veriyi sıfırla
                                                        IlanVeriYoneticisi.paylasilan.selectedPhotos.removeAll() // Fotoğraf dizisini sıfırla
                                                        // Diğer öze
                                                        
                                                        if let navigationController = self.navigationController {
                                                            navigationController.popToRootViewController(animated: true)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        } else {
                                            print("Fotoğraf URL'sini alırken hata oluştu: \(error?.localizedDescription ?? "")")
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        
                    
                 
                
            }
        

     
                
            }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Klavye açılma olayı için tetiklenen işlev
    @objc func keyboardWillShow(_ notification: Notification) {
        // İsterseniz burada başka işlemler yapabilirsiniz
    }

    // Klavye kapanma olayı için tetiklenen işlev
    @objc func keyboardWillHide(_ notification: Notification) {
        // İsterseniz burada başka işlemler yapabilirsiniz
    }

    // Arka plana dokunulduğunda klavyeyi kapatmak için tetiklenen işlev
    @objc func dismissKeyboard() {
        view.endEditing(true) // Klavyeyi kapat
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        // Bildirim aboneliğini kaldırın
        NotificationCenter.default.removeObserver(self)
    }
    // Hata mesajını gösteren yardımcı bir fonksiyon
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
      //  alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)

        // Hata mesajını 1 saniye sonra otomatik olarak kapatmak için Timer kullanılıyor
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
