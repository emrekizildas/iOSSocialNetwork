//
//  AnaTableViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 30.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import SwiftyJSON
import RainyRefreshControl
import SafariServices


class AnaTableViewController: UITableViewController {

    var posts = [Post]()
    var following = [String]()
    var profils = [PP]()
    var ref = FIRDatabase.database().reference()
    var secilen: Int!
    let refresh = RainyRefreshControl()

    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ikon_t_y")
        imageView.image = image
        navTitle.titleView = imageView
        //fetchPP()
        fetchPosts()
                self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        refresh.tintColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        refresh.addTarget(self, action: #selector(AnaTableViewController.shuffleAct(_:)), for: .valueChanged)
        self.tableView.addSubview(refresh)

        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(AnaTableViewController.titleWasTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
        
        tableView.addInfiniteScroll { (tableView) -> Void in
  
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }

    }
    
  
    func titleWasTapped() {
      //  self.tableView.setContentOffset(CGPoint.zero, animated: true)
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: -1), animated: true)
    }
    

    @IBAction func shuffleAct(_ sender: Any) {
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.posts.removeAll()
            self.following.removeAll()
            self.tableView.reloadData()
            self.fetchPosts()
            self.refresh.endRefreshing()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func fetchPosts() {
         let ref = FIRDatabase.database().reference()
        //let ref = FIRDatabase.database().reference(withPath: "posts")
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                if let dict = snapshot.value as? NSDictionary {
                            self.posts = []
                          //  let posst = Post()
                            for item in dict {
                                let json = JSON(item.value)
                               // let author = json["author"].stringValue
                                let pathToImage = json["pathToImage"].stringValue
                                let postID = json["postID"].stringValue
                                let icerik = json["icerik"].stringValue
                                let baslik = json["baslik"].stringValue
                                let turu = json["turu"].stringValue
                                let userID = json["userID"].stringValue
                                let youtube = json["youtube"].stringValue
                                var pic = ""
                                var name = ""
                                let usersReference = FIRDatabase.database().reference(withPath: "users").queryOrderedByKey().queryEqual(toValue: userID)
                                usersReference.observeSingleEvent(of: .value, with: { snapshot in
                                 if let dict = snapshot.value as? NSDictionary {
                                    let userInfo = dict.allValues[0]
                                    let userJSON = JSON(userInfo)
                                    name = userJSON["adsoyad"].stringValue
                                    pic = userJSON["profilImg"].stringValue
                                   }
                                    let post = Post(uid: userID, baslik: baslik, icerik: icerik, name: name, postID: postID,profPic: pic, youtube: youtube, resim: pathToImage, tur: turu)
                                   self.posts.append(post)
                                   // sort posts by date
                                   // self.feeds.sort{$0.date.compare($1.date) == .orderedDescending}
                                   //  self.feedTableView.reloadData()
                                   self.tableView.reloadData()
                                })
                             }
                           }
                        })
                }
    
    func fetchPP () {
        self.ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String: String] {
                            for (_,user) in followingUsers {
                                self.ref.child("users").child(user).observeSingleEvent(of: .value, with: { snapshotum in
                                    if (snapshotum.childrenCount > 0)
                                    {
                                    let usersi = snapshotum.value as! [String: AnyObject]
                                    
                                    for (_, value) in usersi {
                                        let pps = PP()
                                        if let uid = value["uid"] as? String,let pp = value["profilImg"] as? String {
                                            pps.profileImg = pp
                                            pps.userID = uid
                                            self.profils.append(pps)
                                        }
                                    }
                                    }
                                })
                 }
                
            }
        }
        }
    }
    })
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tecrubeCell", for: indexPath) as! TecrubeCell
        
        cell.icerikLbl.sizeToFit()
        cell.authorLbl.text = self.posts[indexPath.row].author
        cell.baslikLbl.text = self.posts[indexPath.row].baslik
        cell.icerikLbl.text = self.posts[indexPath.row].icerik
       
        
        if (self.posts[indexPath.row].youtube != "") && (self.posts[indexPath.row].pathToImage == "") {
            cell.video.isHidden = false
            cell.video.image = UIImage(named: "video")
           // cell.tecrubeImg.isHidden = true
        }
        else if (self.posts[indexPath.row].pathToImage != "") && (self.posts[indexPath.row].youtube == "")
        {
            //cell.tecrubeImg.isHidden = false
             cell.video.isHidden = false
            cell.video.image = UIImage(named: "galeri")
          //  let tecrubeurl = URL(string: self.posts[indexPath.row].pathToImage)
         //    let resourcem = ImageResource(downloadURL:  URL(string: tecrubeurl!)!, cacheKey: tecrubeurl)
            //cell.tecrubeImg.sd_setImage(with: tecrubeurl!, placeholderImage: UIImage(named: "ikon_t"))
        }
        else {
           // cell.tecrubeImg.isHidden = true
             cell.video.isHidden = true
        }
        
        
       /* ref.child("users").child(self.posts[indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let imgUrl = URL(string: dictionary["profilImg"] as! String)
                // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                cell.profilePhoto.sd_setImage(with: imgUrl!, placeholderImage: UIImage(named: "ikon_t"))
            }
            
        }, withCancel: nil)
 
        */
        
        let imgUrl = URL(string: self.posts[indexPath.row].profileIMG)
        cell.profilePhoto.sd_setImage(with: imgUrl!, placeholderImage: UIImage(named: "ikon_t"))

        
        //  let imgUrl = URL(string: profili!)
        //
        
        return cell

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.secilen = indexPath.row
        return print(indexPath.row)
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        return 300.0
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (self.secilen == nil) { print("yarndık yedik"); return }
        if ( segue.identifier == "tecrubeGoster") {
            if let controller = segue.destination as? TecrubeViewController {
                controller.baslik = self.posts[self.secilen].baslik
                controller.icerik = self.posts[self.secilen].icerik
               // controller.tur = self.posts[self.secilen].turu
                controller.yazan = self.posts[self.secilen].author
                controller.userID = self.posts[self.secilen].userID
                controller.postID = self.posts[self.secilen].postID
                controller.imgUrl = self.posts[self.secilen].pathToImage
                controller.youtubeUrl = self.posts[self.secilen].youtube
            }
            
        }
    }



}
