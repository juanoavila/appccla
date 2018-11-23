//
//  BancosData.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 06-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

//Listado de bancos
struct BancosListResponse:Decodable{
    var data:DataBancosListResponse
    var status: String = ""
}

struct DataBancosListResponse:Decodable{
    var bancos: [BancoResponse]
}

/*
struct BancoResponse:Decodable{
    var descripcion: String = ""
    var codigo: Int = 0
}*/

//Listado de tipos de cuentas

struct TiposCuentasResponse:Decodable{
    var data:DataTipoCuentasResponse
    var status: String = ""
}

struct DataTipoCuentasResponse: Decodable{
    var detalle: [TipoCuentaResponse]
}

/*
struct TipoCuentaResponse:Decodable{
    var descripcion: String = ""
    var codigo: String = ""
}*/
