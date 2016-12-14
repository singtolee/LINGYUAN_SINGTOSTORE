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
    var userAddress: FreeAddress!
    var prd: DetailProduct!
    var selectedCS: Int!
    var prdKey: String!
    var qtyHandle: UInt!
    
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
        cs.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        cs.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cs.text = prd.prdCS?[selectedCS]
        cs.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        halfBG.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.topAnchor.constraint(equalTo: prdImg.bottomAnchor, constant: 10).isActive = true
        stepper.leftAnchor.constraint(equalTo: cs.rightAnchor, constant: 0).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 105).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
                }
                DispatchQueue.main.async(execute: { 
                    self.addressCard.address = self.userAddress
                })
            })
        }
        
    }
    
    func qtyChecker() {
        self.qtyHandle = prdRef.child(self.prdKey).child("prodcutCSQty").child(String(selectedCS)).observe(.value, with: { (snap) in
            let remain = snap.value as! String
            let ii = Int(remain)!
            print(ii)
        })
    }

}
