//
//  RegisterViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class RegisterViewController: UIViewController {
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
    var alreadyHaveAcc :Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        haveEmail()
        self.navigationItem.setHidesBackButton(true, animated: false)
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
                // print("passwor\(customer.password)")
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
            
            if(alreadyHaveAcc == true){
                let alert = UIAlertController(title: "Shopify", message: "This email is already have an account! ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            else{
                customer.firstName = firstNameTx.text
                customer.lastName = lastNameTx.text
                setUpEmail()
                setUpPassword()
                setUpPhoneNumber()
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
                isValidate = true
            }
        }
        return isValidate
    }
    
    func setUpPhoneNumber(){
        if(isValidPhoneNumber(phoneTx.text ?? "")){
            customer.phone = phoneTx.text
        }else{
            let alert = UIAlertController(title: "Invaild Phone Number", message: "Please Enter a Valid Phone Number ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
        
        if(validateData()){
            defaults.set(true, forKey: "isLogging")
            if(defaults.value(forKey: "isFavOrCart") as! String == Constant.IS_FAV){
                let fav = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                self.navigationController?.pushViewController(fav, animated: true)
                
            }else{
                let shoppingBag = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
                self.navigationController?.pushViewController(shoppingBag, animated: true)
                
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Invaild Data", message: "Please Confirm All Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    func haveEmail(){
         alreadyHaveAcc = false
        authViewModel.getAllCustomers()
        authViewModel.bindResult = {() in
            let res = self.authViewModel.viewModelResult
            guard let allCustomers = res?.customers else {return}
            self.customers = allCustomers
            for customer in self.customers {
                if(self.emailTx.text == customer.email ){
                    self.alreadyHaveAcc = true
                }
            }
        }
        
    }
    
    @IBAction func AlreadyHaveAccount(_ sender: Any) {
        
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(LoginVC, animated: true)
    }
}
