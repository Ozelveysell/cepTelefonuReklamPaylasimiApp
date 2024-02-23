
import Foundation


class Mesajlar {
    var gönderenKullanıcı: String
    var alıcıKullanıcı: String?
    var mesajIcerigi: String?
    var tarih: String?

    init(dictionary: [String: Any]) {
        self.email = dictionary["epostaAdresi"] as? String ?? ""
        self.ilanId = dictionary["ilanId"] as? String ?? ""
        self.marka = dictionary["marka"] as? String ?? ""
        self.model = dictionary["model"] as? String ?? ""
        self.renk = dictionary["renk"] as? String ?? ""
        self.hafiza = dictionary["hafiza"] as? String ?? ""
        self.garanti = dictionary["garanti"] as? String ?? ""
        self.takas = dictionary["takas"] as? String ?? ""
        self.aciklama = dictionary["aciklama"] as? String ?? ""
        self.baslik = dictionary["baslik"] as? String ?? ""
        self.telefon = dictionary["telefon"] as? String ?? ""
        self.fiyat = dictionary["fiyat"] as? String ?? ""
        self.mahalle = dictionary["mahalle"] as? String ?? ""
        self.sokak = dictionary["sokak"] as? String ?? ""
        self.siteApartman = dictionary["siteApartman"] as? String ?? ""
        self.ilce = dictionary["ilce"] as? String ?? ""
        self.sehir = dictionary["sehir"] as? String ?? ""
        self.adSoyad = dictionary["adSoyad"] as? String ?? ""
        self.selectedPhotos = dictionary["selectedPhotos"] as? [String] ?? []
        self.acilSatilikMi = dictionary["acilSatilikMi"] as? Bool ?? false

    }
}
