//
//  InsetLabel.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import UIKit

/// Custom label that add label edge insets.

@IBDesignable
class InsetLabel: UILabel {
    
    /// Left inset diplayed on identity inspector on storyboards or xib files.
    
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    /// Right inset diplayed on identity inspector on storyboards or xib files.
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    /// Edge insets of the label.
    
    var textInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /**
     Get rect of the drawing text.
     
     - returns: A CGRect instance.
     */
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    /**
     Draw text.
     
     - returns: Nothing.
     */
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

