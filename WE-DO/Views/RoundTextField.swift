//
//  RoundTextField.swift
//  CWCamChat
//
//  Created by Mensah Shadrach on 9/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit


@IBDesignable

class RoundTextField: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColour: UIColor? {
        didSet{
            layer.borderColor = borderColour?.cgColor
        }
    }
    
    @IBInspectable var bachgroundColor: UIColor?{
        didSet{
            backgroundColor = bachgroundColor
        }
    }
    
    @IBInspectable var placeholderColor:UIColor?{
        didSet{
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [.foregroundColor : placeholderColor!])
            attributedPlaceholder = str
        }
    }
}
