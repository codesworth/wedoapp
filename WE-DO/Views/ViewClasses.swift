//
//  ViewClasses.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 06/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class RoundedButton:UIButton{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCorner()
        setElevation()
        
    }
    
    func setCorner(_ radius:CGFloat = 8){
        layer.cornerRadius = radius
    }
    
    override func setElevation(_ height:CGFloat = 2){
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = 2;
        
    }
}


class AttributedButton:UIButton{
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setElevation(_ height:CGFloat = 2){
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = 2;
    }
}

class WDTagButton: UIButton {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 1.2
        layer.borderColor = UIColor.primaryLight.cgColor
    }
    
    func changeBorderColor(_ color:UIColor){
        layer.borderColor = color.cgColor
        setTitleColor(color, for: .normal)
    }
}

class BaseTextField:UITextField{
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    

    
}


class SearchBar:UITextField{
   
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        layout()
    }
    
    func layout(){
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.55)
        layer.cornerRadius = 20
        textColor = UIColor.primary
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [.foregroundColor: UIColor.primaryLight])
        placeholder = attributedPlaceholder?.string
    }
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension UIView{
    
    @objc func setElevation(_ height:CGFloat = 3){
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = 2;
    }
}


