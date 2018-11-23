//
//  EmpresaData.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 08-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

struct ListEmpresasResponse:Decodable{
    var data: DataEmpresaResponse?
    var status: String?
}

struct DataEmpresaResponse: Decodable{
    var empresas: [EmpresaResponse]?
}

struct EmpresaResponse: Decodable{
    var datosEmpresa: DatosEmpresaResponse?
}

struct DatosEmpresaResponse: Decodable{
    var rut: Int = 0
}

struct informacionComercialListResponse: Decodable {
    var informacionComercial:[informacionComercialResponse]
}

struct informacionComercialListResponseSimple: Decodable {
    var informacionComercial:informacionComercialResponse
}
struct informacionComercialResponse: Decodable{
    var empresa:EmpresaUserResponse
}

struct EmpresaUserResponse:Decodable {
    var rut: Int
}
