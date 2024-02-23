//
//  IlanVerVC.swift
//  MobilVery
//
//  Created by veysel on 10.09.2023.
//

import UIKit
import FirebaseAuth
class IlanVerVC: UIViewController {

    @IBOutlet weak var ilanVerButton: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Görünüm ekranda görünmeden önce yapılacak işlemleri burada yapabilirsiniz.
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            performSegue(withIdentifier: "toIlanVerdenGirise", sender: nil)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        label.numberOfLines = 4 // İki satıra izin ver
     //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text = "MobilVery bir telefon reklam paylaşım uygulamasıdır. Lütfen telefon dışında ürün paylaşmayınız, aksi takdirde reklamınız kaldırılacaktır. İlginiz için teşekkür ederiz."
 
        // UIButton'in kenarlarını yuvarlatma
        ilanVerButton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
        ilanVerButton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
        
    }
    

    @IBAction func ilanVerButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toFotografSecVC", sender: nil)
    }
    

}
