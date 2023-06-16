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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createCustomer(){
        validateData()
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
    
    func validateData(){
        if(!firstNameTx.text!.isEmpty && !lastNameTx.text!.isEmpty && !emailTx.text!.isEmpty && !phoneTx.text!.isEmpty && !passwordTx.text!.isEmpty && !passwordConfirmationTx.text!.isEmpty ){
            customer.firstName = firstNameTx.text
            customer.lastName = lastNameTx.text
            customer.phone = phoneTx.text
            setUpEmail()
            setUpPassword()
            authViewModel.saveCustomerInDatabase(customer: customer)
//            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "searchVc")
//            as! SearchViewController
//            self.navigationController?.pushViewController(searchVc, animated: true)
            print("Registed Success")
            
        }else
        {
            let alert = UIAlertController(title: "Invaild Data", message: "Please Confirm All Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
        defaults.set(true, forKey: "isLogging")

    }
    
}
