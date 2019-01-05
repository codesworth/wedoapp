//
//  Constants.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 06/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation

let USER_UID = "uid"
let TIME_INTERVAL_24_HRS:TimeInterval = 86400
let STORAGE_PATH_PROFILE_PICS = "UserProfiles"

func identifier(_ aClass:AnyClass)->String{
    return String.init(describing: aClass.self)
}


/*
func getFriends(){
    let graphPath = "/me/taggable_friends"
    let parameters = ["fields": ""]
    let handler:FBSDKGraphRequestHandler = { (connection:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in
        if let error = error  {
            let nserror = error as NSError
            print("Facebook error occurred with sig: \(nserror.userInfo[FBSDKErrorDeveloperMessageKey] ?? error.localizedDescription)")
        }else{
            print("The reult is: \(result ?? "No res")")
            let json = JSON(result)
            let friendJSONArray = json["data"].arrayValue
            for friendJSON in friendJSONArray {
                print(friendJSON["name"].stringValue)
                print(friendJSON["id"].intValue)
            }
            let nextPageToken = json["paging"]["cursors"]["after"].stringValue
            let prevPageToken = json["paging"]["cursors"]["before"].stringValue
        }
        
    }
    let graphReq = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
    graphReq?.start(completionHandler: handler)
}
*/
