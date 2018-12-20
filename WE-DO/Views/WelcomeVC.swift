//
//  WelcomeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 18/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class WelcomeVC: UIViewController {
    
    
    @IBOutlet weak var fblogIn: WDTagButton!
    @IBOutlet weak var emailSignUp: WDTagButton!
    @IBOutlet weak var emailogIn: WDTagButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fblogIn.changeBorderColor(.white)
        emailogIn.changeBorderColor(.wd_yellow)
        emailSignUp.changeBorderColor(.white)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func EmailLoggedInPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.toEmailAuth.rawValue, sender: 100)
    }
    
    @IBAction func EmailSignUpInPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.toEmailAuth.rawValue, sender: 1020)
    }
    
    @IBAction func FailedPressed(_ sender: Any) {
        facebooklogin()
    }
    
    func facebooklogin(){
        let flogin = LoginManager()
        flogin.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: self) { (result) in
            switch (result){
            case .cancelled:
                 Logger.log("User Cancelled")
                break
            case .failed(let err):
                Logger.log(err)
                break
            case .success(grantedPermissions: _, declinedPermissions:  _, token: let token):
                    self.facebookLogCompletion(token: token)
                break
            default:
                break
            }
        }
    }


    func facebookLogCompletion(token:AccessToken){
        let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (data, err) in
            if (data != nil && err == nil){
                let user = data?.user
                let data = [Fields.username.rawValue:user?.displayName ?? "", Fields.profileUrl.rawValue:user?.photoURL?.absoluteString ?? "", Fields.dateCreated.rawValue:Date(),Fields.phone.rawValue:user?.phoneNumber ?? ""] as [String : Any]
                DataService.main.setUserData(uid: user!.uid, data: data, profiledata: user?.photoURL, { (suc, err) in
                    if (suc  == true){
                        UserDefaults.standard.set(user!.uid, forKey: USER_UID)
                        self.performSegue(withIdentifier: Segue.tohome.rawValue, sender: nil)
                    }else{
                        let alert = createDefaultAlert("OOPS!!", err ?? "Unknown Error",.alert, "Dismiss",.default, nil)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
            }else{
                let alert = createDefaultAlert("OOPS!!", err!.localizedDescription,.alert, "Dismiss",.default, nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = (segue.destination as? UINavigationController)?.topViewController as? EmailAuthVC{
            if let type = sender as? Int{
                dest.logType = type
            }
        }
    }
    

}
