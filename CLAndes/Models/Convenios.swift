//
//  Convenios.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/9/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
class Convenios2: Codable{
    var convenios: [Convenio2]? = []
    
}

class Convenio2: Codable {
    let servicios: String?
    let horario: String
    let nombreSucursal: String?
    
    private enum CodingKeys: String, CodingKey {
        case servicios = "servicios"
        case horario = "horario"
        case nombreSucursal = "nombreSucursal"
    }
}
