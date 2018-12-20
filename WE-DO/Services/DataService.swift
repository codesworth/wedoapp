
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
