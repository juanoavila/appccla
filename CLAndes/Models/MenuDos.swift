//
//  MenuDos.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/17/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import RealmSwift


 class MenuDos: Object {
    @objc dynamic var titulo = ""
    @objc dynamic var vista_ios = ""
    @objc dynamic var visible = ""
    
   
}
class MenuesDos: Object{
      var menues = List<MenuDos>()
    
}
func listToArray() {
    let objectsArray = [MenuDos(), MenuDos(), MenuDos(), MenuDos(), MenuDos()]
    let objectsRealmList = List<MenuDos>()
    
    // this one is illegal
    //objectsRealmList = objectsArray
    
    for object in objectsArray {
        objectsRealmList.append(object)
    }
    
    // storing the data...
    let realm = try! Realm()
    try! realm.write {
        realm.add(objectsRealmList)
    }
}
