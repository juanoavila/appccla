//
//  LicenciasServices.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 25-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class LicenciasService: NSObject {
     //var licencias =  LicenciasSrvResponse()
    
    var listLicencias = [LicenciaResponse]()
    let group = DispatchGroup()
    
    static func obtenerLicenciaDetail(folio: Int, rutEmpresa: String, sucursal: String) -> LicenciasDetailResponse {

        var data = DataLicDetailResponse()
        
        data.fechaResolucionCompin = "erwrwer"
        data.estado = "Pagada"
        data.rutTrabajador = "4363646-4"
        data.fechaEnvioCompin = ""
        data.centroCotizacion = "CALLE RANCAGUA"
        data.fechaInicioReposo = ""
        data.resolucionCompin = " "
        data.gestionCompin = "Autorizada por COMPIN."
        data.nombre = "RETAMALES ARANDA LORENZO ULDARICO"
        data.fechaTerminoReposo = ""
        data.folioCaja = 832011
        data.fechaPago = ""
        data.numeroLicencia = 5207058
        data.fechaEmisionLicencia = ""
        data.fechaRecepcionCLA = ""
        data.variacion = " "
        data.sucursalEmpresa = 1
        data.tipoLicencia = "LME"
        data.diasReposo = 11
        data.sucursalRecepcion = "09"
        data.observaciones = " "
        data.tipoSubsidio = "SIL"
        
        var dcr = DisponibleCobroResponse()
        dcr.continuidad = "N"
        dcr.baseCalculoSubsidio = 10822
        dcr.montoCotizado = 8344
        dcr.baseCalculoCotizado = 10836
        dcr.diasSubsidioAutorizadosParaPagar = 11
        dcr.montoPagado = 357135
        dcr.medioPago = "EFECTIVO"
        
        data.disponibleParaCobro = dcr
        
        var lic = LicenciasDetailResponse()
        lic.data = data
        lic.status = "success"
        
        return lic
    }
    
    
    static func obtenerDetalleCuotas(rutEmpresa: String, rut: String, nroLicencia: Int) -> CuotasResponse{
        
        var cuotas = CuotasResponse()
        var c1 = CuotaResponse()
        var c2 = CuotaResponse()
        var c3 = CuotaResponse()
        
        c1.fechaPagoSil = "31/07/2015"
        c1.estado = "Pagada"
        c1.monto = 119044
        c1.numero = 1
        c1.fechaEfectPago = "10/08/2015"
        c1.folio = "3-5207058"
        
        c2.fechaPagoSil = "31/08/2015"
        c2.estado = "Pagada"
        c2.monto = 119045
        c2.numero = 2
        c2.fechaEfectPago = "10/09/2015"
        c2.folio = "3-5207059"
        
        c3.fechaPagoSil = "31/09/2015"
        c3.estado = "Pagada"
        c3.monto = 119046
        c3.numero = 3
        c3.fechaEfectPago = "10/10/2015"
        c3.folio = "3-5207060"
        
        cuotas.status = "success"
        cuotas.errorCod = 0
        
        cuotas.data.cuotas?.append(c1)
        cuotas.data.cuotas?.append(c2)
        cuotas.data.cuotas?.append(c3)
        
        return cuotas
    }
}
