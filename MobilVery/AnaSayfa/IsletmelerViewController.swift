

import UIKit
import Firebase
import SDWebImage

class IsletmelerViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{
    
    var isletmeModelleri: [IsletmeModel] = []
    var selectedEmail: String? // Seçilen ilanın ID'sini saklayacak değişken

    @IBOutlet weak var searchButton: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchButton.delegate = self
        FirebaseVerileriniAl()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Kullanıcı arama düğmesine bastığında burası tetiklenir
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            if searchText.isEmpty {
                // Eğer arama metni boşsa, tüm ilanları göster
                print("Search bar bos")
                self.FirebaseVerileriniAl()
            } else {
                let filteredIsletmeler = self.isletmeModelleri.filter { isletme in
                    // Aradığınız kriterleri burada belirleyin
                    let ad = isletme.isletmeAdi?.lowercased().contains(searchText.lowercased()) ?? false
                    let il = isletme.il?.lowercased().contains(searchText.lowercased()) ?? false
                    let ilce = isletme.ilce?.lowercased().contains(searchText.lowercased()) ?? false

                    // Tüm kriterlerin en az biriyle eşleşen ilanları seçin
                    return ad || il || ilce
                }
                
                self.isletmeModelleri = filteredIsletmeler
                if filteredIsletmeler.isEmpty {
                    self.FirebaseVerileriniAl()
                    tableView.reloadData()
                  
                }

            }
           
            
            // Filtrelenmiş ilanları kullanarak tableView'i güncelleyin
            tableView.reloadData()
         
                  searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Arama kutusundaki metni alın ve Firestore'dan verileri filtrelemek için kullanın
        
        
        
        print("textDidChange tetiklendi. Yeni metin: \(searchText)")
        let filteredIsletmeler: [IsletmeModel]
        
        if searchText.isEmpty {
            // Eğer arama metni boşsa, tüm ilanları göster
            print("Search bar bos")
            self.FirebaseVerileriniAl()
        } else {
            let filteredIsletmeler = self.isletmeModelleri.filter { isletme in
                // Aradığınız kriterleri burada belirleyin
                let ad = isletme.isletmeAdi?.lowercased().contains(searchText.lowercased()) ?? false
                let il = isletme.il?.lowercased().contains(searchText.lowercased()) ?? false
                let ilce = isletme.ilce?.lowercased().contains(searchText.lowercased()) ?? false

                // Tüm kriterlerin en az biriyle eşleşen ilanları seçin
                return ad || il || ilce
            }
            
            self.isletmeModelleri = filteredIsletmeler
            if filteredIsletmeler.isEmpty {
                self.FirebaseVerileriniAl()
                tableView.reloadData()
              
            }

        }
        
        // Filtrelenmiş ilanları kullanarak tableView'i güncelleyin
        tableView.reloadData()
    
    }


    
    @objc private func refreshData() {
        // Yenileme işlemini burada gerçekleştirin
        
        // Örneğin, verilerinizi yenileyebilirsiniz:
        FirebaseVerileriniAl()
        
        // Yenileme işlemi tamamlandığında refreshControl'ı durdurun
        tableView.refreshControl?.endRefreshing()
    }
    func FirebaseVerileriniAl() {
        let db = Firestore.firestore()
        db.collection("isletmeler").getDocuments { (snapshot, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Belge bulunamadı.")
                return
            }
            
            self.isletmeModelleri = documents.compactMap { IsletmeModel(dictionary: $0.data()) }
            
            
         
            
            self.tableView.reloadData() // Verileri çektikten sonra TableView'i güncelle
        }
    }

      // TableView verilerini doldurmak için gerekli fonksiyonlar
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          print(isletmeModelleri.count)
          return isletmeModelleri.count
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "isletmelerCell", for: indexPath) as! isletmelerTableViewCell
     
          
          let isletme = isletmeModelleri[indexPath.row]
          
          cell.isletmeAdiLabel.text = isletme.isletmeAdi ?? ""
          cell.il.text = isletme.il ?? ""
          cell.ilce.text = isletme.ilce ?? ""
          cell.imageView3.image = nil

          
          if let imageUrl = isletme.gorselUrl, let url = URL(string: imageUrl) {
              cell.imageView3.sd_setImage(with: url) { (image, error, cacheType, url) in
                   if let error = error {
                       print("Resim yükleme hatası: \(error.localizedDescription)")
                       cell.imageView3?.image = UIImage(named: "mobilVeryImage")
                   }
               }
           } else {
               print("Resim URL'si eksik")
               cell.imageView3?.image = UIImage(named: "mobilVeryImage")
           }
            
          cell.layer.borderColor = UIColor.lightGray.cgColor
          cell.layer.borderWidth = 0.75
          
          return cell
          
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedEmail = isletmeModelleri[indexPath.row].email
       
        performSegue(withIdentifier: "toIsletmeDetayVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIsletmeDetayVC" {
            if let destinationVC = segue.destination as? IsletmelerDetayVC {
                destinationVC.selectedEmail = selectedEmail
            }
        }
    }

    
  }


