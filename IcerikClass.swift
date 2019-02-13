//
//  IcerikClass.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 29.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit

class IcerikClass: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSFontAttributeName: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    }

}
