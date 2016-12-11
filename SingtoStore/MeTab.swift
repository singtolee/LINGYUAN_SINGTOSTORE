//
//  MeTab.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import SDWebImage

class MeTab: DancingShoesViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "cellID"
    let funcs = ["ORDERS", "ADDRESS","FAVORITE", "PROFILE", "CONTACT US", "SHARE ME"]
    let icons = [UIImage(named: "order"), UIImage(named: "address"), UIImage(named: "favorite"), UIImage(named: "profile"), UIImage(named: "contactus"), UIImage(named: "share")]
    
    let bgView: UIView = {
        let bg = UIView()
        bg.backgroundColor = Tools.dancingShoesColor
        return bg
    }()
    
    let userAvatar: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "whiteAva")
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        return imgView
    }()
    
    let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOGIN OR REGISTER", for: .normal)
        btn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return btn
    }()
    
    let userName: UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.textColor = UIColor.white
        lab.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return lab
    }()
    
    let signOutBtn = UIButton()
    
    let funcTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //these two lines hide the 1 pixle line at the bottom of navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        addBGView()
        addUserAvatar()
        addExitBtn()
        addUserName()
        addLoginBtn()
        isLogOutBtnsStatus()
        setUpTableView()
        checkIfUerLogin()
    }
    func setUpTableView() {
        view.addSubview(funcTableView)
        funcTableView.delegate = self
        funcTableView.dataSource = self
        funcTableView.translatesAutoresizingMaskIntoConstraints = false
        funcTableView.topAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        funcTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        funcTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        funcTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        funcTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: funcTableView.frame.size.width, height: 1))
    }
    
    func addLoginBtn() {
        bgView.addSubview(loginBtn)
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 0).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        loginBtn.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    }
    
    func addUserName() {
        bgView.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 6).isActive = true
        userName.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        userName.isUserInteractionEnabled = true
        userName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfilePage)))
        
    }
    
    func addExitBtn() {
        bgView.addSubview(signOutBtn)
        signOutBtn.setImage(UIImage(named: "exit"), for: .normal)
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 2).isActive = true
        signOutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        signOutBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        signOutBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        signOutBtn.addTarget(self, action: #selector(signOutActionList), for: .touchUpInside)
    }
    
    func addBGView() {
        view.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        bgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func addUserAvatar() {
        bgView.addSubview(userAvatar)
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0).isActive = true
        userAvatar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userAvatar.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userAvatar.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        userAvatar.isUserInteractionEnabled = true
        userAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfilePage)))
    }
    
    func goToLogin() {
        let loginVC = LoginVC()
        self.present(loginVC, animated: true)
    }
    
    func signOutFromApp() {
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrent(nil)
        isLogOutBtnsStatus()
    }
    
    func isLogOutBtnsStatus() {
        userName.isHidden = true
        userName.text = ""
        signOutBtn.isHidden = true
        loginBtn.isHidden = false
    }
    func isLogInBtnStatus() {
        userName.isHidden = false
        signOutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    
    func checkIfUerLogin() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.isLogInBtnStatus()
                FIRDatabase.database().reference().child("users").child(user.uid).observe(.value, with: { (snap) in
                    if let dict = snap.value as? [String: AnyObject] {
                        if let uname = dict["name"] {
                            self.userName.text = (uname as! String)
                            self.userName.font = UIFont(name: "ArialRoundedMTBold", size: 14)
                        } else {
                            self.userName.text = "EDIT PROFILE"
                            self.userName.font = UIFont(name: "ArialRoundedMTBold", size: 14)
                        }
                        if let uUrl = dict["userAvatarUrl"] {
                            let url = uUrl as! String
                            let urlsd = URL(string: url)
                            self.userAvatar.sd_setImage(with: urlsd, placeholderImage: UIImage(named: "whiteAva"))
                            self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width/2
                        } else {
                            self.userAvatar.image = UIImage(named: "whiteAva")
                        }
                    } else {
                        self.userAvatar.image = UIImage(named: "whiteAva")
                        self.userName.text = "EDIT PROFILE"
                        self.userName.font = UIFont(name: "ArialRoundedMTBold", size: 14)
                    }
                    
                    }, withCancel: nil)
            } else {
                // No user is signed in.
                self.userAvatar.image = UIImage(named: "whiteAva")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funcs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.textLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        cell.textLabel?.text = funcs[(indexPath as NSIndexPath).row]
        cell.imageView?.image = icons[(indexPath as NSIndexPath).row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check if user signed in
        if FIRAuth.auth()?.currentUser != nil {
            if (indexPath as NSIndexPath).row == 0 {
                //let orderView = OrderView()
                //navigationController?.pushViewController(orderView, animated: true)
            }
            else if (indexPath as NSIndexPath).row == 1 {
                let addressView = MyAddress()
                navigationController?.pushViewController(addressView, animated: true)
            }
            else if (indexPath as NSIndexPath).row == 2 {
                let vc = FavoriteVC()
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else if (indexPath as NSIndexPath).row == 3 {
                let editProfile = EditProfileTableViewController()
                navigationController?.pushViewController(editProfile, animated: true)
            }
            else if (indexPath as NSIndexPath).row == 5 {
                //let vc = AboutUs()
                //navigationController?.pushViewController(vc, animated: true)
                
            }
            else {
                let vc = MyAddress()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            didplayNeedSignInAlert()
        }
    }
    
    func didplayNeedSignInAlert() {
        let needSignIn = UIAlertController(title: "Sorry", message: "Please sign in First", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(_: UIAlertAction) -> Void in}
        needSignIn.addAction(okAction)
        self.present(needSignIn, animated: true, completion: nil)
        
    }
    
    func signOutActionList() {
        if FIRAuth.auth()?.currentUser != nil {
            let changeAvatarAlertView: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            changeAvatarAlertView.addAction(cancelActionButton)
            
            let fromLib: UIAlertAction = UIAlertAction(title: "SIGN OUT", style: .default)
            { action -> Void in
                self.signOutFromApp()
            }
            changeAvatarAlertView.addAction(fromLib)
            
            self.present(changeAvatarAlertView, animated: true, completion: nil)
        }
    }
    
    func goToProfilePage() {
        if FIRAuth.auth()?.currentUser != nil {
            let editProfile = EditProfileTableViewController()
            navigationController?.pushViewController(editProfile, animated: true)
        }
    }
}
