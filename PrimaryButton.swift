//
//  PrimaryButton.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 15.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import SimpleButton

class PrimaryButton: SimpleButton {
    
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setBorderWidth(4.0, for: .normal)
        setBackgroundColor(UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0), for: .normal)
        setBackgroundColor(UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0), for: .highlighted)
        setBorderColor(UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0), for: .normal)
        setScale(0.98, for: .highlighted)
        setTitleColor(UIColor.white, for: .normal)
        setShadowRadius(22.0)
        setShadowColor(UIColor.black)
    
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
