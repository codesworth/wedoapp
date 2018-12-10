
//
//  DataService.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import FirebaseFirestore

final class DataService{
    
    static public let main = DataService()
    
    func setUserData(uid:String, data:Aliases.dictionary){
        firestore().collection(References.users.rawValue).document(uid).setData(data, merge: true) { (err) in
            //
        }
    }
}




extension DocumentSnapshot{
    
    func getString(id:String)->String{
        if let field = get(id) as? String{
            return field
        }
        return ""
    }
    
    func getDouble(id:String)->Double{
        if let field = get(id) as? Double{
            return field
        }
        return 0.000001
    }
    
    func getInt(id:String)->Int{
        if let field = get(id) as? Int{
            return field
        }
        return 0
    }
    
    func getInt64(id:String)->Int64{
        if let field = get(id) as? Int64{
            return field
        }
        return 0
    }
    
    
    func getBoolena(id:String)->Bool{
        if let field = get(id) as? Bool{
            return field
        }
        return false
    }
    
}

func firestore()->Firestore{
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
}
