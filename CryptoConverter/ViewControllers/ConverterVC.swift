//
//  ViewController.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/3/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import UIKit

class ConverterVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var presenter: ConverterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDelegate = self
        setUpViews()
    }
    
    private func setUpViews() {
        toLabel.text = "USD"
        
        toTextField.isUserInteractionEnabled = false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: true)
        
        fromTextField.delegate = self
        fromTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func swapButtonPressed(_ sender: UIButton) {
        swap(&fromLabel.text!, &toLabel.text!)
        fromTextField.text = toTextField.text
        
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
    }
}

//  MARK: - UITextField methods

extension ConverterVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
        
        textField.resignFirstResponder()
        return false
    }
    
    
    // Custom method that is called on any changes of text in UITextField
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
    }
}



//  MARK: - ConverterPresenterDelegate methods for updating UI

extension ConverterVC: ConverterPresenterDelegate {
    
    func updateLogo(with imageData: Data) {
        logoImageView.image = UIImage(data: imageData)
    }
    
    func updateCryptoNameLabel(with symbol: String) {
        fromLabel.text = symbol
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}


