//
//  Sucursales.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/5/18.
//  Copyright © 2018 akhil. All rights reserved.
//


import EVReflection

class Products: EVObject{
    var products: [Product]? = []
    
}

class Product: EVObject {
    var Envelope: AnyObject?
    var codigoSucursal: String = ""
    
    var servicios: String = ""
    var nombreSucursal: String = ""
    var longitud: String = ""
    var latitud: Int = 0
    var sucursalPilar: Int = 0
    var UserDistance: Bool = false
    var HasUserDistance: Bool = false
    
   
    
    

}



class Cart: EVObject {
    var numLocal: Int = 0
    var rut: String = ""
    var fecha: String = ""
    var items:[CartItem] = []
}

class Poll: EVObject {
    var numLocal: Int = 0
    var rut:String = ""
    var fecha:String = ""
    var cart:String = ""
    var score:Int = 0
    var comentarios: String = ""
}

class CartItem:EVObject {
    var ean: String = ""
    var price: Int = 0
    var quantity:Int = 0
}

class RestCart:EVObject {
    var cart: String = ""
    var status :Int = 0
}
