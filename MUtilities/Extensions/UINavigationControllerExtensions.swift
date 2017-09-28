//
//  UINavigationControllerExtensions.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func pushViewController(
        viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(
            alongsideTransition: { context in
                viewController.setNeedsStatusBarAppearanceUpdate()
        },
            completion: { context in
                completion()
        }
        )
    }
}

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
