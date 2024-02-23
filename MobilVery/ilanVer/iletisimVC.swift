

import UIKit

class iletisimVC: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var iletisimText: UITextField!
    
    @IBOutlet weak var kaydetVeIlerleButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        label.numberOfLines = 4
        
        label.text = "Alıcılarla iletişimde hızlı ve net olun. Soruları hızlı bir şekilde yanıtlayarak ve randevuları kolayca ayarlayarak satış sürecini hızlandırabilirsiniz."
        
        
        // UIButton'in kenarlarını yuvarlatma
        kaydetVeIlerleButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        kaydetVeIlerleButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın

        // Arka plana dokunulduğunda klavyeyi kapatmak için UITapGestureRecognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // UITextField'i bu sınıfa delegelik yapması için ayarla
        iletisimText.keyboardType = .numberPad // Sadece rakamları göster
        // UITextField'in özelliklerini ayarlayın
              iletisimText.placeholder = "0 (XXX) XXX XXXX"
              iletisimText.delegate = self
    }
    
    // Arka plana dokunulduğunda klavyeyi kapatmak için tetiklenen işlev
      @objc func dismissKeyboard() {
          view.endEditing(true) // Klavyeyi kapat
      }

  
    @IBAction func kaydetVeIlerleButtonClicked(_ sender: Any) {
        if iletisimText.text != "" {
            IlanVeriYoneticisi.paylasilan.telefon = iletisimText.text!
            print(IlanVeriYoneticisi.paylasilan.telefon)

            performSegue(withIdentifier: "toBaslikAciklamaVC", sender: nil)
        }else{
            self.hataMesajiGoster("Lütfen ürününüze ait irtibat no kısmını doldurunuz.")
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
    // UITextField'in içeriği değiştiğinde çağrılan işlev
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Mevcut metin ve eklenen karakteri birleştirin
           if let text = textField.text, let textRange = Range(range, in: text) {
               let updatedText = text.replacingCharacters(in: textRange, with: string)

               // Temizlenmiş numara, sadece rakamları içermeli
               let cleanedPhoneNumber = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

               // Temizlenmiş numara uzunluğunu kontrol edin
               if cleanedPhoneNumber.count <= 11 {
                   // İlk rakam "0" olacak şekilde formatı ayarlayın
                   let formattedPhoneNumber: String
                   if cleanedPhoneNumber.isEmpty {
                       formattedPhoneNumber = "0"
                   } else {
                       formattedPhoneNumber =  cleanedPhoneNumber
                   }
                   textField.text = formattedPhoneNumber
               }

               return false
           }

           return true
       }



    // Telefon numarasının geçerli olup olmadığını kontrol eden işlev
      func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
          // Temizlenmiş numara, 11 karakter uzunluğunda olmalı
          let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
          return cleanedPhoneNumber.count == 11
      }
  
  
}
