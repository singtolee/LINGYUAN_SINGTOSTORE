//
//  Order.swift
//  SingtoStore
//
//  Created by li qiang on 12/22/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
class Order: NSObject {
    
    var oStatus: Int? //-1: cancelled, 0: confirmed, 1:delivering, 2:done;
    var oKey: String?
    var oPKey: String?
    var oQty: Int?
    var oPPrice: Double?
    var oPImageUrl: String?
    var oPCS: Int?
    var oPname: String?
    var oPSpec: String?
    var oTime: String?
    var oDate: String?
}
