//
//  Post.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 22.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit

class Post {
    
    var author: String
    //var likes: Int
    var pathToImage: String
    var userID: String
    var postID: String
    var baslik: String
    var icerik: String
    var turu: String
    var youtube: String
    var profileIMG: String
    
    //var peopleWhoLike: [String] = [String]()
    
    
    init(uid: String, baslik: String, icerik: String, name: String, postID: String, profPic: String, youtube: String, resim: String,tur: String){
        self.userID = uid
        self.baslik = baslik
        self.icerik = icerik
        self.postID = postID
        self.profileIMG = profPic
        self.youtube = youtube
        self.pathToImage = resim
        self.author = name
        self.turu = tur
    }
}
