//
//  WDPlan.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Firebase
import Geofirestore
import IGListKit

public class WDPlan:ListDiffable,Equatable{
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    public static func ==(lhs: WDPlan, rhs: WDPlan) -> Bool {
        return lhs.id == rhs.id && lhs.startDate == rhs.startDate
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? WDPlan else { return false }
        return id == object.id
    }
    

    
    public private (set) var id:String
    public private (set) var creator:String
    public private (set) var planName:String
    public private (set) var startDate:Date
    public private (set) var endDate:Date
    public private (set) var dateCreated:Date?
    public private (set) var activities:[WDActivity]
    public private (set) var invites:Aliases.wdInvite
    
    init(creator: String, name:String, start:Date,end:Date ,activities:[WDActivity],invites:Aliases.wdInvite) {
        id = firestore().collection(.users).document().documentID
        var invites = invites
        invites.updateValue(.accepted, forKey: creator)
        planName = name
        startDate = start
        self.activities = activities
        self.invites = invites
        self.creator = creator
        self.endDate = end
    }
    
    init(_ snapshot:DocumentSnapshot, _ activities:[WDActivity]?){
        id = snapshot.documentID
        creator = snapshot.getString(.creator)
        planName = snapshot.getString(.name)
        startDate = snapshot.getDate(.date)
        endDate = snapshot.getDate(.ending)
        dateCreated = snapshot.getDate(.dateCreated)
        let iv = snapshot.get(Fields.invites.rawValue) as! [String:Int]
        invites = [:]
        for i in iv{
            invites.updateValue(InviteStatus(rawValue: i.value)!, forKey: i.key)
        }
        
        self.activities = activities ?? []
    }
    
    func transform()->[String:Int]{
        var v:[String:Int] = [:]
        for i in invites{
            v.updateValue(i.value.rawValue, forKey: i.key)
        }
        return v
    }
    
    func dataExport()->Aliases.dictionary{
        let datecreated = Date()
        self.dateCreated = datecreated
        return [
            Fields.creator.rawValue:creator,
            Fields.name.rawValue:planName,
            Fields.date.rawValue:startDate,
            Fields.ending.rawValue:endDate,
            Fields.dateCreated.rawValue:datecreated,
            Fields.invites.rawValue:transform()
        ]
    }
}



