//
//  ConvenioTableViewCell.swift
//  CajaLosAndesApp
//
//  Created by Diego Corbinaud on 14-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class ConvenioTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var descuento: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfig(titulo: String, distancia: String, descuento: String, imagen: String){
        
        switch(imagen){
        case "SALUD":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_salud")
            break
        case "EDUCACÍON":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_educacion")
            break
        case "TURISMO":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_viaje")
            break
        case "APOYO SOCIAL":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_social")
            break
        case "RECREACION":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_teatro")
            break
        case "EDUCACIÓN SUPERIOR":
            // set to false to disable all right utility buttons appearing
            self.imagen.image = UIImage(named: "circulo_educacion")
            break
        default:
            self.imagen.image = UIImage(named: "sucurlas_circulo")
            break
        }
        
        self.titulo.text = titulo
        self.distancia.text = distancia
        self.descuento.text = descuento
    }
    
}
