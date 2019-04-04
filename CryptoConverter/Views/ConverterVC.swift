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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        
        guard fromTextField.text != "" else { return }
        let directConversion = toLabel.text == "USD" ? true : false
        toTextField.text = presenter?.convert(amount: fromTextField.text!, isDirectConversion: directConversion)
    }
    
    @IBAction func swapButtonPressed(_ sender: UIButton) {
        swap(&fromLabel.text!, &toLabel.text!)
        fromTextField.text = toTextField.text
        
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

