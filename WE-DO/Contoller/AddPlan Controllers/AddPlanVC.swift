//
//  AddPlanVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 08/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import GooglePlaces
class AddPlanVC: UIViewController {

    @IBOutlet weak var cancelButt: WDTagButton!

    @IBOutlet weak var titleLabel: BaseTextField!
    @IBOutlet weak var sendInviteButt: WDTagButton!
    @IBOutlet weak var mapVContainer: UIView!
    //@IBOutlet weak var addActivityVCC: UIView!
    var invitedList:Aliases.wdInvite!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteLabl: UILabel!
    private var overlay:UIView!
    let client = GMSPlacesClient.shared()
    private var activities = [(WDActivity,Bool)]()
    @IBOutlet weak var inviteimg: UIImageView!
    private var placePhotos:[String:UIImage] = [:]
    @IBOutlet weak var addActivityButt: WDTagButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        invitedList = [:]
        setup()
        titleLabel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    @IBAction func inviteFriendsPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: identifier(InviteeVC.self)) as? InviteeVC{
            vc.delegate = self
            vc.invitedFriends = invitedList
            present(vc, with: nil)
        }
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
        mapVContainer.isHidden = true
        activities.append((activity,false))
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
    
    func setup(){
        tableView.register(UINib(nibName: identifier(WDActivityCell.self), bundle: nil), forCellReuseIdentifier: identifier(WDActivityCell.self))
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        cancelButt.changeBorderColor(UIColor.wd_ash)
        sendInviteButt.changeBorderColor(UIColor.primaryLight)
        addActivityButt.changeBorderColor(UIColor.wd_yellow)
        mapVContainer.isHidden = true
        
        
    }
    
    @IBAction func sendInvitesPressed(_ sender: Any) {

    }
    
    func getPhotoFor(place:WDEventLocation, atIndexPath:IndexPath){
        
        client.lookUpPhotos(forPlaceID: place.placeID) { (photos, err) in
            if let photos = photos{
                for photo in photos.results{
                    self.client.loadPlacePhoto(photo, callback: { (image, err) in
                        if let img = image{
                            self.placePhotos.updateValue(img, forKey: place.placeID)
                            self.tableView.reloadRows(at: [atIndexPath], with: .automatic)
                        }
                    })
                    break
                }
            }
        }
        
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

extension AddPlanVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


extension AddPlanVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(WDActivityCell.self), for: indexPath) as? WDActivityCell{
            let act = activities[indexPath.row].0
            let img = placePhotos[act.location.placeID]
            if (img == nil){
                getPhotoFor(place: act.location, atIndexPath: indexPath)
            }
            cell.configureView(ac: act, expand: activities[indexPath.row].1, img)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activities[indexPath.row].1 = !activities[indexPath.row].1
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if activities.count > 0 {
            return "ACTIVITIES"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tup = activities[indexPath.row]
        if tup.1 {
            return 190
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            self.activities.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        return [action]
    }
    
    
    
    
}

extension AddPlanVC:InvitedListDelegate{
    
    func didPassInvitedList(_ list: Aliases.wdInvite) {
        invitedList = list
    }
}

