//
//  ShadowViews.swift
//  CWCamChat
//
//  Created by Mensah Shadrach on 10/23/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import UIKit

class ShadowViews:UIImageView{
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}
