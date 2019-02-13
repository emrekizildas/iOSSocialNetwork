//
//  FeedViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 22.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var posts = [Post]()
    var following = [String]()
    var ref = FIRDatabase.database().reference()
    var secilen: Int!

    @IBOutlet weak var navigationBarim: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchPosts()
        let imageView = UIImageView(frame: CGRect(x: 50, y: 0, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ikon_t_y")
        imageView.image = image
        
        navigationItem.titleView = imageView
       
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
                                            if let author = post["author"] as? String, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let icerik = post["icerik"] as? String, let baslik = post["baslik"] as? String, let turu = post["turu"] as? String, let userID = post["userID"] as? String {
                                                posst.author = author
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                posst.icerik = icerik
                                                posst.baslik = baslik
                                                posst.turu = turu
                                                posst.userID = userID
                                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                    
                                    self.collectionview.reloadData()
                                }
                            }
                            
                        })
                    }
                }
            }
            
            
            
        })
       ViewControllerUtils().hideActivityIndicator(uiView: self.view)
       // ref.removeAllObservers()
    }*/

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func delCell ()
    {
        self.collectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        
        
            self.ref.child("users").child(self.posts[indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                cell.postImage.image = nil
                let imgUrl = dictionary["profilImg"] as? String
                let resourcem = ImageResource(downloadURL:  URL(string: imgUrl!)!, cacheKey: imgUrl)
                // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                cell.postImage.kf.setImage(with: resourcem)
            }
            
        }, withCancel: nil)
        
        
        
       /* let resource = ImageResource(downloadURL: URL(string: self.posts[indexPath.row].pathToImage!)!, cacheKey: self.posts[indexPath.row].pathToImage)
        cell.postImage.kf.setImage(with: resource)*/
        
        if (self.posts[indexPath.row].turu == "İş Tecrübesi")
        {
            cell.turView.image = UIImage(named: "is")
            let isColor = UIColor(red: 223/255.0, green: 180/255.0, blue: 252/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = isColor
            
        }
        else if (self.posts[indexPath.row].turu == "Alışveriş Tecrübesi")
        {
            cell.turView.image = UIImage(named: "alisveris")
            let alisColor = UIColor(red: 168/255.0, green: 201/255.0, blue: 156/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = alisColor
        }
        else if (self.posts[indexPath.row].turu == "Okul Tecrübesi")
        {
            cell.turView.image = UIImage(named: "okul")
            let okulColor =  UIColor(red: 157/255.0, green: 218/255.0, blue: 219/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = okulColor
        }
        else if (self.posts[indexPath.row].turu == "Seyahat Tecrübesi")
        {
            cell.turView.image = UIImage(named: "seyehat")
            let seyaColor = UIColor(red: 251/255.0, green: 161/255.0, blue: 155/255.0, alpha: 1.0)
            cell.turBack.backgroundColor = seyaColor
        }
        
      //  cell.postImage.downloadImage(imgURL: self.posts[indexPath.row].pathToImage)
        //cell.postImage.downloadedFrom(link: self.posts[indexPath.row].pathToImage)
     //   cell.postImage.loadImageUsingUrlString(self.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.posts[indexPath.row].author
        cell.baslikLabel.text = self.posts[indexPath.row].baslik
        cell.icerikLabel.text = self.posts[indexPath.row].icerik
        cell.postID = self.posts[indexPath.row].postID
      //  self.ref.removeAllObservers()
        return cell
    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: screenSize.width / 3, height: screenSize.width / 3)
    }
    
    @IBAction func refreshAct(_ sender: UIBarButtonItem) {
       // sayikontrol()
        delCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //    sayikontrol()
     //   print(self.sayi)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.secilen = indexPath.row
        return print(indexPath.row)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (self.secilen == nil) { print("yarndık yedik"); return }
        if ( segue.identifier == "tecrubeTest") {
            if let controller = segue.destination as? TecrubeViewController {
                
                controller.baslik = self.posts[self.secilen].baslik
                controller.icerik = self.posts[self.secilen].icerik
                controller.tur = self.posts[self.secilen].turu
                controller.yazan = self.posts[self.secilen].author
                controller.userID = self.posts[self.secilen].userID
                controller.postID = self.posts[self.secilen].postID
            }
        }
    }
 
}

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
