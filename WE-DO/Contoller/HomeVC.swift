//
//  HomeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin

class HomeVC: UIViewController {

    
    @IBOutlet weak var userButt: AttributedButton!
    @IBOutlet weak var addButt: AttributedButton!
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getFriends()
        
    }
    
    @IBAction func userdetailPressed(_ sender: Any) {
       LoginManager().logOut()
    }
    @IBAction func addPlanPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier:String(describing: AddPlanVC.self)) as? AddPlanVC{
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func setupViews(){
        userButt.setElevation(2)
        addButt.setElevation(2)
        
    }
    
    func getFriends(){
        let graphPath = "/me/taggable_friends"
        let parameters = ["fields": ""]
        let handler:FBSDKGraphRequestHandler = { (connection:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in
            if let error = error  {
                let nserror = error as NSError
                print("Facebook error occurred with sig: \(nserror.userInfo[FBSDKErrorDeveloperMessageKey] ?? error.localizedDescription)")
            }else{
                print("The reult is: \(result ?? "No res")")
                let json = JSON(result)
                let friendJSONArray = json["data"].arrayValue
                for friendJSON in friendJSONArray {
                    print(friendJSON["name"].stringValue)
                    print(friendJSON["id"].intValue)
                }
                let nextPageToken = json["paging"]["cursors"]["after"].stringValue
                let prevPageToken = json["paging"]["cursors"]["before"].stringValue
            }
            
            }
        let graphReq = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
        graphReq?.start(completionHandler: handler)
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
