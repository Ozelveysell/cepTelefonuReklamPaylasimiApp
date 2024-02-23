
import UIKit
import FirebaseFirestore
import FirebaseAuth
class AnaSayfaMesajGonderVC: UIViewController , UIScrollViewDelegate , UITextViewDelegate {
    
    
    var mesajlar: [Mesaj] = []
    var selectedIlanID: String?
    var adSoyad: String?
    var aliciEmail: String?
    @IBOutlet weak var gonderButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        textView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.reloadData() // Tabloyu yenile
        
        // TableView'i yeniden yüklemeden önce son eklenen mesaja gitmek için bir düğmeye tıklayın
        fetchPreviousMessagesForCurrentUser()
        let scrollToBottomButton = UIBarButtonItem(title: "En Alt", style: .plain, target: self, action: #selector(scrollToBottom))
        self.navigationItem.rightBarButtonItem = scrollToBottomButton

        // UITapGestureRecognizer ile klavyeyi kapatma
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(tapGesture)
        // Klavye açıldığında klavye boyutunda otomatik kaydırma için bildirimlere abone olun
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeAçıldı(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeKapandı(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    override func viewWillAppear(_ animated: Bool) {
  
        if let selectedIlanId = selectedIlanID {
           FirebaseVeriCek(ilanId: selectedIlanId)
        }
        
        textView.becomeFirstResponder()
        
        // Imlecin yanıp sönme animasyonunu başlatan işlevi çağırın
        startCursorAnimation()

   
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Silme işlemini kontrol edin
        if text == "" && range.length > 0 {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: "")
            textView.text = newText
            return false
        }
        
        // Diğer metin değişikliklerini onaylayın
        return true
    }
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
  func startCursorAnimation() {
        // Imleci yanıp sönme animasyonunu başlatmak için bir döngü kullanın
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            // Imlec görünmez hale gelir
            self.textView.tintColor = .black
        }, completion: nil)
    }
  @objc func scrollToBottom() {
        if mesajlar.isEmpty { return }
        let indexPath = IndexPath(row: mesajlar.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Kullanıcı ekranı aşağı kaydırdığında klavyeyi kapat
        if scrollView.contentOffset.y < 0 {
            view.endEditing(true)
        }
    }
    @objc func klavyeKapandı(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size) != nil {
            
            print("klavye kapandi")
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)

            let contentOnset = CGPoint(x: 0, y: 0  )
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            scrollView.setContentOffset(contentOnset, animated: true)
        }
      

    }
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
      return true

  }
    @objc func klavyeAçıldı(notification: Notification) {
        if let klavyeBoyutu = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
        //    let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150 , right: 0)
            let contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y + 150 )
            
       //     scrollView.contentInset = contentInset
     //       scrollView.scrollIndicatorInsets = contentInset
            scrollView.setContentOffset(contentOffset, animated: true)
        }
    }
    
    func FirebaseVeriCek(ilanId: String) {
        let db = Firestore.firestore()
        
        let query = db.collection("ilanlar").whereField("ilanId", isEqualTo: ilanId)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                // Hata durumunda yapılacak işlemleri burada gerçekleştirin
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Belgeler bulunamadı veya hata oluştu.")
                // Belgeler bulunamama veya hata durumunda yapılacak işlemleri burada gerçekleştirin
                return
            }
            
         
            // Belgeler var ve çekildi
            for document in documents {
                let ilanModel = IlanModel(dictionary: document.data())
                
                self.aliciEmail = ilanModel.email!
                self.adSoyad = ilanModel.adSoyad!.uppercased()
          }

            // TableView ve CollectionView'ı güncelle
            DispatchQueue.main.async {
                if self.adSoyad != "" || self.adSoyad != nil {
                    
                    print(self.adSoyad)
                    
                    self.navigationController?.navigationBar.topItem?.title = self.adSoyad!

                }
           
            }
        }
    }
    
    
    @IBAction func gonderButtonClicked(_ sender: Any) {
        
     if let text = textView.text, !text.isEmpty {
         let mesaj = Mesaj(mesaj: text, gönderen: Auth.auth().currentUser?.email) //
         mesaj.tarih = Date()
       if self.aliciEmail != "" {
             mesaj.alici = self.aliciEmail
             // Firestore referansını alın
             let db = Firestore.firestore()
             
             // Firestore'a mesajı ekleyin
             db.collection("mesajlar").addDocument(data: mesaj.dictionary) { error in
                 if let error = error {
                     print("Firestore'a mesaj ekleme hatası: \(error.localizedDescription)")
                     // Hata durumunda yapılacak işlemleri burada gerçekleştirin
                 } else {
                     // Mesaj başarıyla Firestore'a kaydedildi
                     self.mesajlar.append(mesaj)
                     self.tableView.reloadData()
                     self.textView.text = ""
                     
                     self.scrollToBottom()
                 }
             }
         }
     }
        
    }




    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Saat ve dakika biçimi
        return dateFormatter.string(from: date)
    }
    
   
        func fetchPreviousMessagesForCurrentUser() {
            guard let currentUserEmail = Auth.auth().currentUser?.email else {
                print("Kullanıcı oturumu açmış değil.")
                return
            }
            let db = Firestore.firestore()
        
           
            let query = db.collection("mesajlar").whereField("gönderen", in: [currentUserEmail, aliciEmail]).whereField("alici", in: [currentUserEmail, aliciEmail])
            //   .limit(to: 1) // Yalnızca son mesajı alın
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Mesajları çekerken hata oluştu: \(error.localizedDescription)")
                        return
                    }
                    guard let documents = querySnapshot?.documents else {
                        print("Önceki mesajlar bulunamadı.")
                        return
                    }
                    
                    // Firestore'dan çekilen belgeleri Mesaj nesnelerine dönüştürün
                    for document in documents {
                        if let mesaj = Mesaj(dictionary: document.data()) {
                            self.mesajlar.append(mesaj)
                            print(mesaj)
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    
}
extension AnaSayfaMesajGonderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesajlar.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anaSayfaMesajGonderCell", for: indexPath) as! AnaSayfaMesajGonderTableCell
        
        let ileti = mesajlar[indexPath.row]
        cell.mesajLabel.numberOfLines = 0
        cell.mesajLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.mesajSaatiLabel.translatesAutoresizingMaskIntoConstraints = false // Saat etiketini özelleştirme
        
        // Mesajın içeriği
        let message = ileti.mesaj
        
        // Mesaj etiketinin kısıtlamalarını ayarlama
        cell.mesajLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
        cell.mesajLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        cell.mesajLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8).isActive = true
        cell.mesajLabel.bottomAnchor.constraint(equalTo: cell.mesajSaatiLabel.topAnchor, constant: -8).isActive = true // Saat etiketinden önce boşluk bırak
        
        // Saat etiketinin kısıtlamalarını ayarlama (mesaj etiketinin altına)
        cell.mesajSaatiLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
        cell.mesajSaatiLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        cell.mesajSaatiLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8).isActive = true
        
        cell.mesajLabel.text = message
        
        if ileti.gönderen == Auth.auth().currentUser?.email {
            // Gönderilen mesajları sağa hizala veya farklı bir arayüzle işaretleyin
            let stringDate = formatDate(date: ileti.tarih!)
            cell.mesajSaatiLabel.text = stringDate
            cell.mesajLabel.textAlignment = .right
            cell.mesajSaatiLabel.textAlignment = .right
        } else {
            // Alınan mesajları sola hizala veya farklı bir arayüzle işaretleyin
            let stringDate = formatDate(date: ileti.tarih!)
            cell.mesajSaatiLabel.text = stringDate
            cell.mesajLabel.textAlignment = .left
            cell.mesajSaatiLabel.textAlignment = .left
        }
        
        return cell
    }
}
