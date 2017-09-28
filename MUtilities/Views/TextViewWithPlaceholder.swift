//
//  TextViewWithPlaceholder.swift
//  MUtilities
//
//  Created by Milan Nosáľ on 28/09/2017.
//  Copyright © 2017 Svagant. All rights reserved.
//


import UIKit

protocol TextViewWithPlaceholderDelegate: class {
    
    func textViewDidBeginEditing(_ textViewWithPlaceholder: TextViewWithPlaceholder)
    
    func textViewDidEndEditing(_ textViewWithPlaceholder: TextViewWithPlaceholder)
    
    func textView(_ textViewWithPlaceholder: TextViewWithPlaceholder, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

class TextViewWithPlaceholder: UITextView, UITextViewDelegate {
    
    weak var textViewWithPlaceholderDelegate: TextViewWithPlaceholderDelegate?
    
    private var isPlaceholderActive: Bool = true
    
    var placeholder: String = ""
    
    private var originalTextColor: UIColor?
    
    var placeholderColor: UIColor?
    
    override var textColor: UIColor? {
        get {
            return originalTextColor
        }
        set {
            if !isPlaceholderActive {
                super.textColor = newValue
            }
            originalTextColor = newValue
        }
    }
    
    override var text: String! {
        didSet {
            if text != nil && text != "" {
                super.textColor = originalTextColor
                isPlaceholderActive = false
            } else {
                super.text = placeholder
                super.textColor = placeholderColor
                isPlaceholderActive = true
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unimplemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive {
            super.text = ""
            super.textColor = originalTextColor
            isPlaceholderActive = false
        }
        textViewWithPlaceholderDelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text == "" {
            super.text = placeholder
            super.textColor = placeholderColor
            isPlaceholderActive = true
        }
        textViewWithPlaceholderDelegate?.textViewDidEndEditing(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textViewWithPlaceholderDelegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
}
