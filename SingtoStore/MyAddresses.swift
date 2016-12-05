//
//  MyAddresses.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyAddress: UITableViewController {
    let addressType = ["CASH ON DELIVERY ADDRESS", "POST ADDRESS"]
    var mailingAddresses = [PostAddress]()
    var freeAddress = [FreeAddress]()
    let freeHeader = UIView()
    let postHeader = UIView()
    let cellID = "cellID"
    let indicator = MyIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1))
        tableView.register(AddressCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Tools.dancingShoesColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "ADDRESS"
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 42).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        //self.indicator.center = view.center
        loadFreeAddress()
        loadMailingAddress()
    }
    
    func loadFreeAddress() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("FreeDeliveryAddresses").child(uid).observe(.value, with: { (snap) in
                self.freeAddress.removeAll()
                if let dict = snap.value as? [String: String] {
                    let free = FreeAddress()
                    free.recipient = dict["recipient"]!
                    free.building = dict["officeBuilding"]!
                    free.phone = dict["phone"]!
                    free.room = dict["roomNumber"]!
                    self.freeAddress.append(free)
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                }, withCancel: nil)
        }
        
    }
    func loadMailingAddress() {
        self.indicator.startAnimating()
        //self.mailingAddresses.removeAll()
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("MailingAddresses").child(uid).observe(.value, with: { (snap) in
                self.mailingAddresses.removeAll()
                for child in snap.children {
                    guard let csnap = child as? FIRDataSnapshot else {return}
                    if let dict = csnap.value as? [String: String] {
                        let address = PostAddress()
                        address.recipient = dict["recipient"]!
                        address.phone = dict["phone"]!
                        address.postCode = dict["PostCode"]!
                        address.detailAddress = dict["Address"]!
                        //address.ID = dict["ID"]!
                        address.ID = csnap.key
                        self.mailingAddresses.append(address)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                })
            })
        }
    }
    
    func setUpHeaderFree() -> UIView {
        let vw = UIView()
        vw.backgroundColor = Tools.headerColor
        let label = UILabel()
        label.text = self.addressType[0]
        label.font = UIFont(name: "ArialHebrew-Light", size: 14)
        let btn = UIButton()
        btn.setImage(UIImage(named: "editFreeAddress"), for: UIControlState())
        btn.addTarget(self, action: #selector(addFree), for: .touchUpInside)
        vw.addSubview(label)
        vw.addSubview(btn)
        label.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: vw.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        btn.rightAnchor.constraint(equalTo: vw.rightAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.backgroundColor = Tools.headerColor
        btn.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        return vw
    }
    func setUpHeaderPost() -> UIView {
        let vw = UIView()
        vw.backgroundColor = Tools.headerColor
        let label = UILabel()
        label.text = self.addressType[1]
        label.font = UIFont(name: "ArialHebrew-Light", size: 14)
        let btn = UIButton()
        //btn.setTitle("ADD", forState: .Normal)
        btn.setImage(UIImage(named: "addNewAddress"), for: UIControlState())
        btn.addTarget(self, action: #selector(addPost), for: .touchUpInside)
        vw.addSubview(label)
        vw.addSubview(btn)
        label.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: vw.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        btn.rightAnchor.constraint(equalTo: vw.rightAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.backgroundColor = Tools.headerColor
        btn.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true
        return vw
    }
    
    func addFree() {
        let vc = EditFreeAddress()
        vc.title = "Add Address"
        if self.freeAddress.count > 0{
            vc.officeAddress = self.freeAddress[0]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func addPost() {
        let vc = AddPostAddress()
        vc.title = "Add Mailing Address"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.setUpHeaderFree()
            
        } else {
            return self.setUpHeaderPost()
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return addressType.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNumber: Int
        if section == 0 {
            rowNumber = freeAddress.count
        }
        else {
            rowNumber = mailingAddresses.count
        }
        return rowNumber
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AddressCell
        if (indexPath as NSIndexPath).section == 0 {
            let add = freeAddress[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = add.recipient
            cell.textLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
            cell.detailTextLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
            cell.detailTextLabel?.text = add.room + ", " + add.building
            cell.phoneLable.text = add.phone
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }
        else {
            let add = mailingAddresses[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = add.recipient
            cell.textLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
            cell.detailTextLabel?.text = add.detailAddress + ", " + add.postCode
            cell.phoneLable.text = add.phone
            cell.detailTextLabel?.font = UIFont(name: "ArialHebrew-Light", size: 14)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            let vc = EditPostAddress()
            vc.address = self.mailingAddresses[(indexPath as NSIndexPath).row]
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = EditFreeAddress()
            vc.officeAddress = self.freeAddress[(indexPath as NSIndexPath).row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            if editingStyle == .delete {
                self.deleteAddressByID(mailingAddresses[(indexPath as NSIndexPath).row].ID)
            }
        } else {
            if editingStyle == .delete {
                self.deleteFreeAddress()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func deleteAddressByID(_ ID: String) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference().child("MailingAddresses").child(uid).child(ID)
            ref.removeValue()
        }
    }
    
    func deleteFreeAddress() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let ref = FIRDatabase.database().reference().child("FreeDeliveryAddresses").child(uid)
            ref.removeValue()
        }
    }
}
