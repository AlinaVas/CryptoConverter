//
//  ConverterPresenter.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/4/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation
import Alamofire

protocol ConverterDelegate: class {
    func updateLogo(with imageData: Data)
    func updateNameLabel(with symbol: String)
    
}

class ConverterPresenter {
    
    weak var viewDelegate: ConverterDelegate?
    
    private let selectedCrypto: Crypto
    
    init(crypto: Crypto) {
        
        selectedCrypto = crypto
        getDetailsForCrypto(with: selectedCrypto.id)
    }
    
    
    
    func getDetailsForCrypto(with id: Int) {
        
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info") else {
            print("badurl")
            return
        }
        
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            print("no api")
            return
        }
        
        let parameters = ["id" : "\(id)"]
        
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
            
            self.extractDetails(from: data)
        }
    }
    
    
    
    func extractDetails(from data: Data) {
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
//                print("details", jsonResponse)
                if let data = jsonResponse["data"] as? [String : Any] {
                    if let idInfo = data["\(selectedCrypto.id)"] as? [String : Any] {
                        if let symbol = idInfo["symbol"] as? String {
                            DispatchQueue.main.async {
                                self.viewDelegate?.updateNameLabel(with: symbol)
                            }
                        }
                        if let logo = idInfo["logo"] as? String {
                            downloadImage(from: URL(string: logo))
                        }
                    }
                }
                
            }
            print("no")
        } catch {
            print("error \(error.localizedDescription)")
        }
        
    }
    
    
    
    func downloadImage(from url: URL?) {
        guard url != nil else { return }
        
        Alamofire.request(url!).responseData { response in
            guard let data = response.data, response.error == nil else { return }
            DispatchQueue.main.async {
                self.viewDelegate?.updateLogo(with: data)
            }
        }
    }
}
