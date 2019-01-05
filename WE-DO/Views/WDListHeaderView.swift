//
//  WDListHeaderView.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 26/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
protocol ListExpandableDelegate:class {
    func didExpanded(_ expanded:Bool)
}

class WDListHeaderView: UICollectionViewCell {

    @IBOutlet weak var showButt: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    weak var delegate:ListExpandableDelegate?
    private var isExpanded = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func showButtPressed(_ sender: Any) {
        isExpanded = !isExpanded
        delegate?.didExpanded(isExpanded)
        if isExpanded{
            showButt.setTitle("Show Less", for: .normal)
            Logger.log("It is Expanded")
            
        }else{
            Logger.log("Not Expanded")
            showButt.setTitle("Show More", for: .normal)
        }
    }
    
    func setAttrs(title:String, titleFor button:String?){
        if button == ""{
            showButt.isEnabled = false
        }else{
            showButt.isEnabled = true
        }
        headerTitle.text = title
        showButt.setTitle(button, for: .normal)
    }
}
