//
//  EditUserProfileVC.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditProfileTableViewController: UITableViewController {
    let cellID1 = "cellID1"
    let items = ["PROFILE PHOTO", "NAME", "PHONE NUMBER"]
    var userInfo = ["", "", ""]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        self.fetchUserInfo()
        self.title = "PROFILE"
        navigationController?.navigationBar.barTintColor = Tools.dancingShoesColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellID1)
        cell.textLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
        cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
        cell.detailTextLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
        cell.detailTextLabel?.text = userInfo[(indexPath as NSIndexPath).row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            let vc = EditProfilePhoto()
            //vc.photoUrl = userInfo[3]
            navigationController?.pushViewController(vc, animated: true)
        }
        if (indexPath as NSIndexPath).row == 1 {
            let vc = EidtUserName()
            vc.nameTF.text = userInfo[1]
            navigationController?.pushViewController(vc, animated: true)
        }
        if (indexPath as NSIndexPath).row == 2 {
            let vc = EditPhoneNumber()
            vc.phoneTF.text = userInfo[2]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchUserInfo() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("USERINFO").observe(.value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject] {
                if let uname = dict["name"] {
                    self.userInfo[1] = uname as! String
                }
                if let uPhone = dict["phone"] {
                    self.userInfo[2] = uPhone as! String
                }
                //                if let uUrl = dict["userAvatarUrl"] {
                //                    self.userInfo[3] = uUrl as! String
                //                }
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            }, withCancel: nil)
    }
}
