

import UIKit

class GarantiVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    let garantiDizisi = [
       "Yok","24 ay", "23 ay", "22 ay", "21 ay", "20 ay",
        "19 ay", "18 ay", "17 ay", "16 ay", "15 ay",
        "14 ay", "13 ay", "12 ay", "11 ay", "10 ay",
        "9 ay", "8 ay", "7 ay", "6 ay", "5 ay",
        "4 ay", "3 ay", "2 ay", "1 ay"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return garantiDizisi.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "garantiCell", for: indexPath)
          
          
 
        let garanti = garantiDizisi[indexPath.row]
        cell.textLabel?.text = garanti
    
      return cell
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let secilen = garantiDizisi[indexPath.row]
            

            IlanVeriYoneticisi.paylasilan.garanti = secilen
            print(IlanVeriYoneticisi.paylasilan.garanti)

    
            performSegue(withIdentifier: "toTakasVC", sender: indexPath)
        
      }
    

}
