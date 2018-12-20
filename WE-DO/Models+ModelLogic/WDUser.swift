//
//  WDUser.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage


class WDUser{
    
    public private (set) var uid:String
    public private (set) var username:String
    public private (set) var profileUrl:String
    public private (set) var date_created:Date
    public private (set) var phone:String
    
    public var imageRef:StorageReference{
        return Storage.storage().reference().child(profileUrl)
    }
    
    init(snapshot:DocumentSnapshot) {
        uid = snapshot.getString(id: USER_UID)
        username = snapshot.getString(id: Fields.username.rawValue)
        profileUrl = snapshot.getString(id: Fields.profileUrl.rawValue)
        date_created = snapshot.get(Fields.dateCreated.rawValue) as? Date ?? Date()
        phone = snapshot.getString(id: Fields.phone.rawValue)
    }
    
    
}



class UserLogic{
    
    
    public private (set) var users:[WDUser]
    
    private var userRef:CollectionReference{
        return firestore().collection(References.users)
    }
    
    func count()->Int{return users.count}
    func at(_ index:Int)->WDUser{
        return users[index]
    }
    
    init() {
        users = []
    }
    
    func getUsersFromList(handler:@escaping CompletionHandlers.dataservice){
        //Should first look up friendlist
        userRef.getDocuments { (query, err) in
            if let query = query{
                for doc in query.documents{
                    let user = WDUser(snapshot: doc)
                    self.users.append(user)
                }
                handler(true,nil)
            }else{
                handler(false,err?.localizedDescription)
                Logger.log(err)
            }
        }
    }
}
