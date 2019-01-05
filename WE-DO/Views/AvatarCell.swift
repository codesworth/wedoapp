//
//  AvatarCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 23/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {

    @IBOutlet weak var imgview: CustomImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func display(id:String){
        let url = storage().reference().child(STORAGE_PATH_PROFILE_PICS).child(id)
        imgview.sd_setImage(with: url, placeholderImage: UIImage(named: "sample"))
    }

}
