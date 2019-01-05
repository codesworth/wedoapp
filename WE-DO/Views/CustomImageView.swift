//
//  CustomImageView.swift
//  CWCamChat
//
//  Created by Mensah Shadrach on 9/3/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }

}



