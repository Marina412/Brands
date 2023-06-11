//
//  CurrencyTableViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 08/06/2023.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    var currencyVM: CurrencyViewModel!
    private var selectedCurrency: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return currencyVM.currencyLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as? RadioButtonTableViewCell else { fatalError("Cell Not Found") }
        cell.selectionStyle = .none
        cell.flagImage.image = UIImage(named: currencyVM.currencyLists[indexPath.row].flagImage)
        cell.currencyName.text = currencyVM.currencyLists[indexPath.row].currencyName
        let selected = indexPath.row == selectedCurrency
        cell.isSelected(selected)
        return cell
  
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelectedIndex(indexPath.row)
    }
   
}
