//
//  WDTags.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

enum WDTags:String {
    case Food = "Food"
    case Drinks = "Drinks"
    case Movies = "Movies"
    case Sports = "Sports"
    
}

final class WDActivityTags{
    
    public private (set) var name:String
    public private (set) var colorString:String
    //public private (set) var enumCase:WDTags
    
    init(name:String, colorLiteral:String) {
        self.name = name
        colorString = colorLiteral
        
    }
    
    func getColor()->UIColor{
        return UIColor(colorString)
    }
}


func getWDTags()->[WDActivityTags]{
    var tags = [WDActivityTags]()
    tags.append(WDActivityTags(name: WDTags.Drinks.rawValue, colorLiteral: "#E08C14"))
    tags.append(WDActivityTags(name: WDTags.Food.rawValue, colorLiteral: "#00B0FF"))
    tags.append(WDActivityTags(name: WDTags.Movies.rawValue, colorLiteral: "#F847B5"))
    tags.append(WDActivityTags(name: WDTags.Sports.rawValue, colorLiteral: "#2E7D32"))
    return tags
}
