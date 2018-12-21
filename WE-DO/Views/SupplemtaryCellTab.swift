//
//  SupplemtaryCellTab.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 20/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class SupplemtaryCellTab: UITableViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var label:CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activity.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startAnimating(){
        if !activity.isAnimating{
            activity.startAnimating()
        }
    }
    
    
}
