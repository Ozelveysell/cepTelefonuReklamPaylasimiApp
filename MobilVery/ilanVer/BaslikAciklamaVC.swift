
import UIKit

class BaslikAciklamaVC: UIViewController , UITextViewDelegate {

    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var baslikText: UITextField!
    
    
    @IBOutlet weak var aciklamaTextView: UITextView!
    
    
    @IBOutlet weak var kaydetVeIlerleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aciklamaTextView.delegate = self
        
        // Do any additional setup after loading the view.
        label.numberOfLines = 3 // İki satıra izin ver
        //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text = "İlanınıza detaylı açıklamalar eklemek, alıcıların daha fazla bilgi sahibi olmalarına yardımcı olur. Bu da hızlı bir satışa katkı sağlar"
        
        
        // UIButton'in kenarlarını yuvarlatma
        kaydetVeIlerleButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        kaydetVeIlerleButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        
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

    @IBAction func kaydetVeIlerleButtonClicked(_ sender: Any) {
        
          // Kullanıcının girdiği verileri al
               let baslik = baslikText.text ?? ""
               let aciklama = aciklamaTextView.text ?? ""
               
               // Gerekli alanları doldurup doldurmadığını kontrol et
               if  baslik.isEmpty || aciklama.isEmpty  {
                   // Eğer gerekli alanlardan herhangi biri boşsa, uyarı mesajı göster
                
                
                  hataMesajiGoster("Uyarı! Lütfen tüm alanları doldurun.")
                  
               } else {
                 
                                          
                       IlanVeriYoneticisi.paylasilan.aciklama = aciklama;
                       IlanVeriYoneticisi.paylasilan.baslik  = baslik;
                   print(IlanVeriYoneticisi.paylasilan.baslik)

                   print(IlanVeriYoneticisi.paylasilan.aciklama)

           performSegue(withIdentifier: "toKonumVC", sender: nil)
               }
    }
    

    // Text alanlarına dokunulduğunda klavyenin açılmasını sağlamak için UITextFieldDelegate ve UITextViewDelegate işlevleri
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
