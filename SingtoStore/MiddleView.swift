//
//  MiddleView.swift
//  SingtoStore
//
//  Created by li qiang on 12/6/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

class MiddleView: UIView {
    
    var prdc: DetailProduct? {
        didSet{
            self.titleLable.text = prdc!.prdName! + " (" + prdc!.prdPackageInfo! + ")"
            self.titleLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width/22)
            self.titleLable.heightAnchor.constraint(equalToConstant: frame.width / 14).isActive = true
            self.priceTag.text = "THB " + String(describing: prdc!.prdPrice!)
            self.priceTag.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: frame.width/22)
            self.priceTag.heightAnchor.constraint(equalToConstant: frame.width / 14).isActive = true
            self.detailTag.text = prdc!.prdSub
            self.detailTag.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width/28)
            self.detailTag.heightAnchor.constraint(equalToConstant: frame.width / 7).isActive = true
            self.freeShippingLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width/30)
            self.cashOnDeliveryLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width/30)
            self.refundableLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width/30)

            self.nonrefundableLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width/30)
            //self.csSection.heightAnchor.constraint(equalToConstant: 24 * CGFloat(round(Double(prdc!.prdCS!.count) / 2))).isActive = true
            //self.csSection.heightAnchor.constraint(equalToConstant: 140).isActive = true
            
            if(prdc!.isRefundable!) {
                self.refundableLable.isHidden = false
            } else {
                self.nonrefundableLable.isHidden = false
            }
            
            //self.csSection.colorsizes = prdc!.prdCS!
            
        }
    }
    
    let titleLable: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = UIColor.black
        return tv
    }()
    
    let priceTag: UITextView = {
        let lb = UITextView()
        lb.isScrollEnabled = false
        lb.isEditable = false
        lb.textColor = Tools.dancingShoesColor
        return lb
    }()
    
    let detailTag: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let commitmentView = UIView()
    
    let freeShippingLable: UILabel = {
        let lb = UILabel()
        let iconSize = CGRect(x: 0, y: 1, width: 8, height: 8)
        let attributedString = NSMutableAttributedString(string: "  ")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "dot")
        attachment.bounds = iconSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " FREE DELIVERY"))
        lb.attributedText = attributedString
        return lb
    }()
    
    let cashOnDeliveryLable: UILabel = {
        let lb = UILabel()
        let iconSize = CGRect(x: 0, y: 1, width: 8, height: 8)
        let attributedString = NSMutableAttributedString(string: "  ")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "dot")
        attachment.bounds = iconSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " CASH ON DELIVERY(BANGKOK SELECTED AREA)"))
        lb.attributedText = attributedString
        return lb
    }()
    
    let refundableLable: UILabel = {
        let lb = UILabel()
        let iconSize = CGRect(x: 0, y: 1, width: 8, height: 8)
        let attributedString = NSMutableAttributedString(string: "  ")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "dot")
        attachment.bounds = iconSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " REFUNDABLE WITHIN 7 DAYS"))
        lb.attributedText = attributedString
        return lb
    }()
    
    let nonrefundableLable: UILabel = {
        let lb = UILabel()
        let iconSize = CGRect(x: 0, y: 1, width: 8, height: 8)
        let attributedString = NSMutableAttributedString(string: "  ")
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "undot")
        attachment.bounds = iconSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: " FOOD, NON-REFUNDABLE"))
        lb.attributedText = attributedString
        return lb
    }()
    
    func addTitle() {
        addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    func addPriceTag() {
        addSubview(priceTag)
        //priceTag.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 0)
        priceTag.translatesAutoresizingMaskIntoConstraints = false
        priceTag.topAnchor.constraint(equalTo: titleLable.bottomAnchor).isActive = true
        priceTag.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        priceTag.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func addDetailTag() {
        addSubview(detailTag)
        //detailTag.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        detailTag.translatesAutoresizingMaskIntoConstraints = false
        detailTag.topAnchor.constraint(equalTo: priceTag.bottomAnchor).isActive = true
        detailTag.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        detailTag.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func setUpCommitmentView() {
        commitmentView.addSubview(freeShippingLable)
        commitmentView.isHidden = true
        freeShippingLable.backgroundColor = UIColor.white
        freeShippingLable.translatesAutoresizingMaskIntoConstraints = false
        freeShippingLable.topAnchor.constraint(equalTo: commitmentView.topAnchor, constant: 4).isActive = true
        freeShippingLable.leftAnchor.constraint(equalTo: commitmentView.leftAnchor, constant: 0).isActive = true
        freeShippingLable.rightAnchor.constraint(equalTo: commitmentView.rightAnchor).isActive = true
        
        commitmentView.addSubview(cashOnDeliveryLable)
        cashOnDeliveryLable.backgroundColor = UIColor.white
        cashOnDeliveryLable.translatesAutoresizingMaskIntoConstraints = false
        cashOnDeliveryLable.topAnchor.constraint(equalTo: freeShippingLable.bottomAnchor, constant: 4).isActive = true
        cashOnDeliveryLable.leftAnchor.constraint(equalTo: commitmentView.leftAnchor, constant: 0).isActive = true
        cashOnDeliveryLable.rightAnchor.constraint(equalTo: commitmentView.rightAnchor).isActive = true
        
        commitmentView.addSubview(refundableLable)
        refundableLable.isHidden = true
        refundableLable.backgroundColor = UIColor.white
        refundableLable.translatesAutoresizingMaskIntoConstraints = false
        refundableLable.topAnchor.constraint(equalTo: cashOnDeliveryLable.bottomAnchor, constant: 4).isActive = true
        refundableLable.leftAnchor.constraint(equalTo: commitmentView.leftAnchor, constant: 0).isActive = true
        refundableLable.rightAnchor.constraint(equalTo: commitmentView.rightAnchor).isActive = true
        
        commitmentView.addSubview(nonrefundableLable)
        nonrefundableLable.isHidden = true
        nonrefundableLable.backgroundColor = UIColor.white
        nonrefundableLable.translatesAutoresizingMaskIntoConstraints = false
        nonrefundableLable.topAnchor.constraint(equalTo: cashOnDeliveryLable.bottomAnchor, constant: 4).isActive = true
        nonrefundableLable.leftAnchor.constraint(equalTo: commitmentView.leftAnchor, constant: 0).isActive = true
        nonrefundableLable.rightAnchor.constraint(equalTo: commitmentView.rightAnchor).isActive = true
        
    }
    
    
    func addCommitmentView() {
        setUpCommitmentView()
        addSubview(commitmentView)
        commitmentView.backgroundColor = UIColor.white
        commitmentView.translatesAutoresizingMaskIntoConstraints = false
        commitmentView.topAnchor.constraint(equalTo: detailTag.bottomAnchor, constant: 6).isActive = true
        commitmentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        commitmentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        commitmentView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitle()
        addPriceTag()
        addDetailTag()
        addCommitmentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
