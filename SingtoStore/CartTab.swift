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
    
    let addressRef = FIRDatabase.database().reference().child("FreeDeliveryAddresses")
    var userAddress: FreeAddress!
    
    let ref = FIRDatabase.database().reference().child("users")
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    var handle: UInt!
    
    let bottomBar = UIView()
    let tableView = UITableView()
    
    var carts = [CartProduct]()
    var ckCarts = [CartProduct]()
    
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
    
    let editAddressBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Tools.dancingShoesColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("EDIT ADDRESS", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        return btn
    }()
    
    let proBar: UIProgressView = {
        
        let bar = UIProgressView()
        bar.progressTintColor = Tools.dancingShoesColor
        bar.progressViewStyle = .bar
        bar.progress = 0
        return bar
    }()
    
    func addProBar() {
        view.addSubview(proBar)
        proBar.isHidden = true
        proBar.translatesAutoresizingMaskIntoConstraints = false
        proBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        proBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        proBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        proBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CartCell.self, forCellReuseIdentifier: cellID)
        addBottomBar()
        addTableView()
        addProBar()
        loadUserAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 0).isActive = true
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
        checkOutBtn.isHidden = false
        checkOutBtn.frame = CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: 40)
        checkOutBtn.addTarget(self, action: #selector(checkOutWithProgressBar), for: .touchUpInside)
        
        bottomBar.addSubview(editAddressBtn)
        editAddressBtn.isHidden = true
        editAddressBtn.frame = CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: 40)
        editAddressBtn.addTarget(self, action: #selector(goToEditAddress), for: .touchUpInside)
        
        
    }
    
    func goToEditAddress() {
        let editAddressVC = EditFreeAddress()
        self.navigationController?.pushViewController(editAddressVC, animated: true)
    }
    
    func checkOutWithProgressBar() {
        let addressMsg = "Deliever to: " + userAddress.recipient + " ," + userAddress.phone + " ," + userAddress.room + " ," + userAddress.building
        let willCheckOutAlert = UIAlertController(title: "Are you sure to make this order?", message: addressMsg, preferredStyle: .alert)
        let cancelAct = UIAlertAction(title: "CANCEL", style: .default) {(action) -> Void in
        }
        let okAction = UIAlertAction(title: "ORDER", style: .default) {(action) -> Void in
            for cart in self.carts {
                if cart.pChecked! {
                    self.ckCarts.append(cart)
                }
            }
            
            let num = self.ckCarts.count
            for i in 0..<num {
                self.checkOutOnebyOne(c: self.ckCarts[i], ii: Float(i + 1), num: Float(num + 1))
            }
            
        }
        willCheckOutAlert.addAction(cancelAct)
        willCheckOutAlert.addAction(okAction)
        self.present(willCheckOutAlert, animated: true, completion: nil)
    }
    
    func checkOutOnebyOne(c: CartProduct, ii: Float, num: Float) {
        var order: Dictionary = [String: Any]()
        order["isDone"] = false
        let riq = Tools.getDateTime().riqi
        order["date"] = riq
        order["time"] = Tools.getDateTime().time
        order["userKey"] = FIRAuth.auth()?.currentUser?.uid
        order["prdKey"] = c.pKey
        order["prdName"] = c.pName
        order["prdCS"] = c.pCS
        order["Qty"] = c.pQty
        order["total"] = Double(c.pQty) * c.pPrice!
        order["userAddress"] = self.userAddress.recipient + " ," + self.userAddress.phone + " ," + self.userAddress.room + " ," + self.userAddress.building
        let orderRef = FIRDatabase.database().reference().child("ORDERS").child(riq).child(self.userAddress.building)
        let orderKey = orderRef.childByAutoId().key
        orderRef.child(orderKey).setValue(order, withCompletionBlock: { (err, ref) in
            if err != nil {
                //handle error
            } else {
                // update Qty， get remain first, and remove from cart
                self.prdRef.child(c.pKey!).child("prodcutCSQty").child(String((c.pID)!)).observeSingleEvent(of: .value, with: { (snap) in
                    let bb = snap.value as! String
                    let duct = c.pQty
                    let max = Int(bb)!
                    let newQty = String(max - duct)
                    self.prdRef.child(c.pKey!).child("prodcutCSQty").child(String((c.pID)!)).setValue(newQty)
                    self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).child("SHOPPINGCART").child(c.cartKey!).removeValue()
                    //write to user ORDERS
                    var my: Dictionary = [String: Any]()
                    my["prdKey"] = c.pKey
                    my["qty"] = c.pQty
                    my["cs"] = c.pCS
                    my["isDone"] = false
                    my["date"] = riq
                    my["csID"] = c.pID
                    my["time"] = Tools.getDateTime().time
                    FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Orders").child(orderKey).setValue(my, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            //error msg
                        } else {
                            self.proBar.progress = ii / num
                        }
                    })
                    //self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    func checkOutAll() {
        for cart in carts {
            if cart.pChecked! {
                var order: Dictionary = [String: Any]()
                order["isDone"] = false
                let riq = Tools.getDateTime().riqi
                order["date"] = riq
                order["time"] = Tools.getDateTime().time
                order["userKey"] = FIRAuth.auth()?.currentUser?.uid
                order["prdKey"] = cart.pKey
                order["prdName"] = cart.pName
                order["prdCS"] = cart.pCS
                order["Qty"] = cart.pQty
                order["total"] = Double(cart.pQty) * cart.pPrice!
                order["userAddress"] = self.userAddress.recipient + " ," + self.userAddress.phone + " ," + self.userAddress.room + " ," + self.userAddress.building
                let orderRef = FIRDatabase.database().reference().child("ORDERS").child(riq).child(self.userAddress.building)
                let orderKey = orderRef.childByAutoId().key
                orderRef.child(orderKey).setValue(order, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        //handle error
                    } else {
                        // update Qty， get remain first, and remove from cart
                        self.prdRef.child(cart.pKey!).child("prodcutCSQty").child(String((cart.pID)!)).observeSingleEvent(of: .value, with: { (snap) in
                            let bb = snap.value as! String
                            let duct = cart.pQty
                            let max = Int(bb)!
                            let newQty = String(max - duct)
                            self.prdRef.child(cart.pKey!).child("prodcutCSQty").child(String((cart.pID)!)).setValue(newQty)
                            self.ref.child((FIRAuth.auth()?.currentUser?.uid)!).child("SHOPPINGCART").child(cart.cartKey!).removeValue()
                            //write to user ORDERS
                            var my: Dictionary = [String: Any]()
                            my["prdKey"] = cart.pKey
                            my["qty"] = cart.pQty
                            my["cs"] = cart.pCS
                            my["isDone"] = false
                            my["date"] = riq
                            my["csID"] = cart.pID
                            my["time"] = Tools.getDateTime().time
                            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Orders").child(orderKey).setValue(my)
                            //self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
                
            }
        }
        //let buySuccess = UIAlertController(title: "SUCCESS", message: "Your order will be shipped out within 24 hours.", preferredStyle: .alert)
        //let okAction = UIAlertAction(title: "OK", style: .destructive) {(action) -> Void in
        //}
        //buySuccess.addAction(okAction)
        //self.present(buySuccess, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteFromCartByKey(key: carts[indexPath.item].cartKey!)
        }
    }
    
    func deleteFromCartByKey(key: String) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            let cartRef = ref.child(uid).child("SHOPPINGCART")
            cartRef.child(key).removeValue()
        }
    }
    
    func loadUserCart() {
        if Tools.isUserLogedin() {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let cartRef = ref.child(uid).child("SHOPPINGCART")
                self.handle = cartRef.observe(.value, with: { (snap) in
                    self.carts.removeAll()
                    self.tableView.reloadData()
                    self.updateBottomBar()
                    for child in snap.children {
                        if let csnap = child as? FIRDataSnapshot {
                            if let dict = csnap.value as? [String: AnyObject] {
                                let cart = CartProduct()
                                let title = dict["prdTitle"] as? String
                                cart.pName = title
                                let ke = dict["prdKey"] as? String
                                cart.pKey = ke
                                let id = dict["ID"] as? Int
                                cart.pID = id
                                let che = dict["Check"] as? Bool
                                cart.pChecked = che
                                let qty = dict["Qty"] as? Int
                                cart.pQty = qty!
                                let cartKey = csnap.key
                                cart.cartKey = cartKey
                                let img = dict["prdImg"] as? String
                                cart.pMainImage = img
                                let cs = dict["prdCS"] as? String
                                let price = dict["prdPrice"] as? Double
                                cart.pPrice = price
                                cart.pCS = cs
                                cart.pCSRemain = 6
                                self.carts.append(cart)
                                DispatchQueue.main.async(execute: {
                                    self.tableView.reloadData()
                                    self.updateBottomBar()
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
    func updateBottomBar() {
        var item = 0
        var total: Double = 0
        for cart in carts {
            if cart.pChecked! {
                item = item + cart.pQty
                total = total + Double(cart.pQty) * cart.pPrice!  //at Backoffice, save price as Double
            }
        }
        if item > 0 {
            self.totalPriceLable.text = "TOTOAL: THB " + String(total)
            bottomBar.isHidden = false
        } else {
            bottomBar.isHidden = true
        }
    }
    
    func loadUserAddress() {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if  user?.uid != nil {
                //self.bottomBar.isHidden = false
                self.loadUserCart()
                self.addressRef.child((user?.uid)!).observe(.value, with: { (snap) in
                    if let dict = snap.value as? [String: String] {
                        let free = FreeAddress()
                        free.recipient = dict["recipient"]!
                        free.building = dict["officeBuilding"]!
                        free.phone = dict["phone"]!
                        free.room = dict["roomNumber"]!
                        self.userAddress = free
                        DispatchQueue.main.async(execute: {
                            self.checkOutBtn.isHidden = false
                            self.editAddressBtn.isHidden = true
                        })
                    } else {//no have address yet , pop up hint
                        self.checkOutBtn.isHidden = true
                        self.editAddressBtn.isHidden = false
                    }
                })
            }else {
                self.carts.removeAll()
                self.tableView.reloadData()
                self.totalPriceLable.text = "TOTOAL: THB 0.0"
                self.bottomBar.isHidden = true
                self.userAddress = nil
            }
        })
    }
}
