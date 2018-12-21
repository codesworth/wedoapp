//
//  InviteeCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 16/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FirebaseUI

protocol Invited:class {
    func didFinishInviting(_ uid:String, _ invited:Bool)
}

class InviteeCell: UITableViewCell {

    @IBOutlet weak var inviteButt: WDTagButton!
    @IBOutlet weak var username: CustomLabel!
    @IBOutlet weak var imsgev: UIImageView!
    weak var delegate:Invited?
    var invited = false
    var invitee:WDInvite?
    override func awakeFromNib() {
        super.awakeFromNib()
        inviteButt.changeBorderColor(.wd_yellow)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        invited = false
    }
    
    func configureCell(_ invitee: WDInvite){
        self.invitee = invitee
        username.text = invitee.user.username.capitalized
        imsgev.setImage(invitee.user.profileUrl)
        switch invitee.status {
        case .accepted:
            inviteButt.setTitle("Joined", for: .normal)
            inviteButt.isEnabled = false
            inviteButt.changeBorderColor(.primaryLight)
            break
        case .invited:
            inviteButt.setTitle("Invited", for: .normal)
            inviteButt.isEnabled = false
            inviteButt.changeBorderColor(.wd_ash)
            break
        case .declined:
            inviteButt.setTitle("Declined", for: .normal)
            inviteButt.isEnabled = false
            inviteButt.changeBorderColor(UIColor.red)
            break
        default:
            inviteButt.setTitle("Invite", for: .normal)
            inviteButt.isEnabled = true
            inviteButt.changeBorderColor(UIColor.wd_yellow)
            break
        }
    }
    
    @IBAction func invitePressed(_ sender: WDTagButton) {
        invited = !invited
        if invited{
            delegate?.didFinishInviting(invitee?.user.uid ?? "", invited)
            inviteButt.changeBorderColor(.wd_ash)
            inviteButt.setTitle("Invited", for: .normal)
        }
    }
}
