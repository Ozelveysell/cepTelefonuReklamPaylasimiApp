
import UIKit

class TakasVC: UIViewController , UITableViewDataSource , UITableViewDelegate{
    let takas = [
        "Yok", "Var"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return takas.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "takasCell", for: indexPath)
        
  
        let takas = takas[indexPath.row]
        cell.textLabel?.text = takas
    
    return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let secilen = takas[indexPath.row]
            

            IlanVeriYoneticisi.paylasilan.takas = secilen

            print(IlanVeriYoneticisi.paylasilan.takas)

            performSegue(withIdentifier: "toFiyatVC", sender: indexPath)
        
      }

 

}
