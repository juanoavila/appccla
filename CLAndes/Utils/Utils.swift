//
//  Utils.swift
//  CajaLosAndesApp
//
//  Created by Diego Corbinaud on 12-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//alert para abrir la configuracion de la aplicación
func ShowAlertSettings(message: String, buttonTitle: String) -> (UIAlertController){
    
    let alert = UIAlertController(title: "Ups!", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }))
    return alert
}

public func percentScreen(percent: Double, position: String) -> (CGFloat)?{
    var value: CGFloat
    let screen = UIScreen.main.bounds.size
    
    if (position == "x" || position == "X") {
        value = screen.width
    }else{
        value = screen.height
    }
    
    let total = CGFloat((Double(value) * percent) / 100)
    
    return total
    
}

func calculateDistance(uLatitude: String, uLongitude: String, sLatitude: String, sLongitude: String) -> (Double){
    
    let uLatitudeNumber = textToNumber(number: uLatitude)
    let uLongitudeNumber = textToNumber(number: uLongitude)
    let sLatitudeNumber = textToNumber(number: sLatitude)
    let sLongitudeNumber = textToNumber(number: sLongitude)
    
    let uCoordenate = CLLocation(latitude: uLatitudeNumber, longitude: uLongitudeNumber)
    let sCoordinate = CLLocation(latitude: sLatitudeNumber, longitude: sLongitudeNumber)
    
    let distanceInMeters = uCoordenate.distance(from: sCoordinate)
    
    //distance in Kms
    return (distanceInMeters / 1000)
}

func textToNumber(number: String) -> (Double){
    var result: Double = 0
    let decimalStringNumber = number.replacingOccurrences(of: ",", with: ".")
    
    if let decimal = Double(decimalStringNumber){
        result = decimal
    }
    
    return result
}

public func showAlertInfo(msg: String, title: String, txtButton: String, controller: AnyObject){
    
    //let alert = UIAlertController(title: "¡Ups!", message: msg, preferredStyle: UIAlertController.Style.alert)
    let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
    //alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
    alert.addAction(UIAlertAction(title: txtButton, style: UIAlertAction.Style.default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}
