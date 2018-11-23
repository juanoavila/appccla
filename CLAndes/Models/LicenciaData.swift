//
//  LicenciaData.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 25-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

//Conjunto de estructuras para listado licencias
struct LicenciasSrvResponse: Codable {
    var data: dataLicResponse
    var status : String
}

struct dataLicResponse: Codable {
    var ListaLicenciasSalida: LicenciasResponse?
}

struct LicenciasResponse: Codable{
    var ListLicencias: [LicenciaResponse]?
}

struct LicenciaResponse: Codable{
    var VFechaRecepcion: String = ""
    var VRutPersona: String = ""
    var VNombrePersona: String = ""
    var VNumeroLicencia: Int = 0
    var VEstado: String = ""
    var VTipoLicencia: String = ""
    var VMostrarBotonSolicitar: Bool?
    var VMostrarBotonModificar: Bool?
    var VTipoFormulario: Int?
    var VFlag: Int?
}



//Conjunto de estructuras para detalle licencia

struct DetLicenciaSrvResponse: Decodable{
    var data: DataDetLicResponse
    var status : String
}

struct DataDetLicResponse: Decodable{
    var DetalleLicenciaSalida: LicenciaSalidaResponse
}

struct LicenciaSalidaResponse: Decodable{
    var DetalleLicencia: DetalleLicenciaResponse
}

struct DetalleLicenciaResponse: Decodable {
    var VFechaRecepcion: String = ""
    var VRutPersona: String = ""
    var VFechaTermino: String = ""
    var VFechaInicio: String = ""
    var VMedioPago: String = ""
    var VFechaEnvioCompin: String = ""
    var VNombrePersona: String = ""
    var VSucursalRec: String = "0"
    var VFechaEmision: String = ""
    var VDiasReposo:Int = 0
    var VTipoLicencia: String = ""
    var VFechaPago: String = ""
    var VTipoSubsidio: String = ""
    var VFolio: Int = 0
    var VEstado: String = ""
    var VNumeroLicencia: Int  = 0
}

struct EstadosTabuladosResponse: Decodable{
    var data: [EstadoResponse]?
    var status: String?
}

struct EstadoResponse: Decodable {
    var Alias: String = ""
    var Descripcion: String = ""
}

struct EstadosSolicitudPagoResponse:Decodable{
    var data: [EstadoSolPagoResponse]?
    var status: String?
}

struct EstadoSolPagoResponse:Decodable{
    var banco: Int = 0
    var nombreBanco: String = ""
    var estado: String = ""
    var tipoLicencia: String = ""
    var tipoFormulario: Int = 0
    var nroLicencia: Int = 0
    var nombreSucursal: String = ""
    var nroCuentaBanco: String = "0"
    var sucursalPago: String = "0"
    var tipoCuenta: String = ""
    var fechaSolicitudTransfer: String = ""
}


//Licencias Detail
struct LicenciasDetailResponse: Decodable{
    var data: DataLicDetailResponse?
    var status: String?
}


struct DataLicDetailResponse: Decodable{
    var fechaResolucionCompin: String = ""
    var estado: String = ""
    var rutTrabajador: String = ""
    var fechaEnvioCompin: String = ""
    var centroCotizacion: String = ""
    var fechaInicioReposo: String = ""
    var resolucionCompin: String = ""
    var gestionCompin: String = ""
    var disponibleParaCobro: DisponibleCobroResponse
    var nombre: String = ""
    var fechaTerminoReposo: String = ""
    var folioCaja: Int = 0
    var fechaPago: String = ""
    var numeroLicencia: Int = 0
    var fechaEmisionLicencia: String = ""
    var fechaRecepcionCLA: String = ""
    var variacion: String = ""
    var sucursalEmpresa: Int = 0
    var tipoLicencia: String = ""
    var diasReposo: Int = 0
    var sucursalRecepcion: String = "0"
    var observaciones: String = ""
    //var estadosTabulados: String = ""
    var tipoSubsidio: String = ""
    
    
    init(){
        self .disponibleParaCobro = DisponibleCobroResponse()
    }
}

struct DisponibleCobroResponse: Decodable{
    var continuidad: String = ""
    var baseCalculoSubsidio: Int = 0
    var montoCotizado: Int = 0
    var baseCalculoCotizado: Int = 0
    var diasSubsidioAutorizadosParaPagar: Int = 0
    var montoPagado: Int = 0
    var medioPago: String = ""
}

//Detalle cuota
struct CuotasResponse: Decodable{
    var data: DataCuotasResponse
    var errorCod: Int!
    var status: String!
    
    init(){
        self.data = DataCuotasResponse()
    }
}

struct DataCuotasResponse: Decodable{
    var cuotas: [CuotaResponse]?
    
    init(){
        self.cuotas = [CuotaResponse]()
    }
    
}

struct CuotaResponse: Decodable{
    var fechaPagoSil: String = ""
    var estado: String = ""
    var monto: Int = 0
    var numero: Int = 0
    var fechaEfectPago: String = ""
    var folio: String = ""
}


//Convenio SIL
struct ConvenioSILResponse:Decodable{
    var data: ConvenioResponse?
    var status: String = ""
}

struct ConvenioResponse: Decodable{
    var Convenio: String = ""
    var CodigoError: Int = 0
    var MensajeError: String = ""
}

//Numero Licencia

struct NumeroLicenciaResponce: Decodable{
    var data : [NumeroLicenciaDataResponse]?
    var status: String = ""
}

struct NumeroLicenciaDataResponse: Decodable{
    var fechaIni: String?
    var nroLicencia: Int?
    var nroFormulario: Int?
    var fechaFin: String?
    var diasLicencia: Int?
}
