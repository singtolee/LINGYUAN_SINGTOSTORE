//
//  CheckOutVC.swift
//  SingtoStore
//
//  Created by li qiang on 12/14/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class CheckOutVC: UIViewController {
    
    let addressRef = FIRDatabase.database().reference().child("FreeDeliveryAddresses")
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    let userRef = FIRDatabase.database().reference().child("users")
    let orderRef = FIRDatabase.database().reference().child("ORDERS")
    let ref = FIRDatabase.database().reference()
    var userAddress: FreeAddress!
    var prd: DetailProduct!
    var selectedCS: Int!
    var prdKey: String!
    var qtyHandle: UInt!
    
    var max: Int = 1
    
    let prdImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "placeholder48")
        return img
    }()
    
    let prdTitle = UILabel()
    
    let cs = UILabel()
    
    let stepper = StepperView()
    
    let halfBG = UIView()
    
    let bottomBar = UIView()
    
    let addressCard = AddressCard()
    
    let maxQty: UILabel = {
        let lb = UILabel()
        lb.textColor = Tools.dancingShoesColor
        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10)
        return lb
    }()
    
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
        indi.activityIndicatorViewStyle = .whiteLarge
        return indi
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //transparent background
        self.modalPresentationStyle = .custom
        //touch to dismiss view controller
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        addHalfBG()
        addBottomBar()
        setUpAddressCard()
        addImgView()
        addPrdTitle()
        addCSandStepper()
        loadUserAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qtyChecker()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        prdRef.child(self.prdKey).child("prodcutCSQty").child(String(selectedCS)).removeObserver(withHandle: qtyHandle)
        
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addHalfBG() {
        view.addSubview(halfBG)
        halfBG.backgroundColor = UIColor.white
        halfBG.translatesAutoresizingMaskIntoConstraints = false
        halfBG.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        halfBG.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        halfBG.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        halfBG.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: halfBG.topAnchor, constant: -20).isActive = true
    }
    
    func addBottomBar() {
        halfBG.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: halfBG.bottomAnchor, constant: 0).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: halfBG.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: halfBG.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bottomBar.addSubview(totalPriceLable)
        totalPriceLable.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: 40)
        totalPriceLable.text = "TOTAL: THB \(self.prd.prdPrice!)"
        
        bottomBar.addSubview(checkOutBtn)
        checkOutBtn.frame = CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: 40)
        checkOutBtn.isEnabled = false
        checkOutBtn.addTarget(self, action: #selector(safeCheckOut), for: .touchUpInside)
    }
    
    
    func safeCheckOut() {
        indicator.startAnimating()
        let qtyBuy = Int(self.stepper.qtyLable.text!)!
        
        let safeRef = self.prdRef.child(self.prdKey).child("prodcutCSQty").child(String(self.selectedCS))
        
        safeRef.runTransactionBlock({ (currentQty) -> FIRTransactionResult in
            let qty = currentQty.value as? String
            if qty != nil {
                if (Int(qty!)! - qtyBuy) >= 0 {
                    // enough to sale
                    currentQty.value = String(Int(qty!)! - qtyBuy)
                    return FIRTransactionResult.success(withValue: currentQty)
                }else {
                    //not enough
                    //print("low in stock, try buy less")
                    return FIRTransactionResult.abort()
                }
                
            }else {
                //qty = nil , means there is error with database, alret try again
                // here should not return .abort()
                return FIRTransactionResult.success(withValue: currentQty)
            }
            }) { (error, committed, snap) in
                if error != nil {
                    //handle error, try again
                    let title = "ERROR"
                    let message = "Unknown error, please try again."
                    self.alertVC(tit: title, msg: message)

                } else {
                    //ok to sale, put orders into two paths
                    if committed {
                        // deduct qty, then write order to two paths => Public and Users
                        self.writePublicAndUserOrders()
                    } else {
                        //present modify qty to buy and try again
                        let title = "FAILD MAKING ORDER"
                        let message = "We are low in stock, please reduce the number."
                        self.alertVC(tit: title, msg: message)
                        //print("Unable to make order")
                    }
                }
        }
        
    }
    
    func alertVC(tit: String, msg: String) {
        let alertVC = UIAlertController(title: tit, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) {(action) -> Void in
            self.indicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    func writePublicAndUserOrders() {
        let riqi = Tools.getDateTime().riqi
        let time = Tools.getDateTime().time
        let uid = FIRAuth.auth()?.currentUser?.uid
        var order: Dictionary = [String: Any]()
        order["status"] = 0   //cancelled = -1, default confirmed = 0, deliverying = 1, done = 2
        order["date"] = riqi
        order["time"] = time
        order["userKey"] = uid
        order["prdKey"] = self.prdKey
        order["selectedCSID"] = self.selectedCS
        order["Qty"] = Int(self.stepper.qtyLable.text!)
        //extra
        order["url"] = prd.prdImages![selectedCS]
        order["title"] = prd.prdName
        order["price"] = prd.prdPrice
        order["cs"] = prd.prdCS![selectedCS]
        
        let oRef = orderRef.child(riqi).child(self.userAddress.building)
        let orderKey = oRef.childByAutoId().key
        
        let childUpdates = ["/PUBLICORDERS/\(riqi)/\(orderKey)": order,
                            "/users/\(uid!)/Orders/\(orderKey)": order]
        
        self.ref.updateChildValues(childUpdates) { (error, refrence) in
            if error != nil {
                //error
                let title = "ERROR"
                let message = "Unknown error, please try again."
                self.alertVC(tit: title, msg: message)
            } else {
                // success
                let title = "SUCCESS"
                let message = "Your order will arrive with 24 hours, check it at ORDERS."
                self.alertVC(tit: title, msg: message)
            }
        }
    }
    
    
    func setUpAddressCard() {
        halfBG.addSubview(addressCard)
        addressCard.translatesAutoresizingMaskIntoConstraints = false
        addressCard.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        addressCard.leftAnchor.constraint(equalTo: halfBG.leftAnchor, constant: 25).isActive = true
        addressCard.rightAnchor.constraint(equalTo: halfBG.rightAnchor).isActive = true
        addressCard.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addImgView() {
        halfBG.addSubview(prdImg)
        prdImg.translatesAutoresizingMaskIntoConstraints = false
        prdImg.centerYAnchor.constraint(equalTo: halfBG.topAnchor).isActive = true
        prdImg.heightAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        prdImg.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        prdImg.leftAnchor.constraint(equalTo: halfBG.leftAnchor, constant: 30).isActive = true
        let url = prd.prdImages![selectedCS]
        if let imgUrl = URL(string: url) {
            prdImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "placeholder48"))
        }
    }
    
    func addPrdTitle() {
        halfBG.addSubview(prdTitle)
        prdTitle.translatesAutoresizingMaskIntoConstraints = false
        prdTitle.topAnchor.constraint(equalTo: halfBG.topAnchor, constant: 10).isActive = true
        prdTitle.leftAnchor.constraint(equalTo: prdImg.rightAnchor, constant: 10).isActive = true
        prdTitle.rightAnchor.constraint(equalTo: halfBG.rightAnchor, constant: 0).isActive = true
        prdTitle.bottomAnchor.constraint(equalTo: prdImg.bottomAnchor, constant: -10).isActive = true
        prdTitle.text = prd.prdName
        prdTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    
    func addCSandStepper() {
        halfBG.addSubview(cs)
        cs.translatesAutoresizingMaskIntoConstraints = false
        cs.topAnchor.constraint(equalTo: prdImg.bottomAnchor, constant: 10).isActive = true
        cs.leftAnchor.constraint(equalTo: halfBG.leftAnchor, constant: 30).isActive = true
        cs.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 30).isActive = true
        cs.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cs.text = prd.prdCS?[selectedCS]
        cs.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        halfBG.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.topAnchor.constraint(equalTo: prdImg.bottomAnchor, constant: 10).isActive = true
        stepper.leftAnchor.constraint(equalTo: cs.rightAnchor, constant: 0).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 105).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stepper.minusBtn.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        stepper.plusBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        halfBG.addSubview(maxQty)
        maxQty.isHidden = true
        maxQty.translatesAutoresizingMaskIntoConstraints = false
        maxQty.centerYAnchor.constraint(equalTo: stepper.centerYAnchor).isActive = true
        maxQty.leftAnchor.constraint(equalTo: stepper.rightAnchor, constant: 5).isActive = true
        maxQty.widthAnchor.constraint(equalToConstant: 45).isActive = true
        maxQty.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
                    self.addressCard.address = self.userAddress
                    self.checkOutBtn.isEnabled = true
                })
                } else {//no have address yet , pop up hint
                    
                }
            })
        }
        
    }
    
    func add() {
        var qty = Int(stepper.qtyLable.text!)!
        //var qty = Int(qtyLable.text!)!
        qty += 1
        if qty > max {
            qty = max
        }
        let total = prd.prdPrice! * Double(qty)
        stepper.qtyLable.text = String(qty)
        totalPriceLable.text = "TOTAL: THB \(total)"
    }
    
    func decrease() {
        var qty = Int(stepper.qtyLable.text!)!
        qty -= 1
        if qty < 1 {
            qty = 1
        }
        let total = prd.prdPrice! * Double(qty)
        stepper.qtyLable.text = String(qty)
        totalPriceLable.text = "TOTAL: THB \(total)"
    }
    
    func qtyChecker() {
        self.qtyHandle = prdRef.child(self.prdKey).child("prodcutCSQty").child(String(selectedCS)).observe(.value, with: { (snap) in
            let remain = snap.value as! String
            self.max = Int(remain)!
            if(self.max < 10){
                self.maxQty.isHidden = false
                self.maxQty.text = "(\(self.max) LEFT)"
            }else{
                self.maxQty.isHidden = true
            }
            //self.maxQty.text = "(\(self.max) LEFT)"
        })
    }

}
