//
//  HesapOlusturEpostaVC.swift
//  MobilVery
//
//  Created by veysel on 8.09.2023.
//

import UIKit
import FirebaseAuth
class HesapOlusturEpostaVC: UIViewController {

    
    @IBOutlet weak var adText: UITextField!
    
    @IBOutlet weak var soyadText: UITextField!
    
    @IBOutlet weak var epostaText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func devamEtButtonClicked(_ sender: Any) {
      //  performSegue(withIdentifier: "toHesapOlusturSifreVC", sender: nil)
        guard let email = epostaText.text else {
              // E-posta ve şifre girilmemişse hata mesajı gösterebilirsiniz
            self.hataMesajiGoster("Eposta giriniz")
              return
          }

          // E-posta adresinin daha önce kullanılıp kullanılmadığını kontrol etmek için
          Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
              if let error = error {
                  self.hataMesajiGoster("Hata: \(error.localizedDescription)")
               
                  return
              }

              if let methods = methods, methods.contains(EmailAuthProviderID) {
                  // E-posta adresi zaten kullanılıyor, kullanıcıyı uyarma mesajını gösterin
                  
                  self.hataMesajiGoster("Bu e-posta adresi zaten kullanılıyor.")
              }  else {
                  // E-posta adresi kullanılmıyorsa, ad ve soyadı kaydedin ve HesapOlusturSifreVC'ye yönlendirin
                  let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard adınıza göre güncelleyin
                  if let hesapOlusturSifreVC = storyboard.instantiateViewController(withIdentifier: "HesapOlusturSifreVC") as? HesapOlusturSifreVC {
                      hesapOlusturSifreVC.ad = self.adText.text
                      hesapOlusturSifreVC.soyad = self.soyadText.text
                      hesapOlusturSifreVC.eposta = self.epostaText.text
                      self.navigationController?.pushViewController(hesapOlusturSifreVC, animated: true)
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
}
