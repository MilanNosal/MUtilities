//
//  UIViewExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

extension UIView {
    
    func constraintsFittingToSuperview(topOffset: CGFloat = 0,
                                       leftOffset: CGFloat = 0,
                                       bottomOffset: CGFloat = 0,
                                       rightOffset: CGFloat = 0
        ) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: leftOffset),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: topOffset),
            self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor, constant: -rightOffset),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: -bottomOffset)
        ]
    }
    
    func constraintsFittingToSuperviewMargins() -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: self.superview!.layoutMarginsGuide.leftAnchor),
            self.topAnchor.constraint(equalTo: self.superview!.layoutMarginsGuide.topAnchor),
            self.rightAnchor.constraint(equalTo: self.superview!.layoutMarginsGuide.rightAnchor),
            self.bottomAnchor.constraint(equalTo: self.superview!.layoutMarginsGuide.bottomAnchor)
        ]
    }
    
    func constraintsCenterInSuperview() -> [NSLayoutConstraint] {
        return [
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor)
        ]
    }
    
    func screenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
