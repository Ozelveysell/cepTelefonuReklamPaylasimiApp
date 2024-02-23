
import UIKit
import FirebaseAuth
import Firebase
class HesapVC: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let HesapDizisi = ["İşletme Profiline Geç","Favori İlanlar" , "Dil" , "Hakkında" , "Hesap Bilgilerim" , "Engellenen Kullanıcılar" , "Öneriler" , "Çıkış Yap"]
    let iconDizisi = ["isletmeIcon","favoriler" , "dil" , "hakkinda" , "hesapBilgilerim" ,  "engellenenler" , "oneriler" , "cikisYap"]
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = Auth.auth().currentUser
        label.text = currentUser?.email
        
        tableView.delegate = self
        tableView.dataSource = self
        label.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func confirmLogout() {
        let alertController = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak istediğinize emin misiniz?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Tamam", style: .destructive) { (action) in
            self.logout() // Kullanıcı onay verdiğinde çıkış yapma işlemini çağır
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func logout() {
        do {
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toCikisVC", sender: nil)
        } catch {
            hataMesajiGoster("Çıkış hatası")
        }
    }

    // Hata mesajını gösteren yardımcı bir fonksiyon
    func hataMesajiGoster(_ mesaj: String) {
        let alertController = UIAlertController(title: "Bilgi", message: mesaj, preferredStyle: .alert)
    
        self.present(alertController, animated: true, completion: nil)

        // Hata mesajını 2 saniye sonra otomatik olarak kapatmak için Timer kullanılıyor
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}

extension HesapVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HesapDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hesapCell", for: indexPath) as! HesapTableViewCell
    
        cell.customLabel.text = HesapDizisi[indexPath.row]
        cell.customImageView.image = UIImage(named: iconDizisi[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var secilenBolum = HesapDizisi[indexPath.row]
        if secilenBolum.elementsEqual("İşletme Profiline Geç"){
            kontrolEtIsletmeProfili()
        }
        if secilenBolum.elementsEqual("Favori İlanlar"){
            performSegue(withIdentifier: "toFavoriIlanlar", sender: nil)
        }
        if secilenBolum.elementsEqual("Dil"){
            performSegue(withIdentifier: "toDilVC", sender: nil)
        }
        if secilenBolum.elementsEqual("Hakkında"){
            performSegue(withIdentifier: "toHakkindaVC", sender: nil)
        }
        if secilenBolum.elementsEqual("Hesap Bilgilerim"){
            performSegue(withIdentifier: "toHesapBilgilerimVC", sender: nil)
        }
        if secilenBolum.elementsEqual("Engellenen Kullanıcılar"){
            performSegue(withIdentifier: "toEngellenenVC", sender: nil)
        }
        if secilenBolum.elementsEqual("Öneriler"){
            performSegue(withIdentifier: "toOnerilerVC", sender: nil)
        }
        if secilenBolum.elementsEqual("Çıkış Yap"){
            confirmLogout()
        }
    }
    // Kontrol etmek için bir fonksiyon oluştur
    func kontrolEtIsletmeProfili() {
        if let currentUser = Auth.auth().currentUser {
            let kullaniciEpostasi = currentUser.email
            
            // Firestore veritabanı referansını al
            let db = Firestore.firestore()
            
            // Firestore veritabanına veri eklemek için bir koleksiyon referansı oluştur
            let isletmelerCollection = db.collection("isletmeler")
            
            // Firestore'da aktif kullanıcının e-postasını içeren bir belge olup olmadığını kontrol et
            isletmelerCollection.whereField("eposta", isEqualTo: kullaniciEpostasi ?? "").getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.hataMesajiGoster("Isletme profili kontrolü sırasında bir hata oluştu: \(error.localizedDescription)")
                } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                    print("Isletme profili mevcut") // Isletme profili mevcutsa burada işlem yapabilirsiniz
                    // Isletme profili mevcutsa hedef view controller'a geçiş yap
                    self.performSegue(withIdentifier: "toIsletmeProfiliVCGecis", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "toIsletme", sender: nil)

                }
            }
        }
        
    }
    
    
}
