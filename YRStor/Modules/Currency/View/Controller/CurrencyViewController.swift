//
//  CurrencyViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 05/06/2023.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet weak var uaeDirhamBtn: UIButton!
    @IBOutlet weak var sarRiyalBtn: UIButton!
    @IBOutlet weak var euroBtn: UIButton!
    @IBOutlet weak var dollarBtn: UIButton!
    @IBOutlet weak var poundBtn: UIButton!
    var uncheckedFlag = false
    var checkedFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func poundAction(_ sender: UIButton) {
        if(uncheckedFlag == false){
            sender.setBackgroundImage(UIImage(systemName: "circle.fill"), for: UIControl.State.normal)
//            dollarBtn.setBackgroundImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
            uncheckedFlag = true
            checkedFlag = false
        }
    }
    
    @IBAction func dollarAction(_ sender: UIButton) {
        if(checkedFlag == false){
            sender.setBackgroundImage(UIImage(systemName: "circle.fill"), for: UIControl.State.normal)
            checkedFlag = true
            uncheckedFlag = false
        }
    }
    
   
    @IBAction func euroAction(_ sender: Any) {
    }
    
    @IBAction func riyalAction(_ sender: Any) {
    }
    
    @IBAction func dirhamAction(_ sender: Any) {
    }
}
