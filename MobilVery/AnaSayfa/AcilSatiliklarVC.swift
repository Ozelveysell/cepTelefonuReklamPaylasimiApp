
import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class AcilSatiliklarVC: UIViewController {

@IBOutlet weak var searchBar: UISearchBar!



@IBOutlet weak var acilSatiliklarButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    
@IBOutlet weak var tableView: UITableView!
    
    let telefonMarkalari = [ "Tümü","Apple", "Samsung", "Xiaomi", "Huawei", "Sony", "LG", "Google", "OnePlus", "Nokia", "Motorola", "HTC", "Lenovo", "Asus", "Oppo", "Vivo", "Realme"]
    let iconDizisi = ["","appleicon", "samsungicon" , "Xiaomiicon","Huaweiicon","Sonyicon","LGicon","Googleicon","OnePlusicon","Nokiaicon","Motorolaicon","HTCicon","Lenovoicon","Asusicon","oppoicon","Vivoicon","Realmeicon"]
    var ilanlar: [IlanModel] = []
    var selectedIlanID: String? // Seçilen ilanın ID'sini saklayacak değişken

override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    collectionView.dataSource = self
    collectionView.delegate = self
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
    
    @objc private func refreshData() {
        // Yenileme işlemini burada gerçekleştirin
        
        // Örneğin, verilerinizi yenileyebilirsiniz:
        FirebaseVerileriniAl()
        
        // Yenileme işlemi tamamlandığında refreshControl'ı durdurun
        tableView.refreshControl?.endRefreshing()
    }

@IBAction func kategorilerButtonClicked(_ sender: Any) {
    print("Kategoriler butonuna tıklandı")

}



@IBAction func acilSatiliklarButtonClicked(_ sender: Any) {
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
                return ilan.acilSatilikMi == true
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



}
extension AcilSatiliklarVC: UITableViewDelegate , UITableViewDataSource  , UISearchBarDelegate , UICollectionViewDelegate , UICollectionViewDataSource {

    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toAcilSatilikDetayVC" {
             if let destinationVC = segue.destination as? AcilSatiliklarDetayVC {
                 destinationVC.selectedIlanID = selectedIlanID
             }
         }
     }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "acilSatiliklarCell", for: indexPath) as! AcilSatiliklarCell
    
    let ilan = ilanlar[indexPath.row]
    
    cell.baslikLabel.text = ilan.baslik ?? ""
      cell.fiyatLabel.text = "\(ilan.fiyat! ) TL" ?? ""
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

    performSegue(withIdentifier: "toAcilSatilikDetayVC", sender: nil)

}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acilSatilikKategoriCell", for: indexPath) as! KategoriAcilSatilikCollectionViewCell
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
        print("didSelectItemAt")
        let secilenMarka = telefonMarkalari[indexPath.row]
        print("secilenMarka = " , secilenMarka)
        if secilenMarka == "Tümü" {
            FirebaseVerileriniAl()
        }else{
            FirebaseVerileriniAl(marka: secilenMarka)
            }
    }

}
