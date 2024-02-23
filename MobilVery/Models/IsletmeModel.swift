
import Foundation


class IsletmeModel {
    var isletmeAdi: String?
    var ilce: String?
    var il: String?
    var mahalle: String?
    var caddeSokak: String?
    var bina: String?
    
    var email: String?
    var gorselUrl: String?
    var telefonNo: String?
    
   // var gorsel: String?

    init(dictionary: [String: Any]) {
        self.isletmeAdi = dictionary["isletmeAdi"] as? String ?? ""
        self.ilce = dictionary["ilce"] as? String ?? ""
        self.il = dictionary["il"] as? String ?? ""
        self.email = dictionary["eposta"] as? String ?? ""
        self.gorselUrl = dictionary["profilFotoURL"] as? String ?? ""
        self.telefonNo = dictionary["telefonNo"] as? String ?? ""
        self.bina = dictionary["siteApartman"] as? String ?? ""
        self.caddeSokak = dictionary["cadde"] as? String ?? ""
        self.mahalle = dictionary["mahalle"] as? String ?? ""
        
    }
}
