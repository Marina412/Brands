//
//  EnterLocationViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 03/06/2023.
//

import UIKit
import Reachability

class EnterLocationViewController: UIViewController {
    var reachability = try! Reachability()
    @IBOutlet weak var choosenCountryLbl: UILabel!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var choosenCityLbl: UILabel!
    @IBOutlet weak var popUpCountry: UIButton!
    @IBOutlet weak var popUpCity: UIButton!
    @IBOutlet weak var countryTxtField: UITextField!
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderCountryPopButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func reachabilityChanged(note: Notification) {}
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    func renderCountryPopButton(){
        let country = {
            [self] (action: UIAction) in
            choosenCountryLbl.text = action.title
            renderCityPopButton()
        }
        
        popUpCountry.menu = addressAction(names: Constant.COUNTRIES,closureHandler: country)
        
    }
    func renderCityPopButton(){
        let city = {
            [self] (action: UIAction) in
            choosenCityLbl.text = action.title
        }
        if choosenCountryLbl.text?.lowercased() == Constant.COUNTRIES[0].lowercased()
        {
            let alertController = UIAlertController(title: "Shopify", message: "plz choose country", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            switch choosenCountryLbl.text?.lowercased(){
            case Constant.COUNTRIES[1].lowercased():
                popUpCity.menu = addressAction(names: Constant.CITIES_EGYPT,closureHandler: city)
            case Constant.COUNTRIES[2].lowercased():
                popUpCity.menu = addressAction(names: Constant.CITIES_UK ,closureHandler: city)
            case Constant.COUNTRIES[3].lowercased():
                popUpCity.menu = addressAction(names: Constant.CITIES_US,closureHandler: city)
            case Constant.COUNTRIES[4].lowercased():
                popUpCity.menu = addressAction(names: Constant.CITIES_SAR,closureHandler: city)
            case Constant.COUNTRIES[5].lowercased():
                popUpCity.menu = addressAction(names: Constant.CITIES_UAE,closureHandler: city)
            default:
                popUpCity.menu = addressAction(names: Constant.CITIES_ITALY,closureHandler: city)
            }
        }
        
        
    }
    func saveAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        defaults.set(customerId, forKey: "customerId")
        var address = Address(customer_id:customerId ,address1: streetTxtField.text,country: choosenCountryLbl.text, city: choosenCityLbl.text)
        var customerAddress = CustomerAddress(customer_address: address)
        addressViewModel.saveCustomerAddress(address:customerAddress, customerId: String(customerId))
        
    }
    @IBAction func saveAddres(_ sender: Any) {
        if (reachability.connection != .unavailable){
            saveAddress()
            let alert = UIAlertController(title: "Shopify", message: "Address Added Suceesfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline plz check your connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
}
extension EnterLocationViewController{
    func addressAction(names:[String],closureHandler:@escaping (UIAction)->())->UIMenu{
        var actions = Array<UIMenuElement>()
        names.forEach{
            name in
            actions.append(UIAction(title: name, handler:closureHandler))
        }
        print(actions)
        return UIMenu(children: actions)
        
    }
}
