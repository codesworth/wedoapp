//
//  AuthVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 06/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore

class AuthVC: UIViewController, LoginButtonDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func facebookLogin(){
        let _ = Auth.auth().addStateDidChangeListener() { auth, user in
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
            //print("Yhis is the user: \(user!.description)")
            //user!.delete(completion: cb)
            loginButton.delegate = self
            loginButton.center = self.view.center
            
            self.view.addSubview(loginButton)
            if user != nil  {
                UserDefaults.standard.set(user!.uid, forKey: USER_UID)
                //self.performSegue(withIdentifier: Identifiers.segue_tohome.rawValue, sender: nil)
            }
        }
    }
    
    

    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        //
    }
    
    



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
