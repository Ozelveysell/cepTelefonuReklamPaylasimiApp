
import UIKit

class ModelVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var model: [Ilan] = [] // Seçilen markanın modellerini burada saklayacağız

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        if let selectedBrand = IlanVeriYoneticisi.paylasilan.marka {
               model = telefonModelleri[selectedBrand] ?? []
               tableView.reloadData()
        
           }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath)
        
        
      
            let model = model[indexPath.row]
            
            cell.textLabel?.text = model.model
            
        
     
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         
            let secilenIlan = model[indexPath.row]
            let secilenModel = secilenIlan.model
            IlanVeriYoneticisi.paylasilan.model = secilenModel
            print(IlanVeriYoneticisi.paylasilan.model)

            performSegue(withIdentifier: "toRenkVC", sender: indexPath)
        
            
        
        
    }
    
}
