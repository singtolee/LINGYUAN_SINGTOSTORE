//
//  StepperView.swift
//  SingtoStore
//
//  Created by li qiang on 12/14/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

class StepperView: UIView {
    
    let minusBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("-", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    let plusBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    let qtyLable: UILabel = {
        let lb = UILabel()
        lb.text = "1"
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor.gray.cgColor
        
        addSubview(minusBtn)
        minusBtn.translatesAutoresizingMaskIntoConstraints = false
        minusBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        minusBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        minusBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        minusBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //minusBtn.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        
        addSubview(plusBtn)
        plusBtn.translatesAutoresizingMaskIntoConstraints = false
        plusBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusBtn.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        plusBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        plusBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //plusBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        addSubview(qtyLable)
        qtyLable.translatesAutoresizingMaskIntoConstraints = false
        qtyLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        qtyLable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qtyLable.heightAnchor.constraint(equalToConstant: 30).isActive = true
        qtyLable.widthAnchor.constraint(equalToConstant: 45).isActive = true
        qtyLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func add() {
//        var qty = Int(qtyLable.text!)!
//        qty += 1
//        qtyLable.text = String(qty)
//    }
//    
//    func decrease() {
//        var qty = Int(qtyLable.text!)!
//        qty -= 1
//        if qty < 1 {
//            qty = 1
//        }
//        qtyLable.text = String(qty)
//    }
}
