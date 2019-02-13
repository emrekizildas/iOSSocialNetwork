//
//  MMTabBarViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 16.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import MMTabBarAnimation

class MMTabBarViewController: MMTabBarAnimateController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setAnimateAllItem(animate: .icon(type: .scale(rate: 1.15)))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
