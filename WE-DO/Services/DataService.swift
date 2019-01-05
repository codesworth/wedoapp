
//
//  DataService.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Firebase
import SDWebImage

final class DataService{
    
    static public let main = DataService()
    
    private var storage:StorageReference{
        return Storage.storage().reference()
    }
    
    
    
    func setUserData(uid:String, data:Aliases.dictionary, profiledata:Any?, _ handler:CompletionHandlers.dataservice? = nil){
        firestore().collection(References.users.rawValue).document(uid).setData(data, merge: true) { (err) in
            if err != nil{
                handler?(nil, err?.localizedDescription ?? "Unknown Error")
                return
            }
            handler?(true,nil)
            if let profile = profiledata as? URL{
                self.storage.child(STORAGE_PATH_PROFILE_PICS).child(uid).putFile(from: profile, metadata: nil, completion: { (meta, err) in
                    if err != nil{
                        Logger.log(err)
                    }else{
                        firestore().collection(References.users.rawValue).document(uid).updateData([Fields.profileUrl.rawValue:meta!.path ?? ""])
                    }
                })
            }else if let profile = profiledata as? Data{
                self.storage.child(STORAGE_PATH_PROFILE_PICS).child(uid).putData(profile, metadata: nil, completion: { (meta, err) in
                    if err != nil{
                        Logger.log(err)
                    }else{
                        firestore().collection(References.users.rawValue).document(uid).updateData([Fields.profileUrl.rawValue:meta!.path ?? ""])
                    }
                })
            }
           
        }
    }
}


extension DocumentReference{
    func collection(_ ref:References)->CollectionReference{
        return collection(ref.rawValue)
    }
}

extension DocumentSnapshot{
    
    func getString(_ id:Fields)->String{
        if let field = get(id.rawValue) as? String{
            return field
        }
        return ""
    }
    
    func getDate(_ id:Fields)->Date{
        Logger.log(self.get(id.rawValue).debugDescription)
        if let field = get(id.rawValue) as? Timestamp{
            return field.dateValue()
        }
        return Date.init(timeIntervalSince1970: 0)
        
        
    }
    
    func getArray(_ id:Fields)->[Any]{
        if let field = get(id.rawValue) as? [Any]{
            return field
        }
        return []
    }
    
    func getDictionary(_ id:Fields)->Aliases.dictionary{
        if let field = get(id.rawValue) as? Aliases.dictionary{
            return field
        }
        return [:]

    }
    
    func getDouble(id:Fields)->Double{
        if let field = get(id.rawValue) as? Double{
            return field
        }
        return 0.000001
    }
    
    func getInt(_ id:Fields)->Int{
        if let field = get(id.rawValue) as? Int{
            return field
        }
        return 0
    }
    
    func getInt64(_ id:Fields)->Int64{
        if let field = get(id.rawValue) as? Int64{
            return field
        }
        return 0
    }
    
    
    func getBoolena(_ id:Fields)->Bool{
        if let field = get(id.rawValue) as? Bool{
            return field
        }
        return false
    }
    
    
}


extension Firestore{
    
    func collection(_ ref:References)->CollectionReference{
        return collection(ref.rawValue)
    }
}



func storage()->Storage{
    return Storage.storage()
}
func firestore()->Firestore{
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
}


extension UIImageView{
    
    func setImage(_ userProf:String){
        if userProf.hasPrefix("h"){
            sd_setImage(with: URL(string: userProf)) { (img, err, cache, url) in
                if err != nil{
                    //SetPlaceholderImage
                }
            }
        }else{
            sd_setImage(with:storage().reference(withPath: userProf) , placeholderImage: nil)
        }
    }
}


