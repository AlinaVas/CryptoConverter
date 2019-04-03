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
    
    private var cryptoList: [Crypto] = []
    
    
    
    init() {
        getCryptoList()
    }
    
    //    completion: (Result<(URLResponse, Data), Failure>) -> Void
    func getCryptoList() {
        
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest") else {
            //            completion(.failure(.badURLFormat))
            print("badurl")
            return
        }
        
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            //            completion(.failure(.apiNotProvided))
            print("no api")
            return
        }
        
        let parameters = ["start" : "1",
                          "limit" : "2",
                          "convert" : "USD"]
        
        let headers = ["X-CMC_PRO_API_KEY" : apiKey]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers) .responseJSON {
            response in
            
            guard response.result.isSuccess, let value = response.value else {
                //                completion(.failure(.failure(<#T##Error#>)))
                print("server is error \(response)")
                return
            }
            //            handleSuccess(data: response.result.value)
            print("VALUE*************************************", value)
            //                print("RESPONSE*************************************", response)
        }
        
    }
    
    func handleError(error: Error) {
        
    }
    
    func handleSuccess(data: Data) {
        
    }
    
}

extension CryptoListPresenter {
    
    func getNumberOfRows() -> Int {
        return cryptoList.count
    }
    
    func getCryptoName(at index: Int) -> String {
        return cryptoList[index].name
    }
    
    func getCryptoPriceUSD(at index: Int) -> String {
        return String(cryptoList[index].priceUSD)
    }
}
