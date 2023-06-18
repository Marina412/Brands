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
    let defaults = UserDefaults.standard
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    var globalLocation:CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        if isLocationServiceEnabled(){
            checkAuthorization()
        }
        else{
            showAlert(msg: "Please enable location Service",type: "locationService")
        }
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        saveAddress()
        let controller=self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func SearchOnMap(_ sender: Any) {
        let location = searchTxtField.text!
        if location != ""{
            SearchForLocation(loc: location)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: "please enter location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert,animated: true,completion: nil)
        }
    }
    
    func isLocationServiceEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorization(){
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .denied:
            showAlert(msg: "Please authorize access to location",type: "authSettings")
        case .restricted:
            showAlert(msg: "Authorization restricted",type: "default")
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
    
    func saveAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        var address = Address(customer_id:customerId ,address1: globalLocation.locality)

        var customerAddress = CustomerAddress(customer_address: address)
        addressViewModel.saveCustomerAddress(address:customerAddress, customerId: String(customerId))

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let globalLocation = locations.last{
            zoomToUserLocation(location: globalLocation)
        }
        manager.stopUpdatingLocation()
    }
    
    
    func zoomToUserLocation(location :CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        convertLonToAddress(location: location){
            convertPlaces in
            self.globalLocation = convertPlaces
        }
        
    }
    
    func showAlert(msg:String,type:String){
        let alert = UIAlertController(title: "Shopify", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Setting", style: .default,handler: { action in
            if type == "locationService"{
                // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                UIApplication.shared.open(URL(string: "App-prefs:Privacy&path=LOCATION")!)
            }
            else if type == "authSettings"{
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }))
        present(alert,animated: true,completion: nil)
    }
    
    func locationManager(_ manager:CLLocationManager , didChangeAuthorization status: CLAuthorizationStatus){
        if isLocationServiceEnabled(){
            switch status{
            case .denied:
                showAlert(msg: "Please authorize access to location",type: "authSettings")
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
            showAlert(msg: "please Enable location Service",type: "locationService")
        }
    }
    
    func  SearchForLocation(loc:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(loc) { place,error  in
            guard let places = place?.first, error == nil else{
                let alert = UIAlertController(title: "Shopify", message: "no data to display", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert,animated: true,completion: nil)
                return}
            guard let location = places.location else{return}
            self.searchTxtField.text = ""
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = String(describing: places.name)
            self.mapView.addAnnotation(pin)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapView.setRegion(region, animated: true)
            self.convertLonToAddress(location: location){
                convertPlaces in
                self.globalLocation = convertPlaces
            }
            
           
        }
    }
    
    func convertLonToAddress(location:CLLocation,locClosure:@escaping(CLPlacemark?)->Void){

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                        guard let placemark = placemarks?.first else { return }
                     locClosure(placemark)
                    }
        
    }
}
