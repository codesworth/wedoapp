//
//  InviteeCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 16/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FirebaseUI


class InviteeCell: UITableViewCell {

    @IBOutlet weak var inviteButt: WDTagButton!
    @IBOutlet weak var username: CustomLabel!
    @IBOutlet weak var imsgev: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        inviteButt.changeBorderColor(.wd_yellow)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: WDUser){
        username.text = user.username.capitalized
        imsgev.setImage(user.profileUrl)
    }
    
    @IBAction func invitePressed(_ sender: WDTagButton) {
        
    }
}
