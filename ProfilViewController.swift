//
//  ProfilViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 24.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfilViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tecrubesizLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var baslikItem: UINavigationItem!
    @IBOutlet weak var takipciSayisi: UILabel!
    @IBOutlet weak var tecrubeSayisi: UILabel!
    @IBOutlet weak var takipSayisi: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    let userDefaults = UserDefaults.standard
    var uid = FIRAuth.auth()?.currentUser!.uid
    var ref =  FIRDatabase.database().reference()
    var sayi = UserDefaults.standard.integer(forKey: "tecrubeSayi")
    var posts = [ProfilePost]()
    var following = [String]()
    var profilImgUrl = "ikon_t"
    var secilen: Int!
    var takip = 0
    var takipci = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baslikItem.title = FIRAuth.auth()?.currentUser?.displayName
        
        self.ref.child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let imgUrl = dictionary["profilImg"] as? String
                self.profilImgUrl = (dictionary["profilImg"] as? String)!
                let resource = ImageResource(downloadURL:  URL(string: imgUrl!)!, cacheKey: imgUrl)
               // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                self.profilePhoto.kf.setImage(with: resource)
            }
            
        }, withCancel: nil)
            checkFollowing()
            checkFollowers()
            fetchPosts()

            tecrubeSayisi.text = "\(self.sayi)"
        takipSayisi.text = "\(self.takip)"
        takipciSayisi.text = "\(self.takipci)"
          //  self.ref.removeAllObservers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sayiKontrol()
        checkFollowing()
        checkFollowers()
    }
    
    func sayiKontrol () {
        let ref = FIRDatabase.database().reference()
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            
            let postsSnap = snap.value as! [String: AnyObject]
            self.sayi = 0
            for (_,post) in postsSnap {
                if self.uid == post["userID"] as? String {
                    self.sayi += 1
                    self.tecrubeSayisi.text = "\(self.sayi)"
                }
            }
        })
      //  ref.removeAllObservers()
        if (self.sayi > 0)
        {
            self.tecrubesizLabel.isHidden = true
        }
        else
        {
            self.tecrubesizLabel.isHidden = false
        }
    }
    
    func checkFollowing() {
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref =  FIRDatabase.database().reference()
       
        ref.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
             self.takip = 0
            if let following = snapshot.value as? [String: AnyObject] {
                for (_, _) in following {
                    self.takip += 1
                    self.takipSayisi.text = "\(self.takip)"
                }
            }
        })
        
           ref.removeAllObservers()
        
    }
    
    func checkFollowers() {
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref =  FIRDatabase.database().reference()
        
        ref.child("users").child(uid!).child("followers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            self.takipci = 0
            if let following = snapshot.value as? [String: AnyObject] {
                for (_, _) in following {
                    self.takipci += 1
                    self.takipciSayisi.text = "\(self.takipci)"
                }
            }
        })
        
           ref.removeAllObservers()
        
    }
    
    
    func fetchPosts() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            
            let postsSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postsSnap {
                if self.uid == post["userID"] as? String {
                    self.sayi += 1
                    self.tecrubeSayisi.text = "\(self.sayi)"
                            let posst = ProfilePost()
                            if let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let baslik = post["baslik"] as? String,let turu = post["turu"] as? String,let icerik = post["icerik"] as? String, let author = post["author"] as? String, let userID = post["userID"] as? String {
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.baslik = baslik
                                posst.icerik = icerik
                                posst.author = author
                                posst.turu = turu
                                self.posts.append(posst)
                            }
                    self.collectionview.reloadData()
                }
            }
            if (self.sayi > 0)
            {
                self.tecrubesizLabel.isHidden = true
            }
            else
            {
                self.tecrubesizLabel.isHidden = false
            }
            
            
        })

        
        ref.removeAllObservers()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.secilen = indexPath.row
        return print(indexPath.row)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (self.secilen == nil) { print("yarndık yedik"); return }
        if ( segue.identifier == "tecrubeTest2") {
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostCell", for: indexPath) as! ProfilCell
        
        self.ref.child("users").child(self.posts[indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let imgUrl = dictionary["profilImg"] as? String
                self.profilImgUrl = (dictionary["profilImg"] as? String)!
                let resource = ImageResource(downloadURL:  URL(string: imgUrl!)!, cacheKey: imgUrl)
                // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
                cell.profilResmi.kf.setImage(with: resource)
            }
            
        }, withCancel: nil)
        
        
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
        
        cell.tecrubeBaslik.text = self.posts[indexPath.row].icerik
        cell.tecrubeTuru.text = self.posts[indexPath.row].baslik
        cell.postID = self.posts[indexPath.row].postID
        return cell
    }
    

}
