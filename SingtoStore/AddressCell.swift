//
//  AddressCell.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
class AddressCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: textLabel!.frame.origin.x, y: textLabel!.frame.origin.y - 4, width: self.frame.width - 140, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: detailTextLabel!.frame.origin.x, y: detailTextLabel!.frame.origin.y + 4, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        phoneLable.frame = CGRect(x: self.frame.width - 120, y: textLabel!.frame.origin.y - 4, width: 70, height: textLabel!.frame.height)
    }
    
    let phoneLable: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = UIFont(name: "ArialHebrew-Light", size: 14)
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(phoneLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
