//
//  TecrubeViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 26.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import YouTubePlayer_Swift
import Kingfisher
import HidingNavigationBar


class TecrubeViewController: UIViewController {

    var baslik: String?
    var icerik: String?
    var tur: String?
    var yazan: String?
    var postID: String?
    var userID: String?
    var imgUrl: String?
    var youtubeUrl: String?
    
    @IBOutlet weak var scrollViewim: UIScrollView!
    var hidingNavBarManager: HidingNavigationBarManager?
    
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var yazarLbl: UILabel!
    @IBOutlet weak var altToolbar: UIToolbar!
    @IBOutlet weak var turImg: UIImageView!
   // @IBOutlet weak var navBaslik: UINavigationItem!
    @IBOutlet weak var baslikLbl: UILabel!
    @IBOutlet weak var icerikLbl: UITextView!
    @IBOutlet weak var tecrubeImg: UIImageView!
    @IBOutlet weak var yazanLbl: UILabel!
    @IBOutlet weak var yazarPic: UIImageView!

    @IBOutlet weak var likeBtn: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        let ref = FIRDatabase.database().reference()
        super.viewDidLoad()
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollViewim)
        baslikLbl.text = baslik
        icerikLbl.text = icerik
      //  yazarLbl.text = yazan
        if (imgUrl != "") {
            tecrubeImg.isHidden = false
            let tecrubeurl = URL(string: imgUrl!)
            tecrubeImg.kf.setImage(with: tecrubeurl)
        }
        else if (youtubeUrl != "")
        {
            videoPlayer.isHidden = false
            videoPlayer.backgroundColor = UIColor.black
            videoPlayer.playerVars = ["showinfo": "0" as AnyObject,
                                      "rel": "0" as AnyObject,
                                        "modestbranding": "1" as AnyObject]
            videoPlayer.loadVideoID(youtubeUrl!)
            
        }
        else
        {
             tecrubeImg.isHidden = true
             videoPlayer.isHidden = true
        }
        
        if(yazan != nil)
        {
            yazanLbl.text = yazan
        }
        
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let imgUrl = URL(string: dictionary["profilImg"] as! String)
                // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                self.yazarPic.kf.setImage(with: imgUrl)
            }
            
        }, withCancel: nil)
       
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    

    
    @IBAction func tappi(_ sender: UITapGestureRecognizer) {
        print("h")
        self.performSegue(withIdentifier: "resimGoster", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hidingNavBarManager?.viewWillAppear(animated)
        baslikLbl.text = baslik
        icerikLbl.text = icerik
       // navBaslik.title = baslik
    }

   
    @IBAction func likeAct(_ sender: UIBarButtonItem) {
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.value as? [String: AnyObject]) != nil {
                let updateLikes: [String: Any] = ["peopleWhoLike/\(keyToPost)": FIRAuth.auth()!.currentUser!.uid]
                ref.child("posts").child(self.postID!).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    if error == nil {
                        ref.child("posts").child(self.postID!).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String: AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String: AnyObject] {
                                    let count = likes.count
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID!).updateChildValues(update)
                                    
                                    self.likeBtn.isEnabled = false
                                    self.likeBtn.image = nil
                                    self.likeBtn.title = "Beğendiniz"
                                    self.likeBtn.isEnabled = false
                                    
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
    }
    
    
 
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "resimGoster") {
            if let controller = segue.destination as? ImageViewController {
                if self.imgUrl != nil {
                controller.imgUrl = self.imgUrl
                }
            }
            
        }
    }

}
