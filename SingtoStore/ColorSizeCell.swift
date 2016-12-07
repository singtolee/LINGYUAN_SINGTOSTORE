//
//  ColorSizeCell.swift
//  SingtoStore
//
//  Created by li qiang on 12/7/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

class ColorSizeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let csView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.white
        return iv
    }()
    let cs: UILabel = {
        let lb = UILabel()
        lb.textColor = Tools.dancingShoesColor
        lb.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        return lb
    }()
    
    override var isSelected: Bool {
        didSet {
            //print("ASDA")
            csView.backgroundColor = isSelected ? Tools.dancingShoesColor : UIColor.white
            cs.textColor = isSelected ? UIColor.white : Tools.dancingShoesColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            //print("ASDASDASD")
            //csView.backgroundColor = isHighlighted ? Tools.dancingShoesColor : UIColor.white
            //cs.textColor = isHighlighted ? UIColor.white : Tools.dancingShoesColor
        }
    }
    
    func setupViews() {
        addSubview(csView)
        csView.translatesAutoresizingMaskIntoConstraints = false
        csView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        csView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        csView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        csView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        csView.layer.cornerRadius = 6
        
        csView.addSubview(cs)
        cs.translatesAutoresizingMaskIntoConstraints = false
        cs.centerXAnchor.constraint(equalTo: csView.centerXAnchor).isActive = true
        cs.centerYAnchor.constraint(equalTo: csView.centerYAnchor).isActive = true
    }
    
}
