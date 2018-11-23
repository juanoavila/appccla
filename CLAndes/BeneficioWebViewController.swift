//
//  BeneficioWebViewController.swift
//  Beneficios
//
//  Created by Diego Corbinaud on 30-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit
import WebKit

class BeneficioWebViewController: UIViewController, WKUIDelegate {

    var url = ""
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        if (url.lowercased().range(of: "http") == nil){
            url = "http://\(url)"
        }
        
        let url2 = URL(string: url)!
        webView.loadRequest(URLRequest(url: url2))
        
        view.addSubview(webView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
