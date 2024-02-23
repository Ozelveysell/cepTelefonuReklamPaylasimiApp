
import Foundation
import FirebaseFirestore

class Mesaj {
    
    var mesaj: String?
    var gönderen: String?
    var alici: String?
    var tarih: Date? // Mesajın tarihi
    
    // Firestore'a kaydetmek için kullanılacak veri sözlüğü
    var dictionary: [String: Any] {
        return [
            "mesaj": mesaj ?? "",
            "gönderen": gönderen ?? "",
            "alici": alici ?? "",
            "tarih": tarih as Any
        ]
    }
    
    init(mesaj: String? = nil, gönderen: String? = nil, alici: String? = nil, tarih: Date? = nil) {
        self.mesaj = mesaj
        self.gönderen = gönderen
        self.alici = alici
        self.tarih = tarih
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let mesaj = dictionary["mesaj"] as? String,
              let gönderen = dictionary["gönderen"] as? String,
              let alici = dictionary["alici"] as? String,
              let tarihTimestamp = dictionary["tarih"] as? Timestamp else {
            return nil
        }
        
        // Timestamp'ı Date türüne çevirin
        let tarih = tarihTimestamp.dateValue()
        
        self.init(mesaj: mesaj, gönderen: gönderen, alici: alici, tarih: tarih)
    }

}
