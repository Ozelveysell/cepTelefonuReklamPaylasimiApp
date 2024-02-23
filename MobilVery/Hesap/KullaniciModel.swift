
import Foundation

class KullaniciModel {
    var ad: String?
    var soyad: String?

    var email: String?
  
    init(dictionary: [String: Any]) {
        self.email = dictionary["eposta"] as? String ?? ""
        self.ad = dictionary["ad"] as? String ?? ""
        self.soyad = dictionary["soyad"] as? String ?? ""
   
    }
}
