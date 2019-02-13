//
//  TutorialViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 23.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SCLAlertView

class AnaGirisViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var backVideo: BackgroundVideo!
    var ref: FIRDatabaseReference!
    var dict : NSDictionary!

    

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageImageView: UIImageView!

    @IBOutlet weak var pageCaptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
                ref = FIRDatabase.database().reference(fromURL: "https://tecrubesi-ffb8e.firebaseio.com/")
        backVideo.createBackgroundVideo(name: "Background", type: "mp4", alpha: 0.5)
        
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: (view.frame.width)-(view.frame.width-16), y: (view.frame.height / 2)+150, width: (view.frame.width-32), height: 50)
        let titleText = NSAttributedString(string: "Facebook İle Giriş Yap")
        loginButton.setAttributedTitle(titleText, for: UIControlState.normal)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        // Do any additional setup after loading the view.
    }
    

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }

        print("fbmidegilmi")
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name, id, picture.type(small)"])
            .start(completionHandler:  {
                (connection, result, error) in
                
                if(error != nil) {
                    print(error ?? "")
                    return
                }
                
                let accessToken = FBSDKAccessToken.current()
                guard let accessTokenString = accessToken?.tokenString else { return }
                
                    self.dict = result as! NSDictionary
                   guard let user_email = self.dict.object(forKey: "email") as? String,
                    let user_name = self.dict.object(forKey:"name") as? String,
                    let profil_img = ((self.dict.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as? String else {
                        SCLAlertView().showError("Hata", subTitle: "Giriş için e-posta adresi gereklidir.", duration:3)
                        let loginManager = FBSDKLoginManager()
                        loginManager.logOut()
                        try! FIRAuth.auth()?.signOut()
                        return }
                
                

                let cer = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                print("dneme")
                
                FIRAuth.auth()?.signIn(with: cer, completion: { (user, error) in
                    if error != nil {
                        print("error var:", error ?? "")
                        return
                    }
                    
                    
                    if  let user = user {
                        print("fbmi")
                        self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.childrenCount == 0 {
                                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                                self.present(vc, animated:false, completion: nil)
                                let changerequest = FIRAuth.auth()?.currentUser!.profileChangeRequest()
                                changerequest?.displayName = user_name
                                changerequest?.commitChanges(completion: nil)
                                
                                let userInfo: [String: Any] = ["uid": user.uid,
                                                               "adsoyad": user_name,
                                                               "email": user_email,
                                                               "sifre": accessTokenString,
                                                               "profilImg": profil_img]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                let userDefaults = UserDefaults.standard
                                userDefaults.setValue(user_email, forKey: "email")
                                userDefaults.setValue("evet", forKey: "fblogin")
                                userDefaults.setValue(accessTokenString, forKey: "sifre")
                            }
                            else
                            {
                                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                                self.present(vc, animated:false, completion: nil)
                                let userDefaults = UserDefaults.standard
                                userDefaults.setValue(user_email, forKey: "email")
                                userDefaults.setValue(accessTokenString, forKey: "sifre")
                                userDefaults.setValue(accessTokenString, forKey: "fblogin")
                            }

                        })
                        
                        
                        
                        
                        print("Başarıyla girdin karşim:", user )
                        
                        //print(user_gender)
                        
                    }
                    
                })
            })



    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("login button did logout")
    }
    
       
    
    
    
    
    
    

}
