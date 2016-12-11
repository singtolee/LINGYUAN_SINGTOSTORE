//
//  CartTab.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CartTab: DancingShoesViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "cellID"
    
    let ref = FIRDatabase.database().reference().child("users")
    var handle: UInt!
    
    let bottomBar = UIView()
    let tableView = UITableView()
    
    var carts = [CartProduct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CartCell.self, forCellReuseIdentifier: cellID)
        
        addBottomBar()
        addTableView()
        
        self.loadUserCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.loadUserCart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //remove observor
    }
    func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
    }
    func addBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = Tools.dancingShoesColor
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CartCell
        cell.selectionStyle = .none
        return cell
    }
    
    func loadUserCart() {
        if Tools.isUserLogedin() {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let cartRef = ref.child(uid).child("SHOPPINGCART")
                cartRef.observe(.value, with: { (snap) in
                    self.carts.removeAll()
                    for child in snap.children {
                        if let csnap = child as? FIRDataSnapshot {
                            if let dict = csnap.value as? [String: AnyObject] {
                                let cc = CartProduct()
                                cc.pKey = dict["prdKey"] as? String
                                self.loadPrdByKey(key: cc.pKey!)
                                cc.pID = dict["ID"] as? Int
                                print(cc.pID)
                                self.carts.append(cc)
                            }
                        }
                        
                    }
                })
                
            }
        }
        
    }
    
    func loadPrdByKey(key: String) {
        
    }
    
    
    
}
