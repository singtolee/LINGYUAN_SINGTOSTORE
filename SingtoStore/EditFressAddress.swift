//
//  EditFressAddress.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditFreeAddress: DancingShoesViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var officeAddress: FreeAddress?
    let recipientTF = UITextField()
    let phoneTF = UITextField()
    let roomTF = UITextField()
    let buildingTF = UITextField()
    let saveBTN = UIButton()
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    let buildingPicker = UIPickerView()
    var buildings = [String]()
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        setUpRecipientTF()
        setUpPhoneTF()
        setUpBuildingTF()
        setupRoomNumberTF()
        addBtn()
        setupBuildingPicker()
        setUpActivityIndicator()
        buildingPicker.delegate = self
        buildingPicker.dataSource = self
        recipientTF.text = officeAddress?.recipient
        phoneTF.text = officeAddress?.phone
        roomTF.text = officeAddress?.room
        buildingTF.text = officeAddress?.building
        self.fetchOFB()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allTextFieldsResignFirstResponder)))
        self.view.isUserInteractionEnabled = true
    }
    
    func setUpActivityIndicator() {
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
    }
    
    func setScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height*1.0)
    }
    
    func setUpRecipientTF() {
        scrollView.addSubview(recipientTF)
        recipientTF.delegate = self
        recipientTF.placeholder = "RECIPIENT"
        recipientTF.borderStyle = .none
        recipientTF.autocorrectionType = .no
        recipientTF.clearButtonMode = .whileEditing
        recipientTF.returnKeyType = .next
        recipientTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        recipientTF.translatesAutoresizingMaskIntoConstraints = false
        recipientTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recipientTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        recipientTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        recipientTF.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        recipientTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine0 = UIView()
        subLine0.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine0)
        subLine0.translatesAutoresizingMaskIntoConstraints = false
        subLine0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine0.topAnchor.constraint(equalTo: recipientTF.bottomAnchor).isActive = true
        subLine0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpPhoneTF() {
        scrollView.addSubview(phoneTF)
        phoneTF.delegate = self
        phoneTF.keyboardType = .numberPad
        phoneTF.clearButtonMode = .whileEditing
        phoneTF.placeholder = "PHONE NUMBER"
        phoneTF.borderStyle = .none
        phoneTF.returnKeyType = .next
        phoneTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        phoneTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        phoneTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        phoneTF.topAnchor.constraint(equalTo: recipientTF.bottomAnchor, constant: 10).isActive = true
        phoneTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine1 = UIView()
        subLine1.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine1)
        subLine1.translatesAutoresizingMaskIntoConstraints = false
        subLine1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine1.topAnchor.constraint(equalTo: phoneTF.bottomAnchor).isActive = true
        subLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpBuildingTF() {
        scrollView.addSubview(buildingTF)
        buildingTF.delegate = self
        buildingTF.inputView = buildingPicker
        buildingTF.clearButtonMode = .unlessEditing
        buildingTF.placeholder = "OFFICE BUILDING"
        buildingTF.borderStyle = .none
        buildingTF.returnKeyType = .next
        buildingTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        buildingTF.translatesAutoresizingMaskIntoConstraints = false
        buildingTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buildingTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        buildingTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        buildingTF.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 10).isActive = true
        buildingTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine2 = UIView()
        subLine2.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine2)
        subLine2.translatesAutoresizingMaskIntoConstraints = false
        subLine2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine2.topAnchor.constraint(equalTo: buildingTF.bottomAnchor).isActive = true
        subLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupRoomNumberTF() {
        scrollView.addSubview(roomTF)
        roomTF.delegate = self
        roomTF.autocorrectionType = .no
        roomTF.clearButtonMode = .whileEditing
        roomTF.placeholder = "ROOM NUMBER"
        roomTF.borderStyle = .none
        roomTF.returnKeyType = .done
        roomTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        roomTF.translatesAutoresizingMaskIntoConstraints = false
        roomTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roomTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        roomTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        roomTF.topAnchor.constraint(equalTo: buildingTF.bottomAnchor, constant: 10).isActive = true
        roomTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine3 = UIView()
        subLine3.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine3)
        subLine3.translatesAutoresizingMaskIntoConstraints = false
        subLine3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine3.topAnchor.constraint(equalTo: roomTF.bottomAnchor).isActive = true
        subLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func addBtn() {
        scrollView.addSubview(saveBTN)
        saveBTN.translatesAutoresizingMaskIntoConstraints = false
        saveBTN.backgroundColor = Tools.dancingShoesColor
        saveBTN.layer.cornerRadius = 6
        saveBTN.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        saveBTN.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        saveBTN.topAnchor.constraint(equalTo: roomTF.bottomAnchor, constant: 40).isActive = true
        saveBTN.heightAnchor.constraint(equalToConstant: 36)
        saveBTN.setTitle("SAVE ADDRESS", for: UIControlState())
        saveBTN.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        saveBTN.addTarget(self, action: #selector(checkThenAddtoDB), for: .touchUpInside)
    }
    
    func checkThenAddtoDB() {
        let recipient = Tools.trim(recipientTF.text!)
        let mobile = phoneTF.text!
        let ofb = buildingTF.text
        let room = Tools.trim(roomTF.text!)
        if recipient != "" && mobile.characters.count == 10 && ofb != "" && room != "" {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                indicator.startAnimating()
                var values: Dictionary = [String: String]()
                //var values: Dictionary = [String: AnyObject]()
                values["officeBuilding"] = ofb
                values["roomNumber"] = room
                values["recipient"] = recipient
                values["phone"] = mobile
                let ref = FIRDatabase.database().reference().child("FreeDeliveryAddresses").child(uid)
                ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        self.indicator.stopAnimating()
                        //print(err)
                        return}
                    self.indicator.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                })
                //Tools.saveFreeDeliveryAddressIntoDatabaseWithUID(uid, values: values)
            }
        } else {
            if recipient == "" {
                Tools.shakingUIView(recipientTF)
            }
            if mobile.characters.count != 10 {
                Tools.shakingUIView(phoneTF)
            }
            if ofb == "" {
                Tools.shakingUIView(buildingTF)
            }
            if room == "" {
                Tools.shakingUIView(roomTF)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.roomTF {
            switch UIScreen.main.bounds.height {
            case 480:
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
                })
            case 568:
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 40)
                })
            default: break
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.recipientTF {
            self.phoneTF.becomeFirstResponder()
        }
        if (textField == roomTF) {
            roomTF.resignFirstResponder()
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            })
        }
        return true
    }
    
    func allTextFieldsResignFirstResponder() {
        self.recipientTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.buildingTF.resignFirstResponder()
        self.roomTF.resignFirstResponder()
        //if this code can make it running smoothly
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
        //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func setupBuildingPicker() {
        buildingPicker.backgroundColor = UIColor.white
        buildingPicker.showsSelectionIndicator = true
        buildingPicker.isUserInteractionEnabled = false
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Tools.dancingShoesColor
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonForPicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonForPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.buildingTF.inputAccessoryView = toolBar
        
    }
    
    func fetchOFB() {
        FIRDatabase.database().reference().child("OfficeBuildings").observe(.childAdded, with: { (snapshot) in
            let ob = snapshot.value as! String
            self.buildings.append(ob)
            DispatchQueue.main.async(execute: {
                self.buildingPicker.isUserInteractionEnabled = true
                self.buildingPicker.reloadAllComponents()
            })
            }, withCancel: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buildings.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let lab = UILabel()
        lab.text = buildings[row]
        lab.textColor = Tools.dancingShoesColor
        lab.font = UIFont(name: "ArialHebrew-Light", size: 16)
        lab.textAlignment = .center
        return lab
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        buildingTF.text = buildings[row]
    }
    
    func doneButtonForPicker() {
        self.buildingTF.resignFirstResponder()
        switch UIScreen.main.bounds.height {
        case 480:
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
            })
        case 568:
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.scrollView.contentOffset = CGPoint(x: 0, y: 50)
            })
        default: break
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        //self.scrollView.setContentOffset(CGPoint(x:0, y:100), animated: true)
        self.roomTF.becomeFirstResponder()
    }
    
    func cancelButtonForPicker() {
        self.buildingTF.resignFirstResponder()
    }
    
    
    
}

