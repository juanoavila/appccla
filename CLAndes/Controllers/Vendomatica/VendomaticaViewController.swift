//
//  VendomaticaViewController.swift
//  Vendomatica
//
//  Created by Diego Corbinaud on 23-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit
import CoreBluetooth
//import VendoWallet

class VendomaticaViewController: UIViewController {
    
    @IBOutlet weak var btnSolicitarCafe: UIButton!
    @IBOutlet weak var btnBluetooth: UIButton!
    
    @IBOutlet weak var viewHome: UIView!
    
    var manager:CBCentralManager!
    
    let apiToken = "jMd6Rz6a2Z=bfDokRqcf?Yxa+ce4kFrCosDFCxDHUGiPWz;3Xu9j4DQL6?3YDF]2"
    let email = "test@test.com"
    //let vendoWallet = VendoWallet.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CBCentralManager()
        manager.delegate = self
        
        btnSolicitarCafe.backgroundColor = UIColor.init(red: 255/255, green: 180/255, blue: 2/255, alpha: 1)
        btnSolicitarCafe.layer.cornerRadius = 6
        
        btnSolicitarCafe.isEnabled = false
        
        //        var viewCargando = UIView()
        //        viewCargando.frame = CGRect(x: 25, y: viewHome.frame.height/3, width: viewHome.frame.width, height: viewHome.frame.height/2)
        //        viewCargando.backgroundColor = .white
        //        view.addSubview(viewCargando)
        //
        //        var imagenView = UIImageView()
        //        imagenView.frame = CGRect(x: viewCargando.frame.width / 2 - 22, y: 10, width: 44, height: 81)
        //        imagenView.image = UIImage(named: "bluetooth.png")
        //        viewCargando.addSubview(imagenView)
        
        
    }
    
//    @IBAction func touchGetCoffe(_ sender: Any) {
//
//        VendoWallet.shared.initConnections(email: email, apiToken: apiToken, amount: 1)
//        vendoWallet.getCoffee()
//    }
    
    func showAlert(title: String, message: String, button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//
//extension VendomaticaViewController: VendoWalletDelegate{
//    func onError(_ error: String) {
//        print("Error")
//    }
//
//    func onVendingRequestApproved(_ amount: Int, product: String) {
//        print("Aprobado")
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetCoffeOkViewControllerIdentity") as? GetCoffeOkViewController{
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    func onVendingRequestDenied(_ amount: Int, product: String) {
//        print("Denegado")
//    }
//    
//    func onVendingRequestSuccess() {
//        print("getDevices")
//    }
//    
//    func onVendingRequestFailure() {
//        print("Credito Aprobado")
//    }
//    
//    func connected(_ isConnected: Bool) {
//        print("Estado de conexion -> \(isConnected)")
//        if !isConnected{
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetCoffeDeviceFailViewControllerIdentity") as? GetCoffeDeviceFailViewController{
//                
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
//    
//    
//    
//}

extension VendomaticaViewController: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            btnSolicitarCafe.isEnabled = true
            break
        case .poweredOff:
            btnSolicitarCafe.isEnabled = false
            showAlert(title: "Ups!", message: "El bluetooth está apagado, enciendalo para utilizar vendomática.", button: "OK")
            break
        case .resetting:
            print("Bluetooth reseting")
            break
        case .unauthorized:
            btnSolicitarCafe.isEnabled = false
            showAlert(title: "Ups!", message: "La aplicación no está autorizada para utilizar el bluetooth.", button: "OK")
            print("Bluetooth desautorizado")
            break
        case .unsupported:
            btnSolicitarCafe.isEnabled = false
            showAlert(title: "Ups!", message: "Bluetooth no soportado.", button: "OK")
            print("Bluetooth no soportado")
            break
        case .unknown:
            btnSolicitarCafe.isEnabled = false
            showAlert(title: "Ups!", message: "No se reconoce el bluetooth.", button: "OK")
            print("Bluetooth desconocido")
            break
        default:
            showAlert(title: "Ups!", message: "Ha ocurrido un error.", button: "OK")
            print("Bluetooth default")
            break
        }
    }
}
