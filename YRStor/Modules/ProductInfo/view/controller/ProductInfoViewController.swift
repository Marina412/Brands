//
//  ProductInfoViewController.swift
//  YRStor
//
//  Created by Huda kamal  on 12/06/2023.
//

import UIKit

class ProductInfoViewController: UIViewController {

    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var productPrice: UILabel!
 
    @IBOutlet weak var productDescription: UITextView!
    
    @IBOutlet weak var productBrand: UILabel!
    
    @IBOutlet weak var fabBtnCheck: UIButton!
    
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    var product : Product?
    var productImages : [ProductImage]!
    var draftId :String?
    var favProduct : FavProduct?
    var lineItems : [LineItems]?
    let defaults = UserDefaults.standard
    var viewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
    var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))

    
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        productQuantity.text = "\(Int(stepperOutlet.value))"
        
        checkIsFavProduct()
        setUpView()
        setUpProductDetails()
    }
    
    func checkIsFavProduct(){
        var favViewModel = FavViewModel(repo: Repo(networkManager: NetworkManager()))
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = favViewModel.viewModelResult
            guard let allFav = res?.draftOrders else {return}
            for draft in allFav{
                if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                    self.draftId = String(draft.draftId ?? 0)
                }
                guard let products = draft.lineItems else {return}
                for id in products{
                    print(id.productTitle)
                    if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                        self.fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            }
        }
    }
    
    func saveFavProductToDatabase(){
        let email = defaults.string(forKey: "email")
        lineItems = [LineItems(productId: String(product?.id ?? 0) , productTitle : product?.title,productPrice: product?.variants?[0].price, quantity: "1")]
        print(lineItems?[0].productId)
        favProduct = FavProduct(email: email,lineItems: lineItems)
        viewModel.saveFavProductToDatabase(favProduct: favProduct!)
        fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    func setUpView(){
        productImages = product?.images
        imageCollection.delegate = self
        imageCollection.dataSource = self
        pageControl.numberOfPages = productImages.count
        setUpProductDetails()
    }
    func setUpProductDetails(){
        productName.text = product?.title
        productBrand.text = "Brand : " + (product?.vendor ?? "")
        productDescription.text = product?.bodyHTML
        productPrice.text = "Price : " + (product?.variants?[0].price ?? "")
        productName.numberOfLines = 0
        productName.lineBreakMode = .byWordWrapping
    }
    func deleteProductFromDatabase(){
        var draftId = 0
        favViewModel.getAllFav()
        favViewModel.bindResult = {() in
            let res = self.favViewModel.viewModelResult
            guard let allFav = res else {return}
            guard let customerFav = self.getFavForCustomers(favs: allFav.draftOrders) else {return}
            for draft in customerFav{
                if(draft.lineItems?[0].productId == String(self.product?.id ?? 0)){
                    draftId = draft.draftId ?? 0
                }
            }
            print("draft iddd \(draftId)")
            self.favViewModel.deleteFavListInDatabase(draftId: String(draftId))
  
        }
    }
    
    func getFavForCustomers(favs : [FavProduct])-> [FavProduct]?{
        var favProducts : [FavProduct] = []
        let email = defaults.string(forKey: "email")
        for fav in favs {
            if(fav.email == email){
                favProducts.append(fav)
            }
        }
        return favProducts
        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        if(fabBtnCheck.currentImage == (UIImage(systemName: "heart.fill"))){
            fabBtnCheck.setImage(UIImage(systemName: "heart"), for: .normal)
            deleteProductFromDatabase()
            print("deleted")
        }else{
            fabBtnCheck.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            saveFavProductToDatabase()
            print("added")
        }
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        productQuantity.text = "\(Int(stepperOutlet.value))"
    }
    
    @IBAction func reviewsBtn(_ sender: Any) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "reviewsVC")
        as! ReviewsViewController
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
}

extension ProductInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productImages?.count ?? 3
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ProductImagesCell
        cell.setUpProductImages(productImages: productImages, indexPath: indexPath)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    
    
}
