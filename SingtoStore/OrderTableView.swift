//
//  OrderTableView.swift
//  SingtoStore
//
//  Created by li qiang on 12/22/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OrderTableView: UITableViewController {
    
    var orders = [Order]()
    
    let ref = FIRDatabase.database().reference().child("users")
    var handle: UInt!
    
    
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ORDERS"
        tableView.register(OrderCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
        let empty = CartEmptyState(frame: tableView.frame)
        tableView.backgroundView = empty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.handle = ref.child(uid).child("Orders").observe(.value, with: { (snap) in
                self.orders.removeAll()
                for child in snap.children {
                    if let csnap = child as? FIRDataSnapshot {
                        let dict = csnap.value as? [String: Any]
                        let oo = Order()
                        oo.oPImageUrl = dict?["url"] as? String
                        oo.oPname = dict?["title"] as? String
                        oo.oPSpec = dict?["cs"] as? String
                        oo.oPPrice = dict?["price"] as? Double
                        oo.oQty = dict?["Qty"] as? Int
                        oo.oDate = dict?["date"] as? String
                        oo.oTime = dict?["time"] as? String
                        oo.oStatus = dict?["status"] as? Int
                        self.orders.insert(oo, at: 0)
                        //self.orders.append(oo)
                        self.tableView.reloadData()
                        self.tableView.backgroundView = nil
                    }
                }
            })
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child("Orders").removeObserver(withHandle: self.handle)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrderCell

        cell.order = orders[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
