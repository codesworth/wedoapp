//
//  HomeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin
import IGListKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var userButt: AttributedButton!
    @IBOutlet weak var addButt: AttributedButton!
    @IBOutlet weak var collectionview: UICollectionView!
    var data:[WDPlanLists] = []
    var logic = PlanLogic()
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WE-DO"
        data = logic.planlist
        setupViews()
        adapter.collectionViewDelegate = self
        adapter.collectionView = collectionview
        adapter.dataSource = self
        logic.getAvailablePlans { (sucess, err) in
            if sucess!{
                self.data = self.logic.planlist
                self.adapter.reloadData(completion: nil)
            }
        }
    }
    
    @IBAction func userdetailPressed(_ sender: Any) {
       LoginManager().logOut()
    }
    @IBAction func addPlanPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier:String(describing: AddPlanVC.self)) as? AddPlanVC{
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func setupViews(){
        userButt.setElevation(2)
        addButt.setElevation(2)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}






extension HomeVC:UICollectionViewDelegate,ListAdapterDataSource{
    

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PlanSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
