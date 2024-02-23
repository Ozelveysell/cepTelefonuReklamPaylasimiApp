
import UIKit

class FotografSecDetayVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
  

    var coverPhotoIndex: Int?

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false

            // Hücre boyutlarını ve düzenini yapılandır
        /*    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
                flowLayout.scrollDirection = .horizontal // Yatay kaydırma
                flowLayout.minimumInteritemSpacing = 0 // Yatay aralık (isteğe bağlı)
            } */

            let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            let genislik = (self.collectionView.frame.size.width)
        let uzunluk = self.collectionView.frame.size.height - 100
            tasarim.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            tasarim.itemSize = CGSize(width: genislik, height: uzunluk)
            collectionView.collectionViewLayout = tasarim
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return IlanVeriYoneticisi.paylasilan.selectedPhotos.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoSecDetayCell", for: indexPath) as! FotografSecDetayCollectionCell

            // Her hücre için numarayı güncelle
            let numara = indexPath.item + 1
            cell.numaraLabel.text = String(numara)

            // Hücreye fotoğrafı yerleştir
            let selectedPhoto = IlanVeriYoneticisi.paylasilan.selectedPhotos[indexPath.item]
            cell.imageView.image = selectedPhoto

            // Silme düğmesi
            cell.fotografiSilButton.tag = indexPath.item
            cell.fotografiSilButton.addTarget(self, action: #selector(fotografiSilButtonClicked(_:)), for: .touchUpInside)

            // Seçili hücreyi vurgula
            cell.isSelected = (indexPath.item == coverPhotoIndex)

            // Hücre görünürlüğünü ayarla
            cell.isHidden = false // Hücreyi görünür yap

            // Seçilen hücreyi belirlemek için kontrol ekleyin
            if indexPath.item == coverPhotoIndex {
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.blue.cgColor
            } else {
                cell.layer.borderWidth = 0
            }

            return cell
        }


    @objc func fotografiSilButtonClicked(_ sender: UIButton) {
           let indexToDelete = sender.tag
           IlanVeriYoneticisi.paylasilan.selectedPhotos.remove(at: indexToDelete)
           collectionView.reloadData()
       }
    

}
