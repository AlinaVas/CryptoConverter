//
//  CryptoListVC.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/3/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import UIKit

class CryptoListVC: UITableViewController {

    var presenter = CryptoListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDelegate = self
        setTableView()
    }
    
    private func setTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 43
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRows()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoCell
        cell.nameLabel.text = presenter.getCryptoName(at: indexPath.row)
        cell.priceLabel.text = presenter.getCryptoPriceUSD(at: indexPath.row)
        return cell
    }
    
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let converterVC = storyboard?.instantiateViewController(withIdentifier: "ConverterVC") as! ConverterVC
        converterVC.presenter = ConverterPresenter(crypto: presenter.getCryptoItemFromList(at: indexPath.row))
        navigationController?.pushViewController(converterVC, animated: true)
    }
}



//  MARK: - CryptoListPresenterDelegate methods for updating UI

extension CryptoListVC: CryptoListPresenterDelegate {
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Oops!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
