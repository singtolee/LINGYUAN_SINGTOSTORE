//
//  EditPostAddress.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditPostAddress: AddPostAddress {
    
    var address: PostAddress?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "deleteAddress"), style: .plain, target: self, action: #selector(deleteAddress))
        saveBTN.setTitle("UPDATE", for: UIControlState())
        recipientTF.text = address?.recipient
        phoneTF.text = address?.phone
        postCode.text = address?.postCode
        detailAddressTF.text = address?.detailAddress
        placeHolder.isHidden = true
        
    }
    override func checkThenAddtoDB() {
        let recipient = Tools.trim(recipientTF.text!)
        let mobile = phoneTF.text!
        let address = detailAddressTF.text
        let postcode = Tools.trim(postCode.text!)
        if recipient != "" && mobile.characters.count == 10 && (address?.characters.count)! > 6 && postcode.characters.count == 5 {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                indicator.startAnimating()
                var values: Dictionary = [String: String]()
                values["Address"] = address
                values["PostCode"] = postcode
                values["recipient"] = recipient
                values["phone"] = mobile
                let ref = FIRDatabase.database().reference().child("MailingAddresses").child(uid).child(self.address!.ID)
                ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        self.indicator.stopAnimating()
                        return}
                    self.indicator.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        } else {
            if recipient == "" {
                Tools.shakingUIView(recipientTF)
            }
            if mobile.characters.count != 10 {
                Tools.shakingUIView(phoneTF)
            }
            if postcode.characters.count != 5 {
                Tools.shakingUIView(postCode)
            }
            if (address?.characters.count)! <= 6 {
                Tools.shakingUIView(detailAddressTF)
            }
        }
    }
    
    func deleteAddress() {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            indicator.startAnimating()
            let ref = FIRDatabase.database().reference().child("MailingAddresses").child(uid).child(self.address!.ID)
            ref.removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    self.indicator.stopAnimating()
                    return
                }
                self.indicator.stopAnimating()
                _ = self.navigationController?.popViewController(animated: true)
                
            })
        }
        
    }
    
}

