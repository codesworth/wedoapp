//
//  InviteeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 16/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

protocol InvitedListDelegate:class {
    func didPassInvitedList(_ list:Aliases.wdInvite)
}

class InviteeVC: UIViewController {
    
    @IBOutlet weak var searchField:BaseTextField!
    @IBOutlet weak var tableView:UITableView!
    weak var delegate:InvitedListDelegate?
    var logic:UserLogic!
    var invitedFriends:Aliases.wdInvite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logic = UserLogic()
        registerCells()
        logic.getUsersFromList(inviteeList:invitedFriends) { (suc, err) in
            if suc == true{
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtPressed(_ sender: Any) {
        delegate?.didPassInvitedList(invitedFriends)
        self.dismiss(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func registerCells(){
        tableView.register(UINib(nibName: identifier(InviteeCell.self), bundle: nil), forCellReuseIdentifier: identifier(InviteeCell.self))
        tableView.register(UINib(nibName: identifier(SupplemtaryCellTab.self), bundle: nil), forCellReuseIdentifier: identifier(SupplemtaryCellTab.self))
    }

}


extension InviteeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logic.count() + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < logic.count(){
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(InviteeCell.self), for: indexPath) as? InviteeCell{
                let invitee = logic.at(indexPath.row)
                cell.configureCell(invitee)
                cell.delegate = self
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(SupplemtaryCellTab.self), for: indexPath) as? SupplemtaryCellTab{
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "My Friends"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == logic.count(){
            if let cell = tableView.cellForRow(at: indexPath) as? SupplemtaryCellTab{
                cell.startAnimating()
                logic.getMyFriends { (suc, err) in
                    if suc == true{
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}


extension InviteeVC:Invited{
    
    func didFinishInviting(_ uid: String, _ invited: Bool) {
        if invited{
            self.invitedFriends.updateValue(.invited, forKey: uid)
        }else{
            self.invitedFriends.removeValue(forKey: uid)
        }
    }
}
