//
//  WDPlan.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Firebase

final class WDPlan{
    
    public private (set) var creator:String
    public private (set) var planName:String
    public private (set) var startDate:Date
    public private (set) var dateCreated:Date?
    public private (set) var activities:[WDActivity]
    public private (set) var invites:Aliases.wdInvite
    
    init(creator: String, name:String, start:Date, activities:[WDActivity],invites:Aliases.wdInvite) {
        planName = name
        startDate = start
        self.activities = activities
        self.invites = invites
        self.creator = creator
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
            Fields.dateCreated.rawValue:datecreated,
            Fields.invites.rawValue:transform()
        ]
    }
}



public class PlanLogic{
    
    private var plan:WDPlan
    
    private var reference:CollectionReference{
        return firestore().collection(.plans)
    }
    
    private var userRef:CollectionReference{
        return firestore().collection(.users)
    }
    
    init(plan:WDPlan) {
        self.plan = plan
        
    }
    
    func uploadPlan(handler:@escaping CompletionHandlers.dataservice){
        let batch = firestore().batch()
        let pref = reference.document()
        batch.setData(plan.dataExport(), forDocument: pref, merge: true)
        for activity in plan.activities{
            let ref = pref.collection(References.activities.rawValue).document(String(activity.time.unix_ts))
            batch.setData(activity.databaseExport(), forDocument: ref, merge: true)
        }
        for invite in plan.invites{
           let uref = userRef.document(invite.key).collection(.invites).document(pref.documentID)
            batch.setData([Fields.status.rawValue:invite.value.rawValue,Fields.dateCreated.rawValue:plan.dateCreated ?? Date(), Fields.creator.rawValue:plan.creator], forDocument: uref, merge: true)
        }
        batch.commit { (err) in
            if let err = err{
                handler(false,err.localizedDescription)
            }else{
                handler(true,nil)
            }
        }
    }
}

