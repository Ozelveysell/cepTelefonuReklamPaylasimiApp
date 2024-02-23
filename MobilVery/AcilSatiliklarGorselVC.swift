

import UIKit
import SDWebImage
class AcilSatiliklarGorselVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedImageUrl: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tasarim: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = (self.collectionView.frame.size.width)
        let uzunluk = self.collectionView.frame.size.height - 50
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tasarim.itemSize = CGSize(width: genislik, height: uzunluk)
        tasarim.scrollDirection = .horizontal
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = tasarim
        // Geri düğmesinin metnini özelleştir
     //   navigationItem.backBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: nil, action: nil)

    }
    

  

}
extension AcilSatiliklarGorselVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acilSatiliklarGorselCell2", for: indexPath) as! AcilSatiliklarGorselCell
        if selectedImageUrl == "" && selectedImageUrl == nil  {
        print("Bosss")
            return cell
        }
        let imageUrlString = selectedImageUrl
        
        // Görseli SDWebImage ile yükleyin
        if let imageUrl = URL(string: selectedImageUrl!) {
            cell.imageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            // Geçerli bir URL değilse, varsayılan bir görsel veya hata görseli ayarlayabilirsiniz.
            cell.imageView.image = UIImage(named: "mobilVeryImage")
        }
        
        return cell
        
    }
    
    
    
}
