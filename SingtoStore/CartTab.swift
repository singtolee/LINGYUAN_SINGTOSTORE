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
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    var handle: UInt!
    
    let bottomBar = UIView()
    let tableView = UITableView()
    
    var carts = [CartProduct]()
    
    let totalPriceLable: UILabel = {
        let lb = UILabel()
        lb.text = "TOTAL: THB 0.0"
        lb.textColor = Tools.dancingShoesColor
        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        lb.textAlignment = .center
        return lb
    }()
    
    let checkOutBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Tools.dancingShoesColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("CHECK OUT", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CartCell.self, forCellReuseIdentifier: cellID)
        
        addBottomBar()
        addTableView()
        ifUserLogOut()
        
        //self.loadUserCart()
    }
    
    func ifUserLogOut() {
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            // ...
            if user == nil {
                self.carts.removeAll()
                self.tableView.reloadData()
            } else {
                self.loadUserCart()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.loadUserCart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //will crash when switch between cartTab and other tabs very fast, as viewdiddisappear and willappear
        
        //self.carts.removeAll()
        //self.tableView.reloadData()
        //remove observor
//        if Tools.isUserLogedin() {
//            if let uid = FIRAuth.auth()?.currentUser?.uid {
//                ref.child(uid).child("SHOPPINGCART").removeObserver(withHandle: handle)
//            }
//            
//        }
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
        bottomBar.backgroundColor = UIColor.white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomBar.addSubview(totalPriceLable)
        totalPriceLable.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: 40)
        
        bottomBar.addSubview(checkOutBtn)
        checkOutBtn.frame = CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: 40)
        
        
        
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
        let cart = carts[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CartCell
        cell.cart = cart
        cell.selectionStyle = .none
        return cell
    }
    
    func loadUserCart() {
        if Tools.isUserLogedin() {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let cartRef = ref.child(uid).child("SHOPPINGCART")
                self.handle = cartRef.observe(.value, with: { (snap) in
                    self.carts.removeAll()
                    for child in snap.children {
                        if let csnap = child as? FIRDataSnapshot {
                            if let dict = csnap.value as? [String: AnyObject] {
                                let ke = dict["prdKey"] as? String
                                let id = dict["ID"] as? Int
                                let che = dict["Check"] as? Bool
                                let qty = dict["Qty"] as? Int
                                let cartKey = csnap.key
                                self.loadPrdByKey(key: ke!, id: id!, check: che!, num: qty!, ck: cartKey)
                            }
                        }
                        
                    }
                })
                
            }
        } else {
            // user not login, display login hint with tableview empty status
            //empty carts
            //self.carts.removeAll()
            //tableView.reloadData()
        }
        
    }
    
    func loadPrdByKey(key: String, id: Int, check: Bool, num: Int, ck: String) {
        prdRef.child(key).observeSingleEvent(of: .value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject] {
                let cart = CartProduct()
                cart.pKey = snap.key
                cart.pName = dict["productName"] as? String
                cart.pPrice = dict["productPrice"] as? String
                let pMainImages = dict["productImages"] as? [String]
                cart.pMainImage = pMainImages?[0]
                cart.pChecked = check
                let cs = dict["prodcutCS"] as? [String]
                //let qtys = dict["prodcutCSQty"] as? [String]
                cart.pCS = cs?[id]
                cart.pQty = num
                cart.cartKey = ck
                //cart.pCSRemain = (qtys?[id] as! Int)
                cart.pCSRemain = 6 // now set the max Qty to be 6, can not buy more than 6
                self.carts.append(cart)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.updateBottomBar()
                })
            }
        })
    }
    
    func updateBottomBar() {
        var item = 0
        var total: Double = 0
        for cart in carts {
            if cart.pChecked! {
                item = item + cart.pQty
                total = total + Double(cart.pQty) * Double(cart.pPrice!)!   //at Backoffice, save price as Double
            }
        }
        self.totalPriceLable.text = "TOTOAL: THB " + String(total)
    }
    
    
    
}
