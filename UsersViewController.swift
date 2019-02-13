//
//  UsersViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 21.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUsers()


        // Do any additional setup after loading the view.
    }
    
    
    
    func retrieveUsers() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()?.currentUser!.uid {
                        let userToShow = User()
                        if let adsoyad = value["adsoyad"] as? String {
                            userToShow.adsoyad = adsoyad
                            userToShow.userID = uid
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            
            self.tableview.reloadData()
        })
      //  ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref =  FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        
        var isFollower = false
        
        ref.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
        
            if let following = snapshot.value as? [String: AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.user[indexPath.row].userID {
                        isFollower = true
                        ref.child("users").child(uid!).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            
            if !isFollower {
                let following = ["following/\(key)" : self.user[indexPath.row].userID]
                let followers = ["followers/\(key)": uid]
                
                ref.child("users").child(uid!).updateChildValues(following)
                ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
                
                self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        
       // ref.removeAllObservers()
    }
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref =  FIRDatabase.database().reference()
        
        ref.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String: AnyObject] {
                for (_, value) in following {
                    if value as! String == self.user[indexPath.row].userID {
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
     //   ref.removeAllObservers()

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].adsoyad
        cell.userID = self.user[indexPath.row].userID
        
        checkFollowing(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return user.count 
    }

    @IBAction func cikisAction(_ sender: Any) {
        if(FBSDKAccessToken.current() != nil) {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
          //  self.present(vc, animated:true, completion: nil)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            print("fb cikis")
            try! FIRAuth.auth()?.signOut()
        }
        else
        {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
         //   self.present(vc, animated:true, completion: nil)
            print("email cikis")
            try! FIRAuth.auth()?.signOut()
        }
        else {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "anagiris")
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
          //  self.present(vc, animated:true, completion: nil)
            print("bos cikis")
        }
        }
    }

}
