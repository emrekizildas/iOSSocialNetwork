//
//  KayitViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 21.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class KayitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sifre: SkyFloatingLabelTextField!
    @IBOutlet weak var ePosta: SkyFloatingLabelTextField!
    @IBOutlet weak var adsoyad: SkyFloatingLabelTextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var kayitBtn: UIButton!
    @IBOutlet weak var theScrollView: UIScrollView!
    
    var ref: FIRDatabaseReference!
    var picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        ref = FIRDatabase.database().reference(fromURL: "https://tecrubesi-ffb8e.firebaseio.com/")
        let storage = FIRStorage.storage().reference(forURL: "gs://tecrubesi-ffb8e.appspot.com")
        userStorage = storage.child("users")
        inputHallet()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(KayitViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info [UIImagePickerControllerEditedImage] as? UIImage {
                self.imgView.image = image
                selectBtn.isHidden = true
                kayitBtn.isHidden = false
            }
            
            self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func selectPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
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
        
        adsoyad.placeholder = "Ad Soyad"
        adsoyad.title = "Ad Soyad"
        adsoyad.tintColor = overcastBlueColor // the color of the blinking cursor
        adsoyad.textColor = UIColor.white
        adsoyad.selectedTitleColor = UIColor.white
        adsoyad.selectedLineColor = UIColor.white
        adsoyad.lineHeight = 0.5 // bottom line height in points
        adsoyad.selectedLineHeight = 0.28
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        ePosta.endEditing(true)
        sifre.endEditing(true)
        adsoyad.endEditing(true)
    }
    
 
    @IBAction func kytAction(_ sender: Any) {
        guard sifre.text != "", ePosta.text != "", adsoyad.text != "" else { return }
        ViewControllerUtils().showActivityIndicator(uiView: self.view, metin: "")
        FIRAuth.auth()?.createUser(withEmail: ePosta.text!, password: sifre.text!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)

            }
            
            if  let user = user {
                
                let changerequest = FIRAuth.auth()?.currentUser!.profileChangeRequest()
                changerequest?.displayName = self.adsoyad.text!
                changerequest?.commitChanges(completion: nil)
                
                let imageRef = self.userStorage.child("\(user.uid).jpg")
                let data = UIImageJPEGRepresentation(self.imgView.image!, 0.3)
                let uploadTask  = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    imageRef.downloadURL(completion: { (url, er) in
                        if er != nil {
                            print(er?.localizedDescription ?? "")
                            return
                        }
                        if let url = url {
                            
                            let userInfo: [String: Any] = ["uid": user.uid,
                                                           "adsoyad": self.adsoyad.text!,
                                                           "email": self.ePosta.text!,
                                                           "sifre": self.sifre.text!,
                                                           "profilImg": url.absoluteString]
                            self.ref.child("users").child(user.uid).setValue(userInfo)
                            
                            
                            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                            self.present(vc, animated:true, completion: nil)
                            let userDefaults = UserDefaults.standard
                            userDefaults.setValue(self.ePosta.text!, forKey: "email")
                            userDefaults.setValue(self.sifre.text!, forKey: "sifre")
                        }
                    })
                })
                
                uploadTask.resume()

            }
        })
        

    }
    
    
    @IBAction func geriAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func ppAct(_ sender: Any) {
        
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
