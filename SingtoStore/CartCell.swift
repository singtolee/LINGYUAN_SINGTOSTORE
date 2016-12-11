//
//  CartCell.swift
//  SingtoStore
//
//  Created by li qiang on 12/11/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(UIImage(named: "checked"), for: .normal)
        return btn
    }()
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "placeholder48")
        return iv
    }()
    
    let specification: UILabel = {
        let lb = UILabel()
        lb.text = "Color and size"
        return lb
    }()
    
    let title: UILabel = {
        let lb = UILabel()
        lb.text = "Title"
        return lb
    }()
    
    let price: UILabel = {
        let lb = UILabel()
        lb.text = "THB 99999"
        lb.textColor = Tools.dancingShoesColor
        return lb
    }()
    
    let stepperView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 2
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    
    let plusBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus"), for: .normal)
        btn.setImage(UIImage(named: "plusClicked"), for: .highlighted)
        return btn
    }()
    
    func clicked() {
        print(123123)
    }
    
    let qtyLable: UILabel = {
        let lb = UILabel()
        lb.text = "8"
        lb.layer.borderWidth = 0.5
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.textAlignment = .center
        return lb
    }()
    let minusBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "minus"), for: .normal)
        btn.setImage(UIImage(named: "minusClicked"), for: .selected)
        return btn
    }()
    
    func addCheckBtn() {
        addSubview(checkBtn)
        checkBtn.translatesAutoresizingMaskIntoConstraints = false
        checkBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        checkBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func addImageView() {
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imgView.leftAnchor.constraint(equalTo: checkBtn.rightAnchor, constant: 10).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    func addSpec() {
        addSubview(specification)
        specification.translatesAutoresizingMaskIntoConstraints = false
        specification.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15).isActive = true
        specification.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        specification.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func addTitle() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -45).isActive = true
        title.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func addPrice() {
        addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        price.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        price.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        price.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func addStpper() {
        addSubview(stepperView)
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        stepperView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 45).isActive = true
        stepperView.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        stepperView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        stepperView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        stepperView.addSubview(minusBtn)
        minusBtn.frame = CGRect(x: 1, y: 0.5, width: 23, height: 23)
        minusBtn.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        stepperView.addSubview(plusBtn)
        plusBtn.frame = CGRect(x: 67, y: 0.5, width: 23, height: 23)
        stepperView.addSubview(qtyLable)
        qtyLable.frame = CGRect(x: 25, y: 0, width: 40, height: 24)
    }
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addCheckBtn()
        addImageView()
        addSpec()
        addTitle()
        addPrice()
        addStpper()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
