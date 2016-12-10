//
//  DetailProductViewController.swift
//  SingtoStore
//
//  Created by li qiang on 12/6/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailProductViewController: DancingShoesViewController, UIScrollViewDelegate {

    var prdKey: String?
    var product: DetailProduct?
    var handle: UInt!
    let ref = FIRDatabase.database().reference().child("AllProduct")
    
    let sw = UIScreen.main.bounds.width
    
    let scrollView = UIScrollView()
    let carouselView = CarouselView()
    let middleView = MiddleView()
    
    let csView = ColorSizeView()
    let infoView = InfoView()
    
    let bottomBar = UIView()
    
    let likeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "like"), for: .highlighted)
        btn.setImage(UIImage(named: "unlike"), for: .normal)
        return btn
    }()
    
    let addToCartBtn: UIButton = {
        let addBtn = UIButton()
        addBtn.setTitle("ADD TO CART", for: UIControlState())
        addBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        addBtn.backgroundColor = Tools.dancingShoesColor
        addBtn.layer.cornerRadius = 6
        return addBtn
    }()
    
    let buyBtn: UIButton = {
        let buy = UIButton()
        buy.setTitle("BUY NOW", for: UIControlState())
        buy.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        buy.backgroundColor = Tools.dancingShoesColor
        buy.layer.cornerRadius = 6
        return buy
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addTopView()
        addMiddleView()
        setUpBottomBar()
        addCSView()
        findPrdbyKey()
        likeorUnlikeBtn()
    }
    
    func addInfoView() {
        scrollView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: csView.bottomAnchor, constant: 6).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 30 + view.frame.width * CGFloat((product?.prdInfoImages?.count)!)).isActive = true
    }
    
    func addCSView() {
        scrollView.addSubview(csView)
        csView.translatesAutoresizingMaskIntoConstraints = false
        csView.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 6).isActive = true
        csView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        csView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }

    
    func addTopView() {
        carouselView.backgroundColor = UIColor.white
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(carouselView)
        carouselView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        carouselView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carouselView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carouselView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    func addMiddleView() {
        scrollView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.topAnchor.constraint(equalTo: self.carouselView.bottomAnchor).isActive = true
        middleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        middleView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        middleView.heightAnchor.constraint(equalToConstant: (view.frame.width / 3.5) + 6 + (view.frame.width * 0.2)).isActive = true
    }
    
    func findPrdbyKey() {
        if (prdKey != nil){
            handle = ref.child(prdKey!).observe(.value, with: { (snap) in
                if let dict = snap.value as? [String: AnyObject] {
                    //print(dict)
                    let prd = DetailProduct()
                    var jg = "0"
                    prd.prdID = dict["productID"] as? String
                    prd.prdName = dict["productName"] as? String
                    prd.prdSub = dict["productSubDetail"] as? String
                    prd.prdPackageInfo = dict["productPackageInfo"] as? String
                    prd.prdSuppler = dict["productSuppler"] as? String
                    jg = (dict["productPrice"] as? String)!
                    if(Double(jg) != nil) {
                        prd.prdPrice = Double(jg)
                    } else {
                        prd.prdPrice = 9999.0
                    }
                    prd.isRefundable = dict["productRefundable"] as? Bool
                    prd.prdImages = dict["productImages"] as? [String]
                    prd.prdCS = dict["prodcutCS"] as? [String]
                    prd.prdCSQty = dict["prodcutCSQty"] as? [String]
                    if let info = dict["productInfoImages"] as? [String] {
                        prd.prdInfoImages = info
                    }
                    self.product = prd
                    self.populateView(prd)
                }else {
                    return
                }
            })
        }
    }
    
    func populateView(_ prd: DetailProduct) {
        self.carouselView.prdImg = prd.prdImages!
        self.carouselView.collectionView.reloadData()
        self.carouselView.pageControl.numberOfPages = prd.prdImages!.count
        
        self.middleView.commitmentView.isHidden = false
        self.middleView.prdc = prd
        
        self.csView.heightAnchor.constraint(equalToConstant: 24 * CGFloat(round(Double(prd.prdCS!.count) / 2))).isActive = true
        self.csView.colorsizes = prd.prdCS!
        self.csView.qtys = prd.prdCSQty!
        self.csView.collectionView.reloadData()
        
        let ss = IndexPath(item: 0, section: 0)
        csView.collectionView.selectItem(at: ss, animated: false, scrollPosition: [])
        
        if (prd.prdInfoImages != nil) {
            addInfoView()
            infoView.imageUrls = prd.prdInfoImages!
            infoView.collectionView.reloadData()
            scrollView.contentSize = CGSize(width: view.bounds.width, height: 48 + view.frame.width * CGFloat((product?.prdInfoImages?.count)!) + 1.5 * view.bounds.width + 24 * CGFloat(round(Double(prd.prdCS!.count) / 2)))
        } else {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: 42  + 1.5 * view.bounds.width + 24 * CGFloat(round(Double(prd.prdCS!.count) / 2)))
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.child(prdKey!).removeObserver(withHandle: handle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func setUpBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bottomBar.addSubview(likeButton)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.topAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor).isActive = true
        likeButton.addTarget(self, action: #selector(handleLikeClick), for: .touchUpInside)
        
        //likeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        likeButton.leftAnchor.constraint(equalTo: bottomBar.leftAnchor, constant: 0).isActive = true
        
        bottomBar.addSubview(addToCartBtn)
        addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
        addToCartBtn.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 2).isActive = true
        addToCartBtn.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -2).isActive = true
        addToCartBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        addToCartBtn.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 0).isActive = true
        
        bottomBar.addSubview(buyBtn)
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 2).isActive = true
        buyBtn.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -2).isActive = true
        buyBtn.rightAnchor.constraint(equalTo: bottomBar.rightAnchor, constant: -2).isActive = true
        buyBtn.leftAnchor.constraint(equalTo: addToCartBtn.rightAnchor, constant: 2).isActive = true
    }

}
