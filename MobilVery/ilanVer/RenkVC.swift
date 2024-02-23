
import UIKit

class RenkVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    let renkler = ["Siyah", "Beyaz", "Mor", "Kırmızı", "Mavi", "Yeşil","Sarı","Pembe","Gece Yarısı","Yıldız Işığı"]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return renkler.count
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "renkCell", for: indexPath)
      
            let renk = renkler[indexPath.row]
            
            cell.textLabel?.text = renk // Hücre içeriğini belirtilen renk adıyla güncelle
        
          return cell
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
            let secilen = renkler[indexPath.row]
            

            IlanVeriYoneticisi.paylasilan.renk = secilen
            print(IlanVeriYoneticisi.paylasilan.renk)

            performSegue(withIdentifier: "toHafizaVC", sender: indexPath)

      
    }
    
      

}
