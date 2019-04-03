//
//  CryptoListPresenter.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/3/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation
import Alamofire

protocol CryptoListDelegate: class {
    func updateTable()
}

class CryptoListPresenter {
    
    weak var viewDelegate: CryptoListDelegate?
    
    private var currency: [Crypto] = []
    
    
    
}

extension CryptoListPresenter {
    
    func getNumberOfRows() -> Int {
        return currency.count
    }
    
    func getCryptoName(at index: Int) -> String {
        return currency[index].name
    }
    
    func getCryptoPriceUSD(at index: Int) -> String {
        return String(currency[index].priceUSD)
    }
}
