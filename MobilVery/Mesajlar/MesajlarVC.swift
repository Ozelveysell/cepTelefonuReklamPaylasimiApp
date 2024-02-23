
import UIKit
import FirebaseAuth
import FirebaseFirestore

class MesajlarVC: UIViewController {
    
    
    
    var mesajlar: [Mesaj] = []

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    //    tableView.separatorStyle = .none

        fetchPreviousMessagesForCurrentUser() // Verileri Firebase'den çek


       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Görünüm ekranda görünmeden önce yapılacak işlemleri burada yapabilirsiniz.
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: "toMesajlardanGirise", sender: nil)
        }
    }
    
    
    func fetchPreviousMessagesForCurrentUser() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Kullanıcı oturumu açmış değil.")
            return
        }

        let db = Firestore.firestore()

        let query = db.collection("mesajlar").whereFilter(Filter.orFilter([
                        Filter.whereField("gönderen", isEqualTo: currentUserEmail),
                        Filter.whereField("alici", isEqualTo: currentUserEmail)
                        
                    ]))
          
                  //       .limit(to: 1) // Yalnızca son mesajı alın
                         .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Mesajları çekerken hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("Önceki mesajlar bulunamadı.")
                return
            }

            // Firestore'dan çekilen belgeleri Mesaj nesnelerine dönüştürün
            for document in documents {
                if let mesaj = Mesaj(dictionary: document.data()) {
                    self.mesajlar.append(mesaj)
                   
                }
            }

            // TableView'i güncelleyin
            self.tableView.reloadData()
        }
    }


  

}
extension MesajlarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesajlar.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mesajCell", for: indexPath) as! MesajlarTableViewCell
        
        
        let mesaj = mesajlar[indexPath.row]
        
        cell.adSoyadLabel.text = mesaj.gönderen
        cell.icerikLabel.text = mesaj.mesaj
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss" // Tarih biçimini belirleyin
        if let tarih = mesaj.tarih {
            let tarihString = dateFormatter.string(from: tarih)
            cell.tarihLabel.text = tarihString
        } else {
            cell.tarihLabel.text = nil // Tarih değeri nil ise, tarihLabel'ı boşaltın veya varsayılan bir değer atayın.
        }

       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMesajlarIcerikVC", sender: nil)
    }
}
