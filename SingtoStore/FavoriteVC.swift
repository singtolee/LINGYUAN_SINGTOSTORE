//
//  FavoriteVC.swift
//  SingtoStore
//
//  Created by li qiang on 12/10/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class FavoriteVC: UITableViewController {
    
    let cellId = "cellID"
    let ref = FIRDatabase.database().reference().child("users")
    var favoritePrds = [FavoriteProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAVORITES"
        tableView.register(FavroitPrdCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoritePrds.removeAll();
        self.tableView.reloadData();
        loadFavoritePrds()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            ref.child(uid).child("FavoritePRD").removeAllObservers()
        }
    }
    
    func loadFavoritePrds() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            //observe add
            ref.child(uid).child("FavoritePRD").observe(.childAdded, with: { (snapshot) in
                let ke = snapshot.key
                self.loadFavoritePrdByKey(prdk: ke)
                })
            // observe delete
            ref.child(uid).child("FavoritePRD").observe(.childRemoved, with: { (snap) in
                let ke = snap.key
                for i in 0..<self.favoritePrds.count{
                    if(self.favoritePrds[i].pKey == ke){
                        self.favoritePrds.remove(at: i)
                        self.tableView.deleteRows(at: [IndexPath(row:i,section:0)], with: .fade)
                    }
                }
            })
        }
    }
    
    func newloadFavoritePrds() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            ref.child(uid).child("FavoritePRD").observe(.value, with: { (snapshot) in
                self.favoritePrds.removeAll()
                self.tableView.reloadData()
                for child in snapshot.children {
                    let csnap = child as! FIRDataSnapshot
                    let ke = csnap.key
                    self.loadFavoritePrdByKey(prdk: ke)
                }
            })
        } else {
            print("Not Login")
            return
        }
    }
    
    func loadFavoritePrdByKey(prdk: String) {
        FIRDatabase.database().reference().child("AllProduct").child(prdk).observeSingleEvent(of: .value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject] {
                let fav = FavoriteProduct()
                fav.pKey = snap.key
                fav.pName = dict["productName"] as? String
                fav.pPrice = dict["productPrice"] as? String
                fav.pMainImages = dict["productImages"] as? [String]
                //self.favoritePrds.append(fav)
                self.favoritePrds.insert(fav, at: 0)
                DispatchQueue.main.async(execute: {
                    //self.tableView.reloadData()
                    self.tableView.insertRows(at: [IndexPath(row:0,section:0)], with: .automatic)
                })
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePrds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cp = favoritePrds[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FavroitPrdCell
        cell.prd = cp
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailProductViewController()
        vc.prdKey = favoritePrds[indexPath.item].pKey
        navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deletFavoritePrdByKey(key: favoritePrds[indexPath.item].pKey!)
        }
    }
    
    func deletFavoritePrdByKey(key: String) {
        ref.child((FIRAuth.auth()?.currentUser?.uid)!).child("FavoritePRD").child(key).removeValue()
        
    }

}
