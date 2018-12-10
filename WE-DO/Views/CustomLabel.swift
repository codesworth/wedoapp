//
//  CustomLabel.swift
//  Power Fantasy
//
//  Created by Mensah Shadrach on 12/11/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit



class CustomLabel: UILabel {

     var topInset: CGFloat = 5.0
     var bottomInset: CGFloat = 5.0
     var leftInset: CGFloat = 7.0
     var rightInset: CGFloat = 7.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 3
        
    }
    
    func setCornerRadius(radius:CGFloat){
        layer.cornerRadius = radius
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

}
