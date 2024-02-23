

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class IsletmeProfiliVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var adLabel: UILabel!
    
    @IBOutlet weak var ilLabel: UILabel!
    
    @IBOutlet weak var ilceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // İmajın köşelerini yuvarlak yap
       // imageView.layer.cornerRadius = imageView.frame.size.width / 2
     //   imageView.clipsToBounds = true
FirebaseVerileriniAl()
    }
    

    @IBAction func gorselSec(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    func FirebaseVerileriniAl() {
        let db = Firestore.firestore()
        
     let query = db.collection("isletmeler").whereField("eposta", isEqualTo: Auth.auth().currentUser?.email)
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return

            }
            guard let documents = querySnapshot?.documents else {
                print("Belgeler bulunamadı veya hata oluştu.")
                // Belgeler bulunamama veya hata durumunda yapılacak işlemleri burada gerçekleştirin
                return
            }
            for document in documents {
                
                let isletme = IsletmeModel(dictionary: document.data())
                
                self.adLabel.text = isletme.isletmeAdi
                self.ilLabel.text = isletme.il
                self.ilceLabel.text = isletme.ilce
          //      self.imageView.image
                
                
                
                if let imageUrl = isletme.gorselUrl, let url = URL(string: imageUrl) {
                    self.imageView.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                        if let error = error {
                            print("Resim yükleme hatası: \(error.localizedDescription)")
                            self.imageView.image = UIImage(named: "defaultImage") // Hata durumunda varsayılan bir görüntüyü yükle
                        }
                    })
                } else {
                    print("Resim URL'si eksik")
                    self.imageView.image = UIImage(named: "defaultImage") // URL eksikse varsayılan bir görüntüyü yükle
                }
                
                
                
            }
        
        }
        
    }
    


     
    @IBAction func kaydetButtonClicked(_ sender: Any) {
        // Seçilen fotoğrafı alın
             guard let image = imageView.image else {
                 
                 return
             }

             // Firebase Storage referansını alın
             let storageRef = Storage.storage().reference()

             // Resmin depolanacak yeri ve adını belirtin
             let imageRef = storageRef.child("images/image.jpg")
             // UIImage'ı veriye dönüştürün
             if let imageData = image.jpegData(compressionQuality: 0.5) {
                 // Resmi Firebase Storage'a yükleyin
                 imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                     if let error = error {
                         print("Resmi yüklerken hata oluştu: \(error.localizedDescription)")
                     } else {
                         print("Resim başarıyla Firebase Storage'a yüklendi.")
                         
                         // Resim yüklendikten sonra URL'yi alın
                         imageRef.downloadURL { (url, error) in
                             if let error = error {
                                 print("URL'yi alırken hata oluştu: \(error.localizedDescription)")
                             } else if let downloadURL = url {
                                 // Firebase Authentication ile oturum açmış kullanıcının e-posta adresini alın
                                 if let currentUser = Auth.auth().currentUser {
                                     let kullaniciEpostasi = currentUser.email
                                     
                                     // Firestore veritabanına erişim
                                     let db = Firestore.firestore()
                                     // Kullanıcıyı e-posta adresi ile sorgulayın
                                     db.collection("isletmeler").whereField("eposta", isEqualTo: kullaniciEpostasi).getDocuments { (querySnapshot, error) in
                                         if let error = error {
                                             print("Kullanıcı sorgulanırken hata oluştu: \(error.localizedDescription)")
                                         } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                                             // Kullanıcı bulundu, belgeyi güncelleyin
                                             if let document = documents.first {
                                                 document.reference.updateData(["profilFotoURL": downloadURL.absoluteString]) { error in
                                                     if let error = error {
                                                         print("Belge güncellenirken hata oluştu: \(error.localizedDescription)")
                                                     } else {
                                                         print("Belge başarıyla güncellendi.")
                                                     }
                                                 }
                                             }
                                         }
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
    }
    

