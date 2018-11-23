//
//  Otro.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/17/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import RealmSwift

class MenuesIos: Object{
       var menues = List<MenuIos>()
    
}
class MenuIos: Object {
    @objc dynamic var titulo = ""
    @objc dynamic var vista_ios = ""
    @objc dynamic var visible = ""
    let owners = LinkingObjects(fromType: MenuesIos.self, property: "menues")
}

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = ""
    @objc dynamic var mas = ""
}



