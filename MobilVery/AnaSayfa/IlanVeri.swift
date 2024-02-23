

import Foundation
import UIKit

class IlanVeri {
    
    init() {
          // Sınıfın initializer'ı
      }
    static let paylasilan = IlanVeri()
    let ilanId = UUID().uuidString
    var selectedPhotos: [UIImage] = []
    var marka: String?
    var model: String?
    var renk: String?
    var hafiza: String?
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
   // var gorselUrlDizisi: [String] = []
    var epostaAdresi: String?
    
    
}
