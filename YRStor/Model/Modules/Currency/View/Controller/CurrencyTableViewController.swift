//
//  CurrencyTableViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 08/06/2023.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    var currencyVM: CurrencyViewModel!
    var currencyLists: [Currency] = [
          Currency(flagImage:"EgyptFlag" ,currencyName: Constant.EGYPT_CURRENCY, selected: false),
          Currency(flagImage:"AmericaFlag",currencyName: Constant.AMERICAN_CURRENCY, selected: false),
          Currency(flagImage:"EuropeFlag",currencyName: Constant.EUROPE_CURRENCY, selected: false),
          Currency(flagImage:"SARFlag",currencyName:Constant.SAR_CURRENCY, selected: false),
          Currency(flagImage:"UAEFlag",currencyName: Constant.UAE_CURRENCY, selected: false)]
      private var selectedCurrency: Int? {
          didSet {
              tableView.reloadData()
          }
      }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Shopify"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonTableViewCell")
       
    }
    private func updateSelectedIndex(_ index: Int) {
        selectedCurrency = index
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return currencyLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as? RadioButtonTableViewCell else { fatalError("Cell Not Found") }
        cell.selectionStyle = .none
        cell.flagImage.image = UIImage(named: currencyLists[indexPath.row].flagImage)
        cell.currencyName.text = currencyLists[indexPath.row].currencyName
        let selected = indexPath.row == selectedCurrency
        cell.isSelected(selected,index:indexPath.row)
        return cell
  
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelectedIndex(indexPath.row)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Currency"
        }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
   
   
}
