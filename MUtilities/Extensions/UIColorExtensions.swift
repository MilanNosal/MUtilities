//
//  UIColorExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import Foundation

extension UIColor {
    
    func darkened(by constant: Int = 20) -> UIColor {
        
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        
        self.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        
        redComponent *= 255
        greenComponent *= 255
        blueComponent *= 255
        
        redComponent -= CGFloat(constant)
        greenComponent -= CGFloat(constant)
        blueComponent -= CGFloat(constant)
        
        if redComponent < 0 {
            redComponent = 0
        }
        if greenComponent < 0 {
            greenComponent = 0
        }
        if blueComponent < 0 {
            blueComponent = 0
        }
        
        return UIColor(red: redComponent / 255, green: greenComponent / 255, blue: blueComponent / 255, alpha: alphaComponent)
    }
}
