//
//  AddPlanVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 08/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class AddPlanVC: UIViewController {

    @IBOutlet weak var cancelButt: WDTagButton!
    
    @IBOutlet weak var sendInviteButt: WDTagButton!
    @IBOutlet weak var mapVContainer: UIView!
    //@IBOutlet weak var addActivityVCC: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteLabl: UILabel!
    private var overlay:UIView!
    private var activities = [WDActivity]()
    @IBOutlet weak var inviteimg: UIImageView!
    @IBOutlet weak var addActivityButt: WDTagButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButt.changeBorderColor(UIColor.wd_ash)
        sendInviteButt.changeBorderColor(UIColor.primaryLight)
        addActivityButt.changeBorderColor(UIColor.wd_yellow)
        mapVContainer.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    @IBAction func inviteFriendsPressed(_ sender: Any) {
    }
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    
    @IBAction func addActivityPressed(_ sender: Any) {
        if let addAcc = storyboard?.instantiateViewController(withIdentifier: identifier(AddActivityCVC.self)) as? AddActivityCVC{
            self.addChild(addAcc)
            mapVContainer.addSubview(addAcc.view)
            addAcc.didMove(toParent: self)
        }
        
        mapVContainer.isHidden = false
    }
    
    func updateActivities(activity:WDActivity){
        activities.append(activity)
        tableView.reloadData()
    }
    
    func addMapVC(){
        if let chd = children.first as? AddActivityCVC{
            chd.willMove(toParent: nil)
            chd.removeFromParent()
            chd.view.removeFromSuperview()
        }
        if let mpv = storyboard?.instantiateViewController(withIdentifier: identifier(PlanMapCVC.self)) as? PlanMapCVC{
            self.addChild(mpv)
            mapVContainer.addSubview(mpv.view)
            mpv.didMove(toParent: self)
        }
        
        mapVContainer.isHidden = false
    }
    
    @IBAction func sendInvitesPressed(_ sender: Any) {
        
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


