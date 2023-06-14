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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    var authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
    var customers = [Customer()]
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfCustomerLogedIn()
        passwordTx.isSecureTextEntry = true
        getAllCustomers()
        
    }
    func checkIfCustomerLogedIn(){
        // Check for user email and password every time you open the app
        if let email = defaults.string(forKey: "email"), let password = defaults.string(forKey: "password") {
            print("User email: \(email)")
            print("User password: \(password)")

            emailTx.isHidden = true
            passwordTx.isHidden = true
            showHideBtn.isHidden = true
            logInBtn.isHidden = true
//            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "searchVc") as! SearchViewController
//            self.navigationController?.pushViewController(searchVc, animated: true)
        } else {
            activityIndicator.isHidden = true
        }
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
    
    func validateCustomer(){
        var isCustomerFound = false
        for customer in customers {
            if emailTx.text == customer.email && passwordTx.text == customer.password {
                isCustomerFound = true
                defaults.set(emailTx.text, forKey: "email")
                defaults.set(passwordTx.text, forKey: "password")
                if let email = defaults.string(forKey: "email"), let password = defaults.string(forKey: "password") {
                    print("User email: \(email)")
                    print("User password: \(password)")
                } else {
                    print("User email and/or password not found")
                }
                break
            }
        }
        if isCustomerFound {
            print("found done")
//            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "searchVc") as! SearchViewController
//            self.navigationController?.pushViewController(searchVc, animated: true)
        } else {
            print("not done, not found ")
            let alert = UIAlertController(title: "Invalid Data", message: "InCorrect Email or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func showPassBtn(_ sender: Any) {
        checkShowHideBtn()
    }
    
    @IBAction func logInBtn(_ sender: Any) {
        validateCustomer()
    }
    
}
