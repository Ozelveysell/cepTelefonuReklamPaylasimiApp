
import FirebaseAuth
import FirebaseFirestore
import UIKit

class HesapBilgilerimViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var ozellikDizisi: [String] = []
    var labelDizisi = ["Adi" , "Soyadi" , "Email"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        firebaseVeriCek()
        
    }
    
    func firebaseVeriCek(){
        
        let email = Auth.auth().currentUser?.email
        
        let db = Firestore.firestore()
        
        let query = db.collection("kullanicilar").whereField("eposta", isEqualTo: email)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                // Hata durumunda yapılacak işlemleri burada gerçekleştirin
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Belgeler bulunamadı veya hata oluştu.")
                // Belgeler bulunamama veya hata durumunda yapılacak işlemleri burada gerçekleştirin
                return
            }
            
            // Resetleme
            self.ozellikDizisi.removeAll()
            
            // Belgeler var ve çekildi
            for document in documents {
                let kullaniciModel = KullaniciModel(dictionary: document.data())
                
                // Verileri dizilere ekle
                self.ozellikDizisi.append(contentsOf: [
                    kullaniciModel.ad!,
                    kullaniciModel.soyad!,
                    kullaniciModel.email!
                   
               ])
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
        
    }




extension HesapBilgilerimViewController: UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ozellikDizisi.isEmpty {
            return 1
        }
        return ozellikDizisi.count + 2
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hesapBilgilerimCell", for: indexPath) as! HesapBilgilerimTableViewCell
        if !ozellikDizisi.isEmpty {
            cell.ozellikLabel.text = labelDizisi[indexPath.row]
            cell.kisiselOzellikText.text = ozellikDizisi[indexPath.row]
            }
        if indexPath.row == ozellikDizisi.count + 1 {
            cell.kisiselOzellikText.delete(nil)
           
            cell.ozellikLabel.text = "E posta degistir ?"
        }
        if indexPath.row == ozellikDizisi.count + 2 {
            cell.kisiselOzellikText.delete(nil)
            cell.ozellikLabel.text = "Sifremi degistir ?"
        }
    return cell
    }
}
