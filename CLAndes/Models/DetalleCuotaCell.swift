//
//  DetalleCuotaCell.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 05-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

class DetalleCuotaCell: UITableViewCell {

    @IBOutlet weak var mensajeTituloLabel: UILabel!
    
    @IBOutlet weak var valorCuotaLabel: UILabel!
    
    @IBOutlet weak var fechaPagoLabel: UILabel!
    @IBOutlet weak var btnLiquidacion: UIButton!
    
    var navigation = UINavigationController()
    var cuota = 0
    var folio = 0
    var sucursal = ""
    
    func configurateTheCell(_ cuota: CuotaResponse, totalCuotas: Int, numCuota: Int, sucursal: String, folio: Int, navigation: UINavigationController?, index: Int) {
        self.navigation = navigation ?? UINavigationController()
        self.cuota = cuota.numero
        self.folio = folio
        self.sucursal = sucursal
        self.mensajeTituloLabel.text = "Cuota \(numCuota) de \(totalCuotas)"
        self.valorCuotaLabel.text = "\(cuota.monto.FormatMoney())"
        self.fechaPagoLabel.text = UtilDate.formatDate(input: cuota.fechaEfectPago)
        
        btnLiquidacion.tag = index + 1
        btnLiquidacion.addTarget(self, action: #selector(abrirModulo), for: .touchUpInside)
    }
    
    @objc func abrirModulo(sender: UIButton!) {
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
        
            let index = sender.tag
            
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "LicenciaLiquidacionViewControllerIdentity") as? LicenciaLiquidacionViewController{
                
                vc.url = "http://sucursalvirtual.cajalosandes.cl:8080/CCAFAndes2/VirtualPersona/LicenciasMedicas/LiquidacionCuotaLicencia.asp?Cuota=\(index)&Folio=\(self.folio)&Sucursal=\(self.sucursal)"
                
                self.navigation.pushViewController(vc, animated: true)
            }
        }
    }
}
