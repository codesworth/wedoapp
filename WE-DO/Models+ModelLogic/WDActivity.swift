//
//  WDEvent.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation

class WDActivity{
    
    public private (set) var title:String
    public private (set) var time:Date
    public private (set) var location:WDEventLocation
    public private (set) var tags:Aliases.sset
    
    
    init(title:String,date:Date,location:WDEventLocation,set:Aliases.sset) {
        self.title = title
        tags = set
        time = date
        self.location = location
    }
}


struct WDEventLocation {
    
    var placeID:String
    var placeName:String
    var lat:Double
    var long:Double
    var locationUrl:URL?
    var locationPhone:String?
    var attributes:NSAttributedString?
    
    init(id:String, name:String, lat:Double, lon:Double, url:URL?,phone:String?, attributes:NSAttributedString?) {
        placeID = id
        placeName = name
        self.lat = lat
        long = lon
        locationUrl = url
        locationPhone = phone
        self.attributes = attributes
    }
}
