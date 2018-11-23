//
//  CuentaController.swift
//  CajaLosAndesApp
//
//  Created by admin on 10/25/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
class CuentaController : ViewController {
    var isVaid = true
    @IBOutlet weak var numeroTxtFld: UITextField!
    @IBOutlet weak var tipoTxtFld: UITextField!
    @IBOutlet weak var bancoTxtFld: UITextField!
    @IBOutlet weak var passTxtfld: UITextField!
    
    @IBOutlet weak var switchTitular: UISwitch!
    @IBOutlet weak var bancoSepView: UIView!
    @IBOutlet weak var tipoCtaSepView: UIView!
    @IBOutlet weak var numCtaSepView: UIView!
    @IBOutlet weak var passSepView: UIView!
    
    @IBOutlet weak var errorBancoLbl: UILabel!
    @IBOutlet weak var errorTipoLbl: UILabel!
    @IBOutlet weak var errorNumLbl: UILabel!
    @IBOutlet weak var errorPassLbl: UILabel!
    
    
    
    
    
    
    var loadiengView : LoadingView!

    var tipos = [TipoBanco]()
    var bancos = [Banco]()
    let realm = try! Realm()
    var codBanco = 0
    var codTypo = Int()
    override func viewDidLoad() {
        numeroTxtFld.tintColor = UIColor(red:0, green:0.58, blue:0.79, alpha:1)
        let realm = try! Realm()
        let puppe2 = realm.objects(BancoUser.self)
        print("cantidad de Personas\(puppe2.count)")
        for pup2 in puppe2{
            
            print(pup2)
            bancoTxtFld.text = pup2.banco
            self.tipoTxtFld.text = pup2.tipo
            self.codBanco = pup2.codBanco
            self.codTypo = pup2.codTipo
            numeroTxtFld.text = String(pup2.numero)
        }
        
    }
    
    
    
    
    
    
    func logeando() {
       
        // let validator = try UtilRut.validadorRut(input: txtRut.text?.uppercased())
        // group.enter()
        let pw = UtilRut.encryptarPass(pass: passTxtfld.text!)
        // validateUser(rut: txtRut.text!, password: pw)
        // group.wait()
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
                   
                    self.actualizarCuenta()
                    
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
    func actualizarCuenta()  {

        let numeroCuenta =  numeroTxtFld.text
        let rutFinal = UserDefaults.standard.value(forKey: "rutDig") as! String
        print(rutFinal)
        let parameters: [String: AnyObject] = ([
            "rut" : rutFinal ,
            "codigo_banco" : self.codBanco,
            "codigo_tipo_cuenta" : self.codTypo,  //revisar servicio Typo de datos
            "numero_cuenta": numeroCuenta
            ]as AnyObject) as! [String : AnyObject]
        Alamofire.request("https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/UserPrueba2/ActualizarCuentaBancaria", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if (response.result.value != nil){
                    do {
                        let str = try? response.result.value as? [String: Any]
                        let valor = str??["status"]
                        var valorString = valor as! String
                        print(valor)
                        let s = String(describing: valor)
                        print(s)
                        if (s == "Optional(success)"){
                            print("CORRECTO")
                            self.obtenerCuentaBanco()
                            let alert = UIAlertController(title: "", message: "Datos bancarios actualizados correctamente", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else {
                            print("INCORRECTO")
                            let alert = UIAlertController(title: "", message: "En estos momentos no es posible actualizar sus datos, intente mas tarde", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch {
                        print("The file could not be loaded")
                    }
                    print(response)
                }else {
                    print(response)
                }
                self.loadiengView.hide()
                
                
        }
    }
    func obtenerCuentaBanco(){
        
        let rutFinal = UserDefaults.standard.value(forKey: "rutDig") as! String
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/UserPrueba2/ListaCuentaBancaria?rut=\(rutFinal)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(UserBancosResponse.self, from: data)
                    let banco  = BancoUser()
                    banco.numero = (courses.data?.cuentaBancaria.numeroCuenta)!
                    banco.codBanco = (courses.data?.cuentaBancaria.banco.codigo)!
                    banco.banco = (courses.data?.cuentaBancaria.banco.descripcion)!
                    banco.tipo = (courses.data?.cuentaBancaria.tipoCuenta.descripcion)!
                    banco.codTipo = (courses.data?.cuentaBancaria.tipoCuenta.codigo)!
                    do {
                        
                        try! self.realm.write {
                            self.realm.add(banco)
                        }
                    }catch  {
                        print(error)
                    }
                    
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
        
    }
    @IBAction func Actualizar(_ sender: Any) {
        
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            bancoSepView.backgroundColor = UIColor.red
           // self.logeando()
            isVaid = true
            setColorPrimario()
            validarVacio(txtFld: bancoTxtFld.text!, viewColor: bancoSepView, label: errorBancoLbl)
            validarVacio(txtFld: tipoTxtFld.text!, viewColor: tipoCtaSepView, label: errorTipoLbl)
            validarVacio(txtFld: numeroTxtFld.text!, viewColor: numCtaSepView,label: errorNumLbl)
            validarVacio(txtFld: passTxtfld.text!, viewColor: passSepView, label: errorPassLbl)
           
            if isVaid {
                 if (switchTitular.isOn){
                 self.loadiengView = LoadingView(uiView: view, message: "Cargando tus datos")
                self.loadiengView.show()
                self.logeando()
                 }else {
                    let alert = UIAlertController(title: "", message: "Debe declarar que es titular", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                print("faltan datos")
              
            }
        }
    }
    

    func validarVacio(txtFld : String, viewColor : UIView ,label :UILabel)  {
        
        if txtFld == "" {
            viewColor.backgroundColor = UIColor.red
            isVaid = false
            label.text = "este dato es necesario"
            label.isHidden = false
        }
        if txtFld == "Selecciona Tu banco"{
            viewColor.backgroundColor = UIColor.red
            label.text = "este dato es necesario"
             isVaid = false
            label.isHidden = false
        }else if txtFld == "Selecciona tipo cuenta"{
            viewColor.backgroundColor = UIColor.red
            label.text = "este dato es necesario"
            label.isHidden = false
            isVaid = false
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
            if(mensaje == "Selecciona tu Banco"){
                self.bancoTxtFld.text = bancos[index].descripcion
                self.codBanco = bancos[index].codigo
                self.tipoTxtFld.text = "Selecciona tipo cuenta"
            }else {
                self.tipoTxtFld.text = bancos[index].descripcion
                self.codTypo = bancos[index].codigo
            }
            }
        }

    }
    @IBAction func setNumCuenta(_ sender: Any) {
    }
    @IBAction func setBancos(_ sender: Any) {
    }
    @IBAction func abrirBancos(_ sender: Any) {
        
        let puppies = realm.objects(Banco.self)
        print("cantidad de Dogs\(puppies.count)")
        for pup in puppies {
            bancos.append(pup)
            print(pup)
        }
      
        showAlertList(mensaje: "Selecciona tu Banco", bancos: bancos)
    }
    @IBAction func abrirTipoCuenta(_ sender: Any) {
        
        var tipo1 = TipoBanco()
        tipo1.codigo = 100
        tipo1.descripcion = "Cta. ahorro"
        var tipo2 = TipoBanco()
        tipo2.codigo = 101
        tipo2.descripcion = "Cta.cte."
        var tipo3 = TipoBanco()
        tipo3.codigo = 103
        tipo3.descripcion = "Cta.vista"
        var tipo4 = TipoBanco()
        tipo4.codigo = 102
        tipo4.descripcion = "Sin cuenta"
        
        
        tipos.append(tipo1)
        tipos.append(tipo2)
        tipos.append(tipo3)
        tipos.append(tipo4)
        
        showAlertList(mensaje: "Selecciona tu tipo de cuenta", bancos: tipos)
    }
    
    @IBAction func setTipoCuenta(_ sender: Any) {
      
    }
    func setColorPrimario()  {
        bancoSepView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        tipoCtaSepView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        numCtaSepView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        passSepView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
      
        errorNumLbl.isHidden = true
        errorTipoLbl.isHidden = true
        errorBancoLbl.isHidden = true
        errorPassLbl.isHidden = true
        
    }
}

struct ResponseStatus: Codable {
    let mesage: String
    let status : String
}
