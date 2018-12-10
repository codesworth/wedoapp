//
//  PlanTagCells.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 09/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

//protocol Selectedtags:class {
//    func dudFinishSeleting(_ tag:String)
//}

class PlanTagCells: UICollectionViewCell {
    
    @IBOutlet weak var text:UILabel!
    var wd_tag:WDActivityTags!
    //weak var delegate:Selectedtags?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        layer.cornerRadius = 4
        // Initialization code
    }
    
    func configureTag(tag:WDActivityTags){
        self.wd_tag = tag
        text.text = tag.name
        layer.borderColor = tag.getColor().cgColor
        text.textColor = tag.getColor()
    }
    
    func debounce(){
        text.textColor = wd_tag.getColor()
        backgroundColor = UIColor.groupTableViewBackground
    }
    
    func selected(){
       text.textColor = UIColor.groupTableViewBackground
        backgroundColor = wd_tag.getColor()
    }
}
