//
//  PlanSection.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 24/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import IGListKit

final class PlanSection:ListSectionController,ListSupplementaryViewSource{

    
    private var planList:WDPlanLists!
    private var expanded = false
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func numberOfItems() -> Int {
        if planList.list.count > 2 {
            if expanded{
                return planList.list.count
            }else{
                return 1
            }
        }
        return planList.list.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = collectionContext?.containerSize.width  ?? 0
        let height: CGFloat = CGFloat(index == 0 ? 152 : 2)
        return CGSize(width: width , height: 200)
    }
    
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let cell = collectionContext?.dequeueReusableCell(withNibName:identifier(GenericPlanCell.self), bundle: Bundle.main, for: self, at: index) as? GenericPlanCell {
            let plan = planList!.list[index]
            cell.configureView(plan)
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        planList = (object as! WDPlanLists)
    }
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        if elementKind == UICollectionView.elementKindSectionHeader{
            return HeaderView(atIndex: index)
        }
        fatalError()
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        if planList.list.isEmpty{
            return CGSize(width: collectionContext!.containerSize.width, height:0)
        }
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
    func HeaderView(atIndex:Int)->UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, nibName:identifier(WDListHeaderView.self), bundle: nil, at: atIndex) as? WDListHeaderView else {
            fatalError()
        }
        view.setAttrs(title:planList.headertitle, titleFor: buttTitle())
        view.delegate = self
        return view
    }
    
    func buttTitle()->String{
        if planList.list.count > 2 {
            if expanded{
                return "Show Less"
            }
            return "Show More"
        }
        return ""
    }
}


extension PlanSection:ListExpandableDelegate{
    
    func didExpanded(_ expanded: Bool) {
        self.expanded = !self.expanded
        collectionContext?.performBatch(animated: true, updates: { (context) in
            context.reload(self)
        }, completion: nil)
    }
}
