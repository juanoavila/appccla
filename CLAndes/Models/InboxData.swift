//
//  InboxData.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 19-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

struct InboxGetResponse: Decodable{
    var codigo: String?
    var mensaje: String?
    var respuesta: [MensajeResponse]?
}

struct MensajeResponse: Decodable {
    var id: String?
    var titulo: String?
    var rut_usuario: String?
    var mensaje: String?
    var push: String?
    var codigo: String? = ""
    var created_at: String?
    var leido: String?
}

struct InboxDefaultResponse: Decodable {
    var codigo: String?
    var mensaje: String?
}
