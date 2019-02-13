//
//  TapImage.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 27.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit

class TapImage: UIImageView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  if let touch = touches.first {
         //   let currentPoint = touch.location(in: self)
            // do something with your currentPoint
     //   }
        self.alpha = 0.5
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   if let touch = touches.first {
         //   let currentPoint = touch.location(in: self)
            // do something with your currentPoint
      //  }
        self.alpha = 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  if let touch = touches.first {
          //  let currentPoint = touch.location(in: self)
            // do something with your currentPoint
       // }
        self.alpha = 1
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = 1
    }

}
