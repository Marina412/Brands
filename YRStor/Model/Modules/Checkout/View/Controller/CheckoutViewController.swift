//
//  CheckoutViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import UIKit
import PassKit

class CheckoutViewController: UIViewController{
    
    @IBOutlet weak var cardView3: CardViews!
    @IBOutlet weak var cardView2: CardViews!
    @IBOutlet weak var cardView1: CardViews!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuponCodeTxtField: UITextField!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var TotalLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    var homeVM:HomeViewModel!
    let defaults = UserDefaults.standard
    var addressResult: Address = Address()
    var checkOutItems : FavProduct = FavProduct()
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    var total:String = ""
    var didSelectAddress = Address()
    //ApplePayment
    private var paymentRequest:PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.YRStor"
        request.supportedNetworks = [.masterCard,.visa,.quicPay]
        request.supportedCountries = ["EG","US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = "EGP"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Order", amount:1000)]
        return request
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(addressResult?.country == "" ){
//            let alert = UIAlertController(title: "Shopify", message: "Please add Address first ", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                self.dismiss(animated: true, completion: nil)
//            }))
//        }
        cuponCodeTxtField.text = ""
        defaults.set(true, forKey: "AddressShoppingCart")
        TotalLbl.text = HelperFunctions.priceEXchange(curencyType: addressViewModel.curencyType, price: checkOutItems.totalPrice ?? "0", rates: addressViewModel.rates) + " " +  addressViewModel.curencyType
        getOneAddress()
        homeVM = HomeViewModel(repo: Repo(networkManager: NetworkManager()))
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        applePayBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        applePayBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        
        UIView.elevationCardView(view: cardView1)
        UIView.elevationCardView(view: cardView2)
        UIView.elevationCardView(view: cardView3)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        TotalLbl.text = HelperFunctions.priceEXchange(curencyType: addressViewModel.curencyType, price: checkOutItems.totalPrice ?? "0", rates: addressViewModel.rates) + " " +  addressViewModel.curencyType
        subTotalLbl.text = HelperFunctions.priceEXchange(curencyType: addressViewModel.curencyType, price: checkOutItems.totalPrice ??  "0", rates: addressViewModel.rates) + " " + addressViewModel.curencyType
        if (homeVM.cupons.count != 0 &&  self.defaults.bool(forKey: "touchCopon") == true){
            cuponCodeTxtField.text = defaults.value(forKey: Constant.CUPON_CODE) as! String
        }else{
            cuponCodeTxtField.text = "No Cupon Code"
            applePayBtn.isHidden = true
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
            if(self.defaults.bool(forKey: "didSelectAddress") == true){
                self.addressLabel.text = (self.didSelectAddress.address1 ?? "") + "," + (self.didSelectAddress.city ?? "")
            }
            else{
                self.addressLabel.text = (self.addressResult.address1 ?? "") + "," + (self.addressResult.city ?? "")
            }
            self.phoneLbl.text = self.addressResult.phone
        }
    }
    @IBAction func changeAddress(_ sender: Any) {
        let address=self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        self.navigationController?.pushViewController(address, animated: true)
    }
    @IBAction func ApplyCuponCodeBtn(_ sender: Any) {
        var intCupon = 1.0
        switch(cuponCodeTxtField.text){
        case "15%":
            intCupon = 0.15
        case "25%":
            intCupon = 0.25
        case "50%":
            intCupon = 0.5
        default:
            intCupon = 1
        }
        if let intTotal = Double(checkOutItems.totalPrice ?? ""){
            let result = intTotal - (intTotal * intCupon)
            self.TotalLbl.text =  HelperFunctions.priceEXchange(curencyType: self.addressViewModel.curencyType, price: String(result) , rates: self.addressViewModel.rates) + " " + self.addressViewModel.curencyType
        } else {
            print("One of the strings is not a valid integer.")
        }

    }
    @IBAction func selectPaymentMethod(_ sender: UIButton) {
        if sender == cashOnDeliveryBtn{
            cashOnDeliveryBtn.isSelected = true
            applePayBtn.isSelected = false
            defaults.set("CashOnDelivery", forKey: Constant.PAY_Method)
        }else{
            cashOnDeliveryBtn.isSelected = false
            applePayBtn.isSelected = true
            defaults.set("applePay", forKey: Constant.PAY_Method)
            
        }
        
    }
    @IBAction func PlaceOrderBtn(_ sender: Any) {
        if (homeVM.cupons.count != 0){
            homeVM.cupons.remove(at: 0)
        }
        if ( defaults.string(forKey: "Constant.PAY_Method") == "applePay"){
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil{
                controller!.delegate = self
                present(controller!,animated:true,completion: nil)
            }
        }
        addressViewModel.postOrder(order: Order(
            created_at: HelperFunctions.getTimestamp(), currency: defaults.string(forKey: Constant.CURRENCY), email: defaults.string(forKey: Constant.EMAIL), current_total_price: TotalLbl.text, line_items: HelperFunctions.formFavModelToProduct(shopCartProduct: checkOutItems), reference: Constant.PAY_Method, note: addressLabel.text
        ))
        print("done order ADDED ")
        //// delete shope cart here
        
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

