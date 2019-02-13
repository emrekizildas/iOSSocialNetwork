//
//  GirisViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 7.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
//import SwiftVideoBackground
//import SCLAlertView


class GirisViewController: UIViewController {
    
    
    
    //@IBOutlet weak var BackgroundVideo: BackgroundVideo!
    @IBOutlet weak var sifre: SkyFloatingLabelTextField!
    @IBOutlet weak var ePosta: SkyFloatingLabelTextField!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    
    
    @IBAction func grsAct(_ sender: Any) {
        guard sifre.text != "", ePosta.text != "" else { return }
        
        self.login(email: self.ePosta.text!, sifre: self.sifre.text!)

    
    }
    
    
    public func login(email: String, sifre: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: sifre, completion: {
            user, error in
            if error != nil {
                //self.errorLabel.text = ("Invalid email address or password")
                print(error ?? "")
                 ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            } else {
                print("login successful")
                 ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(self.ePosta.text!, forKey: "email")
                userDefaults.setValue(self.sifre.text!, forKey: "sifre")
                let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                self.present(vc, animated:false, completion: nil)
            }
        })
    }
    
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GirisViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        inputHallet()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.theScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.theScrollView.contentInset = contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
       /* let userDefaults = UserDefaults.standard
        
        if userDefaults.string(forKey: "email") != nil {
            
            let email = userDefaults.string(forKey: "email")
            
            let password = userDefaults.string(forKey: "sifre")
            
            
            
            login(email: email!, sifre: password!)
            
        }*/
    }
    

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        ePosta.endEditing(true)
        sifre.endEditing(true)
    }
    
    func inputHallet () {
        sifre.placeholder = "Parola"
        sifre.title = "Parola"
        sifre.tintColor = overcastBlueColor // the color of the blinking cursor
        sifre.textColor = UIColor.white
        sifre.selectedTitleColor = UIColor.white
        sifre.selectedLineColor = UIColor.white
        sifre.lineHeight = 0.5 // bottom line height in points
        sifre.selectedLineHeight = 0.28
        
        ePosta.placeholder = "E-Posta Adresi"
        ePosta.title = "E-Posta Adresi"
        ePosta.tintColor = overcastBlueColor // the color of the blinking cursor
        ePosta.textColor = UIColor.white
        ePosta.selectedTitleColor = UIColor.white
        ePosta.selectedLineColor = UIColor.white
        ePosta.lineHeight = 0.5 // bottom line height in points
        ePosta.selectedLineHeight = 0.28
    }
    
    @IBAction func geriAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
