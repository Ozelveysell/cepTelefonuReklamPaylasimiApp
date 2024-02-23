
import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class IlanlarimVC: UIViewController {

    var ilanlar: [IlanModel] = []
    var selectedIlanID: String? // Seçilen ilanın ID'sini saklayacak değişken
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
   /*     let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: "toIlanlarimdanGirise", sender: nil)
        } else{
            
            FirebaseVerileriniAl(forUserWithEmail: (currentUser?.email)!)
        } */
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
       


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: "toIlanlarimdanGirise", sender: nil)
        } else{
            
            FirebaseVerileriniAl(forUserWithEmail: (currentUser?.email)!)
        }
        
    }
    
 
    @objc private func refreshData() {
        // Yenileme işlemini burada gerçekleştirin
        
        // Örneğin, verilerinizi yenileyebilirsiniz:
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: "toIlanlarimdanGirise", sender: nil)
        } else{
            
            
            FirebaseVerileriniAl(forUserWithEmail: (currentUser?.email)!)
        }
        
        // Yenileme işlemi tamamlandığında refreshControl'ı durdurun
        tableView.refreshControl?.endRefreshing()
    }
    func FirebaseVerileriniAl() {
        let db = Firestore.firestore()
        db.collection("ilanlar").getDocuments { (snapshot, error) in
            if let error = error {
              //  self.showAlert(title: "Hata", message: "Veri çekme hatası")
                print("Veri çekme hatası")
                return
            }
            
            guard let documents = snapshot?.documents else {
            //    self.showAlert(title: "Hata", message: "Belge bulunamadı.")
              print("Belge bulunamadı.")
                return
            }
            
            self.ilanlar = documents.compactMap { IlanModel(dictionary: $0.data()) }
            self.tableView.reloadData() // Verileri çektikten sonra TableView'i güncelle

        }
      
    }
    func FirebaseVerileriniAl(forUserWithEmail userEmail: String) {
        let db = Firestore.firestore()
        
        // "ilanlar" koleksiyonundan sadece belirli bir kullanıcının e-postasına sahip ilanları almak için filtreleme yapın.
        db.collection("ilanlar")
            .whereField("epostaAdresi", isEqualTo: userEmail)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Veri çekme hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("Belge bulunamadı.")
                    return
                }
                
                self.ilanlar = documents.compactMap { IlanModel(dictionary: $0.data()) }
                self.tableView.reloadData() // Verileri çektikten sonra TableView'i güncelle
            }
    }
 

}


extension IlanlarimVC: UITableViewDelegate , UITableViewDataSource  , UISearchBarDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIlanlarimDetayVC" {
            if let destinationVC = segue.destination as? IlanlarimDetayVC {
                destinationVC.selectedIlanID = selectedIlanID
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ilanlarimCell", for: indexPath) as! IlanlarimCell
        let ilan = ilanlar[indexPath.row]
        
        cell.baslikLabel.text = ilan.baslik ?? ""
          cell.fiyatLabel.text = ilan.fiyat ?? ""
          cell.konumLabel.text = "\(ilan.ilce ?? ""), \(ilan.sehir ?? "")"
          cell.markaModelLabel.text = "\(ilan.marka ?? ""), \(ilan.model ?? "")"
        // İlanın fotoğraf URL'sini kontrol et
 
        if let imageUrl = ilan.selectedPhotos.first, let url = URL(string: imageUrl) {
             cell.imageView2.sd_setImage(with: url) { (image, error, cacheType, url) in
                 if let error = error {
                     print("Resim yükleme hatası: \(error.localizedDescription)")
                     cell.imageView2?.image = UIImage(named: "mobilVeryImage")
                 }
             }
         } else {
             print("Resim URL'si eksik")
             cell.imageView2?.image = UIImage(named: "mobilVeryImage")
         }
          
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.75
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ilanlar.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIlanID = ilanlar[indexPath.row].ilanId

        performSegue(withIdentifier: "toIlanlarimDetayVC", sender: nil)

    }


}
