//
//  EditProfilePhoto.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class EditProfilePhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let avatarImageView = UIImageView()
    let placeHolder = UIImage(named: "placeholder48")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "fromAlbum"), style: .plain, target: self, action: #selector(openAlbum))
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Tools.dancingShoesColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "PROFILE PHOTO"
        self.setUpAvatarView()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("USERINFO").observeSingleEvent(of: .value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject] {
                if let uUrl = dict["userAvatarUrl"] {
                    //use extension
                    let url = uUrl as! String
                    let urlSD = URL(string: url)
                    self.avatarImageView.sd_setImage(with: urlSD, placeholderImage: self.placeHolder)
                } else {
                    self.avatarImageView.image = self.placeHolder
                    self.avatarImageView.contentMode = .scaleAspectFit
                }
            } else {
                self.avatarImageView.image = self.placeHolder
                self.avatarImageView.contentMode = .scaleAspectFit
            }
            }, withCancel: nil)
    }
    
    func setUpAvatarView() {
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        avatarImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.avatarImageView.image = self.placeHolder
        self.avatarImageView.contentMode = .scaleAspectFit
        
    }
    
    func openAlbum() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.avatarImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        self.onRegisterBtnClicked()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func onRegisterBtnClicked() {
        //register account and upload user avatar
        //show registering spin and stop when registration success
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "Uploading...")
        let uid = FIRAuth.auth()?.currentUser?.uid
        //let imageName = NSUUID().UUIDString
        let storeageRef = FIRStorage.storage().reference().child("USERPROFILEPHOTO").child("\(uid!).png")
        if let uploadData = UIImageJPEGRepresentation(self.avatarImageView.image!, 0.2){
            storeageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let failedUploadingAvatarAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok1Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in }
                    failedUploadingAvatarAlert.addAction(ok1Action)
                    self.present(failedUploadingAvatarAlert, animated: true, completion: nil)
                    return
                }
                if let avatarUrl = metadata?.downloadURL()?.absoluteString{
                    let values = ["userAvatarUrl": avatarUrl]
                    //Tools.registerUserIntoDatabaseWithUID(uid!, values: values)
                    let ref = FIRDatabase.database().reference().child("users").child(uid!).child("USERINFO")
                    ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
                        if err != nil {
                            let failedWriteDatabaseAlert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            let ok2Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in }
                            failedWriteDatabaseAlert.addAction(ok2Action)
                            self.present(failedWriteDatabaseAlert, animated: true, completion: nil)
                            SVProgressHUD.dismiss()
                            return
                        }
                        SVProgressHUD.dismiss()
                    })
                    
                }
            })
        }
    }
}
