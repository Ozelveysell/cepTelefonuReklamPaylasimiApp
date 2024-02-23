

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class IlanlarimDetayVC: UIViewController {
    var selectedIlan: IlanModel?
    var selectedIlanID: String?
    var gorselDizisi: [String] = []
    var ozellikDizisi: [String] = [] // String dizisi oluştur

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    
        let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = (self.collectionView.frame.size.width)
        let uzunluk = self.collectionView.frame.size.height - 50
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tasarim.itemSize = CGSize(width: genislik, height: uzunluk)
        tasarim.scrollDirection = .horizontal
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = tasarim
        
              if let selectedIlanId = selectedIlanID {
                 FirebaseVeriCek(ilanId: selectedIlanId)

              }
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFiyatDegistirVC" {
            if let destinationVC = segue.destination as? FiyatDegistirVC {
                destinationVC.selectedIlanID = selectedIlanID
            }
        }
    }
    @IBAction func duzenleButtonClicked(_ sender: Any) {
        // Düzenleme için bir UIAlertController oluşturun
           let alertController = UIAlertController(title: "İlanı Düzenle", message: nil, preferredStyle: .actionSheet)
           
           // Fiyatı Değiştir seçeneğini ekle
           let fiyatDegistirAction = UIAlertAction(title: "Fiyatı Değiştir", style: .default) { (_) in
               // Fiyatı değiştirme işlemlerini burada gerçekleştirin
            
               self.performSegue(withIdentifier: "toFiyatDegistirVC", sender: nil)
               print("Fiyatı değiştir seçeneği seçildi.")
           }
        // Acil Satiliktir seçeneğini ekle
        let acilSatiliktirAction = UIAlertAction(title: "Acil Satiliktir", style: .default) { (_) in
            // Fiyatı değiştirme işlemlerini burada gerçekleştirin
            self.performSegue(withIdentifier: "toAcilSatiliktirDegistirVC", sender: nil)
            print("Acil satiliktir secenegi degistirildi.")
        }
           
           // İlanı Kaldır seçeneğini ekle
           let ilaniKaldirAction = UIAlertAction(title: "İlanı Kaldır", style: .destructive) { (_) in
               // İlanı kaldırma işlemlerini burada gerçekleştirin
                   // İlanı kaldırmadan önce kullanıcıya bir onay mesajı göster
                   let onayAlert = UIAlertController(title: "İlanı Kaldır", message: "İlanı kaldırmak istediğinizden emin misiniz?", preferredStyle: .alert)
                   
                   // Onay butonunu ekle
                   let onayAction = UIAlertAction(title: "Onayla", style: .destructive) { (_) in
                       // İlanı silme işlemini burada gerçekleştirin
                       if let  selectedIlanId = self.selectedIlanID {
                           self.silIlan(ilanId: selectedIlanId)
                     

                       }
                   }
                   
                   // İptal butonunu ekle
                   let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
                   
                   // Onay ve iptal butonlarını onayAlert'e ekle
                   onayAlert.addAction(onayAction)
                   onayAlert.addAction(iptalAction)
                   
                   // OnayAlert'i göster
                   self.present(onayAlert, animated: true, completion: nil)
               }
           
           
           // İptal seçeneğini ekle
           let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
           
           // Action Sheet'e seçenekleri ekle
           alertController.addAction(fiyatDegistirAction)
           alertController.addAction(acilSatiliktirAction)
           alertController.addAction(ilaniKaldirAction)
           alertController.addAction(iptalAction)
           
           // Action Sheet'i görüntüle
           present(alertController, animated: true, completion: nil)
       }
   
    func silIlan(ilanId: String) {
        if  let currentUser = Auth.auth().currentUser {
             let selectedIlanID = ilanId
                // Firestore referansını alın
                let db = Firestore.firestore()
                
                
                let ilanlarim = db.collection("ilanlar")
                
                
                let query = ilanlarim.whereField("ilanId", isEqualTo: ilanId).whereField("epostaAdresi", isEqualTo: currentUser.email ?? "")
                
                query.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Favori ilan sorgulama hatası: \(error.localizedDescription)")
                        // Hata işleme kodu
                    } else if let documents = snapshot?.documents, !documents.isEmpty {
                        for document in documents {
                            document.reference.delete { error in
                                if let error = error {
                                    print("ilanı kaldırma hatası: \(error.localizedDescription)")
                                    // Hata işleme kodu
                                } else {
                                    print("ilan başarıyla kaldırıldı.")
                                    // Başarılı kaldırma işlemi tamamlandıktan sonra istediğiniz ek işlemleri yapabilirsiniz.
                                    
                                }}}} else {
                                    print("bulunamadi")
                                }
                }
            }
       
        
    }


    func FirebaseVeriCek(ilanId: String) {
        let db = Firestore.firestore()
        
        let query = db.collection("ilanlar").whereField("ilanId", isEqualTo: ilanId)
        
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
            self.gorselDizisi.removeAll()
            
            // Belgeler var ve çekildi
            for document in documents {
                let ilanModel = IlanModel(dictionary: document.data())
                
                // Verileri dizilere ekle
                self.ozellikDizisi.append(contentsOf: [
                    ilanModel.fiyat!,
                    ilanModel.marka!,
                    ilanModel.model!,
                    ilanModel.renk!,
                    ilanModel.hafiza!,
                    ilanModel.garanti!,
                    ilanModel.takas!,
                    ilanModel.telefon!,
                    ilanModel.ilce!,
                    ilanModel.sehir!,
                    ilanModel.aciklama!,
                    ilanModel.mahalle! + " " + ilanModel.sokak! + " " + ilanModel.siteApartman! + " " + ilanModel.ilce! + " " + ilanModel.sehir!
                    
                   
                   

                ])
                
                self.gorselDizisi.append(contentsOf: ilanModel.selectedPhotos)
            }
            
            // TableView ve CollectionView'ı güncelle
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }

}
extension IlanlarimDetayVC: UITableViewDelegate , UITableViewDataSource  , UICollectionViewDelegate , UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ilanlarimOzellikCell", for: indexPath) as! IlanlarimOzellikCell
        if ozellikDizisi.isEmpty {
            return cell
        }

            if indexPath.row == 0 {
                // Fiyat hücresi
                cell.ozellikLabel.text = "Fiyat"
                cell.secilenOzellikLabel.text = ozellikDizisi[0] +  " TL"
               
            } else if indexPath.row == 1 {
                // Marka hücresi
                cell.ozellikLabel.text = "Marka"
                cell.secilenOzellikLabel.text = ozellikDizisi[1]
              
            } else if indexPath.row == 2 {
                // Model hücresi
                cell.ozellikLabel.text = "Model"
                cell.secilenOzellikLabel.text = ozellikDizisi[2]
                
            } else if indexPath.row == 3 {
                cell.ozellikLabel.text = "Renk"
                cell.secilenOzellikLabel.text = ozellikDizisi[3]
                
            }else if indexPath.row == 4 {
                cell.ozellikLabel.text = "Hafiza"
                cell.secilenOzellikLabel.text = ozellikDizisi[4]
            }else if indexPath.row == 5 {
                cell.ozellikLabel.text = "Garanti"
                cell.secilenOzellikLabel.text = ozellikDizisi[5]
            }else if indexPath.row == 6 {
                cell.ozellikLabel.text = "Takas"
                cell.secilenOzellikLabel.text = ozellikDizisi[6]
            }else if indexPath.row == 7 {
                cell.ozellikLabel.text = "Irtibat No"
                cell.secilenOzellikLabel.text = ozellikDizisi[7]
            }else if indexPath.row == 8 {
                cell.ozellikLabel.text = "Ilçe"
                cell.secilenOzellikLabel.text = ozellikDizisi[8]
            }else if indexPath.row == 9 {
                cell.ozellikLabel.text = "Sehir"
                cell.secilenOzellikLabel.text = ozellikDizisi[9]
            }else if indexPath.row == 10 {
                
                cell.ozellikLabel.text = "Aciklama"
                
                cell.secilenOzellikLabel.text = ozellikDizisi[10]
                cell.secilenOzellikLabel.numberOfLines = 0 // Tüm satırları görüntüle
                      cell.secilenOzellikLabel.sizeToFit() // Metnin tamamını sığdırmak için boyutu ayarla
                 
            }else if indexPath.row == 11 {
                
                cell.ozellikLabel.text = "Adres"
                
                cell.secilenOzellikLabel.text = ozellikDizisi[11]
                cell.secilenOzellikLabel.numberOfLines = 0 // Tüm satırları görüntüle
                      cell.secilenOzellikLabel.sizeToFit() // Metnin tamamını sığdırmak için boyutu ayarla
                 
            }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gorselDizisi.isEmpty {
            return 1
        }
        
        return gorselDizisi.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ilanlarimCollectionCell", for: indexPath) as! IlanlarimCollectionCell
        if gorselDizisi.isEmpty {
            return cell
        }
        let imageUrlString = gorselDizisi[indexPath.row]
        
        // Görseli SDWebImage ile yükleyin
        if let imageUrl = URL(string: imageUrlString) {
            cell.imageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            // Geçerli bir URL değilse, varsayılan bir görsel veya hata görseli ayarlayabilirsiniz.
            cell.imageView.image = UIImage(named: "mobilVeryImage")
        }
        
        return cell
    }
   
/*    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "togorselCell", sender: nil)
    } */
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "togorselCell" {
            if let destinationVC = segue.destination as? GorselVC {
                // Seçilen hücrenin indeksini alın
                if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                    // indexPath'i kullanarak ilgili görsel URL'sini alın
                    let selectedImageUrl = gorselDizisi[indexPath.row]
                    
                    // Hedef view controller'a görsel URL'sini iletin
                    destinationVC.selectedImageUrl = selectedImageUrl
                }
            }
        }
    }
   */
}
