//
//  Persona.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/25/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import RealmSwift


class Person: Object {
    @objc dynamic var rut = 0
    @objc dynamic var nombre = ""
    @objc dynamic var apellMat = ""
    @objc dynamic var apellPat = ""
    @objc dynamic var descripcionCiudad = ""
    @objc dynamic var codCiudad = 0
    @objc dynamic var comuna = ""
    @objc dynamic var codComuna = 0
    @objc dynamic var region = ""
    @objc dynamic var codRegion = 0
    @objc dynamic var calle = ""
    @objc dynamic var email = ""
    @objc dynamic var telefono = 0
    @objc dynamic var codTele = 0
    @objc dynamic var celular = 0
    @objc dynamic var codCel = 0
    
}

class BancoUser: Object {
    @objc dynamic var numero = 0
    @objc dynamic var banco = ""
    @objc dynamic var codBanco = 0
    @objc dynamic var tipo = ""
     @objc dynamic var codTipo = 0
  
 
    
}

class TipoBanco : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = ""
}


class Banco : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = ""
}
class Region : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = ""
}

class Ciudad : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = ""
}
class Comuna : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = ""
}

class CodArea : Object {
    @objc dynamic var codigo = 0
    @objc dynamic var descripcion = 0
}

class Empresa: Object {
    @objc dynamic var rutEmpresa = 0
}

