//
//  NSLayoutConstraintExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    func with(rawPriority: Int) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: Float(rawPriority))
        return self
    }
    
}

