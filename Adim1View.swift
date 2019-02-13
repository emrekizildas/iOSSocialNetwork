//
//  Adim1View.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 1.02.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class Adim1View: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var baslik: SkyFloatingLabelTextField!
    

    
    @IBOutlet weak var txtBody: UITextView!
    
    
    @IBAction func kapatAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     //   fetchBasliks()
        
     
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Adim1View.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
      //  tableview.delegate = self
       // tableview.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    func dismissKeyboard() {
        baslik.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text != "") && (textField.text != " ")
        {
            self.baslik.endEditing(true)
            self.performSegue(withIdentifier: "adim2Gecis", sender: Any.self)
            return true
        }
        else
        {
            return false
        }
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "adim2Gecis") {
            if let controller = segue.destination as? Adim2View {
                if (self.baslik.text != "")  {
                    controller.baslik = self.baslik.text
                }
                else
                {
                 return
                }
            }
            
        }
    }
    
    

}
