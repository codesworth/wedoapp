//
//  WDActivityCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 11/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class WDActivityCell: UITableViewCell {

    @IBOutlet weak var stackheight: NSLayoutConstraint!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var timelabel: CustomLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loclbale: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var locimg: UIImageView!
    @IBOutlet weak var arrowButt:UIButton!
    var tags:[String]!
    override func awakeFromNib() {
        super.awakeFromNib()
        tags = []
        locimg.layer.cornerRadius = 4
        locimg.clipsToBounds = true
        collectionView.register(UINib(nibName: identifier(PlanTagCells.self), bundle: nil), forCellWithReuseIdentifier: identifier(PlanTagCells.self))
        timelabel.isHidden = true
        collectionView.isHidden = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(ac:WDActivity, expand:Bool = false, _ image:UIImage?){
        activityTitle.text = ac.title
        loclbale.text = ac.location.placeName
        locimg.image = image
        if expand{
            arrowButt.setImage(UIImage(named: AssetsImages.down.rawValue), for: .normal)
            collectionView.delegate = self
            collectionView.dataSource = self
            makeOrdered(sset: ac.tags)
            timelabel.isHidden = false
            collectionView.isHidden = false
            collectionView.reloadData()
        }else{
            arrowButt.setImage(UIImage(named: AssetsImages.next.rawValue), for: .normal)
            timelabel.isHidden = true
            collectionView.isHidden = true
            collectionView.delegate = nil
            collectionView.dataSource = nil
        }
    }
    
    func makeOrdered(sset:Aliases.sset){
        tags.removeAll()
        for s in sset{
            tags.append(s)
        }
    }
    
}


extension WDActivityCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(PlanTagCells.self), for: indexPath) as? PlanTagCells{
            let name = tags[indexPath.row]
            cell.configureTag(tag:WDActivityTags(name: name))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? PlanTagCells{
//            cell.selected()
//        }
//        
//    }
}
