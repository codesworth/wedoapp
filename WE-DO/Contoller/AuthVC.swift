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

        let _ = Auth.auth().addStateDidChangeListener() { auth, user in
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
            
            loginButton.delegate = self
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            if user != nil  {
                UserDefaults.standard.set(user!.uid, forKey: USER_UID)
                self.performSegue(withIdentifier: Identifiers.segue_tohome.rawValue, sender: nil)
            }
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (data, err) in
                if (data != nil && err == nil){
                    let user = data?.user
                    let data = [Fields.username.rawValue:user?.displayName ?? "", Fields.profileUrl.rawValue:user?.photoURL?.absoluteString ?? "", Fields.dateCreated.rawValue:Date(),Fields.phone.rawValue:user?.phoneNumber ?? ""] as [String : Any]
                    DataService.main.setUserData(uid: user!.uid, data: data)
                    UserDefaults.standard.set(user!.uid, forKey: USER_UID)
                    self.performSegue(withIdentifier: Identifiers.segue_tohome.rawValue, sender: nil)
                }else{
                    let alert = createDefaultAlert("OOPS!!", err!.localizedDescription,.alert, "Dismiss",.default, nil)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
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
