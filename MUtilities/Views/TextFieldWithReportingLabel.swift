//
//  TextFieldWithReportingLabel.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//

import UIKit

protocol InputValidator {
    
    func validationErrorMessage(for input: String) -> String?
    
}

class TextFieldWithReportingLabel: UITextField {
    
    enum State: Equatable {
        case normal
        case correctInput
        case incorrectInput(error: String?)
        
        static func == (lhs: State, rhs: State) -> Bool {
            
            switch (lhs, rhs) {
            case (.normal, .normal):
                return true
                
            case (.correctInput, .correctInput):
                return true
                
            case (.incorrectInput(let messageLhs), incorrectInput(let messageRhs)):
                return messageLhs == messageRhs
                
            default:
                return false
            }
        }
    }
    
    var inputState: State = .normal {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var normalStateColor: UIColor? = UIColor.white
    
    @IBInspectable var correctInputColor: UIColor? = UIColor(red: 200 / 255, green: 255 / 255, blue: 200 / 255, alpha: 1.0)
    
    @IBInspectable var incorrectInputColor: UIColor? = UIColor(red: 255 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1.0) {
        didSet {
            errorBubble.bubbleBackgroundColor = incorrectInputColor?.darkened()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
        
    }
    
    fileprivate let errorBubble: TextBubbleView = TextBubbleView()
    
    var inputValidator: InputValidator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        
    }
}

// MARK: UITextFieldDelegate
extension TextFieldWithReportingLabel: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        _ = isValid()
        
    }
    
    func isValid() -> Bool {
        
        guard let inputValidator = inputValidator else {
            return true
        }
        
        let errorMessage = inputValidator.validationErrorMessage(for: self.text!)
        
        if let errorMessage = errorMessage {
            
            self.inputState = .incorrectInput(error: errorMessage)
            return false
            
        } else {
            
            self.inputState = .correctInput
            return true
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.inputState = .normal
    }
}

// MARK: State handling
extension TextFieldWithReportingLabel {
    
    fileprivate func updateView() {
        
        errorBubble.removeFromSuperview()
        
        switch inputState {
            
        case .normal:
            self.backgroundColor = normalStateColor
            
        case .correctInput:
            self.backgroundColor = correctInputColor
            
        case .incorrectInput(error: let errorMessage):
            self.backgroundColor = incorrectInputColor
            
            guard let errorMessage = errorMessage,
                let superView = self.window?.rootViewController?.view else {
                    break
            }
            
            errorBubble.bubbleMessage = errorMessage
            errorBubble.alpha = 0
            
            superView.addSubview(errorBubble)
            
            errorBubble.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                errorBubble.widthAnchor.constraint(lessThanOrEqualToConstant: 0.7 * self.bounds.width),
                errorBubble.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                errorBubble.topAnchor.constraint(equalTo: self.bottomAnchor)
                ])
            
            UIView.animate(withDuration: 0.3, animations: {
                self.errorBubble.alpha = 1
            })
            
        }
        
    }
    
}

// MARK: Bubble message view
class TextBubbleView: UIView {
    
    var bubbleBackgroundColor: UIColor? {
        get {
            return bubbleView.backgroundColor
        }
        
        set {
            bubbleView.backgroundColor = newValue
            bubbleDecorationView.backgroundColor = newValue
        }
    }
    
    var bubbleMessage: String? {
        get {
            return bubbleLabel.text
        }
        
        set {
            bubbleLabel.text = newValue
        }
    }
    
    fileprivate let bubbleView: UIView = UIView()
    fileprivate let bubbleDecorationView: UIView = UIView()
    fileprivate let bubbleLabel: UILabel = UILabel()
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        setInitialViewHierarchy()
        setInitialLayout()
        setInitialAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setInitialViewHierarchy() {
        
        addSubview(bubbleDecorationView)
        
        addSubview(bubbleView)
        
        bubbleView.addSubview(bubbleLabel)
        
    }
    
    private func setInitialAttributes() {
        
        bubbleView.backgroundColor = UIColor(red: 255 / 255, green: 170 / 255, blue: 170 / 255, alpha: 1.0)
        bubbleView.layer.cornerRadius = 4
        bubbleView.clipsToBounds = true
        
        bubbleDecorationView.backgroundColor = UIColor(red: 255 / 255, green: 170 / 255, blue: 170 / 255, alpha: 1.0)
        bubbleDecorationView.layer.cornerRadius = 2
        bubbleDecorationView.clipsToBounds = true
        
        bubbleLabel.textColor = UIColor.red
        bubbleLabel.numberOfLines = 0
        bubbleLabel.font = bubbleLabel.font.withSize(13)
        
    }
    
    private func setInitialLayout() {
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleDecorationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubbleDecorationView.widthAnchor.constraint(equalToConstant: 12),
            bubbleDecorationView.widthAnchor.constraint(equalTo: bubbleDecorationView.heightAnchor),
            bubbleDecorationView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleDecorationView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        bubbleDecorationView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            bubbleLabel.topAnchor.constraint(equalTo: bubbleView.layoutMarginsGuide.topAnchor),
            bubbleLabel.leadingAnchor.constraint(equalTo: bubbleView.layoutMarginsGuide.leadingAnchor),
            bubbleLabel.trailingAnchor.constraint(equalTo: bubbleView.layoutMarginsGuide.trailingAnchor),
            bubbleLabel.bottomAnchor.constraint(equalTo: bubbleView.layoutMarginsGuide.bottomAnchor)
            ])
        
    }
    
}
