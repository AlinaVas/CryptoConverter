//
//  TableViewCell.swift
//  CryptoConverter
//
//  Created by Alina FESYK on 4/3/19.
//  Copyright © 2019 Alina FESYK. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
