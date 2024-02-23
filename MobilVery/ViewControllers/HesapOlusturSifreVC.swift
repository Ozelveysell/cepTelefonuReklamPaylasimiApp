import UIKit
import JGProgressHUD
import FirebaseAuth
import FirebaseFirestore
class HesapOlusturSifreVC: UIViewController {

    var ad: String?
    var soyad: String?
    var eposta: String?
    private let spinner = JGProgressHUD(style: .dark)

    @IBOutlet weak var hesapOlusturButton: UIButton!
    
    @IBOutlet weak var sifreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // UIButton'in kenarlarını yuvarlatma
        hesapOlusturButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        hesapOlusturButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
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

    @IBAction func hesapOlusturButtonClicked(_ sender: Any) {
        
        sifreText.resignFirstResponder()
        guard let sifre = sifreText.text else {
               // Şifre alanı boşsa hata mesajı gösterilebilir
               return
           }

           

           // Örnek şifre koşulu: En az 6 karakter
           if sifre.count < 6 {
               self.hataMesajiGoster("Şifre en az 6 karakter içermelidir.")
               
               return
           }
        spinner.show(in: view)


        Auth.auth().createUser(withEmail: eposta ?? "eposta gelmedi", password: sifre) { (authResult, error) in
            if let error = error {
                // Hata durumunda kullanıcıya bilgi verin
                self.hataMesajiGoster("Hata: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // Kullanıcı başarıyla oluşturulduğunda UID'yi alın
                
                
                UserDefaults.standard.setValue(self.eposta!, forKey: "email")
                UserDefaults.standard.setValue("\(self.ad!) \(self.soyad!)", forKey: "name")


                let chatUser = ChatAppUser(firstName: self.ad!,
                                           lastName: self.soyad!,
                                           emailAddress: self.eposta!)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        print("Database yükleme başarılı")
                       // self.hataMesajiGoster("Database yükleme başarılı")
                    }
                }

                
                let kullaniciUid = authResult.user.uid
                
                // Diğer kullanıcı bilgilerini Firebase veritabanına kaydedebilirsiniz
                // Örneğin Firestore kullanarak kaydetme işlemi:
                let db = Firestore.firestore()
                let kullaniciVerileri = [
                    "ad": self.ad ?? "",
                    "soyad": self.soyad ?? "",
                    "eposta": self.eposta ?? ""
                    
                ]
                
                // Firestore koleksiyonuna kullanıcı bilgilerini ekleyin
                db.collection("kullanicilar").document(kullaniciUid).setData(kullaniciVerileri) { error in
                    if let error = error {
                        self.hataMesajiGoster("Firestore hata: \(error.localizedDescription)")
                        print("Firestore hata: \(error.localizedDescription)")
                    } else {
                        
                        
                        
                        
                        
                        
                        
                        
                        print("Kullanıcı başarıyla Firestore'a kaydedildi.")
                        self.performSegue(withIdentifier: "toAnaSayfasegue3", sender: nil)
                    }
                }
            }
        }

           }
       }
    


