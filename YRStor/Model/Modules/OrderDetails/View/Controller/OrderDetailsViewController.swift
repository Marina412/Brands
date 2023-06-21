//
//  OrderDetailsViewController.swift
//  YRStor
//
//  Created by marina on 15/06/2023.
//

import UIKit

class OrderDetailsViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var payedBy: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var order:Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        renderUi()
        registerXibCells()
    }
    
}
extension OrderDetailsViewController{
    func renderUi(){
        let endCar = (order?.createdAt?.firstIndex(of: "T"))!
        orderDate.text = order?.createdAt?.substring(to: endCar)
        adress.text = order?.address
        payedBy.text = order?.payType
        totalPrice.text = (order?.currentTotalPrice ?? "") + " " + (order?.currencyType ?? "")
    }
    private func registerXibCells(){
        itemsCollectionView.register(UINib(nibName: "OrderItemColletionViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderItemColletionViewCellCollectionViewCell")
    }
}
extension OrderDetailsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       if collectionView.numberOfItems(inSection: section) == 1  {
           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)
       }
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
   }
}
extension OrderDetailsViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order?.lineItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orderDetailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemColletionViewCellCollectionViewCell", for: indexPath) as? OrderItemColletionViewCellCollectionViewCell
        orderDetailsCell?.cellSetUp(order: order?.lineItems?[indexPath.row] ?? OrderLineItems(),currency: order?.currencyType ?? "")
        
        return orderDetailsCell ?? OrderItemColletionViewCellCollectionViewCell()
        
    }
}
