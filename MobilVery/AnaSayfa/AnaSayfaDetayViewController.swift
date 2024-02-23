
import MapKit
import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class AnaSayfaDetayViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mesajGonderButton: UIButton!
    
    @IBOutlet weak var ilanVerenButton: UIButton!
    
    var ilanVeren: String?
    var selectedIlan: IlanModel?
    var ozellikDizisi: [String] = [] // String dizisi oluştur
    var selectedIlanID: String? 
    var gorselDizisi: [String] = []
    // CLLocationManager'ı oluşturun
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
      //  mesajGonderButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
       // mesajGonderButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = (self.collectionView.frame.size.width)
    let uzunluk = self.collectionView.frame.size.height - 50
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tasarim.itemSize = CGSize(width: genislik, height: uzunluk)
        tasarim.scrollDirection = .horizontal
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = tasarim
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
        if let selectedIlanId = selectedIlanID {
           FirebaseVeriCek(ilanId: selectedIlanId)
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
                    ilanModel.mahalle! + " " + ilanModel.sokak! + " " + ilanModel.siteApartman! + " " + ilanModel.ilce! + " " + ilanModel.sehir!,
                    ilanModel.email!,
                    ilanModel.telefon!,
                    ilanModel.adSoyad!
                   
                   

                ])
                // self.FirebaseIsimCek(email: ilanModel.email!)
                
                self.gorselDizisi.append(contentsOf: ilanModel.selectedPhotos)
            }

            // TableView ve CollectionView'ı güncelle
            DispatchQueue.main.async {
                if !self.ozellikDizisi[14].isEmpty {
                    let adSoyad = self.ozellikDizisi[14].uppercased()
                    self.ilanVerenButton.setTitle(adSoyad, for: .normal)
                    self.ilanVerenButton.titleLabel?.adjustsFontSizeToFitWidth = true
                    
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
  
    @IBAction func ilanVerenButtonClicked(_ sender: Any) {
        
        print("IlanVerenButtonClicked")
    }
    
    @IBAction func araButtonClicked(_ sender: Any) {
        if ozellikDizisi.isEmpty {
            
        } else {
             let telefon = ozellikDizisi[7]
                ara(telefonNo: telefon)
            
        }
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
    
    @IBAction func paylasButtonClicked(_ sender: Any) {
        ilanPaylas()
    }
    // İlanı paylaşma işlemini gerçekleştiren fonksiyon
    func ilanPaylas() {
        
            // İlan metni veya bağlantısı
            let ilanMetni = "Ilgili ilan baglantisi"
            
        let ilanMetni2 = ilanMetni.uppercased()
            // Paylaşım işlemini ayarla
            let activityViewController = UIActivityViewController(activityItems: [ilanMetni2], applicationActivities: nil)
            
            // Paylaşım işlemini göster
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
               
            }
        
            present(activityViewController, animated: true, completion: nil)
        }
    
    @IBAction func favorileButtonClicked(_ sender: Any) {
            let currentUser = Auth.auth().currentUser
            
            if currentUser == nil {
                // Kullanıcı giriş yapmamışsa, giriş ekranına yönlendirin veya uygun bir işlem yapın.
                performSegue(withIdentifier: "toAnaSayfadanGirise", sender: nil)
            } else {
                // Kullanıcı giriş yapmışsa, ilanın favori durumunu kontrol edin ve favori ekleyin veya çıkarın.
                if let selectedIlanID = selectedIlanID {
                    // Firestore referansını alın
                    let db = Firestore.firestore()
                    
                    // Favori ilanların saklanacağı koleksiyon ve belge referansını oluşturun
                    let favoriIlanlarCollection = db.collection("favoriIlanlar")
                    
                    // Kullanıcının favori ilanı zaten eklemiş olup olmadığını kontrol edin
                    let query = favoriIlanlarCollection.whereField("ilanID", isEqualTo: selectedIlanID).whereField("ekleyenEmail", isEqualTo: currentUser?.email ?? "")
                    
                    query.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Favori ilan sorgulama hatası: \(error.localizedDescription)")
                            // Hata işleme kodu
                        } else if let documents = snapshot?.documents, !documents.isEmpty {
                            // Kullanıcı favori ilanı zaten eklemişse, bu ilanı favorilerden çıkarın
                            for document in documents {
                                document.reference.delete { error in
                                    if let error = error {
                                        print("Favori ilanı kaldırma hatası: \(error.localizedDescription)")
                                        // Hata işleme kodu
                                    } else {
                                        print("Favori ilan başarıyla kaldırıldı.")
                                        // Başarılı kaldırma işlemi tamamlandıktan sonra istediğiniz ek işlemleri yapabilirsiniz.
                                    }
                                }
                            }
                        } else {
                            // Kullanıcı favori ilanı eklememişse, bu ilanı favorilere ekleyin
                            let favoriIlanBelgesi = favoriIlanlarCollection.document()
                            
                            // Favori ilanın verilerini hazırlayın
                            let favoriIlanVerileri: [String: Any] = [
                                "ilanID": selectedIlanID,
                                "ekleyenEmail": currentUser?.email ?? "" // Kullanıcının e-posta adresini ekleyin
                            ]
                            
                            // Firestore'a favori ilanı ekleyin
                            favoriIlanBelgesi.setData(favoriIlanVerileri) { error in
                                if let error = error {
                                    print("Favori ilan ekleme hatası: \(error.localizedDescription)")
                                    // Hata işleme kodu
                                } else {
                                    print("Favori ilan başarıyla eklendi.")
                                    // Başarılı ekleme işlemi tamamlandıktan sonra istediğiniz ek işlemleri yapabilirsiniz.
                                }
                            }
                        }
                    }
                }
            }
            
            print("favorileButtonClicked")
        }

    func favorileIlanEkle(forUserEmail userEmail: String, ilanID: String) {
        let db = Firestore.firestore()
        
        // Koleksiyon referansı oluştur
        let favoriIlanlarCollection = db.collection("favoriIlanlar")
        
        // Kullanıcının favori ilanını favoriIlanlar koleksiyonuna ekle
        favoriIlanlarCollection.addDocument(data: [
            "ekleyenEmail": userEmail,
            "ilanId": ilanID,
            "tarih": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Favori ilanı ekleme hatası")
            } else {
               print("Favori ilan başarıyla eklendi.")
            }
        }
    }
 
    @IBAction func mesajgonderButtonClicked(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
         if currentUser == nil {
             performSegue(withIdentifier: "toAnaSayfadanGirise", sender: nil)
         } else {
             
             navigateToConversationsViewController()
         }
        
        
     }
    // Bu kod parçasını, kullanıcının bir butona tıkladığında çağırabilirsiniz.
    func navigateToConversationsViewController() {
        
        if let conversationsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "conversationsVC") as? ConversationsViewController {
            
            navigationController?.pushViewController(conversationsVC, animated: true)
        }
    }

   
    
    @IBAction func nasilGiderimButtonClicked(_ sender: Any) {
        // Kullanıcıdan konum izni isteniyor
        checkLocationAuthorization()

    }
    
    func checkLocationAuthorization() {
           switch CLLocationManager.authorizationStatus() {
           case .authorizedWhenInUse:
               // Kullanıcı konum iznini verdi, şimdi konum alınabilir
               if CLLocationManager.locationServicesEnabled() {
                   locationManager.startUpdatingLocation()
               }
           case .denied:
               // Kullanıcı konum iznini reddetti
               // Uygulamanın konum hizmetlerine erişim izni gerekiyor, kullanıcıyı ayarlara yönlendirin
               showLocationDeniedAlert()
           case .notDetermined:
               // Konum izni henüz belirlenmedi, kullanıcıdan izin isteyin
               locationManager.requestWhenInUseAuthorization()
           default:
               break
           }
       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          if let userLocation = locations.last {
              // Kullanıcının anlık konumu
              let latitude = userLocation.coordinate.latitude
              let longitude = userLocation.coordinate.longitude

              // İlgili ilanın konumu (örneğin, bir restoranın konumu)
              let destinationLatitude = 37.9342447 // Hedef konumun enlemi
              let destinationLongitude = 40.2023638 // Hedef konumun boylamı

              // Maps uygulamasını açmak için URL oluşturun
              let coordinate = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
              let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
              mapItem.name = "Hedef Konum"
              mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
          }
      }
    func showLocationDeniedAlert() {
           let alertController = UIAlertController(
               title: "Konum Erişim İzni",
               message: "Uygulamanın konum hizmetlerine erişim izni gerekiyor. Ayarlara giderek konum iznini etkinleştirebilirsiniz.",
               preferredStyle: .alert
           )

           let settingsAction = UIAlertAction(
               title: "Ayarlar",
               style: .default
           ) { (_) in
               if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(settingsURL)
               }
           }

           let cancelAction = UIAlertAction(
               title: "İptal",
               style: .cancel,
               handler: nil
           )

           alertController.addAction(settingsAction)
           alertController.addAction(cancelAction)

           present(alertController, animated: true, completion: nil)
       }
   

}
extension AnaSayfaDetayViewController: UITableViewDelegate , UITableViewDataSource  , UICollectionViewDelegate , UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnaSayfaOzellikCell", for: indexPath) as! AnaSayfaOzellikCell
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
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gorselDizisi.isEmpty {
            return 1
        }
        
        return gorselDizisi.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnaSayfaImageCell", for: indexPath) as! AnaSayfaImageCollectionCell
        // Görsel dizisinden ilgili görsel URL'ini alın
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "togorselCell", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if segue.identifier == "toAnaSayfaMesajGonderVC" {
            if let destinationVC = segue.destination as? AnaSayfaMesajGonderVC {
                destinationVC.selectedIlanID = selectedIlanID

                }
            }
        }
    

    
}


  
