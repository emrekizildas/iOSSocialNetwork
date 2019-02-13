//
//  UploadViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 21.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import SCLAlertView

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {


    @IBOutlet weak var baslik: SkyFloatingLabelTextField!
   
    @IBOutlet weak var icerik: UITextView!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var postBtn: UIBarButtonItem!
    
    @IBOutlet weak var selectBtn: UIBarButtonItem!
    
    @IBOutlet weak var turpicker: UIPickerView!
    
    @IBOutlet weak var theScrollView: UIScrollView!
    var photoVarMi = false
    
    var picker = UIImagePickerController()
    var tecrubesi: String!
    
    let limitLength = 35

    var tecrubeler = ["İş Tecrübesi", "Okul Tecrübesi", "Alışveriş Tecrübesi", "Seyahat Tecrübesi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        turpicker.delegate = self
        turpicker.dataSource = self
        baslik.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.dismissKeyboard))
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    @IBAction func geriAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        baslik.endEditing(true)
        icerik.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            self.photoVarMi = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func selectPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    

    @IBAction func postPressed(_ sender: Any) {
        guard baslik.text != "", icerik.text != "" else {
            SCLAlertView().showError("Dikkat!", subTitle: "Lütfen başlık veya içeriği boş bırakmayınız")
            return
        }
        
        //AppDelegate.instance().showActivityIndicator()
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
                                "onay": 0,
                                "baslik": self.baslik.text!,
                                "icerik": self.icerik.text!,
                                "turu": self.tecrubesi,
                                "author": FIRAuth.auth()!.currentUser!.displayName!,
                                "postID": key] as [String: Any]
                    
                    let postFeed = ["\(key)": feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    //AppDelegate.instance().dismissActivityIndicator()
                    ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                    SCLAlertView().showTitle(
                        "Gönderildi", // Title of view
                        subTitle: "Tecrübeniz onaylandıktan sonra yayınlanacaktır.", // String of view
                        duration: 3.0, // Duration to show before closing automatically, default: 0.0
                        completeText: "Tamam", // Optional button value, default: ""
                        style: .notice, // Styles - see below.
                        colorStyle: 0xA429FF,
                        colorTextButton: 0xFFFFFF
                    )
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
                        "onay": 0,
                        "baslik": self.baslik.text!,
                        "icerik": self.icerik.text!,
                        "turu": self.tecrubesi,
                        "author": FIRAuth.auth()!.currentUser!.displayName!,
                        "postID": key] as [String: Any]
            
            let postFeed = ["\(key)": feed]
            
            ref.child("posts").updateChildValues(postFeed)
            
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anaekran")
            self.present(vc, animated:false, completion: nil)
            ViewControllerUtils().hideActivityIndicator(uiView: self.view)
            SCLAlertView().showTitle(
                "Gönderildi", // Title of view
                subTitle: "Tecrübeniz onaylandıktan sonra yayınlanacaktır.", // String of view
                duration: 3.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Tamam", // Optional button value, default: ""
                style: .notice, // Styles - see below.
                colorStyle: 0xA429FF,
                colorTextButton: 0xFFFFFF
            )
        }
        

    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tecrubeler.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.tecrubesi = tecrubeler[row]
        return tecrubeler[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tecrubesi = tecrubeler[row]
    }
}
