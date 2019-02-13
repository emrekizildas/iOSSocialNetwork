//
//  ProfilCell.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 25.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit

class ProfilCell: UICollectionViewCell {
    
    @IBOutlet weak var profilResmi: UIImageView!
    
    @IBOutlet weak var tecrubeTuru: UILabel!
    
    @IBOutlet weak var tecrubeBaslik: UILabel!
    
    @IBOutlet weak var turPic: UIImageView!
     var postID: String!
    
    @IBOutlet weak var turBack: UIView!
}
