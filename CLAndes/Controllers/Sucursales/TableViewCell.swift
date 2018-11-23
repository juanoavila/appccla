//
//  TableViewCell.swift
//  CajaLosAndesIosNativo
//
//  Created by Diego Corbinaud on 08-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var kmsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(title: String, direction: String, distance: String){
        imageViewCell.image = #imageLiteral(resourceName: "sucurlas_circulo")
        tittleLabel.text = title
        directionLabel.text = direction
        kmsLabel.text = distance
    }
    
}
