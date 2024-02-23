
import UIKit

class MarkaVC: UIViewController , UITableViewDataSource , UITableViewDelegate {
    let iconDizisi = ["appleicon", "samsungicon" , "Xiaomiicon","Huaweiicon","Sonyicon","LGicon","Googleicon","OnePlusicon","Nokiaicon","Motorolaicon","HTCicon","Lenovoicon","Asusicon","oppoicon","Vivoicon","Realmeicon"]
    let telefonMarkalari = [ "Apple", "Samsung", "Xiaomi", "Huawei", "Sony", "LG", "Google", "OnePlus", "Nokia", "Motorola", "HTC", "Lenovo", "Asus", "Oppo", "Vivo", "Realme"]

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
              return telefonMarkalari.count
          
      }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markaCell", for: indexPath)
        
      
            cell.textLabel?.text = telefonMarkalari[indexPath.row ] // Dizideki indeks farkı nedeniyle -1 ekliyoruz
            if indexPath.row  < iconDizisi.count { // İndeks sınırlarını kontrol etmek önemlidir
                cell.imageView?.image = UIImage(named: iconDizisi[indexPath.row ]) 
            }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
            let secilen = telefonMarkalari[indexPath.row]
            
            
            IlanVeriYoneticisi.paylasilan.marka = secilen
            print(IlanVeriYoneticisi.paylasilan.marka)
            performSegue(withIdentifier: "toModelVC", sender: indexPath)
            
            
        
        
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toModelVC" {
            if let indexPath = sender as? IndexPath,
               let destinationVC = segue.destination as? ModelVC {
                let secilen = telefonMarkalari[indexPath.row  ]
                let secilenModel = telefonModelleri[secilen] ?? []
                destinationVC.model = secilenModel
            }
        }
    }

    
}
