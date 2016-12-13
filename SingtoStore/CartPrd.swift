//
//  CartPrd.swift
//  SingtoStore
//
//  Created by li qiang on 12/11/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
class CartProduct: NSObject {
    var cartKey: String?  //the key in the SHOPPINGCART folder
    var pName: String?  //title
    var pCS: String?  //specification
    var pPrice: String?
    var pMainImage: String?
    var pKey: String?
    var pQty: Int = 1 // how many wants to buy, should be <= pCSRemain
    var pChecked: Bool?  //if checked, check bill together
    var pCSRemain: Int? //how many left
    var pID: Int? // use this ID to get color or size and Qty left
}
