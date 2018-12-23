//
//  Enums.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 20/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit


enum Segue:String{
    case tohome = "tohome"
    case toEmailAuth = "toEmailAuth"
}

enum InviteStatus:Int{
    case invited = 1
    case accepted = 2
    case declined = 3
    case uninvited = 0
}


enum Keys:String{
    case api_gmaps = "AIzaSyAtgk7n7Fm3Sf0JX_tXThY9rRoCReq9DXE"
}


enum CompletionHandlers{
    typealias alert = (_ alert:UIAlertAction) -> ()
    typealias dataservice = (_ success: Bool?, _ errorMessage: String?) -> ()
    typealias authBlock = (_ sucess:Bool, _ errMessage:String?) -> Void
    typealias simpleExecution = () -> ()
    
}

enum Aliases{
    typealias dictionary = Dictionary<String,Any>
    typealias sset = Set<String>
    typealias wdInvite = Dictionary<String,InviteStatus>
}

enum DateFormats:String{
    case short_t = "MM-dd-yyyy HH:mm"
    case shirt_nt = "MM/dd/yyyy"
    case year_month = "MMMM yyyy"
    case long_epoch = "E, d MMM yyyy HH:mm:ss Z"
    case no_year_t = "MMM d, h:mm a"
}



enum References:String{
    case users = "WD-USERS"
    case plans = "WD-PLANS"
    case locations = "WD-Locations"
    case photos = "photos"
    case invites = "Invites"
    case activities = "Activities"
}

enum Fields:String{
    
    case username = "username"
    case dateCreated = "dateCreated"
    case timestamp = "timestamp"
    case profileUrl = "profileUrl"
    case phone = "phone"
    case name = "name"
    case date = "date"
    case activities = "activities"
    
    case placeID = "placeID"
    case placeName = "placeName"
    case latitude = "latitude"
    case longitude = "longitude"
    case locationUrl = "locationUrl"
    case locationPhone = "locationPhone"
    case attributes = "attributes"
    case creator = "creator"
    case status = "status"
    case title = "title"
    case time = "time"
    case location = "location"
    case tags = "tags"
    case invites = "invites"
    
}

enum AssetsImages:String{
    
    case navigator = "navigator"
    case next = "next"
    case down = "down-arrow"
    
}

