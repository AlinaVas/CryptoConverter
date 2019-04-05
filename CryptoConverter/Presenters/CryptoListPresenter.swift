//
//  CryptoListPresenter.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/3/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation

//  MARK: - ConverterPresenterDelegate (required methods for viewDelegate's UI updates)

protocol CryptoListPresenterDelegate: class {
    func updateTable()
    func showAlert(msg: String)
}


//  MARK: - CryptoListPresenter

class CryptoListPresenter {
    
    weak var viewDelegate: CryptoListPresenterDelegate?
    
    private var cryptoList: [Crypto] = []
    
    init() {
        getCryptoList()
    }
    
    
    // Get the list of cruptocurrency and its current price in USD
    
    func getCryptoList() {
        APIManager.shared.requestCryptoList { result in
            switch result {
            case .success(let cryptoList):
                self.cryptoList = cryptoList
                self.viewDelegate?.updateTable()
            case .failure(let error):
                self.viewDelegate?.showAlert(msg: error.description)
            }
        }
    }
    
    
    // Returns a Crypto from cryptoList (to pass to ConverterPresenter)
    
    func getCryptoItemFromList(at index: Int) -> Crypto {
        return cryptoList[index]
    }
}


// Helpers for UITableView DataSource methods

extension CryptoListPresenter {
    
    func getNumberOfRows() -> Int {
        return cryptoList.count
    }
    
    func getCryptoName(at index: Int) -> String {
        return cryptoList[index].name
    }
    
    func getCryptoPriceUSD(at index: Int) -> String {
        let priceString = String(format: "%.3f", arguments: [cryptoList[index].priceUSD])
        return "\(priceString) USD"
    }
}
