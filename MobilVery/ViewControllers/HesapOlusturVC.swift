//
//  HesapOlusturVC.swift
//  MobilVery
//
//  Created by veysel on 8.09.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class HesapOlusturVC: UIViewController  {

    @IBOutlet weak var label: UILabel!
   
    @IBOutlet weak var epostabutton: UIButton!
    
    @IBOutlet weak var applebutton: UIButton!
    
    @IBOutlet weak var googlebutton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.numberOfLines = 2 // İki satıra izin ver
     //   label.lineBreakMode = .byWordWrapping // Kelimeleri sarma (word wrap) modunda ayarla
        label.text = "Hesap oluşturmak için e-postanızı veya sosyal medya hesabınızı kullanın."
 
 // UIButton'in kenarlarını yuvarlatma
 applebutton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
 applebutton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
 
 // UIButton'in kenarlarını yuvarlatma
 epostabutton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
 epostabutton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
 
 // UIButton'in kenarlarını yuvarlatma
 googlebutton.layer.cornerRadius = 18 // Kenar yarıçapını istediğiniz değere ayarlayın
 googlebutton.clipsToBounds = true // Kenar yarıçapını ayarladığınızda bu özelliği true yapın
       
        
    }
    

    @IBAction func epostaButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toHesapOlusturSegue3", sender: nil)
    }
    
    
    @IBAction func appleButtonClicked(_ sender: Any) {
    }
 
    
    @IBAction func googleButtonClicked(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
           print("Hata1")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          // ...
        }
    }
    
    
    
}
