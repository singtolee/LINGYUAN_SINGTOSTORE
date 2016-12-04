//
//  Tools.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
class Tools {
    
    static let bgColor: UIColor = UIColor(red:251/255, green:252/255, blue:252/255, alpha:1.0)
    static let veryLightColor: UIColor = UIColor(red:21/255, green:67/255, blue:96/255, alpha:1.0)
    static let dancingShoesColor = UIColor(red:255/255, green:56/255, blue:69/255, alpha:1.0)  //FF3845
    static let headerColor = UIColor(red: 242/255, green: 244/255, blue: 244/255, alpha: 1.0)
    static let placeHolderColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
    
    static func trim(_ str: String) -> String{
        
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    static func isEmail(_ email :String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func shakingUIView(_ textField: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }
    
    static func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: String]) {
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err)
                return}
        })
    }
}
