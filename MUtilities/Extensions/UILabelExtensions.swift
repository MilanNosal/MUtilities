//
//  UILabelExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import Foundation

extension UILabel {
    
    func setSpacedText(text: String, spacing: CGFloat?, lineSpacing: CGFloat?) {
        
        var attributes: [NSAttributedStringKey : Any] = [:]
        
        if let spacing = spacing {
            attributes[.kern] = spacing
        }
        
        if let lineSpacing = lineSpacing {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = style
        }
        
        self.attributedText = NSAttributedString(string: text,
                                                 attributes: attributes)
    }
    
    func setSpacedText(text: String, spacing: CGFloat?, lineSpacing: CGFloat?, withAttributes attributes: [NSAttributedStringKey : Any]) {
        var attributes: [NSAttributedStringKey : Any] = attributes
        
        if let spacing = spacing {
            attributes[.kern] = spacing
        }
        
        if let lineSpacing = lineSpacing {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = style
        }
        
        self.attributedText = NSAttributedString(string: text,
                                                 attributes: attributes)
    }
    
}
