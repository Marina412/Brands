//
//  CheckoutViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import UIKit
import PassKit

class CheckoutViewController: UIViewController{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuponCodeTxtField: UITextField!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    @IBOutlet weak var applePayBtn: UIButton!
    let userDefaults = UserDefaults.standard
    var homeVM:HomeViewModel!
    let defaults = UserDefaults.standard
    var addressResult: Address?
    var checkOutItems : FavProduct = FavProduct()
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
  
    //ApplePayment
    private var paymentRequest:PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.YRStor"
        request.supportedNetworks = [.masterCard,.visa,.quicPay]
        request.supportedCountries = ["EG","US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = "EGP"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "iphone", amount: 1000)]
        return request
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("productTitlee \(checkOutItems.totalPrice)")
        
        getOneAddress()
        homeVM = HomeViewModel(repo: Repo(networkManager: NetworkManager()))
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        applePayBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        applePayBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        if (homeVM.cupons.count != 0){
            cuponCodeTxtField.text = Constant.CUPON_CODE
        }else{
            cuponCodeTxtField.text = "No Cupon Code"
        }
    }
    
    
    func getOneAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        print("customerId \(customerId)")
        addressViewModel.getAllAdresses(customerId: String(customerId))
        addressViewModel.bindResult = {() in
            print("enter bind ")
            let res = self.addressViewModel.viewModelResult
            guard let oneAddress = res?.addresses?[0] else {return}
            self.addressResult = oneAddress
            print("after set address \(self.addressResult)")
            self.addressLabel.text = (self.addressResult?.address1 ?? "") + "," + (self.addressResult?.city ?? "")
        }
}
    @IBAction func ApplyCuponCodeBtn(_ sender: Any) {
        
    }
    @IBAction func selectPaymentMethod(_ sender: UIButton) {
        if sender == cashOnDeliveryBtn{
            cashOnDeliveryBtn.isSelected = true
            applePayBtn.isSelected = false
            userDefaults.set("CashOnDelivery", forKey: Constant.PAY_Method)
        }else{
            cashOnDeliveryBtn.isSelected = false
            applePayBtn.isSelected = true
            userDefaults.set("applePay", forKey: Constant.PAY_Method)

        }
        
    }
    @IBAction func PlaceOrderBtn(_ sender: Any) {
        if (homeVM.cupons.count != 0){
            homeVM.cupons.remove(at: 0)
        }
        if ( userDefaults.string(forKey: "Constant.PAY_Method") == "applePay"){
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil{
                controller!.delegate = self
                present(controller!,animated:true,completion: nil)
            }
        }
    }
}

extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment,handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

