//
//  CategoryProductsListView.swift
//  SingtoStore
//
//  Created by li qiang on 12/6/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

let cellID = "cellID"

class CategoryProductView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var shortPrd = [ShortProduct]()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var cellSize = CGSize.zero
    var fontSize = CGFloat()
    let loadingIndicator = MyIndicator()
    var category = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(PrdCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = Tools.dancingShoesColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        setupIndicator()
        setCellSize()
        loadShortPrd()
        
    }
    
    
    func setCellSize() {
        let width = (screenWidth - 2) / 2 - 1
        let height = width * 1.42
        self.cellSize = CGSize(width: width, height: height)
        //self.fontSize = screenWidth / 25
    }
    
    func setupIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.widthAnchor.constraint(equalToConstant: 42).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func loadShortPrd() {
        self.loadingIndicator.startAnimating()
        FIRDatabase.database().reference().child("Each_Category").child(category).observe(.childAdded, with: { (snap) in
            if let dict = snap.value as? [String: String] {
                let prd = ShortProduct()
                prd.pKey = snap.key
                prd.pName = dict["productName"]!
                prd.pSub = dict["productSubDetail"]!
                if (Double(dict["productPrice"]!) != nil) {
                    prd.pPrice = Double(dict["productPrice"]!)
                } else {
                    prd.pPrice = 9999.0
                }
                prd.pMainImage = dict["productMainImage"]!
                self.shortPrd.insert(prd, at: 0)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    self.loadingIndicator.stopAnimating()
                })
            } else {
                //no data
                self.loadingIndicator.stopAnimating()
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortPrd.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PrdCell
        let p = shortPrd[(indexPath as NSIndexPath).row]
        cell.sprd = p
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailProductViewController()
        vc.prdKey = shortPrd[(indexPath as NSIndexPath).row].pKey!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

}
