//
//  ScrollTab.swift
//  SingtoStore
//
//  Created by li qiang on 12/6/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit

struct SlidingContainerSliderViewAppearance {
    var backgroundColor: UIColor
    
    var font: UIFont
    var selectedFont: UIFont
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    
    var outerPadding: CGFloat
    var innerPadding: CGFloat
    
    var selectorColor: UIColor
    var selectorHeight: CGFloat
}

protocol SlidingContainerSliderViewDelegate {
    func slidingContainerSliderViewDidPressed (_ slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int)
}

class SlidingContainerSliderView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Properties
    
    var appearance: SlidingContainerSliderViewAppearance! {
        didSet {
            draw()
        }
    }
    
    var shouldSlide: Bool = true
    
    let sliderHeight: CGFloat = 34 // HEIGHT
    var titles: [String]!
    
    var labels: [UILabel] = []
    var selector: UIView!
    
    var sliderDelegate: SlidingContainerSliderViewDelegate?
    
    
    // MARK: Init
    
    init (width: CGFloat, titles: [String]) {
        super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
        self.titles = titles
        
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        
        appearance = SlidingContainerSliderViewAppearance (
            backgroundColor: Tools.headerColor,
            font: UIFont(name: "AppleSDGothicNeo-Light", size: 12)!,
            selectedFont: UIFont(name: "AppleSDGothicNeo-Light", size: 12)!,
            
            textColor: UIColor.darkGray,
            selectedTextColor: UIColor.white,
            
            outerPadding: 1,
            innerPadding: 1,
            
            selectorColor: Tools.dancingShoesColor,
            selectorHeight: 2)   //LINE HEIGHT
        
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Draw
    
    func draw () {
        
        // clean
        if labels.count > 0 {
            for label in labels {
                
                label.removeFromSuperview()
                
                if selector != nil {
                    selector.removeFromSuperview()
                    selector = nil
                }
            }
        }
        
        labels = []
        backgroundColor = appearance.backgroundColor
        
        var labelTag = 0
        var currentX = appearance.outerPadding
        
        for title in titles {
            let label = labelWithTitle(title)
            label.frame.origin.x = currentX
            label.center.y = frame.size.height/2
            label.tag = labelTag
            labelTag += 1
            
            addSubview(label)
            labels.append(label)
            currentX += label.frame.size.width + appearance.outerPadding
        }
        
        let selectorH = appearance.selectorHeight
        selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: 100, height: selectorH))
        selector.backgroundColor = appearance.selectorColor
        addSubview(selector)
        
        contentSize = CGSize (width: currentX, height: frame.size.height)
    }
    
    func labelWithTitle (_ title: String) -> UILabel {
        
        let label = UILabel (frame: CGRect (x: 0, y: 0, width: 0, height: 0))
        label.text = title
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.textAlignment = .center
        
        label.sizeToFit()
        label.frame.size.width += appearance.innerPadding * 2
        
        label.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(didTap)))
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    
    // MARK: Actions
    
    func didTap (_ tap: UITapGestureRecognizer) {
        self.sliderDelegate?.slidingContainerSliderViewDidPressed(self, atIndex: tap.view!.tag)
    }
    
    
    // MARK: Menu
    
    func selectItemAtIndex (_ index: Int) {
        
        // Set Labels
        
        for i in 0..<self.labels.count {
            let label = labels[i]
            
            if i == index {
                
                label.textColor = appearance.selectorColor
                label.font = appearance.selectedFont
                
                label.sizeToFit()
                label.frame.size.width += appearance.innerPadding * 2
                
                // Set selector
                
                UIView.animate(withDuration: 0.3, animations: {
                    [unowned self] in
                    self.selector.frame = CGRect (
                        x: label.frame.origin.x,
                        y: self.selector.frame.origin.y,
                        width: label.frame.size.width,
                        height: self.appearance.selectorHeight)
                    })
                
            } else {
                
                label.textColor = appearance.textColor
                label.font = appearance.font
                
                label.sizeToFit()
                label.frame.size.width += appearance.innerPadding * 2
            }
        }
    }
    
}