//
//  LicenciaLiquidacionViewController.swift
//  CajaLosAndesApp
//
//  Created by Diego Corbinaud on 07-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import WebKit

class LicenciaLiquidacionViewController: UIViewController {
    
    var url = ""
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.webView.backgroundColor = .white
        let barHeight=self.navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
        let height =  barHeight + statusBarHeight
        self.webView.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let url2 = URL(string: url)!
        self.webView.loadRequest(URLRequest(url: url2))
        
        let doubleTap = UIGestureRecognizer(target: self, action: #selector(LicenciaLiquidacionViewController.OnDoubleTap(_:)))
        
        self.webView.scrollView.addGestureRecognizer(doubleTap)
        self.webView.scrollView.setZoomScale(1, animated: true)
        
        view.addSubview(self.webView)
        
    }
    
    @objc func OnDoubleTap(_ recognizer: UIGestureRecognizer){
        
        if (self.webView.scrollView.zoomScale >= 1){
            self.webView.scrollView.setZoomScale(0.75, animated: true);
        }else{
            self.webView.scrollView.setZoomScale(1.25, animated: true);
        }
        self.webView.scrollView.isScrollEnabled = true;
        
    }
    
    
}

extension LicenciaLiquidacionViewController: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
    }
}
