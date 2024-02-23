

import UIKit

class FotografSecVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var coverPhotoIndex: Int?
    var isEditingModeEnabled = false // Hücreleri düzenleme modunu izlemek için bir bayrak


    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var fotografEkleButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var kaydetVeilerlebutton: UIButton!
    
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
     
        label.numberOfLines = 5 // İki satıra izin ver
     //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text = "Bilgilendirme: Fotoğraf seçerken fotoğraflarınızın net bir şekilde görünür olmasına dikkat edin. Fotoğrafları seçme sıranıza göre reklamda bu sırayla gösterilecektir. Seçeceğiniz ilk fotoğraf reklamınızın kapak fotoğrafı olacaktır."
        // UIButton'in kenarlarını yuvarlatma
        fotografEkleButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        fotografEkleButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        // UIButton'in kenarlarını yuvarlatma
        kaydetVeilerlebutton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        kaydetVeilerlebutton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // Hücre boyutlarını yapılandır
     
        
        let tasarim:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = (self.collectionView.frame.size.width - 40 ) / 3
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.itemSize = CGSize(width: genislik, height: genislik)
        tasarim.scrollDirection = .horizontal
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = tasarim
   
    }
  

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IlanVeriYoneticisi.paylasilan.selectedPhotos.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCell", for: indexPath) as! FotografSecCollectionViewCell
          
          
          let selectedPhoto = IlanVeriYoneticisi.paylasilan.selectedPhotos[indexPath.item]
          
         
          cell.imageView.image = selectedPhoto
          cell.layer.borderWidth = 4 // Seçilen hücreyi çerçeve ile vurgulayabilirsiniz
          cell.layer.borderColor = UIColor.blue.cgColor // Seçilen hücre çerçevesi rengini ayarlayın
         
          cell.isSelected = (indexPath.item == coverPhotoIndex)
          
          // Seçilen hücreyi belirlemek için kontrol ekleyin
                if indexPath.item == coverPhotoIndex  {
                    cell.layer.borderWidth = 2 // Seçilen hücreyi çerçeve ile vurgulayabilirsiniz
                    cell.layer.borderColor = UIColor.red.cgColor // Seçilen hücre çerçevesi rengini ayarlayın
                } else {
                    cell.layer.borderWidth = 0 // Seçili olmayan hücrelerin çerçevesini kaldırın
                }


          return cell
      }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        performSegue(withIdentifier: "toFotografSecDetayVC", sender: nil)
    }


    @IBAction func FotografEkleButtonClicked(_ sender: Any) {
   
        let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = false
               present(imagePicker, animated: true, completion: nil)
       }
    // Fotoğraf seçildiğinde çağrılır
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let secilenFoto = info[.originalImage] as? UIImage {
                 // Seçilen fotoğrafı diziyi ekleyin
            IlanVeriYoneticisi.paylasilan.selectedPhotos.append(secilenFoto)
                 coverPhotoIndex = IlanVeriYoneticisi.paylasilan.selectedPhotos.count - 1 // Son eklenen fotoğrafı seçili olarak işaretle
                 collectionView.reloadData()
             }
             picker.dismiss(animated: true, completion: nil)
    }

   
    @IBAction func kaydetVeIlerleButtonClicked(_ sender: Any) {
        if IlanVeriYoneticisi.paylasilan.selectedPhotos.isEmpty {
            hataMesajiGoster("Lütfen ürününüze ait fotograf ekleyiniz.")
        }else{
            performSegue(withIdentifier: "toMarkaVC", sender: nil)
        }
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
