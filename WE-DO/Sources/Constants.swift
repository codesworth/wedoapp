//
//  Constants.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 06/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation

let USER_UID = "uid"

func identifier(_ aClass:AnyClass)->String{
    return String.init(describing: aClass.self)
}