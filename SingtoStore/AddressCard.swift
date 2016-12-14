//
//  AddressCard.swift
//  SingtoStore
//
//  Created by li qiang on 12/14/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

class AddressCard: UIView {
    
    var address: FreeAddress? {
        didSet {
            recipientLable.text = "TO: " + (address?.recipient)! + "   " + (address?.phone)!
            //recipientLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
            //phoneLable.text = "PHONE: " + (address?.phone)!
            //phoneLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
            addressLable.text = "ADDRESS: " + (address?.room)! + ", " + (address?.building)!
            //addressLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        }
    }
    
    let recipientLable: UITextView = {
        let lb = UITextView()
        //lb.textAlignment = .right
        lb.isScrollEnabled = false
        lb.isEditable = false
        //lb.text = "TO: SINGTO"
        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        return lb
    }()
    
//    let phoneLable: UITextView = {
//        let lb = UITextView()
//        lb.isScrollEnabled = false
//        lb.isEditable = false
//        //lb.textAlignment = .right
//        //lb.text = "PHONE: 0917271197"
//        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
//        return lb
//    }()
    
    let addressLable: UITextView = {
        let lb = UITextView()
        lb.isScrollEnabled = false
        lb.isEditable = false
        //lb.textAlignment = .right
        //lb.text = "ADDRESS: 44/181, Villaggio"
        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    func setUp() {
        addSubview(recipientLable)
        //addSubview(phoneLable)
        addSubview(addressLable)
        recipientLable.translatesAutoresizingMaskIntoConstraints = false
        recipientLable.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recipientLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        recipientLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recipientLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
//        phoneLable.translatesAutoresizingMaskIntoConstraints = false
//        phoneLable.topAnchor.constraint(equalTo: recipientLable.bottomAnchor).isActive = true
//        phoneLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        phoneLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        phoneLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addressLable.translatesAutoresizingMaskIntoConstraints = false
        addressLable.topAnchor.constraint(equalTo: recipientLable.bottomAnchor).isActive = true
        addressLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        addressLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        addressLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
