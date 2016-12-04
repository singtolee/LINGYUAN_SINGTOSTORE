//
//  MyIndicator.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
class MyIndicator: UIView {
    
    let diameter = UIScreen.main.bounds.width / 53
    let gap: CGFloat = 2
    var numberOfCircles: Int = 4
    var animationDelay: Double = 0.2
    var defaultColor: UIColor = Tools.dancingShoesColor
    var isAnimating = false
    
    func startAnimating() {
        if !isAnimating {
            self.addCircles()
            isAnimating = true
        }
    }
    
    func addCircles() {
        for i in 0 ..< numberOfCircles {
            self.createCircleWithIndex(i)
        }
    }
    func createCircleWithIndex(_ index: Int) {
        let oX: CGFloat = CGFloat(index) * (diameter + gap) + gap + diameter / 2
        let oY: CGFloat = gap + diameter / 2
        let circle = UIView(frame: CGRect(x: oX, y: oY, width: diameter, height: diameter))
        circle.backgroundColor = defaultColor
        circle.layer.cornerRadius = diameter / 2
        circle.translatesAutoresizingMaskIntoConstraints = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.9
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.beginTime = CACurrentMediaTime() + Double(index) * animationDelay + 0.2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: circle.center.x, y: circle.center.y - 6))
        animation.toValue = NSValue(cgPoint: CGPoint(x: circle.center.x, y: circle.center.y + 6))
        circle.layer.add(animation, forKey: "position")
        self.addSubview(circle)
    }
    
    func stopAnimating() {
        if isAnimating {
            isAnimating = false
            self.removeCircles()
        }
    }
    
    func removeCircles() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
