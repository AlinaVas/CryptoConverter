//
//  APIManager.swift
//  CryptoConverter
//
//  Created by Alina Fesyk on 4/5/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    private let apiKey = "77537db6-78b4-4444-9f9c-8f52c572f15a"
    
    private init() {}
    
    
    /*
    *   MARK: - API requests for CryptoListPresenter
    */
    
    // API call to get list of cryptocurrency with its price
    
    func requestCryptoList(completion: @escaping (Result<[Crypto], CustomError>) -> Void) {
        
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest") else {
            completion(.failure(.badURLFormat))
            return
        }
        
        let parameters = ["start" : "1",
                          "limit" : "1000"]
        
        let headers = ["X-CMC_PRO_API_KEY" : apiKey]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON {
            response in
            
            guard response.result.isSuccess else {
                completion(.failure(.serverResponseIsFailure))
                return
            }
            
            guard let data = response.data  else {
                completion(.failure(.responseDataUnavailable))
                return
            }
            
            completion(self.getCryptoListFromJSON(from: data))
        }
    }
    
    // Parse JSON with response info
    
    func getCryptoListFromJSON(from data: Data) -> Result<[Crypto], CustomError> {
        var cryptoList: [Crypto] = []

        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let data = jsonResponse["data"] as? [[String:Any]] {
                    for item in data {
                        if let name = item["name"] as? String  {
                            if let id = item["id"] as? Int {
                                if let quote = item["quote"] as? [String:Any] {
                                    if let usd = quote["USD"] as? [String:Any] {
                                        if let price = usd["price"] as? Double {
                                            cryptoList.append(Crypto(id: id, name: name, priceUSD: price))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            return .failure(.custom(error.localizedDescription))
        }
        
        if cryptoList.isEmpty {
            return .failure(.responseDataUnavailable)
        } else {
            return .success(cryptoList)
        }
    }
    
    
    /*
     *   MARK: - API requests for ConverterPresenter
     */
    
    // API call to get logo and symbolic name for specific cryptocurrency
    
    func getDetailsForCrypto(with id: Int, completion: @escaping (Result<(symbol: String, logoURL: String), CustomError>) -> Void) {
        
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info") else {
            completion(.failure(.badURLFormat))
            return
        }
        
        let parameters = ["id" : "\(id)"]
        
        let headers = ["X-CMC_PRO_API_KEY" : apiKey]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON {
            response in
            
            guard response.result.isSuccess else {
                completion(.failure(.serverResponseIsFailure))
                return
            }
            
            guard let data = response.data  else {
                completion(.failure(.responseDataUnavailable))
                return
            }
            
            completion(self.getCryptoDetailsFromJSON(from: data, cryptoId: id))
        }
    }
    
    
    // Parse JSON with responce
    
    func getCryptoDetailsFromJSON(from data: Data, cryptoId: Int) -> Result<(symbol: String, logoURL: String), CustomError> {
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                if let data = jsonResponse["data"] as? [String : Any] {
                    if let idInfo = data["\(cryptoId)"] as? [String : Any] {
                        if let symbol = idInfo["symbol"] as? String {
                            if let logo = idInfo["logo"] as? String {
                                return .success((symbol: symbol, logoURL: logo))
                            }
                        }
                    }
                }
            }

        } catch {
            return .failure(.custom(error.localizedDescription))
        }
        return .failure(.responseDataUnavailable)
    }
    
    
    // Download image with URL
    
    func downloadImageData(from url: URL?, completion: @escaping (Data?) -> Void) {
        guard url != nil else { return }
        
        Alamofire.request(url!).responseData { response in
            guard let data = response.data, response.error == nil else { return }
            completion(data)
        }
        
    }
}
