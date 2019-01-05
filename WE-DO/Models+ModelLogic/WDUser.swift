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
        uid = snapshot.documentID
        username = snapshot.getString(.username)
        profileUrl = snapshot.getString(.profileUrl)
        date_created = snapshot.getDate(.dateCreated)
        phone = snapshot.getString(.phone)
    }
    
    
}

class WDInvite{
    
    public private (set) var user:WDUser
    public private (set) var status:InviteStatus
    
    init(user:WDUser,status:InviteStatus) {
        self.user = user
        self.status = status
    }
}



class UserLogic{
    
    
    public private (set) var invitees:[WDInvite]
    private var searchedResults:[WDInvite]
    public var isSearching = false
    private var userRef:CollectionReference{
        return firestore().collection(References.users)
    }
    
    func count()->Int{
        if isSearching{
            return searchedResults.count
        }
       return invitees.count
    }
    func at(_ index:Int)->WDInvite{
        if isSearching{
            return searchedResults[index]
        }
        return invitees[index]
    }
    
    init() {
        invitees = []
        searchedResults = []
    }
    
    func getUsersFromList(inviteeList:Aliases.wdInvite, handler:@escaping CompletionHandlers.dataservice){
        //Should first look up friendlist
        var count = 0
        for (id,status) in inviteeList{
            userRef.document(id).getDocument { (snapshot, err) in
                count += 1
                if let doc = snapshot {
                    let user = WDUser(snapshot: doc)
                    let invite = WDInvite(user: user, status: status)
                    self.invitees.append(invite)
                    if count == inviteeList.count{
                        handler(true,nil)
                    }
                }else{
                    if count == inviteeList.count{
                        handler(true,nil)
                    }
                }
            }
        }
        
    }
    
    func searchBegun(_ text:String, callback:CompletionHandlers.simpleExecution){
        
        searchedResults = invitees.compactMap { invite  -> WDInvite? in
            if invite.user.username.lowercased().contains(text.lowercased()){
                return invite
            }else{return nil}
        }
        callback()
    }
    
    func getMyFriends(handler:@escaping CompletionHandlers.dataservice){
        
        userRef.getDocuments { (query, err) in
            if let query = query{
                for doc in query.documents{
                    let uid = UserDefaults.standard.string(forKey: USER_UID)!
                    if doc.documentID != uid {
                        let user = WDUser(snapshot: doc)
                        let invite = WDInvite(user: user, status: .uninvited)
                        self.invitees.append(invite)
                    }
                }
                handler(true,nil)
            }else{
                handler(false,err?.localizedDescription)
                Logger.log(err)
            }
        }
        
    }
    

}

/*
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
}*/
