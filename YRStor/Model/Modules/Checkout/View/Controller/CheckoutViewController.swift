//
//  CheckoutViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 13/06/2023.
//

import UIKit
import PassKit
import Reachability

class CheckoutViewController: UIViewController,CheckOutDelegate{
    
    @IBOutlet weak var cardView3: CardViews!
    @IBOutlet weak var cardView2: CardViews!
    @IBOutlet weak var cardView1: CardViews!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuponCodeTxtField: UITextField!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    var paymentMethod :String = ""
    var homeVM:HomeViewModel!
    let defaults = UserDefaults.standard
    var addressResult: Address = Address()
    var checkOutItems : FavProduct!
    var addressViewModel = CustomerAddressViewModel(repo: Repo(networkManager: NetworkManager()))
    var didSelectAddress = Address()
    var reachability = try! Reachability()
    private var paymentRequest:PKPaymentRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuponCodeTxtField.text = ""
        defaults.set(true, forKey: "AddressShoppingCart")
        totalLbl.text =  HelperFunctions.priceEXchange(price:checkOutItems.totalPrice ?? "0" )
        
        getOneAddress()
        homeVM = HomeViewModel(repo: Repo(networkManager: NetworkManager()))
        
        paymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.com.YRStor"
            request.supportedNetworks = [.masterCard,.visa,.quicPay]
            request.supportedCountries = ["EG","US"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "EG"
            request.currencyCode = "EGP"
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Shopify", amount:NSDecimalNumber(string: totalLbl.text))]
            return request
        }()
        
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        cashOnDeliveryBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        applePayBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        applePayBtn.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        
        UIView.elevationCardView(view: cardView1)
        UIView.elevationCardView(view: cardView2)
        UIView.elevationCardView(view: cardView3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculateTotal()
        showCupon()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc func reachabilityChanged(note: Notification) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func getAddress(address: Address) {
        self.addressResult = address
        self.addressLabel.text = (self.addressResult.address1 ?? "") + "," + (self.addressResult.city ?? "")
    }
    
    func getOneAddress(){
        let customerId = defaults.integer(forKey: "customerId")
        addressViewModel.getAllAdresses(customerId: String(customerId))
        addressViewModel.bindResult = {() in
            let res = self.addressViewModel.viewModelResult
//            if(self.getOneAddress() == nil){
//
//                let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
//                self.navigationController?.pushViewController(addressVC, animated: true)
//            }
            guard res?.addresses != nil else {
                let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                    self.navigationController?.pushViewController(addressVC, animated: true)
                return
                
            }
            if(!(res?.addresses!.isEmpty ?? false)){
                self.addressResult = res?.addresses![0] ?? Address()
                if(self.defaults.bool(forKey: "didSelectAddress") == true){
                    self.addressLabel.text = (self.didSelectAddress.address1 ?? "") + "," + (self.didSelectAddress.city ?? "")
                }
                else{
                    self.addressLabel.text = (self.addressResult.address1 ?? "") + "," + (self.addressResult.city ?? "")
                }
                self.phoneLbl.text = self.addressResult.phone
            }
            else{
                let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                                    self.navigationController?.pushViewController(addressVC, animated: true)
            }
        }
    }
    
    func calculateTotal(){
        totalLbl.text = HelperFunctions.priceEXchange(price:checkOutItems.totalPrice ?? "0" )
        subTotalLbl.text = HelperFunctions.priceEXchange(price:checkOutItems.totalPrice ?? "0" )
    }
    
    func showCupon(){
        if (homeVM.cupons.count != 0 &&  self.defaults.bool(forKey: "touchCopon") == true){
            cuponCodeTxtField.text = defaults.value(forKey: Constant.CUPON_CODE) as! String
        }else{
            cuponCodeTxtField.text = "No Cupon Code"
            applyBtn.isHidden = true
        }
    }
    @IBAction func changeAddress(_ sender: Any) {
        if (reachability.connection != .unavailable){
            let address=self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            address.checkOutItems = checkOutItems
            address.checkOutDelegate = self
            self.navigationController?.pushViewController(address, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline check connectivity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
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
            self.totalLbl.text = HelperFunctions.priceEXchange(price:String(result) ?? "0" )
            
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
        if (reachability.connection != .unavailable){
            let alert = UIAlertController(title: "Shoify", message: " Are you sure you want to confirm  payment?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default,handler: {  action in
                if (self.homeVM.cupons.count != 0){
                    self.homeVM.removeItemFromCupon(index: 0)
                }
                if ( self.defaults.string(forKey: Constant.PAY_Method) == "applePay"){
                    let controller = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest ?? PKPaymentRequest())
                    if controller != nil{
                        controller!.delegate = self
                        self.present(controller!,animated:true){
                            self.addOrder()
                        }
                    }
                }
                else{
                    self.addOrder()
                    let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
                    self.navigationController?.pushViewController(ordersVC, animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            self.present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Shopify", message: " Sorry!! you are offline check connectivity", preferredStyle: .alert)
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

extension CheckoutViewController{
    func addOrder(){
        addressViewModel.postOrder(order:PostOrders(order: Order(
            currencyType: defaults.string(forKey: Constant.CURRENCY), currentTotalPrice: totalLbl.text, userEmail: defaults.string(forKey: Constant.EMAIL), address: addressLabel.text, payType: defaults.string(forKey: Constant.PAY_Method), lineItems: HelperFunctions.formFavModelToProduct(shopCartProduct: checkOutItems)
        ))){
            res in
            if ((res) != nil){
                print("order done")
                var cartViewModel = ShoppingCartViewModel(repo: Repo(networkManager: NetworkManager()))
                cartViewModel.deleteFavListInDatabase(draftId: String(self.checkOutItems.draftId ?? 0), indexPath: nil) {
                  
                }

            }
            else{
                print("order did not save")
            }
        }
    }
}
extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            self.navigationController?.pushViewController(ordersVC, animated: true)
            if let navigationController = self.navigationController{
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment,handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

