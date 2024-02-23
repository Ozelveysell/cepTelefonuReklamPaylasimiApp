

import UIKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD
class GirisYapEpostaVC: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    @IBOutlet weak var epostaGirisButton: UIButton!
    
    
    @IBOutlet weak var epostaText: UITextField!
    
    @IBOutlet weak var sifreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // UIButton'in kenarlarını yuvarlatma
        epostaGirisButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        epostaGirisButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        
        sifreText.autocapitalizationType = .none
        sifreText.autocorrectionType = .no
        sifreText.isSecureTextEntry = true
        
    }
    
    @IBAction func epostaGirisButtonClicked(_ sender: Any) {
        
        epostaText.resignFirstResponder()
        sifreText.resignFirstResponder()
  
        spinner.show(in: view)

        // E-posta ve şifre alanlarının boş olup olmadığını kontrol et
             guard let eposta = epostaText.text, !eposta.isEmpty,
                   let sifre = sifreText.text, !sifre.isEmpty else {
                 hataMesajiGoster("E-posta ve şifre alanları boş olamaz.")
                 spinner.dismiss()
                 return
             }

             // Firebase Authentication ile giriş yap
             Auth.auth().signIn(withEmail: eposta, password: sifre) { [weak self] (authResult, error) in
                 guard let self = self else { return }
                 
                 DispatchQueue.main.async {
                     self.spinner.dismiss()
                 }

                 if let error = error {
                     // Hata durumunda kullanıcıya bilgi verin
                     //self.hataMesajiGoster("Giriş yapılırken bir hata oluştu: \(error.localizedDescription)")
                     let hataMesaji = turkceHataMesaji(error: error)
                     self.hataMesajiGoster(hataMesaji)

                 } else {
                     // Kullanıcı başarıyla giriş yaptığında istediğiniz işlemleri yapabilirsiniz
                     
                     
                     
                     
                     if let kullaniciUid = authResult?.user.uid {
                         let db = Firestore.firestore()

                         let kullaniciRef = db.collection("kullanicilar").document(kullaniciUid)

                         kullaniciRef.getDocument { (document, error) in
                             if let document = document, document.exists {
                                 let userData = document.data()
                                 if let firstName = userData?["ad"] as? String,
                                    let lastName = userData?["soyad"] as? String {
                                     // Kullanıcı adını ve soyadını al
                                     UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                                     print(firstName , lastName)
                                 }
                             } else {
                                 print("Kullanıcı belgesi bulunamadı veya bir hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen Hata")")
                             }
                         }

                         // E-posta adresini sakla
                         UserDefaults.standard.set(eposta, forKey: "email")
                         print(eposta)
                         // Kullanıcıyı oturumdan çıkar
                         self.navigationController?.dismiss(animated: true, completion: nil)

                         
                         performSegue(withIdentifier: "toAnaSayfaSegue2", sender: nil)
                         // Örneğin, ana ekrana yönlendirme veya diğer işlemleri burada yapabilirsiniz
                     }
                 }
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

    func turkceHataMesaji(error: Error) -> String {
        let errorKodu = (error as NSError).code

        switch errorKodu {
        case AuthErrorCode.networkError.rawValue:
            return "Ağ hatası oluştu. Lütfen internet bağlantınızı kontrol edin."
        case AuthErrorCode.userNotFound.rawValue:
            return "Bu kullanıcı bulunamadı."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Yanlış şifre girdiniz. Lütfen tekrar deneyin."
        // Diğer hata kodları için aynı şekilde çeviriler ekleyebilirsiniz.
        default:
            return "Bir hata oluştu."
        }
    }


    @IBAction func hesapOlusturButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toHesapOlusturSegue", sender: nil)
    }
    
    
    @IBAction func sifremiUnuttumButtonClicked(_ sender: Any) {
    }
    
    
}
