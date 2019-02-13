//
//  ViewControllerUtils.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 24.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Foundation

class ViewControllerUtils {

    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var text = UILabel()
    
    public class var shared: ViewControllerUtils {
        struct Static {
            static let instance: ViewControllerUtils = ViewControllerUtils()
        }
        return Static.instance
    }
    
    public func showActivityIndicator(uiView: UIView, metin: String) {
        containerView.frame = uiView.frame
        containerView.center = uiView.center
        containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)
        
        progressView.frame = CGRect(x:0, y:0, width:80, height:80)
        progressView.center = uiView.center
        progressView.backgroundColor = UIColor(hex: 0x444444, alpha: 0.7)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.center = CGPoint(x:progressView.bounds.width / 2, y:progressView.bounds.height / 2)

        
        text.frame = CGRect(x:5.0, y: 55, width:progressView.frame.width, height:21);
        text.text = metin
        text.textColor = .white
        text.font = UIFont(name: "Avenir-Light", size: 14)
        
        progressView.addSubview(activityIndicator)
        progressView.addSubview(text)
        containerView.addSubview(progressView)
        uiView.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
