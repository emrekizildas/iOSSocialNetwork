//
//  AnaSayfaViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 27.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AnaSayfaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var following = [String]()
    var ref = FIRDatabase.database().reference()
    var secilen: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  fetchPosts()
        }

  /*  func fetchPosts() {
        // let ref = FIRDatabase.database().reference()
        self.ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String: String] {
                            for (_,user) in followingUsers {
                                self.following.append(user)
                            }
                        }
                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
                        
                        self.ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            
                            
                            let postsSnap = snap.value as! [String: AnyObject]
                            
                            for (_,post) in postsSnap {
                                
                                if let userID = post["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let posst = Post()
                                            if let author = post["author"] as? String, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let icerik = post["icerik"] as? String, let baslik = post["baslik"] as? String, let turu = post["turu"] as? String, let userID = post["userID"] as? String, let youtube = post["youtube"] as? String {
                                                posst.author = author
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                posst.icerik = icerik
                                                posst.baslik = baslik
                                                posst.turu = turu
                                                posst.userID = userID
                                                posst.youtube = youtube
                                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                    
                                    self.tableView.reloadData()
                                }
                            }
                            
                        })
                    }
                }
            }
            
            
            
        })
        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
         ref.removeAllObservers()
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tecrubeCell", for: indexPath) as! TecrubeCell
        
        cell.icerikLbl.sizeToFit()
        cell.authorLbl.text = self.posts[indexPath.row].author
        cell.baslikLbl.text = self.posts[indexPath.row].baslik
        cell.icerikLbl.text = self.posts[indexPath.row].icerik

        
        if (self.posts[indexPath.row].pathToImage == "")
        {
    //        cell.tecrubeImg.isHidden = true
            
        }
        else {
        let tecrubeurl = URL(string: self.posts[indexPath.row].pathToImage)
       // let resourcem = ImageResource(downloadURL:  URL(string: tecrubeurl!)!, cacheKey: tecrubeurl)
    //    cell.tecrubeImg.kf.setImage(with: tecrubeurl)
        }

        
        if (self.posts[indexPath.row].turu == "İş Tecrübesi")
        {
            cell.turPic.image = UIImage(named: "is")
            let isColor = UIColor(red: 223/255.0, green: 180/255.0, blue: 252/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = isColor
            
            
        }
        else if (self.posts[indexPath.row].turu == "Alışveriş Tecrübesi")
        {
            cell.turPic.image = UIImage(named: "alisveris")
            let alisColor = UIColor(red: 168/255.0, green: 201/255.0, blue: 156/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = alisColor
        }
        else if (self.posts[indexPath.row].turu == "Okul Tecrübesi")
        {
            cell.turPic.image = UIImage(named: "okul")
            let okulColor =  UIColor(red: 157/255.0, green: 218/255.0, blue: 219/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = okulColor
        }
        else if (self.posts[indexPath.row].turu == "Seyahat Tecrübesi")
        {
            cell.turPic.image = UIImage(named: "seyehat")
            let seyaColor = UIColor(red: 251/255.0, green: 161/255.0, blue: 155/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = seyaColor
        }
        
        self.ref.child("users").child(self.posts[indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                cell.profilePhoto.image = nil
                let imgUrl = URL(string: dictionary["profilImg"] as! String)
                // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                cell.profilePhoto.kf.setImage(with: imgUrl)
            }
            
        }, withCancel: nil)
        
        
        if (self.posts[indexPath.row].youtube != "") {
            cell.video.isHidden = false
        }
        
        
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.posts[indexPath.row].pathToImage == "") || (self.posts[indexPath.row].pathToImage == nil)
        {
            if (self.posts[indexPath.row].icerik.characters.count > 50)
            {
                return 115
            }
            else {
            return 94.0
            }
        }
        return 247.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.secilen = indexPath.row
        return print(indexPath.row)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (self.secilen == nil) { print("yarndık yedik"); return }
        if ( segue.identifier == "tecrubeDetay") {
            if let controller = segue.destination as? TecrubeViewController {
                controller.baslik = self.posts[self.secilen].baslik
                controller.icerik = self.posts[self.secilen].icerik
                controller.tur = self.posts[self.secilen].turu
                controller.yazan = self.posts[self.secilen].author
                controller.userID = self.posts[self.secilen].userID
                controller.postID = self.posts[self.secilen].postID
                controller.imgUrl = self.posts[self.secilen].pathToImage
                controller.youtubeUrl = self.posts[self.secilen].youtube
            }
            
        }
    }
    
    
    


}
