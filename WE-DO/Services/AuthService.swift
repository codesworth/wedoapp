//
//  AuthService.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 18/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import FirebaseAuth

final class AuthService{
    
    private var isAuthenticating:Bool = false
    
    
    func signUp(with email:String, and password:String, handler:@escaping CompletionHandlers.authBlock){
        if isAuthenticating{ return}else{
            isAuthenticating = true
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            defer{
                self.isAuthenticating = false
            }
            guard let user = authResult?.user else {
                handler(false, error!.localizedDescription)
                return
            }
            UserDefaults.standard.set(user.uid, forKey: USER_UID)
            handler(true,nil)
        }
    }
    
    func signIn(with email:String, and password:String, handler:@escaping CompletionHandlers.authBlock){
        if isAuthenticating{ return}else{
            isAuthenticating = true
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            defer{
                self.isAuthenticating = false
            }
            guard let user = data?.user else {
                handler(false, error!.localizedDescription)
                return
            }
            UserDefaults.standard.set(user.uid, forKey: USER_UID)
            handler(true,nil)
            
        }
    }
    
}
