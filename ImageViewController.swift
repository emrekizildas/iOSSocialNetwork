//
//  ImageViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 27.01.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imgUrl: String!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        let resourcem2 = ImageResource(downloadURL:  URL(string: imgUrl!)!, cacheKey: imgUrl)
        // self.profilePhoto.loadImageUsingCacheWithUrlString(urlString: imgUrl!)
        image.kf.setImage(with: resourcem2)

        
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
         self.dismiss(animated: true, completion: nil)
    }



}
