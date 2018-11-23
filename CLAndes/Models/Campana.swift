//
//  Campana.swift
//  Beneficios
//
//  Created by Diego Corbinaud on 29-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import Foundation

class Campana {
    var bajada: String = ""
    var url_imagen: String = ""
    var masiva: Bool = false
    var titulo: String = ""
    var accion = Accion()
    var funcionalidad = Funcionalidad()
    var prioridad = Prioridad()
    var boton = Boton()
}

class Accion{
    var codigo: String = ""
    var tipo: String = ""
    var destino: String = ""
}

class Funcionalidad {
    var codigo: String = ""
    var nombre: String = ""
}

class Prioridad {
    var codigo: String = ""
    var nombre: String = ""
}

class Boton {
    var texto: String = ""
    var color: String = ""
}

//struct Envelope: Decodable {
//    var EntObtenerCampaniaOutABM: EntObtenerCampaniaOutABM?
//}
//
//struct EntObtenerCampaniaOutABM: Decodable{
//    var response: response
//    var body: body
//}
//
//struct response: Decodable{
//    var mensaje: String
//    //var codigoRetorno: Int
//}
//
//struct body: Decodable{
//    var Campana: [Campana]
//}
//
//struct Campana: Decodable{
//    var accion: accion
//    var bajada: String
//    var boton: boton
//    var funcionalidad: funcionalidad
//    var masiva: Bool
//    var prioridad: prioridad
//    var titulo: String
//    var url_imagen: String
//}
//
//struct accion: Decodable{
//    var codigo: String
//    var destino: String
//    var tipo: String
//}
//
//struct boton: Decodable{
//    var color: String
//    var texto: String
//}
//
//struct funcionalidad: Decodable{
//    var codigo: String
//    var nombre: String
//}
//
//struct prioridad: Decodable{
//    var codigo: String
//    var nombre: String
//}
