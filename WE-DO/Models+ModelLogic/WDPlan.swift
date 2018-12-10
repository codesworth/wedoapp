//
//  WDPlan.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation

final class WDPlan{
    
    public private (set) var planName:String
    public private (set) var startDate:Date
    public private (set) var events:[WDActivity]
    
    
    init(name:String, start:Date, events:[WDActivity]) {
        planName = name
        startDate = start
        self.events = events
    }
}
