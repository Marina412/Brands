//
//  RadioButtonTableViewCell.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 08/06/2023.
//

import UIKit

class RadioButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    private let checked = UIImage(systemName: "circle.fill")
    private let unchecked = UIImage(systemName: "circle")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    public func configure(_ currency:Currency) {
        currencyName.text = currency.currencyName
        flagImage.image = UIImage(named: currency.flagImage)
    }
    public func isSelected(_ selected: Bool) {
        setSelected(selected, animated: false)
        let image = selected ? checked : unchecked
        icon.image = image
        let defaults = UserDefaults.standard
        defaults.set(currencyName.text, forKey: Constant.CURRENCY)
        
    }
    
}
