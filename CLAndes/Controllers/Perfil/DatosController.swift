//
//  DatosController.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/25/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Alamofire

class DatosController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayFruits.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayFruits[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    var isVaid = true
    
    @IBOutlet weak var direccionView: UIView!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var ciudadView: UIView!
    @IBOutlet weak var comunaView: UIView!
    @IBOutlet weak var codAreaTel: UIView!
    @IBOutlet weak var numTelView: UIView!
    @IBOutlet weak var codCelView: UIView!
    @IBOutlet weak var numCelView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passView: UIView!
    
    
    @IBOutlet weak var regionPicker: UIPickerView!
    @IBOutlet weak var direccionTxtfield: UITextField!
    @IBOutlet weak var ciudadTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var regionTxtField: UITextField!
    @IBOutlet weak var comunaTxtField: UITextField!
    @IBOutlet weak var telefonoTxtField: UITextField!
    @IBOutlet weak var celTxtField: UITextField!
    @IBOutlet weak var codAreaTelTxtF: UITextField!
    @IBOutlet weak var codAreaCelTxtF: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    var urlBanco = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/BancosV2/"
    var urlCiudades = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CiudadesV2/?region_id=15"

    var arrayFruits = [String]()
    let realm = try! Realm()
    var ciudades = [Ciudad]()
    var comunas = [Comuna]()
    var bancos = [Banco]()
    var regiones = [Region]()
    var loadiengView : LoadingView!
    var idRegion = 15
    var idCiudad = 0
    var idComuna = 0
    var codAreaTelValue = 0
    func performTap()
    {
        // Perform you action here
    }
    override func viewDidLoad() {
        
//        super.viewDidLoad()
      //  self.direccionTxtfield.becomeFirstResponder()
        let puppies = self.realm.objects(Region.self)
        print("cantidad de Dogs\(puppies.count)")
        for pup in puppies {
            regiones.append(pup)
            print(pup)
        }
        
        
       var ban1 = Banco()
        ban1.codigo = 24
        ban1.descripcion = "BBVA"
        var ban2 = Banco()
        ban2.codigo = 14
        ban2.descripcion = "Banco Estado"
        var ban3 = Banco()
        ban3.codigo = 7
        ban3.descripcion = "Banco Paris"
        var ban4 = Banco()
        ban4.codigo = 6
        ban4.descripcion = "Banco Penta"
        var ban5 = Banco()
        ban5.codigo = 4
        ban5.descripcion = "Banco Ripley"
        
        bancos.append(ban1)
         bancos.append(ban2)
         bancos.append(ban3)
         bancos.append(ban4)
         bancos.append(ban5)
        
       /* Alamofire.request(urlBanco, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                
        }*/
        
         let realm = try! Realm()
        let puppe2 = realm.objects(Person.self)
        print("cantidad de Personas\(puppe2.count)")
        for pup2 in puppe2{
            
            print(pup2)
            direccionTxtfield.text = pup2.calle
            emailTxtField.text = pup2.email
            regionTxtField.text = pup2.region
            ciudadTxtField.text = pup2.descripcionCiudad
            comunaTxtField.text = pup2.comuna
            telefonoTxtField.text = String(pup2.telefono)
            celTxtField.text = String(pup2.celular)
            codAreaTelTxtF.text = String(pup2.codTele)
            codAreaCelTxtF.text = String("9")//String(pup2.codCel)
            
        }
        let puppe3 = realm.objects(BancoUser.self)
        print("cantidad de Bancos\(puppe3.count)")
        for pup3 in puppe3{
            
            print(pup3)
           
        }
    }

    func validarVacio(txtFld : String, viewColor : UIView )  {
        
        if txtFld == "" {
            viewColor.backgroundColor = UIColor.red
            isVaid = false
        }
        
        
    }



    @IBAction func Actualizar(_ sender: Any) {
        
       
        isVaid = true
        setColorPrimario()
         validarVacio(txtFld: direccionTxtfield.text!, viewColor: direccionView)
        validarVacio(txtFld: regionTxtField.text!, viewColor: regionView)
        validarVacio(txtFld: ciudadTxtField.text!, viewColor: ciudadView)
        validarVacio(txtFld: comunaTxtField.text!, viewColor: comunaView)
        validarVacio(txtFld: codAreaTelTxtF.text!, viewColor: codAreaTel)
        validarVacio(txtFld: codAreaCelTxtF.text!, viewColor: codCelView)
        validarVacio(txtFld: direccionTxtfield.text!, viewColor: direccionView)
        validarVacio(txtFld: telefonoTxtField.text!, viewColor: numTelView)
        validarVacio(txtFld: celTxtField.text!, viewColor: numCelView)
        validarVacio(txtFld: emailTxtField.text!, viewColor: emailView)
        validarVacio(txtFld: passTxtField.text!, viewColor: passView)
       // self.actualizaMisDatos()
        
        if isVaid {
            print("guardado!!")
            self.loadiengView = LoadingView(uiView: view, message: "Cargando tus datos")
            self.loadiengView.show()
            self.logeando()
           
        }else {
            print("faltan datos")
            print("INCORRECTO")
            let alert = UIAlertController(title: "Ups!", message: "Este dato es necesario", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //self.loadiengView.hide()
        }
        
    }
    func actualizaMisDatos(){
        
        
        let rut = UserDefaults.standard.string(forKey: "rut")

        print(self.idRegion)
        print(self.idCiudad )
        print(self.idComuna)
        
        let parameters: [String: AnyObject] = ([
            "rut" : rut as AnyObject,
            "direccion" : direccionTxtfield.text as AnyObject,
            "region" : self.idRegion as AnyObject,
            "ciudad": self.idCiudad as AnyObject,
            "comuna" :  self.idComuna as AnyObject,
            "telefonoFijo" : "" as AnyObject,
            "codigoArea" : 0 as AnyObject,
            "codigoAreaName" : "" as AnyObject,
            "codigoAreaDesc" : 0 as AnyObject,
            "telefonoMovil": "90839018" as AnyObject,
            "email" : emailTxtField.text as AnyObject,
            "mediosEnvioInfo" : [
                [
                    "codigo":"10"
                ],
                [
                    "codigo":"20"
                ]
                ] as AnyObject,
            "areasInteres": [
                [
                    "codigo":"101"
                ],
                [
                    "codigo":"102"
                ],
                [
                    "codigo":"103"
                ]
                ] as AnyObject,
            "informacionComercial" : [
                
                "empresa":[
                    "rut" : 76409164,
                    "digitoVerificador" : "7",
                    "razonSocial" : "COMERCIALIZADORA ZENTA GROUP SPA",
                    "cantidadTrabajadores" : 145,
                    "esAfiliado": true,
                    "cajaCompensacion" : [
                        "codigo":0
                    ]as AnyObject
                    ] as AnyObject,
                "direccionEmpresa":[
                    "calle" : "GENERAL CALDERON 121",
                    "numero" : "5585",
                    "codigoPostal" : "",
                    "region" : [
                        "codigo" : 0,
                        "nombre" : "",
                        "descripcion" : ""
                    ]as AnyObject,
                    "ciudad" : [
                        "codigo" : 0,
                        "nombre" : "",
                        "descripcion" : ""
                    ]as AnyObject,
                    "comuna" : [
                        "codigo" : 0,
                        "nombre" : "",
                        "descripcion" : ""
                    ]as AnyObject
                    
                ]as AnyObject,
                "detallesContactoEmpresa" : [
                    "codigoTelefono" : [
                        "descripcion" : 33,
                        "codigo" : 4,
                        "nombre" : 0
                    ]as AnyObject,
                    "numeroTelefono" : 223522587,
                    "codigoTelefonoMovil" : [
                        "descripcion" : "33",
                        "codigo" : "0",
                        "nombre" : "Maule"
                        ]as AnyObject,
                    "numeroMovil":0,
                    "email":"dimd@okd.od"
                ]
                ]as AnyObject,
            "areaTrabajo": [
                "codigo" : 4,
                "descripcion" :"10:00 - 10:25 Manana"
                ]as AnyObject,
            "cargo": [
                "codigo" : 0,
                "descripcion" :"10:00 - 10:25 Manana"
                ]as AnyObject
        ] as AnyObject)  as! [String : AnyObject]
        Alamofire.request("https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/UserPrueba2/actualizarDatosContacto", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                //  print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                let str = try? response.result.value as? [String: Any]
                let valor = str??["status"]
                var valorString = valor as! String
                let s = String(describing: valor)
                print(s)
                if (s == "Optional(success)"){
                    print("CORRECTO")
                    let alert = UIAlertController(title: "", message: "Tus datos han sido cambiado satisfactoriamente", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.loadiengView.hide()
                }else {
                    print("INCORRECTO")
                    let alert = UIAlertController(title: "", message: "Contraseña incorrecta, Intente nuevamente", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.loadiengView.hide()
                }
                
        
    }
    }
    @IBAction func setCodigoArea(_ sender: Any) {
       /* Alamofire.request("https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CodigoAreaV2/getCodigoArea").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
         
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
         
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }*/
        var listaCodAreas = [DetailCodAreaResponse]()
        self.loadiengView = LoadingView(uiView: view, message: "Cargando listado de códigos de área")
        self.loadiengView.show()
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CodigoAreaV2/getCodigoArea"
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) {
                (data, _, err) in DispatchQueue.main.async {
                    if let err = err {
                        print("Failed to get data from url:", err)
                        return
                    }
                    guard let data = data else { return }
                    print(data)
                    do {
                        let decoder = JSONDecoder()
                        let courses = try decoder.decode(CodAreaResponse.self, from: data)
                        for item in (courses.data?.codigoAreaParticular)! {
                             listaCodAreas.append(item)
                        }
                        print(courses)
                       
                        self.showAlertCodAreaList(mensaje: "Selecciona un código de área", bancos: listaCodAreas)
                        
                    }catch let jsonErr {
                        print("Failed to decode:", jsonErr)
                    }
                    self.loadiengView.hide()
                }
                }.resume()
    }
    
    struct CodAreaResponse: Decodable{
        var data: DataResponse?
        var status: String
    }
    
    struct DataResponse: Decodable{
        var codigoAreaParticular: [DetailCodAreaResponse]

    }
    struct DetailCodAreaResponse: Decodable{
        var codigo: Int
        var descripcion: Int
        var nombre: String
    }
    
    
    func logeando() {
        
        let pw = UtilRut.encryptarPass(pass: passTxtField.text!)
        let rut = UserDefaults.standard.string(forKey: "rut")
        let parameters: [String: AnyObject] = [
            "rut" : rut as AnyObject,
            "password": pw as AnyObject
        ]
        Alamofire.request("https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Login/Login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                let str = try? response.result.value as? [String: Any]
                let valor = str??["status"]
                var valorString = valor as! String
                let s = String(describing: valor)
                print(s)
                if (s == "Optional(success)"){
                    print("CORRECTO")
                    
                    self.actualizaMisDatos()
                    
                }else {
                    print("INCORRECTO")
                    
                    print("faltan datos")
                    let alert = UIAlertController(title: "", message: "Contraseña incorrecta, Intente nuevamente", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.loadiengView.hide()
                }
                
                
        }
        
    }
    func setColorPrimario()  {
        direccionView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        regionView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        ciudadView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        comunaView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        codAreaTel.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        codCelView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        direccionView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        numCelView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        numTelView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        emailView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        passView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        
    }

    @IBAction func getCiudad(_ sender: Any) {
        self.loadiengView = LoadingView(uiView: view, message: "Cargando lista de ciudades")
        self.loadiengView.show()
        self.obtenerCiudades()
    }
    @IBAction func getComuna(_ sender: Any) {
        self.loadiengView = LoadingView(uiView: view, message: "Cargando lista de comunas")
        self.loadiengView.show()
        self.obtenerComuna()
    }
    @IBAction func getRegiones(_ sender: Any) {
        var listaRegiones = [Region]()
        let puppies = realm.objects(Region.self)
        print("cantidad de Dogs\(puppies.count)")
        for pup in puppies {
            listaRegiones.append(pup)
            print(pup)
        }
        
        showAlertList(mensaje: "Selecciona tu Region", bancos: listaRegiones)
    }
    func showAlertCodAreaList (mensaje :String, bancos : [DetailCodAreaResponse]) {
        
        let cantidad = bancos.count
        var actions: [(String, UIAlertAction.Style)] = []
        for banco in bancos {
            actions.append((String(banco.descripcion), UIAlertAction.Style.default))
        }
        actions.append(("cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "", message: mensaje, actions: actions) { (index) in
            print("call action \(index)")
            if ( index < cantidad){
              
                    self.codAreaTelTxtF.text = String(bancos[index].descripcion)
                    self.codAreaTelValue = bancos[index].codigo
            }
        }
        
    }
    func showAlertList (mensaje :String, bancos : [AnyObject]) {
        
        let cantidad = bancos.count
        var actions: [(String, UIAlertAction.Style)] = []
        for banco in bancos {
            actions.append((banco.descripcion, UIAlertAction.Style.default))
        }
        actions.append(("cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "", message: mensaje, actions: actions) { (index) in
            print("call action \(index)")
            if ( index < cantidad){
                if(mensaje == "Selecciona tu Region"){
                    self.idRegion = bancos[index].codigo
                    self.regionTxtField.text = bancos[index].descripcion
                    self.comunaTxtField.text = "Selecciona tu comuna"
                     self.ciudadTxtField.text = "Selecciona tu ciudad"
                }else if(mensaje == "Selecciona tu Comuna") {
                     self.idComuna = bancos[index].codigo
                    self.comunaTxtField.text = bancos[index].descripcion
                   
                    
                }else{
                    self.idCiudad = bancos[index].codigo
                    self.ciudadTxtField.text = bancos[index].descripcion
                }
            }
        }
        
    }
    func obtenerCiudades(){
        
        guard let url = URL(string: "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CiudadesV2/?region_id=\(self.idRegion)") else { return }
        URLSession.shared.dataTask(with: url) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(CiudadesResponse.self, from: data)
                    var listRegiones = (courses.data?.ciudades)!
                    self.loadiengView.hide()
                    for regionItem in listRegiones {
                        let ciudad  = Ciudad()
                        
                        ciudad.setValue(regionItem.codigo, forKey: "codigo")
                        ciudad.setValue(regionItem.descripcion, forKey: "descripcion")
                        self.ciudades.append(ciudad)
                        
                    }
                    self.showAlertList(mensaje: "Selecciona tu ciudad", bancos: self.ciudades)
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
        
    }
    func obtenerComuna(){
        
        guard let url = URL(string: "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/ComunasV2/?ciudad_id=\(self.idCiudad)") else { return }
        URLSession.shared.dataTask(with: url) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(ComunasResponse.self, from: data)
                    var listRegiones = (courses.data?.comunas)!
                    self.loadiengView.hide()
                    for regionItem in listRegiones {
                        let comuna  = Comuna()
                        
                        comuna.setValue(regionItem.codigo, forKey: "codigo")
                        comuna.setValue(regionItem.descripcion, forKey: "descripcion")
                        self.comunas.append(comuna)
                        
                    }
                    self.showAlertList(mensaje: "Selecciona tu Comuna", bancos: self.comunas)
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
        
    }
}


struct CiudadesResponse: Decodable{
    var data: DataCiuResponse?
    var status: String
}
struct DataCiuResponse: Decodable{
    var ciudades: [CiuDetailRes]
}
struct CiuDetailRes: Decodable{
    var descripcion: String
    var codigo: Int
}

struct ComunasResponse: Decodable{
    var data: DataComResponse?
    var status: String
}
struct DataComResponse: Decodable{
    var comunas: [ComDetailRes]
}
struct ComDetailRes: Decodable{
    var descripcion: String
    var codigo: Int
}

class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}
