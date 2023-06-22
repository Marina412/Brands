//
//  RegisterViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit
import Reachability

class RegisterViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstNameTx: UITextField!
    @IBOutlet weak var lastNameTx: UITextField!
    @IBOutlet weak var emailTx: UITextField!
    @IBOutlet weak var phoneTx: UITextField!
    @IBOutlet weak var passwordTx: UITextField!
    @IBOutlet weak var passwordConfirmationTx: UITextField!
    var customer = Customer()
    var authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
    let defaults = UserDefaults.standard
    var customerId = 0
    var customers :[Customer] = []
    var alreadyHaveAcc  = false
    var phoneInvalid = false
    var reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        ChechBackendData()
        self.navigationItem.setHidesBackButton(true, animated: false)
       
        activityIndicator.isHidden = true
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
    func ChechBackendData(){
        authViewModel.getAllCustomers()
        authViewModel.bindResult = {() in
            let res = self.authViewModel.viewModelResult
            guard let allCustomers = res?.customers else {return}
            self.customers = allCustomers
        }
        
    }
    func phoneTaken(){
        phoneInvalid = false
        print("count \(self.customers.count)")
        for customer in self.customers {
            
            if(customer.phone  == "+20" + (self.phoneTx.text ?? "") ){
                print("text field  " + (self.phoneTx.text ?? ""))
                //                print(self.customer.email)
                self.phoneInvalid = true
                
            }
            
        }
        print("already have \(alreadyHaveAcc)")
        
    }
    
    func haveEmail(){
        alreadyHaveAcc = false
            for customer in self.customers {
                print( "customer email \( self.customer.email)")
                if(self.emailTx.text == customer.email ){
                    print("text field  " + (self.emailTx.text ?? ""))
                    print(self.customer.email)
                    self.alreadyHaveAcc = true
                    print("enter if ")
                }
               
            }
        print("already have \(alreadyHaveAcc)")
        }
    
    func setUpEmail(){
        
        if(isValidEmail(emailTx.text!)){
            customer.email = emailTx.text
        }else{
            let alert = UIAlertController(title: "Invaild Email", message: "Please Enter Vaild Email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func setUpPassword(){
        if(passwordTx.text == passwordConfirmationTx.text){
            if(isValidPassword(passwordTx.text!)){
                customer.password = passwordTx.text
                customer.password_confirmation = passwordConfirmationTx.text
               
            }else
            {
                let alert = UIAlertController(title: "Invaild Password", message: "Password should contains at least 8 characters long and contain at least one letter and one number.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Password Don't Match", message: "Please Confirm The Same Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateData()-> Bool{
        var isValidate = false
        if(!firstNameTx.text!.isEmpty && !lastNameTx.text!.isEmpty && !emailTx.text!.isEmpty && !phoneTx.text!.isEmpty && !passwordTx.text!.isEmpty && !passwordConfirmationTx.text!.isEmpty ){
            
            haveEmail()
            phoneTaken()
            if(alreadyHaveAcc == true){
                print("enterrr ifff ")
                let alert = UIAlertController(title: "Shopify", message: "This email is already have an account! ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)

            }

            if(phoneInvalid == true){
                let alert = UIAlertController(title: "Shopify", message: "This phone is already taken! ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            print("already \(alreadyHaveAcc) \(phoneInvalid)")
            if(alreadyHaveAcc == false && phoneInvalid == false ) {
                isValidate = true
                print( "second  \(alreadyHaveAcc)")
                customer.firstName = firstNameTx.text
                customer.lastName = lastNameTx.text
                setUpEmail()
                setUpPassword()
                authViewModel.saveCustomerInDatabase(customer: customer)
                authViewModel.bindCustomerResult = { ()
                    let res = self.authViewModel.viewModelCustomerResult
                    guard let customer = res else {return}
                    print("customer id \(customer.id)")
                    self.customerId = customer.id ?? 0
                    self.defaults.set(self.customerId, forKey: "customerId")
                    print((self.defaults.value(forKey: "customerId")))
                }
                self.defaults.set(emailTx.text, forKey: "email")
                self.defaults.set(passwordTx.text, forKey: "password")
                print("Registed Success")
               
            }
        }
        return isValidate
    }
    

    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
        if (reachability.connection != .unavailable){
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            if(validateData()){
                var cupons:[String] = ["15%","25%","50%"]
                defaults.set(cupons, forKey: "SavedArray")

                defaults.set(true, forKey: "isLogging")
                activityIndicator.isHidden = true
                var navigation = defaults.value(forKey: "isFavOrCart") as! String
                
                switch navigation {
                    
                case Constant.IS_SHOPPING_CART:
                    let shoppingBag = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
                    self.navigationController?.pushViewController(shoppingBag, animated: true)
                    
                case Constant.IS_FAV:
                    let fav = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                    self.navigationController?.pushViewController(fav, animated: true)
                    
                case Constant.IS_ADDRESS:
                    let address = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                    self.navigationController?.pushViewController(address, animated: true)
                    
                case Constant.IS_CATEGORY:
                    let category = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                    self.navigationController?.pushViewController(category, animated: true)
                    
                case Constant.IS_BRANDS:
                    let brands = self.storyboard?.instantiateViewController(withIdentifier: "BrandProductsViewController") as! BrandProductsViewController
                    self.navigationController?.pushViewController(brands, animated: true)
                    
                case Constant.IS_PRODUCT_INFO:
                    let search = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                    self.navigationController?.pushViewController(search, animated: true)
                    
                default:
                    print("No match")
                }
                
            }
            else
            {
                let alert = UIAlertController(title: "Invaild Data", message: "Please Enter Valid  Data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                activityIndicator.isHidden = true
            }
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline, Plz check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
           
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    
    @IBAction func AlreadyHaveAccount(_ sender: Any) {
        
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(LoginVC, animated: true)
    }
    
    @IBAction func logInAsGuest(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let guestVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(guestVC, animated: true)
    }
}
