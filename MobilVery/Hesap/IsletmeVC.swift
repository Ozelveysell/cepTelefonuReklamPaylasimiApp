//
//  IsletmeVC.swift
//  MobilVery
//
//  Created by veysel on 1.11.2023.
//

import UIKit
import Firebase
import CoreLocation


class IsletmeVC: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var isletmeTelefonText: UITextField!
    
    
    @IBOutlet weak var isletmeAdiText: UITextField!
    
    
    @IBOutlet weak var mahalleText: UITextField!
    
    
    @IBOutlet weak var caddeText: UITextField!
    
    
    @IBOutlet weak var siteApartmanText: UITextField!
    
    
    @IBOutlet weak var ilceText: UITextField!
    
    
    @IBOutlet weak var ilText: UITextField!
    
    var locationManager: CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self

        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("1")
           if let location = locations.last {
               print("2")

               let geocoder = CLGeocoder()
               geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                   if let error = error {
                       print("Konum bilgisi alınamadı: \(error.localizedDescription)")
                       self.hataMesajiGoster("Konum bilgisi alınamadı. Lütfen tekrar deneyin.")
                       return

                   }
                   
                   if let placemark = placemarks?.first {
                       let il = placemark.administrativeArea ?? ""
                       let ilce = placemark.locality ?? ""
                       let mahalle = placemark.subLocality ?? ""
                       
                       DispatchQueue.main.async {
                           self.ilText.text = il
                           self.ilceText.text = ilce
                           self.mahalleText.text = mahalle
                       }
                   }
               }
           }
       }
    
    @IBAction func mevcutKonumuKullanButtonClicked(_ sender: Any) {
        
        
        // mevcut konum buttonu suan icin yanlis calisiyor !!!!!!!!
        
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        self.bitirButtonClicked((Any).self)
        
    }
    
    
    @IBAction func bitirButtonClicked(_ sender: Any) {
        
        
        guard let isletmeAdi = isletmeAdiText.text, !isletmeAdi.isEmpty else {
            hataMesajiGoster("İşletme adı boş olamaz")
            return
        }
        
        // Firestore veritabanı referansını al
        let db = Firestore.firestore()
        
        // Firestore veritabanına veri eklemek için bir koleksiyon referansı oluştur
        let isletmelerCollection = db.collection("isletmeler")
        
        // Kullanıcıdan girilen işletme adının benzersiz olup olmadığını kontrol et
        isletmelerCollection.whereField("isletmeAdi", isEqualTo: isletmeAdi).getDocuments { (querySnapshot, error) in
            if let error = error {
                //   self.hataMesajiGoster("İşletme adı kontrolü sırasında bir hata oluştu: \(error.localizedDescription)")
                
                print("İşletme adı kontrolü sırasında bir hata oluştu: \(error.localizedDescription)")
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                //  self.hataMesajiGoster("İşletme adı zaten kullanılıyor. Lütfen farklı bir işletme adı seçin.")
                
                print("İşletme adı zaten kullanılıyor. Lütfen farklı bir işletme adı seçin.")
            } else {
                // Kullanıcı işletme adını kullanabilir, verileri Firestore'a ekleyin
                if let currentUser = Auth.auth().currentUser {
                    let kullaniciEpostasi = currentUser.email
                    isletmelerCollection.addDocument(data: [
                        "isletmeAdi": isletmeAdi,
                        "mahalle": self.mahalleText.text ?? "",
                        "cadde": self.caddeText.text ?? "",
                        "siteApartman": self.siteApartmanText.text ?? "",
                        "ilce": self.ilceText.text ?? "",
                        "il": self.ilText.text ?? "",
                        "eposta": kullaniciEpostasi ?? "",
                        "telefonNo": self.isletmeTelefonText.text ?? ""
                    ]) { error in
                        if let error = error {
                            //     self.hataMesajiGoster("Verileri Firestore'a eklerken bir hata oluştu: \(error.localizedDescription)")
                            print("Verileri Firestore'a eklerken bir hata oluştu: \(error.localizedDescription)")
                            
                        } else {
                            //  self.hataMesajiGoster("Veriler başarıyla Firestore'a eklendi.")
                            print("Veriler başarıyla Firestore'a eklendi.")
                            
                        }
                    }
                } else {
                    //  self.hataMesajiGoster("Kullanıcı oturum açmamış.")
                    print("Kullanıcı oturum açmamış.")
                    
                }
            }
        }
    }
    
    
    // Hata mesajını gösteren yardımcı bir fonksiyon
    func hataMesajiGoster(_ mesaj: String) {
        let alertController = UIAlertController(title: "Bilgi", message: mesaj, preferredStyle: .alert)
        //  alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        // Hata mesajını 1 saniye sonra otomatik olarak kapatmak için Timer kullanılıyor
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
  
    
    
}
