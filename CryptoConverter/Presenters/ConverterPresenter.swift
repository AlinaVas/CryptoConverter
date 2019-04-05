//
//  ConverterPresenter.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/4/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import Foundation

//  MARK: - ConverterPresenterDelegate (required methods for viewDelegate's UI updates)

protocol ConverterPresenterDelegate: class {
    func updateLogo(with imageData: Data)
    func updateCryptoNameLabel(with symbol: String)
    func showAlert(msg: String)
}


//  MARK: - CryptoListPresenter

class ConverterPresenter {
    
    weak var viewDelegate: ConverterPresenterDelegate?
    
    private let apiKey = "77537db6-78b4-4444-9f9c-8f52c572f15a"
    private let selectedCrypto: Crypto
    private var logoImageURL: URL? {
        didSet {
            downloadLogo()
        }
    }
    private var cryptoSymbolicName: String = ""
    
    init(crypto: Crypto) {
        selectedCrypto = crypto
        getCryptoLogoAndSymbolicName()
    }
    
    // Get logo and symbolic name for specific cryptocurrency
    
    func getCryptoLogoAndSymbolicName() {
        
        APIManager.shared.getDetailsForCrypto(with: selectedCrypto.id) { result in
            switch result {
            case .success(let symbol, let logoURL):
                self.viewDelegate?.updateCryptoNameLabel(with: symbol)
                self.logoImageURL = URL(string: logoURL)
            case .failure(let error):
                self.viewDelegate?.showAlert(msg: "\(error)")
            }
        }
    }
    
    // Get logo image data for specific cryptocurrency
    
    func downloadLogo() {
        APIManager.shared.downloadImageData(from: logoImageURL) { imageData in
            guard let imageData = imageData else { return }
            self.viewDelegate?.updateLogo(with: imageData)
        }
    }
    
    
    // Method for currency conversion
    
    func convert(amount: String, isDirectConversion: Bool) -> String? {
        guard amount != "" else { return "" }
        
        guard let amount = Double(amount) else {
            viewDelegate?.showAlert(msg: CustomError.badUserInput.description)
            return nil
        }
        
        let rate = isDirectConversion ? selectedCrypto.priceUSD : 1 / selectedCrypto.priceUSD
        return String(amount * rate)
    }
}
