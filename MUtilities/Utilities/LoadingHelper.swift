//
//  LoadingHelper.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

class ClosureSleeve {
    let closure: () -> Void
    
    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add(for controlEvents: UIControlEvents, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

class LoadingHelper {
    
    fileprivate static var visibleActivityIndicators: [UIView : UIActivityIndicatorView] = [:]
    fileprivate static var visibleReloadButtons: [UIView : UIButton] = [:]
    
    static func startedLoading(for view: UIView) {
        
        if let activityIndicator = visibleActivityIndicators[view] {
            visibleActivityIndicators.removeValue(forKey: view)
            activityIndicator.removeFromSuperview()
        }
        if let reloadButton = visibleReloadButtons[view] {
            visibleReloadButtons.removeValue(forKey: view)
            reloadButton.removeFromSuperview()
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black.withAlphaComponent(0.6)
        activityIndicator.startAnimating()
        view.alpha = 0
        if let superview = view.superview {
            superview.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            [
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ].activate()
        } else {
            view.window?.addSubview(activityIndicator)
            activityIndicator.center = view.window?.center ?? CGPoint.zero
        }
        
        visibleActivityIndicators[view] = activityIndicator
        
        view.isUserInteractionEnabled = false
    }
    
    static func successfullyFinishedLoading(for view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            visibleActivityIndicators[view]?.alpha = 0
            view.alpha = 1
        }, completion: { (_) in
            visibleActivityIndicators[view]?.stopAnimating()
            visibleActivityIndicators[view]?.removeFromSuperview()
            visibleActivityIndicators.removeValue(forKey: view)
            view.isUserInteractionEnabled = true
        })
    }
    
    static func unsuccessfullLoad(for view: UIView, reloadCallback: @escaping () -> Void) {
        if let activityIndicator = visibleActivityIndicators[view] {
            activityIndicator.removeFromSuperview()
        }
        if let reloadButton = visibleReloadButtons[view] {
            reloadButton.removeFromSuperview()
        }
        
        let reloadButton = ReloadButton()
        
        view.superview!.addSubview(reloadButton)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        [
            reloadButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            reloadButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            reloadButton.topAnchor.constraint(equalTo: view.topAnchor),
            reloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ].activate()
        
        visibleReloadButtons[view] = reloadButton
        
        reloadButton.add(for: .touchUpInside, reloadCallback)
    }
}

class ReloadButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        self.setTitleColor(UIColor.blue, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.setTitle("↺", for: .normal)
        let size = CGFloat(24)
        self.titleLabel?.font = UIFont(name: "CircularAirPro-Bold", size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = min(min(self.bounds.height, self.bounds.width) / 2, 54)
        self.titleLabel?.font = UIFont(name: "CircularAirPro-Bold", size: size)
    }
}
