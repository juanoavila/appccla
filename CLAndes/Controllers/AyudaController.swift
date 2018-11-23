//
//  AyudaController.swift
//  mySidebar2
//
//  Created by admin on 10/2/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

import UIKit
import RealmSwift
var loadingView : LoadingView!
var urlFace : URL = URL.init(string:"https://www.facebook.com/CajaLosAndesCL")!
var urlTwit : URL = URL.init(string:"https://twitter.com/cajalosandes")!
var urlInsta : URL = URL.init(string:"https://www.instagram.com/cajalosandes/")!
var urlEscribenos : URL = URL.init(string: "https://sucursalvirtual2.cajalosandes.cl/ccafandes/publico/contacto_new.asp")!

class AyudaController: UIViewController{
    
    @IBAction func irFace(_ sender: Any) {
        UIApplication.shared.openURL(urlFace)
    }
    @IBAction func irTwit(_ sender: Any) {
        UIApplication.shared.openURL(urlTwit)
    }
    @IBAction func irInsta(_ sender: Any) {
        UIApplication.shared.openURL(urlInsta)
    }
    @IBAction func llamanos(_ sender: Any) {
        let url  = URL(string: "tel:6005100000")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func escribenos(_ sender: Any) {
        UIApplication.shared.openURL(urlEscribenos)
    }
    
    override func viewDidLoad() {
        self.title = "¡Te Ayudamos!"
    }
    
    
    
    
}
