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
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.setTitle("CHECK OUT", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        return btn
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indi = UIActivityIndicatorView()
        indi.hidesWhenStopped = true
        indi.activityIndicatorViewStyle = .gray
        return indi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CartCell.self, forCellReuseIdentifier: cellID)
        
        addBottomBar()
        addTableView()
        loadUserAddress()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        ifUserLogOut()
    }
    
    func ifUserLogOut() {
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            // ...
            if user == nil {
                self.carts.removeAll()
                self.tableView.reloadData()
                self.totalPriceLable.text = "TOTOAL: THB 0.0"
                self.bottomBar.isHidden = true
            } else {
                self.bottomBar.isHidden = false
                self.loadUserCart()
            }
        }
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
        checkOutBtn.addTarget(self, action: #selector(checkOutAll), for: .touchUpInside)
        checkOutBtn.isEnabled = false
    }
    func checkOutAll() {
        indicator.startAnimating()
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
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
                
            }
        }
        let buySuccess = UIAlertController(title: "SUCCESS", message: "Your order will be shipped out within 24 hours.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {(action) -> Void in
            self.indicator.stopAnimating()
        }
        buySuccess.addAction(okAction)
        self.present(buySuccess, animated: true, completion: nil)
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
        } else {
            // user not login, display login hint with tableview empty status
            //empty carts
            //self.carts.removeAll()
            //tableView.reloadData()
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
        self.totalPriceLable.text = "TOTOAL: THB " + String(total)
    }
    
    func loadUserAddress() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            addressRef.child(uid).observeSingleEvent(of: .value, with: { (snap) in
                if let dict = snap.value as? [String: String] {
                    let free = FreeAddress()
                    free.recipient = dict["recipient"]!
                    free.building = dict["officeBuilding"]!
                    free.phone = dict["phone"]!
                    free.room = dict["roomNumber"]!
                    self.userAddress = free
                    DispatchQueue.main.async(execute: {
                        self.checkOutBtn.isEnabled = true
                    })
                } else {//no have address yet , pop up hint
                    
                }
            })
        }
        
    }
}
