//
//  mapViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 03/06/2023.
//
import CoreLocation
import UIKit
import MapKit

class mapViewController: UIViewController,CLLocationManagerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        //TODO save location in coreData
    }
    
    
    @IBAction func SearchOnMap(_ sender: Any) {
        let location = searchTxtField.text!
        if location != ""{
           // SearchForLocation(location: location)
        }
        else{
            //Todo add alert with ok button your msg is please enter your location
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        if isLocationServiceEnabled(){
            checkAuthorization()
        }
        else{
            showAlert(msg: "Please enable location Service")
        }
        //        manager.requestWhenInUseAuthorization()
        //        manager.startUpdatingLocation()
    }
    func isLocationServiceEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorization(){
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
        case .denied:
            showAlert(msg: "Please authorize access to location")
            
        case .restricted:
            showAlert(msg: "Autherization restricted")
            
        case .authorizedAlways:
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
        manager.stopUpdatingLocation()
    }
    func render(_ location:CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
    }
    func showAlert(msg:String){
        let alert = UIAlertController(title: "Shopify", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Setting", style: .default,handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert,animated: true,completion: nil)
    }
    
    func locationManager(_ manager:CLLocationManager , didChangeAuthorization status: CLAuthorizationStatus){
        if isLocationServiceEnabled(){
            switch status{
            case .notDetermined:
                manager.requestAlwaysAuthorization()
                
            case .denied:
                showAlert(msg: "Please authorize access to location")
                
            case .authorizedAlways:
                manager.startUpdatingLocation()
                mapView.showsUserLocation = true
                
            case .authorizedWhenInUse:
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
                mapView.showsUserLocation = true
            default:
                print("default")
            }
        }
        else{
            showAlert(msg: "please Enable location Service")
        }
    }
//    func  SearchForLocation(loc:String){
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(loc) { place in
//            guard let place else {
//                //Todo show alert with message no data to display
//                self.showAlert(msg: "error")
//                return
//            }
//            self.searchTxtField.text = ""
//            guard let loc = place.location else{return}
//            render(location: loc)
//        }
//    }
}
