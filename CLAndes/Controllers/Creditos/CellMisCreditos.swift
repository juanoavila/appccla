//
//  CellTableMisDatos.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/12/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import Foundation

class CellMisCreditos: UITableViewCell {

    @IBOutlet weak var lblFechaOtor: UILabel!
    
    @IBOutlet weak var estadoLbl: UILabel!
    @IBOutlet weak var lblMonto: UILabel!
    @IBOutlet weak var lblvalorMonto: UILabel!
    
    
    func setDatos(datos : MisCreditosData)  {
        lblFechaOtor.text = datos.fechaOtorg
        lblMonto.text = String(datos.monto)
        lblvalorMonto.text = datos.estado
    }
}
