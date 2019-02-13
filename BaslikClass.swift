//
//  BaslikClass.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 30.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit

class BaslikClass: UILabel {

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
    }

}
