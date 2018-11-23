//
//  Menu.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/9/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
class Menues: Codable{
    var menues: [Menu]? = []
    
}
class Menu: Codable {
    let titulo: String?
    let vista_ios: String
    let visible: String?
    
    private enum CodingKeys: String, CodingKey {
        case titulo = "titulo"
        case vista_ios = "vista_ios"
        case visible = "visible"
}
}
