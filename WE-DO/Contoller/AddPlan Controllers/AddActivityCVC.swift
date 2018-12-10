//
//  AddActivityCVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 09/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import MapKit

class AddActivityCVC: UIViewController {

    @IBOutlet weak var addActivity: AttributedButton!
    @IBOutlet weak var locationButt: AttributedButton!
    @IBOutlet weak var locationLabl: CustomLabel!
    @IBOutlet weak var tagCollections: UICollectionView!
    @IBOutlet weak var activityDate: UITextField!
    @IBOutlet weak var activtyName: UITextField!
    private var date:Date?
    private var mapItem:MKMapItem?
    var tags:[WDActivityTags]!
    var selectedtags:Set<String>!
    private lazy var datepicker: UIDatePicker = {
        let dat = UIDatePicker(frame: CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200))
        dat.datePickerMode = .dateAndTime
        
        dat.minimumDate = Date()
        dat.setDate(Date(), animated: true)
        return dat
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = getWDTags()
        selectedtags = []
        addActivity.isEnabled = false
        tagCollections.allowsMultipleSelection = true
        tagCollections.register(UINib(nibName: identifier(PlanTagCells.self), bundle: nil), forCellWithReuseIdentifier: identifier(PlanTagCells.self))
        activityDate.inputView = datepicker
        setup()
        activityDate.delegate = self
        activtyName.delegate = self
        tagCollections.delegate = self
        tagCollections.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addMapVC(_ sender: Any) {
//        if let parent = parent as? AddPlanVC{
//            parent.addMapVC()
//        }
        if let mpv = storyboard?.instantiateViewController(withIdentifier: identifier(PlanMapCVC.self)) as? PlanMapCVC{
            self.addChild(mpv)
            view.addSubview(mpv.view)
            mpv.didMove(toParent: self)
        }
    }
    
    func triggerUpdate(mapItem:MKMapItem?){
        self.mapItem = mapItem
        if mapItem != nil{
            locationLabl.text = mapItem?.name ?? ""
            locationButt.setTitle("Activity Location", for: .normal)
            addActivity.isEnabled = true
            addActivity.backgroundColor = UIColor.primaryLight
        }
    }
    
    
    @IBAction func addActivity(_ sender: Any) {
        
        if date != nil && activtyName.text! != "" && mapItem != nil {
            let loc = WDEventLocation(name: mapItem!.name!, lat: mapItem!.placemark.coordinate.latitude, lon: mapItem!.placemark.coordinate.longitude,url:mapItem?.url, phone:mapItem?.phoneNumber)
            let activity = WDActivity(title: activtyName.text!, date: date!, location: loc, set: selectedtags)
            if let parent = parent as? AddPlanVC{
                parent.updateActivities(activity: activity)
            }
            removeFrom()
        }else{
            present(createDefaultAlert("OOPS!!", "Please make sure fill in required activity details",.alert, "OK",.default, nil), animated: true, completion: nil)
        }
    }

    
    @objc func datePickerEnded(){
        date  =  datepicker.date
        activityDate.text = date!.toStringwith(.short_t)
    }
    
    func setup(){
        datepicker.addTarget(self, action: #selector(datePickerEnded), for: .valueChanged)
        let toolbar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissdp))
        
//        toolbar.items = [(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissdp)))]
        activityDate.inputAccessoryView = toolbar
    }
    
    @objc func dismissdp(){
        view.endEditing(true)
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


extension AddActivityCVC:UITextFieldDelegate{
    
    
}

extension AddActivityCVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(PlanTagCells.self), for: indexPath) as? PlanTagCells{
            cell.configureTag(tag: tags[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlanTagCells{
            cell.selected()
        }
        selectedtags.insert(tags[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlanTagCells{
            cell.debounce()
        }
    }
    
}
