//
//  Adim2View.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 1.02.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase

class Adim2View: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    

    var picker = UIImagePickerController()
    @IBOutlet weak var baslikLbl: UILabel!
    var baslik: String!
    struct Constants {
        static var tur: String = ""
    }
    @IBOutlet weak var previewImage: UIImageView!
    var photoVarMi = false

    @IBOutlet weak var icerikText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(baslik ?? "yok")
        baslikLbl.text = baslik ?? "yok"
        icerikText.text = "İçerik gir..."
        icerikText.textColor = UIColor.lightGray
        picker.delegate = self
        self.addDoneButtonOnKeyboard()

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            self.photoVarMi = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gonder(_ sender: Any) {
        if Constants.tur == "" {
            SCLAlertView().showError("Dikkat!", subTitle: "Lütfen tecrübe türünü seçiniz.")
            return
        }
        else if baslik == "" || baslik == "yok" {
            SCLAlertView().showError("Dikkat!", subTitle: "Lütfen başlık giriniz.")
            return
        }
        else if icerikText.text == "" || icerikText.text == "İçerik gir..." || icerikText.text == " " {
            SCLAlertView().showError("Dikkat!", subTitle: "Lütfen içerik giriniz.")
            return
        }
        
        
        ViewControllerUtils().showActivityIndicator(uiView: self.view, metin: "Yükleniyor")
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://tecrubesi-ffb8e.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid!).child("\(key).jpg")
   
        if (self.photoVarMi == true)
        {
            let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.5)
            
            let uploadTask = imageRef.put(data!, metadata: nil) {(metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    //  AppDelegate.instance().dismissActivityIndicator()
                    ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        let feed = ["userID": uid!,
                                    "pathToImage": url.absoluteString,
                                    "likes": 0,
                                    "youtube": "",
                                    "onay": 1,
                                    "baslik": self.baslik,
                                    "icerik": self.icerikText.text!,
                                    "turu": Constants.tur,
                                    "author": FIRAuth.auth()!.currentUser!.displayName!,
                                    "postID": key] as [String: Any]
                        
                        let postFeed = ["\(key)": feed]
                        
                        ref.child("posts").updateChildValues(postFeed)
                        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
                        self.present(vc, animated:false, completion: nil)
                    }
                })
                
            }
            
            
            uploadTask.resume()
        }
        else
        {
            let feed = ["userID": uid!,
                        "pathToImage": "",
                        "likes": 0,
                        "youtube": "",
                        "onay": 1,
                        "baslik": self.baslik,
                        "icerik": self.icerikText.text!,
                        "turu": Constants.tur,
                        "author": FIRAuth.auth()!.currentUser!.displayName!,
                        "postID": key] as [String: Any]
            
            let postFeed = ["\(key)": feed]
            
            ref.child("posts").updateChildValues(postFeed)
            
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
            self.present(vc, animated:false, completion: nil)
        }
        
        

    }
    
  
    @IBAction func gorselEkleme(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }

    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
            print(Constants.tur)
            
        }
    }
    
   
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "İçerik gir..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Bitti", style: UIBarButtonItemStyle.done, target: self, action: #selector(Adim2View.doneButtonAction))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.icerikText.inputAccessoryView = doneToolbar
      //  self.textField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.icerikText.resignFirstResponder()
      //  self.textViewDescription.resignFirstResponder()
    }

}
