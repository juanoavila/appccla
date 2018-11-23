//
//  SucursalesWebViewController.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/17/18.
//  Copyright © 2018 akhil. All rights reserved.
//


import UIKit
import WebKit

class SucursalesWebViewController: UIViewController {
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let url2 = URL(string: url)!
        webView.loadRequest(URLRequest(url: url2))
        
        view.addSubview(webView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
