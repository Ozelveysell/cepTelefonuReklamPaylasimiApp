//
//  AcilSatiliktirDegistirVC.swift
//  MobilVery
//
//  Created by veysel on 19.09.2023.
//

import UIKit

class AcilSatiliktirDegistirVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var acilSatilikSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.numberOfLines = 4
        label.text = "Dikkat bu işlemi yalnızca bir kez gerçekleştirebilirsiniz. İlanınızı acil satış olarak işaretlemek istiyorsanız fiyatı daha rekabetçi tutmanız tavsiye edilir."
    }
    

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
                 // UISwitch açıkken uyarı mesajı göster
                 let alertController = UIAlertController(
                     title: "Acil Satılıktır",
                     message: "Bu özelliği açtığınızda, ürününüz 'Acil Satılık' olarak işaretlenecektir.",
                     preferredStyle: .alert
                 )
                 
                 alertController.addAction(UIAlertAction(title: "Devam Et", style: .default, handler: nil))
                 alertController.addAction(UIAlertAction(title: "İptal", style: .cancel) { _ in
                     // UISwitch'i kapatın
                     sender.isOn = false
                 })
                 
                 present(alertController, animated: true, completion: nil)
             }
         }
    
    @IBAction func kaydetButtonClicked(_ sender: Any) {
        // buraya bir kontrol daha koy son kez uyarsin
   print("Degisiklikler kaydedildi")
        
    }
    
}
