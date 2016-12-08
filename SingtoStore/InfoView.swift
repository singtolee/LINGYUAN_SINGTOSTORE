//
//  InfoView.swift
//  SingtoStore
//
//  Created by li qiang on 12/8/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import SDWebImage

class InfoView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let header = UILabel()
    
    let cellId = "cellId"
    var imageUrls = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "DESCRIPTION"
        header.textAlignment = .center
        header.textColor = UIColor.white
        header.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        header.backgroundColor = Tools.dancingShoesColor
        header.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: cellId)
        //collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CarouselCell
        let url = imageUrls[(indexPath as NSIndexPath).item]
        if let imageUrl = URL(string: url) {
            cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder48"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
