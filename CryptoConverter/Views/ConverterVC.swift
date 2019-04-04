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
    @IBOutlet weak var VerticalCenteringConstraint: NSLayoutConstraint!
    
    var presenter: ConverterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        toTextField.isUserInteractionEnabled = false
        
        presenter?.viewDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillLayoutSubviews() {
//        switch UIDevice.current.orientation {
//        case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown:
//            print(<#T##items: Any...##Any#>)
//        case .landscapeLeft, .landscapeRight:
//            print(<#T##items: Any...##Any#>)
//        }
//
//    }
    
    
    
}

extension ConverterVC: ConverterDelegate {
    func updateLogo(with imageData: Data) {
        logoImageView.image = UIImage(data: imageData)
    }
    
    func updateNameLabel(with symbol: String) {
        fromLabel.text = symbol
    }
    
    
    
}

