

import UIKit
import Firebase
import FirebaseFirestore

class IsletmelerDetayVC: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var isletmeAdiLabel: UILabel!
    
    @IBOutlet weak var isletmeTelefonLabel: UILabel!
    
    
    @IBOutlet weak var isletmeAdresLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tlfNo: String?
    var selectedEmail: String? // Seçilen ilanın ID'sini saklayacak değişken

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isletmeAdresLabel.numberOfLines = 2
        
        
        
        if selectedEmail != nil {
           FirebaseVerileriniAl()
        }
        
    }
    
    func FirebaseVerileriniAl() {
        let db = Firestore.firestore()
        
        if selectedEmail != nil {
            
            let query = db.collection("isletmeler").whereField("eposta", isEqualTo: selectedEmail!)
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
                    
                    self.isletmeAdiLabel.text = isletme.isletmeAdi
                    self.isletmeTelefonLabel.text = isletme.telefonNo
                    self.tlfNo = isletme.telefonNo!
                    self.isletmeAdresLabel.text = isletme.mahalle! + " " + isletme.caddeSokak! + " " + isletme.bina! + " " + isletme.ilce! + " " + isletme.il!
                    
                    
                    
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
            
        }}
    
    

    @IBAction func nasilGiderimButtonClicked(_ sender: Any) {
    }
    
    func ara(telefonNo: String){
        let phoneNumber = telefonNo // Aramak istediğiniz telefon numarasını buraya ekleyin

        if let url = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Cihaz telefon aramalarını başlatamıyorsa (örneğin, iPod Touch veya iPad gibi), kullanıcıya bir hata mesajı gösterin.
                let alertController = UIAlertController(title: "Hata", message: "Bu cihazda telefon araması yapılamıyor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func mesajGonderButtonClicked(_ sender: Any) {
        
        if selectedEmail != nil {
            
            performSegue(withIdentifier: "isletmeToMesajVC", sender: selectedEmail)

            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "isletmeToMesajVC" {
            if let selectedEmail = sender as? String {
                if let destinationVC = segue.destination as? ConversationsViewController {
                    // Mesaj gönderilecek kişinin kimliğini veya bilgilerini MesajViewController'a iletiyoruz
                    destinationVC.selectedEmail = selectedEmail
                }
            }
        }
    }

    
    
    @IBAction func araButtonClicked(_ sender: Any) {
        
        if tlfNo != nil {
            
            ara(telefonNo: tlfNo!)
            
            
        }
    }
    

}

