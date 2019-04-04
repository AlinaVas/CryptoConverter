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
    @IBOutlet weak var convertButton: UIButton!
    
    var presenter: ConverterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        presenter?.viewDelegate = self
        
        toTextField.isUserInteractionEnabled = false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: true)
        
        fromTextField.delegate = self
        fromTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func convertButtonPressed(_ sender: UIButton) {
        guard fromTextField.text != "" else { return }
        
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
        
        fromTextField.resignFirstResponder()
    }
    
    @IBAction func swapButtonPressed(_ sender: UIButton) {
        swap(&fromLabel.text!, &toLabel.text!)
        fromTextField.text = toTextField.text
        
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
    }
}

extension ConverterVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
        
        textField.resignFirstResponder()
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
    }
}

extension ConverterVC: ConverterDelegate {
    func updateLogo(with imageData: Data) {
        logoImageView.image = UIImage(data: imageData)
    }
    
    func updateNameLabel(with symbol: String) {
        fromLabel.text = symbol
    }
    
}


