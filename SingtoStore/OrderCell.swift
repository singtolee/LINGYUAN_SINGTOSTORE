
//
//  OrderCell.swift
//  SingtoStore
//
//  Created by li qiang on 12/22/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import SDWebImage

class OrderCell: UITableViewCell {
    
    var order: Order? {
        didSet {
            title.text = order?.oPname
            title.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 25)
            
            specification.text = (order?.oPSpec)! + " * " + String((order?.oQty!)!)
            specification.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 30)
            
            let total = Double((order?.oQty)!) * (order?.oPPrice)!
            price.text = "THB \(total)"
            specification.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 30)
            
            timeStampe.text = (order?.oTime)! + ", " + (order?.oDate)!
            
            let url = URL(string: (order?.oPImageUrl)!)
            imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder48"))
            switch (order?.oStatus!)! {
            case -1:
                self.cancelStatus()
            case 0:
                self.confirmedStatus()
            case 1:
                self.shippingStatus()
            case 2:
                self.doneStatus()
            default:
                self.confirmedStatus()
            }
        }
    }
    
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "placeholder48")
        iv.backgroundColor = Tools.headerColor
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
    
    let timeStampe: UILabel = {
        let lb = UILabel()
        lb.text = "12:34, 10th Oct 2015"
        lb.textColor = Tools.headerColor
        lb.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        return lb
    }()

    
    let ccDot: UIView = {
        let v = UIView()
        return v
    }()
    
    let lineA: UIView = {
        let v = UIView()
        return v
    }()
    
    let shipDot: UIView = {
        let v = UIView()
        return v
    }()
    
    let lineB: UIView = {
        let v = UIView()
        return v
    }()
    
    let doneDot: UIView = {
        let v = UIView()
        return v
    }()
    
    let ccLab: UILabel = {
        let lb = UILabel()
        lb.text = "CONFIRMED"
        lb.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        return lb
    }()
    
    let shipLab: UILabel = {
        let lb = UILabel()
        lb.text = "SHIPPING"
        lb.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        return lb
    }()
    
    let doneLab: UILabel = {
        let lb = UILabel()
        lb.text = "DONE"
        lb.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        return lb
    }()
    
    
    
    
    
    func addImg() {
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addTitle() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: imgView.centerYAnchor, constant: -20).isActive = true
        title.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func addSpec() {
        addSubview(specification)
        specification.translatesAutoresizingMaskIntoConstraints = false
        specification.centerYAnchor.constraint(equalTo: imgView.centerYAnchor, constant: 0).isActive = true
        specification.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        specification.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func addQty() {
        addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        price.centerYAnchor.constraint(equalTo: imgView.centerYAnchor, constant: 20).isActive = true
        price.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10).isActive = true
        price.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -130).isActive = true
    }
    
    func addTimeMark() {
        addSubview(timeStampe)
        timeStampe.translatesAutoresizingMaskIntoConstraints = false
        timeStampe.centerYAnchor.constraint(equalTo: imgView.centerYAnchor, constant: 20).isActive = true
        timeStampe.leftAnchor.constraint(equalTo: price.rightAnchor).isActive = true
        timeStampe.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func addCCDot() {
        addSubview(ccDot)
        ccDot.translatesAutoresizingMaskIntoConstraints = false
        ccDot.centerYAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        ccDot.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        ccDot.heightAnchor.constraint(equalToConstant: 14).isActive = true
        ccDot.widthAnchor.constraint(equalToConstant: 14).isActive = true
        ccDot.layer.cornerRadius = 7
        ccDot.backgroundColor = Tools.dancingShoesColor
    }
    
    func addShipDot() {
        addSubview(shipDot)
        shipDot.translatesAutoresizingMaskIntoConstraints = false
        shipDot.centerYAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        shipDot.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        shipDot.heightAnchor.constraint(equalToConstant: 14).isActive = true
        shipDot.widthAnchor.constraint(equalToConstant: 14).isActive = true
        shipDot.layer.cornerRadius = 7
        shipDot.backgroundColor = Tools.dancingShoesColor
    }
    
    func addDoneDot() {
        addSubview(doneDot)
        doneDot.translatesAutoresizingMaskIntoConstraints = false
        doneDot.centerYAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        doneDot.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        doneDot.heightAnchor.constraint(equalToConstant: 14).isActive = true
        doneDot.widthAnchor.constraint(equalToConstant: 14).isActive = true
        doneDot.layer.cornerRadius = 7
        doneDot.backgroundColor = Tools.dancingShoesColor
    }
    
    func addLineA() {
        addSubview(lineA)
        lineA.translatesAutoresizingMaskIntoConstraints = false
        lineA.centerYAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        lineA.leftAnchor.constraint(equalTo: ccDot.rightAnchor).isActive = true
        lineA.rightAnchor.constraint(equalTo: shipDot.leftAnchor).isActive = true
        lineA.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineA.backgroundColor = UIColor.gray

    }
    
    func addLineB() {
        addSubview(lineB)
        lineB.translatesAutoresizingMaskIntoConstraints = false
        lineB.centerYAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 15).isActive = true
        lineB.leftAnchor.constraint(equalTo: shipDot.rightAnchor).isActive = true
        lineB.rightAnchor.constraint(equalTo: doneDot.leftAnchor).isActive = true
        lineB.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineB.backgroundColor = UIColor.gray
        
    }
    
    func addCCLab() {
        addSubview(ccLab)
        ccLab.translatesAutoresizingMaskIntoConstraints = false
        ccLab.topAnchor.constraint(equalTo: doneDot.bottomAnchor, constant: 2).isActive = true
        ccLab.centerXAnchor.constraint(equalTo: ccDot.centerXAnchor, constant: 0).isActive = true
    }
    
    func addShipLab() {
        addSubview(shipLab)
        shipLab.translatesAutoresizingMaskIntoConstraints = false
        shipLab.topAnchor.constraint(equalTo: doneDot.bottomAnchor, constant: 2).isActive = true
        shipLab.centerXAnchor.constraint(equalTo: shipDot.centerXAnchor, constant: 0).isActive = true
    }
    
    func addDoneLab() {
        addSubview(doneLab)
        doneLab.translatesAutoresizingMaskIntoConstraints = false
        doneLab.topAnchor.constraint(equalTo: doneDot.bottomAnchor, constant: 2).isActive = true
        doneLab.centerXAnchor.constraint(equalTo: doneDot.centerXAnchor, constant: 0).isActive = true
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        addImg()
        addTitle()
        addSpec()
        addQty()
        addTimeMark()
        addCCDot()
        addShipDot()
        addDoneDot()
        addLineA()
        addLineB()
        addCCLab()
        addShipLab()
        addDoneLab()
        
    }
    
    func cancelStatus() {
        ccDot.backgroundColor = Tools.headerColor
        shipDot.backgroundColor = Tools.headerColor
        doneDot.backgroundColor = Tools.headerColor
        
        lineA.backgroundColor = Tools.headerColor
        lineB.backgroundColor = Tools.headerColor
        
        ccLab.text = "CANCELLED"
        ccLab.textColor = Tools.dancingShoesColor
        
        shipLab.text = ""
        
        doneLab.text = ""
        
    }
    
    func confirmedStatus() {
        ccDot.backgroundColor = Tools.dancingShoesColor
        shipDot.backgroundColor = Tools.headerColor
        doneDot.backgroundColor = Tools.headerColor
        
        lineA.backgroundColor = Tools.headerColor
        lineB.backgroundColor = Tools.headerColor
        
        ccLab.text = "CONFIRMED"
        ccLab.textColor = Tools.dancingShoesColor
        
        shipLab.text = ""
        
        doneLab.text = ""
    
    }
    
    func shippingStatus() {
        ccDot.backgroundColor = Tools.dancingShoesColor
        shipDot.backgroundColor = Tools.dancingShoesColor
        doneDot.backgroundColor = Tools.headerColor
        
        lineA.backgroundColor = Tools.dancingShoesColor
        lineB.backgroundColor = Tools.headerColor
        
        ccLab.text = "CONFIRMED"
        ccLab.textColor = Tools.dancingShoesColor
        
        shipLab.text = "SHIPPING"
        shipLab.textColor = Tools.dancingShoesColor
        
        doneLab.text = ""
    }
    
    func doneStatus() {
        ccDot.backgroundColor = Tools.dancingShoesColor
        shipDot.backgroundColor = Tools.dancingShoesColor
        doneDot.backgroundColor = Tools.dancingShoesColor
        lineA.backgroundColor = Tools.dancingShoesColor
        lineB.backgroundColor = Tools.dancingShoesColor
        ccLab.text = "CONFIRMED"
        ccLab.textColor = Tools.dancingShoesColor
        shipLab.text = "SHIPPING"
        shipLab.textColor = Tools.dancingShoesColor
        doneLab.text = "DONE"
        doneLab.textColor = Tools.dancingShoesColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
