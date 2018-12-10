//
//  HomeVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 07/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var userButt: AttributedButton!
    @IBOutlet weak var addButt: AttributedButton!
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    @IBAction func userdetailPressed(_ sender: Any) {
        
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
