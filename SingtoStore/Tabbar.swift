//
//  Tabbar.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
class Tabbar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //store tab
        let story = StoryTab()
        story.tabBarItem.title = "Story"
        story.tabBarItem.image = UIImage(named: "story")
        let navStore = UINavigationController()
        navStore.viewControllers = [story]
        
        
        //let prd = ProductTab(collectionViewLayout: UICollectionViewFlowLayout())
        let prd = ProductTab()
        prd.tabBarItem.title = "Product"
        prd.tabBarItem.image = UIImage(named: "product")
        let navPrd = UINavigationController()
        navPrd.viewControllers = [prd]
        
        //cart tab
        let cart = CartTab()
        cart.tabBarItem.title = "Cart"
        cart.tabBarItem.image = UIImage(named: "cart")
        //me tab
        let me = MeTab()
        me.tabBarItem.title = "Me"
        me.tabBarItem.image = UIImage(named: "me")
        //test if I can put this view controller inside Navigation controller,
        let nav = UINavigationController()
        nav.viewControllers = [me]
        viewControllers = [navStore, navPrd, cart, nav]
    }

}
