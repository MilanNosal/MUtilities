//
//  ArrayExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

extension Array {
    
    func randomItem() -> Element {
        let randomIndex = arc4random_uniform(UInt32(self.count))
        return self[Int(randomIndex)]
    }
}
