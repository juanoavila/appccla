//
//  Overlay.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 18-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

public class Overlay{
    
    class var shared: Overlay {
        struct Static {
            static let instance: Overlay = Overlay()
        }
        return Static.instance
    }
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    public func showOverlay(view: UIView){
        //creating overlay
        overlayView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.clipsToBounds = true
        
        //creating activityIndicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        //adding subviews
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        overlayView.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    public func showOverlayWithCustomColor(view: UIView, color: UIColor){
        //creating overlay
        overlayView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        overlayView.center = view.center
        overlayView.backgroundColor = color
        overlayView.clipsToBounds = true
        
        //creating activityIndicator
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        //adding subviews
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        overlayView.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlay(){
        //remove views
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    
}
