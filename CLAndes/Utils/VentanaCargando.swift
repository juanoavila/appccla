//
//  VentanaCargando.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 23-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import SVProgressHUD

public func enabledCargando(msg: String){
    let gifImage:UIImage = UIImage.gif(name: "load")!
    
    //SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
    SVProgressHUD.setBackgroundColor(UIColor.white)
    SVProgressHUD.setImageViewSize(CGSize(width: 100, height: 100))
    SVProgressHUD.setFont(UIFont(name: "RawsonPro-Regular" , size: 14)!)
    SVProgressHUD.show(gifImage, status: msg)
}

public func dissabledCargando(){
    SVProgressHUD.dismiss()
}
