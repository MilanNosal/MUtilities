//
//  ReachabilityNotifier.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//


import UIKit

class ReachabilityNotifier: UIViewController {
    
    fileprivate let networkStatusBar = UIView()
    fileprivate let networkStatusLabel = UILabel()
    
    fileprivate var barCollapsedConstraint: NSLayoutConstraint?
    fileprivate var barExpandedConstraint: NSLayoutConstraint?
    
    fileprivate var dismissWorkItem: DispatchWorkItem?
    
    fileprivate var networkStatus: Reachability.NetworkStatus = .unreachable {
        didSet {
            DispatchQueue.main.async {
                if self.networkStatus == .unreachable {
                    self.showDisconnected()
                } else {
                    self.showConnected()
                }
            }
        }
    }
    
    static var connectedColor: UIColor = UIColor.green
    static var disconnectedColor: UIColor = UIColor.red
    
    fileprivate static var registered = false
    
    fileprivate func showDisconnected() {
        dismissWorkItem?.cancel()
        self.networkStatusLabel.text = "Offline"
        self.networkStatusBar.backgroundColor = ReachabilityNotifier.disconnectedColor
        self.barCollapsedConstraint?.isActive = false
        self.barExpandedConstraint?.isActive = true
        self.networkStatusBar.setNeedsLayout()
        UIView.animate(withDuration: 0.2) {
            self.networkStatusBar.layoutIfNeeded()
        }
    }
    
    fileprivate func showConnected() {
        if barCollapsedConstraint?.isActive == true {
            self.networkStatusLabel.text = ""
        } else {
            self.networkStatusLabel.text = "You're back online!"
        }
        self.networkStatusBar.backgroundColor = ReachabilityNotifier.connectedColor
        dismissWorkItem = DispatchWorkItem {
            self.barExpandedConstraint?.isActive = false
            self.barCollapsedConstraint?.isActive = true
            self.networkStatusLabel.text = ""
            self.networkStatusBar.setNeedsLayout()
            UIView.animate(withDuration: 0.2) {
                self.networkStatusBar.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: dismissWorkItem!)
    }
    
    @objc fileprivate func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        self.networkStatus = reachability.currentReachabilityStatus
    }
    
    override func loadView() {
        self.view = PassView()
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialHierarchy()
        setupInitialAttributes()
        setupInitialLayout()
    }
    
    fileprivate func setupInitialHierarchy() {
        self.view.addSubview(networkStatusBar)
        networkStatusBar.addSubview(networkStatusLabel)
    }
    
    fileprivate func setupInitialAttributes() {
        networkStatusBar.backgroundColor = ReachabilityNotifier.connectedColor
        
//        networkStatusLabel.font = UIFont.mllReachabilityNotifierLabel()
        networkStatusLabel.textColor = UIColor.white
        networkStatusLabel.textAlignment = .center
    }
    
    fileprivate func setupInitialLayout() {
        networkStatusBar.translatesAutoresizingMaskIntoConstraints = false
        networkStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        barExpandedConstraint = networkStatusBar.heightAnchor.constraint(equalToConstant: statusBarHeight)
        barCollapsedConstraint = networkStatusBar.heightAnchor.constraint(equalToConstant: 0)
        
        [
            networkStatusBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            networkStatusBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            networkStatusBar.topAnchor.constraint(equalTo: view.topAnchor),
            barCollapsedConstraint!,
            
            networkStatusLabel.leftAnchor.constraint(equalTo: networkStatusBar.leftAnchor, constant: 16),
            networkStatusLabel.rightAnchor.constraint(equalTo: networkStatusBar.rightAnchor, constant: -16),
            networkStatusLabel.centerYAnchor.constraint(equalTo: networkStatusBar.centerYAnchor),
            ].activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}


// MARK: Presentation
extension ReachabilityNotifier {
    
    fileprivate struct Static {
        static let window: UIHigherWindow = {
            let window = UIHigherWindow(frame: UIScreen.main.bounds)
            window.rootViewController = ReachabilityNotifier()
            window.windowLevel = UIWindowLevelAlert - 1
            return window
        }()
    }
    
    static func dismiss(animated: Bool = true, completion: @escaping () -> Void) {
        let notifier = Static.window.rootViewController as! ReachabilityNotifier
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                () -> Void in
                
                notifier.view.alpha = 0
            }, completion: {
                (_) -> Void in
                
                Static.window.isHidden = true
                completion()
            })
        } else {
            Static.window.isHidden = true
            completion()
        }
    }
    
    static func present(animated: Bool = true) {
        precondition(Thread.isMainThread)
        guard Static.window.isHidden else {
            return
        }
        
        let notifier = Static.window.rootViewController as! ReachabilityNotifier
        if animated {
            notifier.view.alpha = 0
            Static.window.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                () in
                notifier.view.alpha = 1
            })
        } else {
            Static.window.isHidden = false
            notifier.view.alpha = 1
        }
    }
    
    static func register() {
        let notifier = Static.window.rootViewController as! ReachabilityNotifier
        
        let reachability = Reachability()
        NotificationCenter.default.addObserver(notifier, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        try? reachability?.startNotifier()
        
        present(animated: false)
    }
}

// MARK: Passing touch events to the back view
class PassView: UIView {}

class UIHigherWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView!.isKind(of: PassView.self) {
            return nil
        }
        return hitView
    }
}
