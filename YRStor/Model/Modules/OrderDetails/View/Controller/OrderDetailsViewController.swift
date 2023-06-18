//
//  OrderDetailsViewController.swift
//  YRStor
//
//  Created by marina on 15/06/2023.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
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
        orderDate.text = order?.created_at
        adress.text = order?.note
        payedBy.text = order?.reference
        totalPrice.text = order?.current_total_price
    }
    private func registerXibCells(){
        itemsCollectionView.register(UINib(nibName: "OrderItemColletionViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OrderItemColletionViewCellCollectionViewCell")
    }
}

extension OrderDetailsViewController : UICollectionViewDelegate{
    
}
extension OrderDetailsViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order?.line_items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orderDetailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemColletionViewCellCollectionViewCell", for: indexPath) as? OrderItemColletionViewCellCollectionViewCell
        orderDetailsCell?.cellSetUp(order: order?.line_items?[indexPath.row] ?? OrderProductItems())
        
        return orderDetailsCell ?? OrderItemColletionViewCellCollectionViewCell()
        
    }
}
