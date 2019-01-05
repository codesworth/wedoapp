//
//  GenericPlanCell.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 23/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit


class GenericPlanCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UICollectionView!
    @IBOutlet weak var creatorText: UILabel!
    @IBOutlet weak var creatorImg: CustomImageView!
    @IBOutlet weak var planTitle: CustomLabel!
    @IBOutlet weak var startDate: CustomLabel!
    @IBOutlet weak var bgOverlay: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var badge:UILabel!
    
    var invites:Aliases.stray = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badge.clipsToBounds = true
        badge.layer.cornerRadius = 10
        badge.isHidden = true
        //containerView.setCollectionViewLayout(OverlappingFlowLayout(overlap: 20), animated: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.isHidden = false
        badge.isHidden = true
    }
    
    func configureView(_ plan:WDPlan){
        invites = plan.invites.allKeys()
        let myuid = UserDefaults.standard.string(forKey: USER_UID)!
        let mystatus = plan.invites[myuid]
        if let mystatus = mystatus{
            if mystatus == .invited{
                badge.isHidden = false
                containerView.isHidden = true
            }else{
                badge.isHidden = true
                containerView.isHidden = false
            }
        }
        containerView.register(UINib(nibName: identifier(AvatarCell.self), bundle: nil), forCellWithReuseIdentifier: identifier(AvatarCell.self))
        containerView.delegate = self
        containerView.dataSource = self
        
        firestore().collection(.users).document(plan.creator).getDocument { (snap, err) in
            if let username = snap?.getString(.username){
                self.creatorText.text = "Created by \(username)"
                
            }
            if let prof = snap?.getString(.profileUrl){
                self.creatorImg.setImage(prof)
            }
        }
        planTitle.text = plan.planName
        startDate.text = plan.startDate.toStringwith(.no_year_nt)
        //bgImage.
    }
    

}


extension GenericPlanCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(AvatarCell.self), for: indexPath) as? AvatarCell{
            let id = invites[indexPath.row]
            cell.display(id: id)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let borderWidth:CGFloat = 5
        return UIEdgeInsets(top: -borderWidth, left: -borderWidth, bottom: -borderWidth, right: -borderWidth)
    
    }
}





