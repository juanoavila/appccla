//
//  LicenciaCell.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 26-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

class LicenciaCell: UITableViewCell {
    
    @IBOutlet weak var fechaRecepcionTitleLabel: UILabel!
    @IBOutlet weak var fechaRecepcionLabel: UILabel!
    
    @IBOutlet weak var estadoLicenciaTitleLabel: UILabel!
    @IBOutlet weak var estadoLicenciaLabel: UILabel!
    
    
    func configurateTheCell(_ licencia: LicenciaResponse) {
        self.fechaRecepcionLabel.text = UtilDate.formatDate(input: licencia.VFechaRecepcion)
        self.estadoLicenciaLabel.text = licencia.VEstado

        self.estadoLicenciaLabel.frame = CGRect(x: estadoLicenciaLabel.frame.minX, y: estadoLicenciaLabel.frame.minY,
            width: estadoLicenciaLabel.frame.width, height: CGFloat(estadoLicenciaLabel.calculateMaxLines() * 20))

    }
    
}
