//
//  GradientView.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    init(axis: UILayoutConstraintAxis = .horizontal) {
        self.axis = axis
        super.init(frame: CGRect.zero)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let axis: UILayoutConstraintAxis
    
    public var startColor: UIColor = UIColor.white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    
    public var endColor: UIColor = UIColor.black {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        if axis == .vertical {
            // nothing
        } else {
            gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        }
        return gradientLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
