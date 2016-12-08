//
//  ProductTab.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProductTab: DancingShoesViewController {
    var CategoryList = [String]()
    var viewControllers = [CategoryProductView]()
    var tabs = [String]()
    let vc = CategoryProductView()
    let indicator = MyIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategory()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 42).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func loadTabandVCs() {
        for cate in CategoryList {
            let vc = CategoryProductView(collectionViewLayout: UICollectionViewFlowLayout())
            vc.category = cate
            self.viewControllers.append(vc)
            self.tabs.append(cate)
        }
        
        let slidingVC = SlidingContainerViewController(
            parent: self,
            contentViewControllers: viewControllers,
            titles: tabs
        )
        view.addSubview(slidingVC.view)
        slidingVC.sliderView.appearance.outerPadding = 0
        slidingVC.sliderView.appearance.innerPadding = 10
        slidingVC.setCurrentViewControllerAtIndex(0)
    }
    
    func loadCategory() {
        self.indicator.startAnimating()
        FIRDatabase.database().reference().child("ProductCategory").observe(.value, with: { (snap) in
            for child in snap.children {
                guard let csnap = child as? FIRDataSnapshot else {return}
                let category = csnap.value as! String
                self.CategoryList.append(category)
            }
            DispatchQueue.main.async(execute: {
                self.loadTabandVCs()
                self.indicator.stopAnimating()
            })
            
        })
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingVC: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingVC: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingVC: SlidingContainerViewController, viewController: UIViewController) {
        
    }
    
    func slidingContainerViewControllerDidMoveToViewControllerAtIndex(_ slidingVC: SlidingContainerViewController, index: Int) {
        
    }
    
    
}
