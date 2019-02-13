//
//  BaslikTableViewController.swift
//  tecrubesi.iOS
//
//  Created by Emre Kızıldaş on 12.02.2017.
//  Copyright © 2017 Emre Kızıldaş. All rights reserved.
//

import UIKit
import Firebase

class BaslikTableViewController: UITableViewController {
    
    var ref = FIRDatabase.database().reference()
    
    var secilen: Int!
    
    var basliks = [Baslik]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBasliks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.secilen = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.secilen = indexPath.row
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.basliks.count
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.secilen = indexPath.row
        self.performSegue(withIdentifier: "adim2Gecistable", sender: Any?.self)
    }
    
    func fetchBasliks() {
        // let ref = FIRDatabase.database().reference()
        //       var yx = 0
        var sayisi = 0
        self.ref.child("posts").queryOrdered(byChild: "baslik").observeSingleEvent(of: .value, with: { snapshot in
            
            let posts = snapshot.value as! [String: AnyObject]
            var i = 0
            for (_, value) in posts {
                i += 1
                if (i == 7) { break }
                let basliklarr = Baslik()
                self.ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { snaps in
                    let postss = snaps.value as! [String: AnyObject]
                    sayisi = 0
                    for (_, valuee) in postss {
                        
                        if value["baslik"] as? String == valuee["baslik"] as? String {
                            sayisi += 1
                        }
                    }
                    basliklarr.sayi = sayisi
                })
                if let baslik = value["baslik"] as? String {
                    basliklarr.baslik = baslik
                }
                self.basliks.append(basliklarr)
                self.tableView.reloadData()
            }
        })


        ref.removeAllObservers()
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baslikCell", for: indexPath) as! BaslikCell
        if (indexPath.row < 6) {
        cell.baslikLabel.text = self.basliks[indexPath.row].baslik

        return cell
        }
        else
        {
            cell.baslikLabel.text = ""
            return cell
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "adim2Gecistable") {
            if let controller = segue.destination as? Adim2View {
                if (self.secilen != nil)  {
                    controller.baslik = self.basliks[secilen].baslik
                }
                else
                {
                    return
                }
            }
            
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
