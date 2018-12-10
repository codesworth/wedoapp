//
//  MapSearchCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 08/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class MapSearchCell: UITableViewCell {

    @IBOutlet weak var placedetail: UILabel!
    @IBOutlet weak var placeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(title:String, detail:String?){
        placeName.text = title
        placedetail.text = detail
    }
    
}
