
import UIKit

class HafizaVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    let dahiliHafizaDizisi = ["1 TB", "512 GB", "256 GB", "128 GB", "64 GB", "32 Gb","16 GB","8 GB"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dahiliHafizaDizisi.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "hafizaCell", for: indexPath)
         
          
      
            let hafiza = dahiliHafizaDizisi[indexPath.row]
            cell.textLabel?.text = hafiza 
        
          return cell
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
      
            let secilen = dahiliHafizaDizisi[indexPath.row]
            IlanVeriYoneticisi.paylasilan.hafiza = secilen
            print(IlanVeriYoneticisi.paylasilan.hafiza)

            performSegue(withIdentifier: "toGarantiVC", sender: indexPath)
        
      }
   

}
