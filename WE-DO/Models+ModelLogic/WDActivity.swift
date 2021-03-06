//
//  WDEvent.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class WDActivity{
    
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
    
    func databaseExport()->Aliases.dictionary{
        return [
            Fields.title.rawValue:title,
            Fields.time.rawValue:time,
            Fields.tags.rawValue:Array(tags),
            Fields.location.rawValue:location.dataExport()
        ]
    }
    
    init(_ snapshot:DocumentSnapshot){
        title = snapshot.getString(.title)
        tags = Set(snapshot.getArray(.tags) as! Aliases.stray)
        time = snapshot.getDate(.time)
        location = WDEventLocation(snapshot.getDictionary(.location))
    }
}


public struct WDEventLocation {
    
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
    func dataExport() -> Aliases.dictionary {
        return [
            Fields.placeID.rawValue:placeID,
            Fields.placeName.rawValue:placeName,
            Fields.longitude.rawValue:long,
            Fields.latitude.rawValue:lat,
            Fields.locationUrl.rawValue:locationUrl?.absoluteString ?? "",
            Fields.locationPhone.rawValue:locationPhone ?? "",
            Fields.attributes.rawValue:attributes?.string ?? ""
        ]
    }
    
    init(_ data:Aliases.dictionary) {
        placeID = data.getString(.placeID)
        placeName = data.getString(.placeName)
        lat = data.getDouble(id: .latitude)
        long = data.getDouble(id: .longitude)
        locationUrl = URL(string:data.getString(.locationUrl))
        locationPhone = data.getString(.phone)
        attributes = NSAttributedString(string: data.getString(.attributes))
        
    }
}
