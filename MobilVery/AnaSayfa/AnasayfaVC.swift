
import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class AnasayfaVC: UIViewController  , UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var acilSatiliklarButton: UIButton!
    let telefonMarkalari = [ "Tümü","Apple", "Samsung", "Xiaomi", "Huawei", "Sony", "LG", "Google", "OnePlus", "Nokia", "Motorola", "HTC", "Lenovo", "Asus", "Oppo", "Vivo", "Realme"]
    let iconDizisi = ["","appleicon", "samsungicon" , "Xiaomiicon","Huaweiicon","Sonyicon","LGicon","Googleicon","OnePlusicon","Nokiaicon","Motorolaicon","HTCicon","Lenovoicon","Asusicon","oppoicon","Vivoicon","Realmeicon"]
    var ilanlar: [IlanModel] = []
    var selectedIlanID: String? // Seçilen ilanın ID'sini saklayacak değişken

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate =  self
        searchBar.delegate = self
   
     
        let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = ((self.collectionView.frame.size.width   ) / 3)
        let uzunluk = ((self.collectionView.frame.size.height) - (self.collectionView.frame.size.height - 35))
       // tasarim.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        tasarim.itemSize = CGSize(width: genislik, height: uzunluk)
        tasarim.scrollDirection = .horizontal
       // tasarim.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = tasarim
        
        
        FirebaseVerileriniAl()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            //   tableView.reloadData()
    }
 
    @IBAction func isletmelerButtonClicked(_ sender: Any) {
        print("isletmeler tiklandi")
        performSegue(withIdentifier: "toIsletmelerViewController2", sender: nil)
        
    }
    
   
  
    
    @objc private func refreshData() {
        // Yenileme işlemini burada gerçekleştirin
        
        // Örneğin, verilerinizi yenileyebilirsiniz:
        FirebaseVerileriniAl()
        
        // Yenileme işlemi tamamlandığında refreshControl'ı durdurun
        tableView.refreshControl?.endRefreshing()
    }

   
    
    @IBAction func acilSatiliklarButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toAcilSatiliklarVC", sender: nil)
        
        print("Acil Satılıklar butonuna tıklandı")

    }
    func FirebaseVerileriniAl() {
        let db = Firestore.firestore()
        db.collection("ilanlar").getDocuments { (snapshot, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Belge bulunamadı.")
                return
            }
            
            self.ilanlar = documents.compactMap { IlanModel(dictionary: $0.data()) }
            
            // İlanları acilSatilikMi değeri true olanlarla filtrele
            self.ilanlar = self.ilanlar.filter { ilan in
                return ilan.acilSatilikMi == false
            }
            
            self.tableView.reloadData() // Verileri çektikten sonra TableView'i güncelle
        }
    }
    func FirebaseVerileriniAl(marka: String) {
        let db = Firestore.firestore()
        
        // "ilanlar" koleksiyonundan sadece belirli bir kullanıcının e-postasına sahip ilanları almak için filtreleme yapın.
        db.collection("ilanlar")
            .whereField("marka", isEqualTo: marka)
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
                
                // İlanları acilSatilikMi değeri true olanlarla filtrele
                self.ilanlar = self.ilanlar.filter { ilan in
                    return ilan.acilSatilikMi == false
                }
                
                self.tableView.reloadData() // Verileri çektikten sonra TableView'i güncelle
            }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Kullanıcı arama düğmesine bastığında burası tetiklenir
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            if searchText.isEmpty {
                // Eğer arama metni boşsa, tüm ilanları göster
                print("Search bar bos")
                self.FirebaseVerileriniAl()
            } else {
                let filteredIlanlar = self.ilanlar.filter { ilan in
                    // Aradığınız kriterleri burada belirleyin
                    let markaKriteri = ilan.marka?.lowercased().contains(searchText.lowercased()) ?? false
                    let modelKriteri = ilan.model?.lowercased().contains(searchText.lowercased()) ?? false
                    let renkKriteri = ilan.renk?.lowercased().contains(searchText.lowercased()) ?? false
                    let hafizaKriteri = ilan.hafiza?.lowercased().contains(searchText.lowercased()) ?? false
                    let fiyatKriteri = ilan.fiyat?.lowercased().contains(searchText.lowercased()) ?? false

                    // Tüm kriterlerin en az biriyle eşleşen ilanları seçin
                    return markaKriteri || modelKriteri || renkKriteri || hafizaKriteri || fiyatKriteri
                }
                
                self.ilanlar = filteredIlanlar
                if filteredIlanlar.isEmpty {
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
        // Her harf girişi sırasında bu işlev tetiklenir
        // searchText'i kullanarak ilanları anlık olarak filtrelemek için burayı kullanabilirsiniz
       print("textDidChange tetiklendi. Yeni metin: \(searchText)")
       let filteredIlanlar: [IlanModel]

       if searchText.isEmpty {
             // Eğer arama metni boşsa, tüm ilanları göster
             print("Search bar bos")
             filteredIlanlar = self.ilanlar
         } else {
             filteredIlanlar = self.ilanlar.filter { ilan in
                 // Aradığınız kriterleri burada belirleyin
                 let markaKriteri = ilan.marka?.lowercased().contains(searchText.lowercased()) ?? false
                 let modelKriteri = ilan.model?.lowercased().contains(searchText.lowercased()) ?? false
                 let renkKriteri = ilan.renk?.lowercased().contains(searchText.lowercased()) ?? false
                 let hafizaKriteri = ilan.hafiza?.lowercased().contains(searchText.lowercased()) ?? false
                 let fiyatKriteri = ilan.fiyat?.lowercased().contains(searchText.lowercased()) ?? false
                 let baslikKriteri = ilan.baslik?.lowercased().contains(searchText.lowercased()) ?? false
                 let sehirKriteri = ilan.sehir?.lowercased().contains(searchText.lowercased()) ?? false
                 let ilceKriteri = ilan.ilce?.lowercased().contains(searchText.lowercased()) ?? false
                 let ilanIdKriteri = ilan.ilanId.lowercased().contains(searchText.lowercased()) ?? false
              

                 // Tüm kriterlerin en az biriyle eşleşen ilanları seçin
                 return markaKriteri || modelKriteri || renkKriteri || hafizaKriteri || fiyatKriteri || baslikKriteri || sehirKriteri || ilceKriteri || ilanIdKriteri
             }
         
           
           self.ilanlar = filteredIlanlar
           if filteredIlanlar.isEmpty {
               self.FirebaseVerileriniAl()
               tableView.reloadData()
             
           }

       }
       
       // Filtrelenmiş ilanları kullanarak tableView'i güncelleyin
       tableView.reloadData()
    }


    
    

}
extension AnasayfaVC: UITableViewDelegate , UITableViewDataSource  , UICollectionViewDelegate , UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            // Kullanıcı aşağı doğru sürüklüyor, klavyeyi kapat
            searchBar.resignFirstResponder()
        }
    }

    
   


   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnaSayfaDetay" {
            if let destinationVC = segue.destination as? AnaSayfaDetayViewController {
                destinationVC.selectedIlanID = selectedIlanID
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kategoriCollectionCell", for: indexPath) as! KategoriCollectionViewCell
        let kategori = telefonMarkalari[indexPath.row]
        
        cell.label.text = kategori
        if indexPath.row  < iconDizisi.count { // İndeks sınırlarını kontrol etmek önemlidir
            cell.imageView?.image = UIImage(named: iconDizisi[indexPath.row ])
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return telefonMarkalari.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secilenMarka = telefonMarkalari[indexPath.row]
       // print("secilenMarka = " , secilenMarka)
        if secilenMarka == "Tümü" {
            FirebaseVerileriniAl()
        }else{
            FirebaseVerileriniAl(marka: secilenMarka)
            }
    } 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anaSayfaCell", for: indexPath) as! AnaSayfaCell
        
        let ilan = ilanlar[indexPath.row]
        
        cell.baslikLabel.text = ilan.baslik ?? ""
          cell.fiyatLabel.text = ilan.fiyat ?? ""
          cell.konumLabel.text = "\(ilan.ilce ?? ""), \(ilan.sehir ?? "")"
          cell.markaModelLabel.text = "\(ilan.marka ?? ""), \(ilan.model ?? "")"
        // İlanın fotoğraf URL'sini kontrol et
        
        if let imageUrl = ilan.selectedPhotos.first, let url = URL(string: imageUrl) {
             cell.anaSayfaImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                 if let error = error {
                     print("Resim yükleme hatası: \(error.localizedDescription)")
                     cell.anaSayfaImageView?.image = UIImage(named: "mobilVeryImage")
                 }
             }
         } else {
             print("Resim URL'si eksik")
             cell.anaSayfaImageView?.image = UIImage(named: "mobilVeryImage")
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
        performSegue(withIdentifier: "toAnaSayfaDetay", sender: self)

    }
 /*   func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if contentOffsetY > 0 {
            // Kullanıcı aşağı kaydırıyor, arama çubuğunu gizle
            searchBar.isHidden = true
            kategorilerButton.isHidden = true
            acilSatiliklarButton.isHidden = true
            
            // TableView'i yukarı kaydır ve ekstra boşluk bırak
            tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        } else {
            // Kullanıcı yukarı kaydırıyor, arama çubuğunu göster
            searchBar.isHidden = false
            kategorilerButton.isHidden = false
            acilSatiliklarButton.isHidden = false
            
            // TableView'i orijinal konumuna getir
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
*/


}
