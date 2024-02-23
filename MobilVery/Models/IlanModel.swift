
import Foundation




class IlanModel {
    var selectedPhotos: [String] = []
    var ilanId: String
    var marka: String?
    var model: String?
    var renk: String?
    var hafiza: String? // Hafıza özelliği burada tanımlanır
    var garanti: String?
    var takas: String?
    var aciklama: String?
    var telefon: String?
    var baslik: String?
    var fiyat: String?
    var mahalle: String?
    var sokak: String?
    var siteApartman: String?
    var ilce: String?
    var sehir: String?
    var email: String?
    var acilSatilikMi: Bool
    var adSoyad: String?
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
