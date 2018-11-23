//
//  PerfilViewController.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/24/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

import Alamofire
import UIKit
import RealmSwift

class PerfilViewController: UIViewController{
    @IBOutlet weak var btnDatos: UIButton!
    @IBOutlet weak var btnCuenta: UIButton!
    @IBOutlet weak var arrowDatos: UIImageView!
    @IBOutlet weak var arrowCuenta: UIImageView!
    
    var loadingView : LoadingView!
    var urlBanco = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/BancosV2/"
    var urlRegiones = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/RegionesV2/"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mi Cuenta"
        
        arrowCuenta.isHidden = true
        self.datos(self)
       

    }

    @IBAction func datos(_ sender: Any) {
        self.loadingView = LoadingView(uiView: view, message: "Cargando tus datos")
        self.loadingView.show()
        self.obtenerRegiones()
        self.obtenerCuentaBanco()
    }
    
    @IBAction func cuenta(_ sender: Any) {
        arrowDatos.isHidden = true
        arrowCuenta.isHidden = false
        btnCuenta.backgroundColor =  UIColor(red: 252/255, green: 190/255, blue: 65/255, alpha: 1.0)
        btnDatos.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 207/255, alpha: 1.0)
        let controllerDos = storyboard!.instantiateViewController(withIdentifier: "CuentaController")
        addChild(controllerDos)
        controllerDos.view.frame =  CGRect(x: 0, y: 108, width:(view.frame.width), height: (view?.frame.height)!)
        view.addSubview(controllerDos.view)
    }
    func obtenerRegiones(){
        
        guard let url = URL(string: urlRegiones) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(RegionesResponse.self, from: data)
                    var listRegiones = (courses.data?.regiones)!
                    let realm = try! Realm()
                    let items = realm.objects(Region.self)
                    try! realm.write {
                        realm.delete(items)
                    }
                    for regionItem in listRegiones {
                        let region  = Region()
                        region.setValue(regionItem.codigo, forKey: "codigo")
                        region.setValue(regionItem.descripcion, forKey: "descripcion")
                        do {
                            try! realm.write {
                                realm.add(region)
                            }
                        }catch  {
                            print(error)
                        }
                    }
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
        
    }
    func obtenerCuentaBanco(){
        
        guard let url = URL(string: urlBanco) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                self.loadingView.hide()
                guard let data = data else { return }
                do {
                    self.irADatos()
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(BancosResponse.self, from: data)
                    var listBancos = (courses.data?.bancos)!
                    let realm = try! Realm()
                    let items = realm.objects(Banco.self)
                    try! realm.write {
                        realm.delete(items)
                    }
                    for bancoItem in listBancos {
                         let banco  = Banco()
                        banco.setValue(bancoItem.codigo, forKey: "codigo")
                        banco.setValue(bancoItem.descripcion, forKey: "descripcion")
                        do {
                            try! realm.write {
                                realm.add(banco)
                            }
                        }catch  {
                            print(error)
                        }
                    }
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
        
    }
    
    func irADatos() {
        arrowCuenta.isHidden = true
        arrowDatos.isHidden = false
        btnDatos.backgroundColor =  UIColor(red: 252/255, green: 190/255, blue: 65/255, alpha: 1.0)
        btnCuenta.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 207/255, alpha: 1.0)
        let controller = storyboard!.instantiateViewController(withIdentifier: "MisDatosController")
        addChild(controller)
        controller.view.frame =  CGRect(x: 0, y: 108, width:(view.frame.width), height: (view?.frame.height)!)//...  // or better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        view.addSubview(controller.view)
    }
}

struct BancosResponse: Decodable{
    var data: DataBncosResponse?
    var status: String
}
struct DataBncosResponse: Decodable{
    var bancos: [BncoDetailRes]
}
struct BncoDetailRes: Decodable{
    var descripcion: String
    var codigo: Int
}

struct RegionesResponse: Decodable{
    var data: DataRegResponse?
    var status: String
}
struct DataRegResponse: Decodable{
    var regiones: [RegDetailRes]
}
struct RegDetailRes: Decodable{
    var descripcion: String
    var codigo: Int
}
