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
        requestCryptoList()
    }
    
    func requestCryptoList() {
        
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest") else {
            print("badurl")
            return
        }
        
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            print("no api")
            return
        }
        
        let parameters = ["start" : "1",
                          "limit" : "1000"]
        
        let headers = ["X-CMC_PRO_API_KEY" : apiKey]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON {
            response in
            
            guard response.result.isSuccess else {
                print("server is error \(response)")
                return
            }
            
            guard let data = response.data  else {
                print("no data")
                return
            }

            self.extractCryptoInfo(from: data)
        }
    }
    
    func handleError(error: Error) {
        // parse status to get error msg
    }
    
    func extractCryptoInfo(from data: Data) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let data = jsonResponse["data"] as? [[String:Any]] {
                    for item in data {
                        if let name = item["name"] as? String  {
                            if let id = item["id"] as? Int {
                                if let quote = item["quote"] as? [String:Any] {
                                    if let usd = quote["USD"] as? [String:Any] {
                                        if let price = usd["price"] as? Double {
                                            self.cryptoList.append(Crypto(id: id, name: name, priceUSD: price))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            print("********************",cryptoList.count)
            DispatchQueue.main.async {
                self.viewDelegate?.updateTable()
            }
            
        } catch {
            print("error parsing : \(error.localizedDescription)")
        }
    }
    
    func getCryptoFromList(at index: Int) -> Crypto {
        return cryptoList[index]
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
        let priceString = String(format: "%.3f", arguments: [cryptoList[index].priceUSD])
        return "\(priceString) USD"
    }
}
