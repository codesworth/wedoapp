//
//  GSMapVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 15/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

protocol PlaceSelected:class {
    func didFinishSelecting(_ place:GMSPlace?)
}
class GSMapVC: UIViewController {
    
    var locationManager:CLLocationManager!
    var mapView:GMSMapView!
    var marker:GMSMarker!
    var searchbar:SearchBar!
    var placeMarker:GMSMarker?
    var tableView:UITableView!
    var myloc:CLLocation?
    var didLaySubViewsAlready = false
    var fetcher: GMSAutocompleteFetcher?
    var selectedPlace:GMSPlace?
    var setPlaceButt:UIButton!
    weak var delegate:PlaceSelected?
    var datasource:[GMSAutocompletePrediction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        setupLocation()
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: 33.86, longitude: 151.20), zoom: 15)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.view = mapView
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        view.backgroundColor = UIColor.primaryLight
        let label = UILabel(frame: CGRect(origin: view.frame.origin, size: view.frame.size))
        label.textAlignment = .center
        label.text = "Set Activity Location"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(label)
        mapView.addSubview(view)
        
        /**
         Search view
         */
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLaySubViewsAlready{
            let canvas = UIView(frame: CGRect(x: 0, y: 80, width: mapView.frame.width * 0.90, height: 40))
            searchbar = SearchBar(frame: CGRect(x: 0, y: 0, width: mapView.frame.width * 0.75, height: 40))
            let butt = UIButton(frame: CGRect(x: mapView.frame.width * 0.75 + (mapView.frame.width * 0.15 - 40) , y: 0, width: 40, height: 40))
            butt.layer.cornerRadius = 20
            butt.clipsToBounds = true
            butt.setImage(UIImage(named:AssetsImages.navigator.rawValue), for: .normal)
            butt.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
            //butt.contentMode = .scaleToFill
            butt.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            butt.addTarget(self, action: #selector(updateloc), for: .touchUpInside)
            canvas.addSubview(searchbar)
            canvas.addSubview(butt)
            canvas.backgroundColor = .clear
            
            self.view.addSubview(canvas)
            canvas.center.x = mapView.center.x
            for gesture in mapView.gestureRecognizers! {
                mapView.removeGestureRecognizer(gesture)
            }
            tableView = UITableView(frame: CGRect(x: 0, y: 125, width: mapView.frame.width * 0.90, height: mapView.frame.height - 130), style: .grouped)
            tableView.backgroundColor = .clear
            tableView.layer.cornerRadius = 4
            var fr = CGRect.zero; fr.size.height = .leastNormalMagnitude
            tableView.tableHeaderView = UIView(frame:fr)
            tableView.register(UINib(nibName: identifier(MapSearchCell.self), bundle: nil), forCellReuseIdentifier: identifier(MapSearchCell.self))
            mapView.addSubview(tableView)
            tableView.isHidden = true
            tableView.center.x = mapView.center.x
            tableView.delegate = self
            tableView.dataSource = self
            searchbar.delegate = self
            searchbar.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            setPlaceButt = UIButton(frame: CGRect(x: 0, y: mapView.frame.height, width: mapView.frame.width, height: 100))
            self.mapView.addSubview(setPlaceButt)
            setPlaceButt.backgroundColor = UIColor.primaryLight
            setPlaceButt.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            setPlaceButt.setTitle("Set Place For Activity", for: .normal)
            setPlaceButt.addTarget(self, action: #selector(placeSelected), for: .touchUpInside)
        }
        didLaySubViewsAlready = true
    }
    
    @objc func updateloc(){
        if myloc != nil{
            updateMyLocation(location: myloc!)
        }
    }
    
    @objc func placeSelected(){
        delegate?.didFinishSelecting(selectedPlace)
        dismiss(animated: true, completion: nil)
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


extension GSMapVC:CLLocationManagerDelegate{
    
    func setupLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager?.startUpdatingLocation()
        }
    }
    
    func updateMyLocation(location:CLLocation){
        marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = "Me"
        marker.snippet = ""
        marker.map = mapView
        mapView.animate(toLocation: location.coordinate)
    }
    
    func updatePlace(){
        guard selectedPlace != nil else{
            return
        }
        placeMarker = GMSMarker(position: selectedPlace!.coordinate)
        placeMarker!.title = selectedPlace!.name
        placeMarker!.snippet = selectedPlace!.formattedAddress
        placeMarker!.map = mapView
        mapView.animate(toLocation: selectedPlace!.coordinate)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            
            self.setPlaceButt.frame.origin.y -= 80
        }, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else{
            return
        }
        myloc = userLocation
        updateMyLocation(location: userLocation)
        
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}

extension GSMapVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchbar.resignFirstResponder()
        tableView.isHidden = true
        let client = GMSPlacesClient()
        client.autocompleteQuery(searchbar.text!, bounds: nil, boundsMode: GMSAutocompleteBoundsMode.bias, filter: nil) { (preds, err) in
            if let preds = preds{
                self.datasource = preds
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (setPlaceButt.frame.origin.y != mapView.frame.height){
            setPlaceButt.frame.origin.y = mapView.frame.height
        }
    }
    
    @objc func textDidChange(){
        fetcher?.sourceTextHasChanged(searchbar.text!)
        //searchCompleter.queryFragment = locationSearchBar.text ?? ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did End : \(textField.text ?? "Novae")")
    }
    
    
}


extension GSMapVC:GMSAutocompleteFetcherDelegate{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        datasource = predictions
        tableView.reloadData()
        tableView.reloadData() //Animate In Future
        tableView.isHidden = false
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        Logger.log(error)
    }
    
    func fetchGooglePlace(placeId:String?){
        let client = GMSPlacesClient()
        guard let id = placeId else{
            return
        }
        client.lookUpPlaceID(id) { (place, error) in
            if let place = place{
                self.selectedPlace = place
                self.updatePlace()
            }else{
                Logger.log(error)
            }
        }
        
    }
    
   
}

extension GSMapVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier(MapSearchCell.self), for: indexPath) as? MapSearchCell {
            let cl = datasource[indexPath.row]
            cell.configure(title: cl.attributedFullText.string, detail: cl.attributedPrimaryText.string)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        self.view.endEditing(true)
        let pl = datasource[indexPath.row]
        searchbar.text = pl.attributedPrimaryText.string
        fetchGooglePlace(placeId: pl.placeID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
