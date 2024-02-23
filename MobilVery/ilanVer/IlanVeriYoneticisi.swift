

import Foundation
import UIKit

class IlanVeriYoneticisi {
    
    static let paylasilan = IlanVeriYoneticisi()
    
    let ilanId = UUID().uuidString
    var selectedPhotos: [UIImage] = []
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
    var epostaAdresi: String?
    var acilSatilikMi: Bool?
    var adSoyad: String?
    private init() {}
    
}
