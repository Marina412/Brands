//
//  LogInViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTx: UITextField!
    @IBOutlet weak var passwordTx: UITextField!
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    
    let defaults = UserDefaults.standard
    var authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
    var customers = [Customer()]
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTx.isSecureTextEntry = true
        getAllCustomers()
        
    }
    
    func getAllCustomers(){
        authViewModel.getAllCustomers()
        authViewModel.bindResult = {() in
            let res = self.authViewModel.viewModelResult
            guard let allCustomers = res else {return}
            self.customers = allCustomers.customers
            
        }
    }
    func checkShowHideBtn(){
        if(showHideBtn.titleLabel?.text == "Show"){
            passwordTx.isSecureTextEntry = false
            showHideBtn.setTitle("Hide", for: .normal)
        }else if(showHideBtn.titleLabel?.text == "Hide"){
            passwordTx.isSecureTextEntry = true
            showHideBtn.setTitle("Show", for: .normal)
        }
    }
    
    func validateCustomer()-> Bool{
        var isCustomerFound = false
        for customer in customers {
            if emailTx.text == customer.email && passwordTx.text == customer.password {
                isCustomerFound = true
                defaults.set(emailTx.text, forKey: "email")
                defaults.set(passwordTx.text, forKey: "password")
                defaults.set(customer.id, forKey: "customerId")
                //                let customerIdDefaults = defaults.integer(forKey: "customerId")
                //                if let email = defaults.string(forKey: "email"), let password = defaults.string(forKey: "password") {
                //                    print("User email: \(email)")
                //                    print("User password: \(password)")
                //                    print("User ID : \(customerIdDefaults)")
                //                } else {
                //                    print("User email and/or password not found")
                //                }
            }
            
        }
        return isCustomerFound

    }
    
    @IBAction func showPassBtn(_ sender: Any) {
        checkShowHideBtn()
        
    }
    
    @IBAction func logInBtn(_ sender: Any) {
        
        if(validateCustomer()){
            defaults.set(true, forKey: "isLogging")

            if(defaults.value(forKey: "isFavOrCart") as! String == Constant.IS_SHOPPING_CART){
                let shoppingBag = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
                            self.navigationController?.pushViewController(shoppingBag, animated: true)
           
            }else{
                let fav = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                          self.navigationController?.pushViewController(fav, animated: true)
                          
                
            }

        }
        
        else{
            print("not done, not found ")
            let alert = UIAlertController(title: "Invalid Data", message: "InCorrect Email or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }

        
    }
    
    @IBAction func createNewAccountBtn(_ sender: Any) {
        
        let RegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(RegisterVC, animated: true)
        
    }
}
