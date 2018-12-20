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
    case Other = "Other"
    
}

enum WDTagColors:String {
    case Food = "#00B0FF"
    case Drinks = "#E08C14"
    case Movies = "#F847B5"
    case Sports = "#2E7D32"
    case Other = "#9A9A9A"
}

final class WDActivityTags{
    
    public private (set) var name:String
    public private (set) var colorString:String
    //public private (set) var enumCase:WDTags
    
    init(name:String, colorLiteral:String) {
        self.name = name
        colorString = colorLiteral
        
    }
    
    init(name:String) {
        self.name = name
        switch name {
        case WDTags.Food.rawValue:
            colorString = WDTagColors.Food.rawValue
            break
        case WDTags.Drinks.rawValue:
            colorString = WDTagColors.Drinks.rawValue
            break
        case WDTags.Movies.rawValue:
            colorString = WDTagColors.Movies.rawValue
            break
        case WDTags.Sports.rawValue:
            colorString = WDTagColors.Sports.rawValue
            break
        default:
            colorString = WDTagColors.Other.rawValue
            break
        }
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
