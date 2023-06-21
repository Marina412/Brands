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
    public func isSelected(_ selected: Bool,index:Int) {
        setSelected(selected, animated: false)
        let image = selected ? checked : unchecked
        icon.image = image
        if selected{
            switch index{
            case 0 :
                UserDefaults.standard.set(Constant.EGYPT_CURRENCY, forKey: Constant.CURRENCY)
            case 1 :
                UserDefaults.standard.set(Constant.AMERICAN_CURRENCY, forKey: Constant.CURRENCY)
            case 2 :
                UserDefaults.standard.set(Constant.EUROPE_CURRENCY, forKey: Constant.CURRENCY)
            case 3 :
                UserDefaults.standard.set(Constant.SAR_CURRENCY, forKey: Constant.CURRENCY)
            case 4 :
                UserDefaults.standard.set(Constant.UAE_CURRENCY, forKey: Constant.CURRENCY)
                
            default:
                print("")
            }
        } 
    }
}
