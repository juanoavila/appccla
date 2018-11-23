//
//  PagoPorDepositoViewController.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 06-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import RealmSwift

class PagoPorDepositoViewController: UIViewController {
    
    var countAsync: Int = 0
    var asyncCallNum01: Int = 2
    var bancos = [BancoResponse]()
    var tiposCuentas = [TipoCuentaResponse]()
    var codigosArea = [CodigoAreaResponse]()
    var tipos = [TipoBanco]()
    var responsePOST = DefaultResponse()
    let group = DispatchGroup()
    var codBanco = -1
    var codArea = -1
    var codTipoCuenta = ""
    var licenciaDetalle = DetalleLicenciaResponse()
    var licencia = LicenciaResponse()
    
    //textfield
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var tfijoTxtFld: UITextField!
    @IBOutlet weak var tfijo2TxtFld: UITextField!
    @IBOutlet weak var tmovilTxtFld: UITextField!
    @IBOutlet weak var bancoTxtFld: UITextField!
    @IBOutlet weak var tipoCuentaTxtFld: UITextField!
    @IBOutlet weak var ncuentaTxtFld: UITextField!
    @IBOutlet weak var titularSwch: UISwitch!
    
    //label error
    @IBOutlet weak var labelEmailErr: UILabel!
    @IBOutlet weak var labelTFijoError: UILabel!
    @IBOutlet weak var labelTMovilError: UILabel!
    @IBOutlet weak var labelBancoError: UILabel!
    @IBOutlet weak var labelTipoCuentaError: UILabel!
    @IBOutlet weak var labelNumCuentaError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countAsync = 0
        setearTiposCuentas()
        
        self.group.enter()
        obtenerBancos()
        obteneCodigosArea()
        self.group.wait()
        
        
        self.tfijo2TxtFld.keyboardType = UIKeyboardType.numberPad
        self.tmovilTxtFld.keyboardType = UIKeyboardType.numberPad
        self.ncuentaTxtFld.keyboardType = UIKeyboardType.numberPad
        
        self.setDefaultValue()
        //bancoTxtFld.addTarget(self, action: #selector(prueba), for: .touchDown)
        
    }
    
    @IBAction func guardarSolicitud(_ sender: Any) {
        
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            self.labelEmailErr.text = ""
            self.labelTFijoError.text = ""
            self.labelTMovilError.text = ""
            self.labelBancoError.text = ""
            self.labelTipoCuentaError.text = ""
            self.labelNumCuentaError.text = ""
            
            if(!validarFormulario()){
                self.group.enter()
                self.guardarDatosSolicitudPago()
                self.group.wait()
                
                if(self.responsePOST.status == "success"){
                    let alert = UIAlertController(title: "¡Bien!", message: "Tu solicitud fue registrada exitosamente", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "¡Ups!", message: "No fue posible guardar la solicitud", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func mostrarCodigosAreas(_ sender: Any) {
        self.showAlertListCodigosArea(mensaje: "Selecciona código area", codsArea: self.codigosArea)
    }
    
    @IBAction func mostrarBancos(_ sender: Any) {
        self.showAlertListBancos(mensaje: "Selecciona tu Banco", bancos: self.bancos)
    }
    
    @IBAction func mostrarTiposCuenta(_ sender: Any) {
        self.showAlertListTiposCuenta(mensaje: "Selecciona tipo de cuenta", tipoCuentas: self.tiposCuentas)
    }
    
    
    @IBAction func formatearTelefonoFijo(_ sender: Any) {
        self.validarFormatoNumero(largo: 9, label: self.tfijo2TxtFld,
                                  texto: "\(String(self.tfijoTxtFld.text!))\(String( self.tfijo2TxtFld.text!))")
    }
    
    @IBAction func formatearTelefonoMovil(_ sender: Any) {
        self.validarFormatoNumero(largo: 8, label: self.tmovilTxtFld, texto: self.tmovilTxtFld.text!)
    }
    
    @IBAction func formatearNumeroCuenta(_ sender: Any) {
        self.validarFormatoNumero(largo: 15, label: self.ncuentaTxtFld, texto: self.ncuentaTxtFld.text!)
    }
    
    func setDefaultValue(){
        
        let realm = try! Realm()
        let personas = realm.objects(Person.self)
        print("PERSONAS: \(personas)")
        for persona in personas{
            
            self.emailTxtFld.text = persona.email
            self.tmovilTxtFld.text = String(persona.celular)
            if(persona.codTele != 0){
                buscarCodigoArea(cArea: persona.codTele)
                self.tfijoTxtFld.text = String(persona.codTele)
            }
            if(persona.telefono != 0){
                self.tfijo2TxtFld.text = String(persona.telefono)
            }
        }
        
        let bancos = realm.objects(BancoUser.self)
        print("BANCOS: \(bancos)")
        for bank in bancos{
            
            if(bank.codBanco != 0){
                self.bancoTxtFld.text = bank.banco
                self.codBanco = bank.codBanco
            }
            if(bank.codTipo != 0){
                self.tipoCuentaTxtFld.text = bank.tipo
                self.codTipoCuenta = self.obtenerIdentificadorCuenta(codigo: bank.codTipo)
            }
            
            self.ncuentaTxtFld.text = String(bank.numero)
            
        }
    }
    
    func buscarCodigoArea(cArea: Int){
        
        for item in self.codigosArea {
            if(item.descripcion == cArea){
                self.codArea = item.codigo
                break
            }
        }
        
    }
    
    private func validarFormulario()->Bool{
        
        var flagError: Bool = false
        
        if(self.emailTxtFld.text?.trimmingCharacters(in: .whitespaces) == ""){
            flagError = true
            labelEmailErr.text = "Este dato es necesario"
        } else {
            if(!UtilValidations.isValidEmail(testStr: self.emailTxtFld.text!)){
                flagError = true
                labelEmailErr.text = "El email ingresado no es válido"
            }
        }
        
        if(self.codTipoCuenta == ""){
            flagError = true
            labelTipoCuentaError.text = "Este dato es necesario"
        }
        
        if(self.codBanco == -1){
            flagError = true
            labelBancoError.text = "Este dato es necesario"
        }
        
        if(self.ncuentaTxtFld.text?.trimmingCharacters(in: .whitespaces) == ""){
            flagError = true
            labelNumCuentaError.text = "Este dato es necesario"
        }
        
        
        if (self.tmovilTxtFld.text!.trimmingCharacters(in: .whitespaces) == "" &&
            self.tfijo2TxtFld.text!.trimmingCharacters(in: .whitespaces) == "") {
            flagError = true
            labelTMovilError.text = "Este dato es necesario"
        } else if(self.tmovilTxtFld.text!.trimmingCharacters(in: .whitespaces) != ""){
            let firstChar = tmovilTxtFld.text!.first
            if(Int("\(String(firstChar!))")! < 2 || tmovilTxtFld.text!.count != 8){
                flagError = true
                labelTMovilError.text = "El teléfono ingresado no es válido"
            }
        }else if(self.tfijo2TxtFld.text!.trimmingCharacters(in: .whitespaces) != ""){
            if("\(String(describing: self.tfijoTxtFld.text))\(String(describing: self.tfijo2TxtFld.text))".count != 9){
                flagError = true
                labelTFijoError.text = "El teléfono ingresado no es válido"
            }
        }
        
        
        if(!self.titularSwch.isOn){
            let alert = UIAlertController(title: "¡Ups!", message: "Para hacer una solicitud de pago por depósito, debes leer y aceptar la Declaración de Titularidad de Cuenta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            flagError = true
            print("Se evaluo el switch")
            
        }
        
        
        return flagError
    }
    
    func validarFormatoNumero(largo: Int, label: UITextField, texto: String){
        
        let rutRegex = "0123456789"
        
        let lastChar = texto.last
        if(lastChar != nil && !rutRegex.contains(lastChar!)){
            label.text?.removeLast()
        }else if(lastChar != nil && texto.count > largo){
            label.text?.removeLast()
        }
        
    }
    
    func obtenerIdentificadorCuenta(codigo: Int)-> String{
        var identificador = ""
        for tipo in self.tiposCuentas {
            if(tipo.codigo == codigo){
                identificador = tipo.identificador!
                break
            }
        }
        return identificador
    }
    
    func setearTiposCuentas(){
        var tipo1 = TipoCuentaResponse()
        tipo1.codigo = 100
        tipo1.descripcion = "Cta. ahorro"
        tipo1.identificador = "A"
        var tipo2 = TipoCuentaResponse()
        tipo2.codigo = 101
        tipo2.descripcion = "Cta.cte."
        tipo2.identificador = "C"
        var tipo3 = TipoCuentaResponse()
        tipo3.codigo = 103
        tipo3.descripcion = "Cta.vista"
        tipo3.identificador = "V"
        
        self.tiposCuentas.append(tipo1)
        self.tiposCuentas.append(tipo2)
        self.tiposCuentas.append(tipo3)
    }
    
    @IBAction func abrirTiposCuentas(_ sender: Any) {
        self.showAlertListTiposCuenta(mensaje: "Selecciona tipo de cuenta", tipoCuentas: self.tiposCuentas)
    }
    
    @IBAction func abrirCodigosArea(_ sender: Any) {
        self.showAlertListCodigosArea(mensaje: "Selecciona código area", codsArea: self.codigosArea)
    }
    
    @IBAction func abrirBancos(_ sender: Any) {
        self.showAlertListBancos(mensaje: "Selecciona tu Banco", bancos: self.bancos)
    }
    
    
    func obtenerBancos(){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Bancos/"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
            do {
                self.countAsync += 1
                let decoder = JSONDecoder()
                let respuesta = try decoder.decode(BancosListResponse.self, from: data)
                if(respuesta.status == "success"){
                    self.bancos = respuesta.data.bancos
                }
                
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
    
    func obtenerTiposCuentas(){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/BancosTipoCuentaV2/?flag=1"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
            
            do {
                self.countAsync += 1
                let decoder = JSONDecoder()
                let respuesta = try decoder.decode(TiposCuentasResponse.self, from: data)
                if(respuesta.status == "success"){
                    self.tiposCuentas = respuesta.data.detalle
                }
                
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
    func obteneCodigosArea(){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CodigoArea/getCodigoArea"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                self.countAsync += 1
                let decoder = JSONDecoder()
                let respuesta = try decoder.decode(CodigoAreaListResponse.self, from: data)
                if(respuesta.status == "success"){
                    self.codigosArea = respuesta.data.codigoAreaParticular
                }
                
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
    
    func guardarDatosSolicitudPago(){
        
        var urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/GuardarDatos/?"
        
        let fecha = Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        
        var params = "tipoFormulario=\(self.licencia.VTipoFormulario!)"
        params.append("&nroLicencia=\(self.licenciaDetalle.VNumeroLicencia)")
        params.append("&rut=\(UserDefaults.standard.string(forKey: "rut")!)")
        params.append("&fechaIni=\(self.licenciaDetalle.VFechaInicio)")
        params.append("&tipoCuenta=\(self.codTipoCuenta)")
        params.append("&banco=\(self.codBanco)")
        params.append("&nroCuenta=\(self.ncuentaTxtFld.text!)")
        params.append("&fechaAct=\(dateFormatterPrint.string(from: fecha) )")
        params.append("&email=\(self.emailTxtFld.text!)")
        if(self.tfijo2TxtFld.text!.trimmingCharacters(in: .whitespaces) == ""){
            params.append("&areaFonoP=")
            params.append("&fonoPart=")
        }else{
            params.append("&areaFonoP=\(self.tfijoTxtFld.text!)")
            params.append("&fonoPart=\(self.tfijo2TxtFld.text!)")
        }
        params.append("&movil=\(self.tmovilTxtFld.text!)")
        params.append("&flag=\(self.licencia.VFlag!)")
        urlString.append(params)
        
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                print("DATA GUARDAR: \(String(decoding: data, as: UTF8.self))")
                
                let decoder = JSONDecoder()
                self.responsePOST = try decoder.decode(DefaultResponse.self, from: data)
                self.group.leave()
            } catch let error {
                print(error.localizedDescription)
                self.group.leave()
            }
            
        } )
        task.resume()
    }
    
    //*****************************
    //ALERTS
    //*****************************
    func showAlertListBancos (mensaje :String, bancos : [BancoResponse]) {
        
        var actions: [(String, UIAlertAction.Style)] = []
        for banco in bancos {
            actions.append((banco.descripcion!, UIAlertAction.Style.default))
        }
        actions.append(("cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "", message: mensaje, actions: actions) { (index) in
            if ( index < bancos.count){
                self.bancoTxtFld.text = bancos[index].descripcion
                self.codBanco = bancos[index].codigo!
            }
        }
    }
    
    
    func showAlertListCodigosArea (mensaje :String, codsArea : [CodigoAreaResponse]) {
        
        var actions: [(String, UIAlertAction.Style)] = []
        for cod in codsArea {
            actions.append(("\(cod.descripcion)", UIAlertAction.Style.default))
        }
        actions.append(("cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "", message: mensaje, actions: actions) { (index) in
            if ( index < codsArea.count){
                self.tfijoTxtFld.text = "\(codsArea[index].descripcion)"
                self.codArea = codsArea[index].codigo
            }
        }
    }
    
    
    func showAlertListTiposCuenta (mensaje :String, tipoCuentas : [TipoCuentaResponse]) {
        
        var actions: [(String, UIAlertAction.Style)] = []
        for tipo in tipoCuentas {
            actions.append((tipo.descripcion!, UIAlertAction.Style.default))
        }
        actions.append(("cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "", message: mensaje, actions: actions) { (index) in
            if ( index < tipoCuentas.count){
                self.tipoCuentaTxtFld.text = tipoCuentas[index].descripcion
                self.codTipoCuenta = tipoCuentas[index].identificador!
            }
        }
    }
    
}
