//
//  WDUser.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import FirebaseFirestore


class WDUser{
    
    public private (set) var uid:String
    public private (set) var username:String
    public private (set) var profileUrl:String
    public private (set) var date_created:Date
    public private (set) var phone:String
    
    
    init(snapshot:DocumentSnapshot) {
        uid = snapshot.getString(id: USER_UID)
        username = snapshot.getString(id: Fields.username.rawValue)
        profileUrl = snapshot.getString(id: Fields.profileUrl.rawValue)
        date_created = snapshot.get(Fields.dateCreated.rawValue) as? Date ?? Date()
        phone = snapshot.getString(id: Fields.phone.rawValue)
    }
    
    
}
