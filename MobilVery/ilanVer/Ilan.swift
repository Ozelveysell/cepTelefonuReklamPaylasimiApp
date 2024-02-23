

import Foundation

class Ilan {
    var marka: String
    var model: String
    
    
    init(marka: String, model: String) {
        self.marka = marka
        self.model = model
    }

}

// Telefon markalarını ve modellerini içeren sözlük
let telefonModelleri: [String: [Ilan]] = [
    "Apple": [
      Ilan( marka: "Apple", model: "iPhone 14 Pro Max"),
      Ilan( marka: "Apple", model: "iPhone 14 Pro "),
      Ilan( marka: "Apple", model: "iPhone 14 Plus"),
      Ilan( marka: "Apple", model: "iPhone 14 "),
      Ilan( marka: "Apple", model: "iPhone 13 Pro Max"),
      Ilan( marka: "Apple", model: "iPhone 13 Pro "),
      Ilan( marka: "Apple", model: "iPhone 13"),
      Ilan( marka: "Apple", model: "iPhone 13 Mini"),
      Ilan( marka: "Apple", model: "iPhone 12 Pro Max"),
      Ilan( marka: "Apple", model: "iPhone 12 Pro "),
      Ilan( marka: "Apple", model: "iPhone 12 Mini "),
      Ilan( marka: "Apple", model: "iPhone 12"),
      Ilan( marka: "Apple", model: "iPhone SE (2. nesil)"),
      Ilan( marka: "Apple", model: "iPhone 11 Pro Max "),
      Ilan( marka: "Apple", model: "iPhone 11 Pro"),
      Ilan( marka: "Apple", model: "iPhone 11 "),
      Ilan( marka: "Apple", model: "iPhone XS Max"),
      Ilan( marka: "Apple", model: "iPhone XS "),
      Ilan( marka: "Apple", model: "iPhone XR"),
      Ilan( marka: "Apple", model: "iPhone X"),
      Ilan( marka: "Apple", model: "iPhone 8 Plus"),
      Ilan( marka: "Apple", model: "iPhone 8 "),
      Ilan( marka: "Apple", model: "iPhone 7 Plus "),
      Ilan( marka: "Apple", model: "iPhone 7"),
      Ilan( marka: "Apple", model: "iPhone 6s Plus"),
      Ilan( marka: "Apple", model: "iPhone 6s "),
      Ilan( marka: "Apple", model: "iPhone 6 Plus "),
      Ilan( marka: "Apple", model: "iPhone 6"),
      Ilan( marka: "Apple", model: "iPhone 5s"),
      Ilan( marka: "Apple", model: "iPhone 5"),
      Ilan( marka: "Apple", model: "iPhone 4s"),
      Ilan( marka: "Apple", model: "iPhone 3GS"),
      Ilan( marka: "Apple", model: "iPhone 3G"),
      Ilan( marka: "Apple", model: "iPhone (1. nesil)"),
      
        
      
    ],
    "Samsung": [
        
        
        
        Ilan( marka: "Samsung", model: "Galaxy S21 Ultra"),
        Ilan( marka: "Samsung", model: "Galaxy S21+"),
        Ilan( marka: "Samsung", model: "Galaxy S21"),
        Ilan( marka: "Samsung", model: "Galaxy S20 Ultra"),
        Ilan( marka: "Samsung", model: "Galaxy S20+"),
        Ilan( marka: "Samsung", model: "Galaxy S20"),
        Ilan( marka: "Samsung", model: "Galaxy Note 20 Ultra"),
        Ilan( marka: "Samsung", model: "Galaxy Note 20"),
        Ilan( marka: "Samsung", model: "Galaxy A71"),
        Ilan( marka: "Samsung", model: "Galaxy A51"),
        Ilan( marka: "Samsung", model: "Galaxy S10+"),
        Ilan( marka: "Samsung", model: "Galaxy S10"),

        Ilan( marka: "Samsung", model: "Galaxy S10e"),
        Ilan( marka: "Samsung", model: "Galaxy Note 10+"),
        Ilan( marka: "Samsung", model: "Galaxy Note 10"),
        Ilan( marka: "Samsung", model: "Galaxy A50"),
        Ilan( marka: "Samsung", model: "Galaxy A30"),
        Ilan( marka: "Samsung", model: "Galaxy A20"),
        
       
        Ilan( marka: "Samsung", model: "Galaxy J6+"),
        Ilan( marka: "Samsung", model: "Galaxy J4+"),
        Ilan( marka: "Samsung", model: "Galaxy J2 Core"),
        Ilan( marka: "Samsung", model: "Galaxy J8"),
        Ilan( marka: "Samsung", model: "Galaxy J6"),
        Ilan( marka: "Samsung", model: "Galaxy J4"),
        Ilan( marka: "Samsung", model: "Galaxy J2"),
   
        Ilan( marka: "Samsung", model: "Galaxy S9+"),
        Ilan( marka: "Samsung", model: "Galaxy S9"),
        Ilan( marka: "Samsung", model: "Galaxy Note 9"),
        Ilan( marka: "Samsung", model: "Galaxy J7"),
        Ilan( marka: "Samsung", model: "Galaxy J5"),
        Ilan( marka: "Samsung", model: "Galaxy J3"),
        
        
        
        Ilan( marka: "Samsung", model: "Galaxy A9 Pro"),
        Ilan( marka: "Samsung", model: "Galaxy A9"),
        Ilan( marka: "Samsung", model: "Galaxy A8"),
        Ilan( marka: "Samsung", model: "Galaxy A7"),
        Ilan( marka: "Samsung", model: "Galaxy A5"),
        Ilan( marka: "Samsung", model: "Galaxy A3"),
        
        
        
        Ilan( marka: "Samsung", model: "Galaxy Note 8"),
        Ilan( marka: "Samsung", model: "Galaxy S8+"),
        Ilan( marka: "Samsung", model: "Galaxy S8"),
        Ilan( marka: "Samsung", model: "Galaxy S7 Edge"),
        Ilan( marka: "Samsung", model: "Galaxy S7"),
        Ilan( marka: "Samsung", model: "Galaxy Note 7"),
     
        
      

    ],
    "Xiaomi": [
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),
        Ilan( marka: "Xiaomi", model: " "),

        ],
        "Huawei": [
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),
            Ilan( marka: "Huawei", model: " "),

        ],
        "Sony": [
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),
            Ilan( marka: "Sony", model: " "),


        ],
        "LG": [
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),
            Ilan( marka: "LG", model: " "),

            
        ],
        "Google": [
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),
            Ilan( marka: "Google", model: " "),

            
        ],
        "OnePlus": [
            Ilan( marka: "OnePlus", model: " "),
            Ilan( marka: "OnePlus", model: " "),
            Ilan( marka: "OnePlus", model: " "),
            Ilan( marka: "OnePlus", model: " "),
            Ilan( marka: "OnePlus", model: " "),


        ],
        "Nokia": [
            // Nokia modelleri buraya ekleyin
        ],
        "Motorola": [
            // Motorola modelleri buraya ekleyin
        ],
        "HTC": [
            // HTC modelleri buraya ekleyin
        ],
        "Lenovo": [
            // Lenovo modelleri buraya ekleyin
        ],
        "Asus": [
            // Asus modelleri buraya ekleyin
        ],
        "Oppo": [
            // Oppo modelleri buraya ekleyin
        ],
        "Vivo": [
            // Vivo modelleri buraya ekleyin
        ],
        "Realme": [
            // Realme modelleri buraya ekleyin
        ]
        // Diğer markaları da buraya ekleyin
]
