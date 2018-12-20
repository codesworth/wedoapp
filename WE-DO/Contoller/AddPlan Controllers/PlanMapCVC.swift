//
//  PlanMapCVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 09/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import MapKit

class PlanMapCVC: UIViewController {
    
    @IBOutlet weak var accessButt: UIButton!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    @IBOutlet weak var locationSearchBar: SearchBar!
    @IBOutlet weak var tableView:UITableView!
    var mapitem:MKMapItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        locationSearchBar.delegate = self
        searchCompleter.delegate = self
        locationSearchBar.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelMaps(_ sender: Any) {
//        if let parent = parent as? AddActivityCVC{
//            parent.triggerUpdate(mapItem: mapitem)
//        }
//        self.removeFrom()
        
    }
    
    func searchLocation(){
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = locationSearchBar.text
        let activeSearch = MKLocalSearch(request: req)
        activeSearch.start { (response, err) in
            if let response = response {
                self.runResponse(response: response)
            }
        }
    }
    
    
    func setup(){
        tableView.layer.cornerRadius = 4
        tableView.register(UINib(nibName: identifier(MapSearchCell.self), bundle: nil), forCellReuseIdentifier: identifier(MapSearchCell.self))
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



extension PlanMapCVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationSearchBar.resignFirstResponder()
        searchLocation()
        return true
    }
    
    @objc func textDidChange(){
        searchCompleter.queryFragment = locationSearchBar.text ?? ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did End : \(textField.text ?? "Novae")")
    }
    
    
}


extension PlanMapCVC:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        if tableView.isHidden {
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error Occurred")
    }
}


extension PlanMapCVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(MapSearchCell.self), for: indexPath) as? MapSearchCell {
            let item = searchResults[indexPath.row]
            cell.configure(title:item.title, detail:item.subtitle)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let found = searchResults[indexPath.row]
        let searchreq = MKLocalSearch.Request(completion: found)
        let search = MKLocalSearch(request: searchreq)
        search.start { (response, err) in
            if let res = response{
                self.runResponse(response: res)
            }else{
                self.present(createDefaultAlert("EROR", "Unable to retrieve location",.alert, "OK",.default, nil), animated: true, completion: nil)
            }
        }
        self.tableView.isHidden = true
        locationSearchBar.resignFirstResponder()
    }
    
    func runResponse(response:MKLocalSearch.Response){
        
        //Remove annotations
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        //Getting data
        let latitude = response.boundingRegion.center.latitude
        let longitude = response.boundingRegion.center.longitude
        
        //Create annotation
        let annotation = MKPointAnnotation()
        mapitem = response.mapItems.first
        annotation.title = response.mapItems.first?.name ?? ""
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.mapView.addAnnotation(annotation)
        
        //Zooming in on annotation
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.width.constant = 140
            self.accessButt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.accessButt.setTitle("Set Location", for: .normal)
        }) { (succ) in
            //
        }
    }
}
