//
//  AutoLoginViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 22.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AutoLoginViewController: UIViewController {
    
    var gir = true

    
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil) {
            print("fb login")
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            let cer = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            ViewControllerUtils().showActivityIndicator(uiView: self.view, metin: "")
            FIRAuth.auth()?.signIn(with: cer, completion: { (user, error) in
                if error != nil {
                    print("error var:", error ?? "")
                    ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                    let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
                    self.present(vc, animated:false, completion: nil)
                }
                else
                {
                    let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                    self.present(vc, animated:false, completion: nil)
                }
            })
            
        } else if FIRAuth.auth()?.currentUser?.uid != nil {
            ViewControllerUtils().showActivityIndicator(uiView: self.view, metin: "")
            //  login(email: email!, sifre: password!)
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
            self.present(vc, animated:false, completion: nil)
            print("b")
        }
        else
        {
            print("a")
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
            self.present(vc, animated:false, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          }
    
    func anagirisegec() {
         let vc2 =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
          self.present(vc2, animated:true, completion: nil)
    }
    
    public func login(email: String, sifre: String) {
         let userDefaults = UserDefaults.standard
        FIRAuth.auth()?.signIn(withEmail: email, password: sifre, completion: {
            user, error in
            if error != nil {
                //self.errorLabel.text = ("Invalid email address or password")
                print("email giris hatasi")
                 ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                print(error.debugDescription)
                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
                self.present(vc, animated:false, completion: nil)
            } else {
                print("email giris basarili")
                userDefaults.setValue(FIRAuth.auth()?.currentUser?.displayName, forKey: "adsoyad")

                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                self.present(vc, animated:false, completion: nil)
            }
        })
    }

}
