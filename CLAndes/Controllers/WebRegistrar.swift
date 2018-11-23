//
//  WebRegistrar.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/22/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

class WebRegistrar : UIViewController {
    @IBOutlet weak var weView: UIWebView!
    
    
    override func viewDidLoad() {
        self.title = "Registrate"
        if let url = NSURL(string: "https://misucursal.cajalosandes.cl/webcenter/portal/creacionclave") {
            let request = NSURLRequest(url: url as URL)
            weView.loadRequest(request as URLRequest)
        }
    }
    
}
