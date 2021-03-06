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
import SVProgressHUD

class CartTab: DancingShoesViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "cellID"
    var lowQty = false
    
    let addressRef = FIRDatabase.database().reference().child("FreeDeliveryAddresses")
    var userAddress: FreeAddress!
    
    let ref = FIRDatabase.database().reference().child("users")
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    
    var uid: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomBar()
        addTableView()
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
        tableView.register(CartCell.self, forCellReuseIdentifier: cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 0).isActive = true
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
        let empty = CartEmptyState(frame: tableView.frame)
        tableView.backgroundView = empty
    }
    func addBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.white
        bottomBar.isHidden = true
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
        //check qty=> update qty => write orders => remove from Cart
        let addressMsg = "Deliever to: " + userAddress.recipient + " ," + userAddress.phone + " ," + userAddress.room + " ," + userAddress.building
        let willCheckOutAlert = UIAlertController(title: "Are you sure to make this order?", message: addressMsg, preferredStyle: .alert)
        let cancelAct = UIAlertAction(title: "CANCEL", style: .default) {(action) -> Void in
        }
        let okAction = UIAlertAction(title: "ORDER", style: .default) {(action) -> Void in
            
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "Submiting orders...")
            
            for cart in self.carts {
                if cart.pChecked! {
                    self.ckCarts.append(cart)
                }
            }
            
            let num = self.ckCarts.count
            self.lowQty = false
            for i in 0 ..< num {
                self.checkOutOnebyOne(c: self.ckCarts[i], i: i + 1, num: num)
            }
        }
        willCheckOutAlert.addAction(cancelAct)
        willCheckOutAlert.addAction(okAction)
        self.present(willCheckOutAlert, animated: true, completion: nil)
    }
    
    func alertVC(tit: String, msg: String) {
        let alertVC = UIAlertController(title: tit, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func checkOutOnebyOne(c: CartProduct, i: Int, num: Int) {
        let safeRef = self.prdRef.child(c.pKey!).child("prodcutCSQty").child(String(c.pID!))
        safeRef.runTransactionBlock({ (currentQty) -> FIRTransactionResult in
            let qty = currentQty.value as? String
            if qty != nil {
                if (Int(qty!)! - c.pQty) >= 0 {
                    currentQty.value = String(Int(qty!)! - c.pQty)
                    return FIRTransactionResult.success(withValue: currentQty)
                } else {
                    return FIRTransactionResult.abort()
                }
            }else {
                return FIRTransactionResult.success(withValue: currentQty)
            }
        }) { (error, committed, snap) in
            if error != nil {
                // unknown error
            }else {
                if committed {
                    //enough for sell, remove from cart, write to order paths
                    let riqi = Tools.getDateTime().riqi
                    let time = Tools.getDateTime().time
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    var order: Dictionary = [String: Any]()
                    order["status"] = 0
                    order["date"] = riqi
                    order["time"] = time
                    order["userKey"] = uid
                    order["prdKey"] = c.pKey!
                    order["selectedCSID"] = c.pID!
                    order["Qty"] = c.pQty
                    //extra
                    order["url"] = c.pMainImage
                    order["title"] = c.pName
                    order["price"] = c.pPrice
                    order["cs"] = c.pCS
                    let orderKey = self.ref.childByAutoId().key
                    
                    //remove from cart
                    self.ref.child(uid!).child("SHOPPINGCART").child(c.cartKey!).removeValue()
                    
                    let childUpdates = ["/PUBLICORDERS/\(riqi)/\(orderKey)": order,
                                        "/users/\(uid!)/Orders/\(orderKey)": order]
                    
                    FIRDatabase.database().reference().updateChildValues(childUpdates, withCompletionBlock: { (err, ref) in
                        //SVProgressHUD.dismiss()
                        if err != nil {
                            return
                        } else {
                            if i == num {
                                self.ckCarts.removeAll()
                                SVProgressHUD.dismiss()
                                if self.lowQty {
                                    let title = "WARN"
                                    let message = "Some products are low in stock,Please reduce the quantity."
                                    self.alertVC(tit: title, msg: message)
                                } else {
                                    let title = "SUCCESS"
                                    let message = "You can check the status of your orders in ORDERS"
                                    self.alertVC(tit: title, msg: message)
                                }
                            }
                        }
                    })
                }else {
                    self.lowQty = true
                    if i == num {
                        SVProgressHUD.dismiss()
                        self.ckCarts.removeAll()
                        let title = "WARN"
                        let message = "Some products are low in stock,Please reduce the quantity."
                        self.alertVC(tit: title, msg: message)
                    }
                }
            }
        }
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
    
    func listenCart(uid: String){
        let cartRef = ref.child(uid).child("SHOPPINGCART")
        cartRef.observe(.childAdded, with: { (snap) in
            //child add
            let cc = CartProduct()
            if let dict = snap.value as? [String: Any]{
                cc.cartKey = snap.key
                cc.pKey = dict["prdKey"] as? String
                cc.pName = dict["prdTitle"] as? String
                cc.pMainImage = dict["prdImg"] as? String
                cc.pChecked = dict["Check"] as? Bool
                cc.pCS = dict["prdCS"] as? String
                cc.pPrice = dict["prdPrice"] as? Double
                cc.pID = dict["ID"] as? Int
                cc.pQty = (dict["Qty"] as? Int)!
                
            }
            self.carts.insert(cc, at: 0)
            //print("After adding ",self.carts.count)
            self.tableView.insertRows(at: [IndexPath(row:0,section:0)], with: .automatic)
            self.updateBottomBar()
            
        })
        cartRef.observe(.childChanged, with: { (snap) in
            //child changed
            let cc = CartProduct()
            if let dict = snap.value as? [String: Any]{
                cc.cartKey = snap.key
                cc.pKey = dict["prdKey"] as? String
                cc.pName = dict["prdTitle"] as? String
                cc.pMainImage = dict["prdImg"] as? String
                cc.pChecked = dict["Check"] as? Bool
                cc.pCS = dict["prdCS"] as? String
                cc.pPrice = dict["prdPrice"] as? Double
                cc.pID = dict["ID"] as? Int
                cc.pQty = (dict["Qty"] as? Int)!
                
            }
            let i = self.findIndexByKey(key: snap.key)
            self.carts[i] = cc
            //print("After Changing ",self.carts.count)
            self.tableView.reloadRows(at: [IndexPath(row:i,section:0)], with: .none)
            
            self.updateBottomBar()
        })
        cartRef.observe(.childRemoved, with: { (snap) in
            //child removed
            let i = self.findIndexByKey(key: snap.key)
            //print("Index removed at: ", i)
            if i != -1 {
                self.carts.remove(at: i)
                //print("After remone, Now left ", self.carts.count)
                self.tableView.deleteRows(at: [IndexPath(row:i,section:0)], with: .fade)
                self.updateBottomBar()
            }else{
                //TODO
                print("Could not find this ",snap.key)
            }
        })
    }
    
    func findIndexByKey(key: String) -> Int {
        var index = -1
        for i in 0..<self.carts.count {
            if carts[i].cartKey == key {
                index = i
                break
            }
        }
        return index
    }
    
    func updateBottomBar() {
        let badge = carts.count
        if badge > 0 {
            tabBarController?.tabBar.items?[2].badgeValue = String(badge)
            tableView.backgroundView = nil
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = nil
            //tableview is empty, add an empty view
            //let emptyStateLabel = UILabel(frame: tableView.frame)
            //emptyStateLabel.text = "Your cart is EMPTY"
            //tableView.backgroundView = emptyStateLabel
            let emptyView = CartEmptyState(frame: tableView.frame)
            tableView.backgroundView = emptyView
        }
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
                self.uid = user?.uid
                //clear before login
                self.carts.removeAll();
                self.ckCarts.removeAll();
                self.listenCart(uid: self.uid!)
                //self.bottomBar.isHidden = false
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
                self.ckCarts.removeAll()
                self.tableView.reloadData()
                self.updateBottomBar()
                self.totalPriceLable.text = "TOTOAL: THB 0.0"
                self.bottomBar.isHidden = true
                self.userAddress = nil
                if (self.uid != nil){
                    self.ref.child(self.uid!).child("SHOPPINGCART").removeAllObservers()//this is IMPORTANT!!! is not removed, event will be observed many time.
                    self.addressRef.child(self.uid!).removeAllObservers()
                }
            }
        })
    }
}
