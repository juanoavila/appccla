//
//  SolpagodepositoData.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 07-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation


struct CodigoAreaListResponse: Decodable{
    var data:DataCodigoAreaResponse
    var status: String
}

struct DataCodigoAreaResponse: Decodable{
    var codigoAreaParticular: [CodigoAreaResponse]
}

struct CodigoAreaResponse: Decodable{
    var descripcion: Int
    var codigo: Int
}
