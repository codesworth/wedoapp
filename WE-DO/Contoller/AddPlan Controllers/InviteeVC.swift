//
//  InviteeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 16/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class InviteeVC: UIViewController {
    
    @IBOutlet weak var searchField:BaseTextField!
    @IBOutlet weak var tableView:UITableView!
    
    let userLogic = UserLogic()
    var invitedFriends:[String:Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: identifier(InviteeCell.self), bundle: nil), forCellReuseIdentifier: identifier(InviteeCell.self))
        userLogic.getUsersFromList { (suc, err) in
            if suc == true{
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtPressed(_ sender: Any) {
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

}


extension InviteeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLogic.count()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(InviteeCell.self), for: indexPath) as? InviteeCell{
            let user = userLogic.at(indexPath.row)
            cell.configureCell(user: user)
            return cell
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
}

class GirlFriend{
    
}
