//
//  LoginController.swift
//  mySidebar2
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import SVProgressHUD

class LoginController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var segmentUsers: UISegmentedControl!
    
    @IBOutlet weak var separadorRut: UIView!
    
    @IBOutlet weak var separadorPass: UIView!
    
    @IBOutlet weak var separadorCarga: UIView!
    
    @IBOutlet weak var txtRut: UITextField!
    @IBOutlet weak var lblPass: UILabel!
    
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var olvidastePass: UIButton!
    @IBOutlet weak var registrate: UIButton!
    
    @IBOutlet weak var lblEncabezadoLogin: UITextView!
    
    let group = DispatchGroup()
    var access: Bool = false
    var nombre = ""
    var esCarga: Bool!
    //var loadingView : LoadingView!
    let realm = try! Realm()
    var vc = UIViewController()
    override func viewDidLoad() {
        
        //******** Session que se utiliza para cargar el mensaje que indica que botón presionó
        let msgModulo = UserDefaults.standard.string(forKey: "msjModuloLogin")
        var msg = self.lblEncabezadoLogin.text!
        msg = msg.replacingOccurrences(of: "xxx", with: msgModulo!)
        self.lblEncabezadoLogin.text = msg
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem!.tintColor = UIColor.white
        //messageTextView.text = "Por su seguridad, para ingresar a \(mensaje) es necesario que te valides con tu clave de Mi Sucursal"
        esCarga = false
        selectTabAfiliado()
        (segmentUsers.subviews[0] as UIView).tintColor = UIColor.clear
        (segmentUsers.subviews[1] as UIView).backgroundColor = UIColor(red: 205/255, green: 37/255, blue: 176/255, alpha: 1.0)
        segmentUsers.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: UIControl.State.normal)
        segmentUsers.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
    }
    @IBAction func changeUser(_ sender: Any) {
        
        segmentUsers.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: UIControl.State.normal)
        switch segmentUsers.selectedSegmentIndex
        {
        case 0:
            
            esCarga = false
            (segmentUsers.subviews[0] as UIView).backgroundColor = UIColor(red: 205/255, green: 37/255, blue: 176/255, alpha: 1.0)
            (segmentUsers.subviews[1] as UIView).backgroundColor = UIColor.clear
            segmentUsers.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        case 1:
            // textLabel.text = "Second Segment Selected";
            (segmentUsers.subviews[1] as UIView).backgroundColor = UIColor(red: 205/255, green: 37/255, blue: 176/255, alpha: 1.0)
            esCarga = true
            (segmentUsers.subviews[0] as UIView).backgroundColor = UIColor.clear
            segmentUsers.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
            selectTabCarga()
        default:
            break
        }
    }
    
    func selectTabAfiliado() {
        olvidastePass.isHidden = false
        registrate.isHidden = false
        lblPass.isHidden = false
        txtPass.isHidden = false
        separadorCarga.isHidden = true
        separadorPass.isHidden = false
        
    }
    func guardarPersona(myDog : Dog){
       
        try! realm.write {
            realm.add(myDog)
        }
    }
    func selectTabCarga() {
        separadorRut.isHidden = false
        txtPass.isHidden = true
        lblPass.isHidden = true
        olvidastePass.isHidden = true
        registrate.isHidden = true
        separadorPass.isHidden = true
        
    }
    struct ResponseObject: Codable {
        let respuesta: [NewsItem]
    }
    struct NewsItem: Codable {
        let titulo: String
        let vista_ios: String
        let visible: String
        enum CodingKeys: String, CodingKey {
            case titulo = "titulo"
            case vista_ios = "vista_ios"
            case visible = "visible"
            
        }
    }
    
    @IBAction func formatRut(_ sender: Any) {
          txtRut.text = UtilRut.formatoRut(rut: txtRut.text!)
    }
    @IBAction func hola(_ sender: Any) {
     
    }
    func obtenerCuentaBanco(){
        
        let newString = txtRut.text!.replacingOccurrences(of: ".", with: "")
        let rutFinal = newString.replacingOccurrences(of: "-", with: "")
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/User/ListaCuentaBancaria?rut=\(rutFinal)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) {
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
                    banco.numero = (courses.data?.cuentaBancaria.numeroCuenta ?? 0)!
                    banco.codBanco = (courses.data?.cuentaBancaria.banco.codigo ?? 0)!
                   banco.banco = (courses.data?.cuentaBancaria.banco.descripcion ?? "")!
                    banco.tipo = (courses.data?.cuentaBancaria.tipoCuenta.descripcion ?? "")!
                    banco.codTipo = (courses.data?.cuentaBancaria.tipoCuenta.codigo ?? 0)!
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
    func obtenerDatosPersona(){
        
     
        let newString = txtRut.text!.replacingOccurrences(of: ".", with: "")
        let rutFinal = newString.replacingOccurrences(of: "-", with: "")
        UserDefaults.standard.set(rutFinal , forKey: "rutDig")
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/User/ObtenerDatos?rut=\(rutFinal)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, _, err) in DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let courses = try decoder.decode(UserInfoResponseSimple.self, from: data)
                    let persona  = Person()
                    persona.rut = (courses.data?.persona.rut)!
                    persona.apellMat = (courses.data?.persona.apellidoMaterno)!
                    persona.apellPat = (courses.data?.persona.apellidoPaterno)!
                    persona.nombre  = (courses.data?.persona.nombre)!
                    persona.descripcionCiudad = (courses.data?.direccionPersona.ciudad.descripcion)!
                    persona.codCiudad = (courses.data?.direccionPersona.ciudad.codigo)!
                    persona.calle = (courses.data?.direccionPersona.calle)!
                    
                    persona.comuna = ((courses.data?.direccionPersona.comuna.descripcion)!)
                    persona.codComuna = ((courses.data?.direccionPersona.comuna.codigo)!)
                    persona.region = ((courses.data?.direccionPersona.region.descripcion)!)
                    persona.codRegion = ((courses.data?.direccionPersona.region.codigo)!)
                    persona.email = ((courses.data?.detallesContactoPersona.email)!)
                    persona.celular = ((courses.data?.detallesContactoPersona.numeroMovil)!)
                    persona.codCel = ((courses.data?.detallesContactoPersona.codigoTelefonoMovil.codigo)!)
                    persona.telefono = ((courses.data?.detallesContactoPersona.numeroTelefono)!)
                    persona.codTele = ((courses.data?.detallesContactoPersona.codigoTelefono.codigo)!)
                   // var infoComercial = [informacionComercialResponse]()
                    var infoComercial = ((courses.data?.listaInformacionComercial.informacionComercial)!)
                    self.nombre = (courses.data?.persona.nombre)!
                    do {
                        try! self.realm.write {
                           // for info in infoComercial {
                             //   let empresa = Empresa()
                               // empresa.rutEmpresa = info.empresa.rut
                                //self.realm.add(empresa)
                           // }
                            self.realm.add(persona)
                        }
                        self.cargarMenu()
                        
                    }catch  {
                        print(error)
                        dissabledCargando()
                    }

                }catch let jsonErr {
                    do {
                        let decoder = JSONDecoder()
                        let courses = try decoder.decode(UserInfoResponse.self, from: data)
                        let persona  = Person()
                        persona.rut = (courses.data?.persona.rut)!
                        persona.apellMat = (courses.data?.persona.apellidoMaterno)!
                        persona.apellPat = (courses.data?.persona.apellidoPaterno)!
                        persona.nombre  = (courses.data?.persona.nombre)!
                        persona.descripcionCiudad = (courses.data?.direccionPersona.ciudad.descripcion)!
                        persona.codCiudad = (courses.data?.direccionPersona.ciudad.codigo)!
                        persona.calle = (courses.data?.direccionPersona.calle)!
                        
                        persona.comuna = ((courses.data?.direccionPersona.comuna.descripcion)!)
                        persona.codComuna = ((courses.data?.direccionPersona.comuna.codigo)!)
                        persona.region = ((courses.data?.direccionPersona.region.descripcion)!)
                        persona.codRegion = ((courses.data?.direccionPersona.region.codigo)!)
                        persona.email = ((courses.data?.detallesContactoPersona.email)!)
                        persona.celular = ((courses.data?.detallesContactoPersona.numeroMovil)!)
                        persona.codCel = ((courses.data?.detallesContactoPersona.codigoTelefonoMovil.codigo)!)
                        persona.telefono = ((courses.data?.detallesContactoPersona.numeroTelefono)!)
                        persona.codTele = ((courses.data?.detallesContactoPersona.codigoTelefono.codigo)!)
                        // var infoComercial = [informacionComercialResponse]()
                        var infoComercial = ((courses.data?.listaInformacionComercial.informacionComercial)!)
                        self.nombre = (courses.data?.persona.nombre)!
                        do {
                            try! self.realm.write {
                                // for info in infoComercial {
                                //   let empresa = Empresa()
                                // empresa.rutEmpresa = info.empresa.rut
                                //self.realm.add(empresa)
                                // }
                                self.realm.add(persona)
                            }
                            self.cargarMenu()
                            
                        }catch  {
                            print(error)
                            dissabledCargando()
                        }
                        
                    }catch let jsonErr {
                        dissabledCargando()
                        let alert = UIAlertController(title: "", message: "Hay problemas con la conexión", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Failed to decode:", jsonErr)
                    }
                }
            }
            }.resume()
        
    }
    func myFunction() {
        let array = [Object]()
        let group = DispatchGroup() // initialize
        
        array.forEach { obj in
            
            // Here is an example of an asynchronous request which use a callback
            group.enter() // wait
           
        }
        
        group.notify(queue: .main) {
            // do something here when loop finished
        }
    }

    func logeando() {
        if (txtRut.text != ""){
            do{
              let validator = try UtilRut.validadorRut(input: txtRut.text?.uppercased())
            }
        catch  {
                print(error)
        }
        if (txtPass.text != ""){
            enabledCargando(msg: "Espera unos segundos")
        let pw = UtilRut.encryptarPass(pass: txtPass.text!)
        let parameters: [String: AnyObject] = [
            "rut" : txtRut.text! as AnyObject,
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
                    let aToken = str??["access_token"]
                    UserDefaults.standard.set(aToken! , forKey: "access_token")
                    UserDefaults.standard.set(self.txtRut.text! , forKey: "rut")
                     self.obtenerDatosPersona()
                    self.obtenerCuentaBanco()
                   
                   
                }else {
                    print("INCORRECTO")
                    let alert = UIAlertController(title: "", message: "Credenciales inválidas, Intente nuevamente", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    dissabledCargando()
                }
                
                
        }
        }else {
            print("INCORRECTO")
            let alert = UIAlertController(title: "", message: "Debe ingresar Contraseña", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }else {
            print("INCORRECTO")
            let alert = UIAlertController(title: "", message: "Debe ingresar Rut", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func controlCaracters(_ sender: Any) {
        
        let rutRegex = "0123456789kK"
        
        let lastChar = txtRut.text!.last
        if(lastChar != nil && !rutRegex.contains(lastChar!)){
            txtRut.text?.removeLast()
        }else if(lastChar != nil && txtRut.text!.count == 13){
            txtRut.text?.removeLast()
        }else{
            txtRut.text = UtilRut.formatoRut(rut: txtRut.text!)
        }
    }
    func cargarMenu()  {
        //obtenerDatosPersona()
        //obtenerCuentaBanco()
        
        var url = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/menuIOS/MenuIOS?tipo=1"
        
        var arrayNomHome = [String]()
        var arrayNomMenu = [String]()
        
        UserDefaults.standard.set("afiliado" , forKey: "esCarga")
        if (esCarga){
            UserDefaults.standard.set("carga" , forKey: "esCarga")
            url = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/menuIOS/MenuIOS?tipo=2"
        }
        do {
                var tipoUser = 1
                UserDefaults.standard.set("afiliado" , forKey: "esCarga")
                if (esCarga){
                    
                    UserDefaults.standard.set("carga" , forKey: "esCarga")
                    tipoUser = 2
                }
                Alamofire.request(url).responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")
                    
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            do {
                                let responseObject = try decoder.decode(ResponseObject.self, from: data)
                                let realm = try! Realm()
                                arrayNomMenu.append("Bienvenido")
                                arrayNomMenu.append(self.nombre)
                                for efe in responseObject.respuesta {
                                        let menuIos  = MenuIos()
                                        
                                        menuIos.setValue(efe.titulo, forKey: "titulo")
                                        menuIos.setValue(efe.visible, forKey: "visible")
                                        menuIos.setValue(efe.vista_ios, forKey: "vista_ios")
                                        if(efe.visible == "t"){
                                            arrayNomMenu.append(efe.titulo)
                                        }
                                        arrayNomHome.append(efe.titulo)
                                        if let index = arrayNomHome.index(of: "On Boarding") {
                                            arrayNomHome.remove(at: index)
                                        }
                                        if let index = arrayNomMenu.index(of: "Vendomatica") {
                                            arrayNomMenu.remove(at: index)
                                        }
                                        if let index = arrayNomHome.index(of: "Cerrar sesión") {
                                            arrayNomHome.remove(at: index)
                                        }
                                        if let index = arrayNomHome.index(of: "Certificados") {
                                            arrayNomHome.remove(at: index)
                                        }
                                        if let index = arrayNomMenu.index(of: "Certificados") {
                                            arrayNomMenu.remove(at: index)
                                        }
                                        if let index = arrayNomHome.index(of: "Mi cuenta") {
                                            arrayNomHome.remove(at: index)
                                        }
                                        if let index = arrayNomHome.index(of: "Home") {
                                            arrayNomHome.remove(at: index)
                                        }
                                      
                                        if let index = arrayNomHome.index(of: "Empresas") {
                                            arrayNomHome.remove(at: index)
                                        }
                                        if let index = arrayNomMenu.index(of: "Empresas") {
                                            arrayNomMenu.remove(at: index)
                                        }
                                        if let index = arrayNomMenu.index(of: "On Boarding") {
                                            arrayNomMenu.remove(at: index)
                                        }
                                    
                                        let myDog = Dog()
                                        myDog.name = "eeeedde"
                                        myDog.age = "xxsxs"
                                        myDog.mas = "effr"
                                        
                                        self.guardarPersona(myDog: myDog)
                                        do {
                                            try! realm.write {
                                                realm.add(menuIos)
                                            }
                                        }catch  {
                                            print(error)
                                        }
                                    }
                                
                                UserDefaults.standard.set(true , forKey: "loggin")
                                
                                UserDefaults.standard.set(arrayNomHome , forKey: "arregloHomeNom")
                                print("arrayNomMenu \(arrayNomMenu)")
                                UserDefaults.standard.set(arrayNomMenu , forKey: "arregloMenuNom")
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.construyeMenu()
                                dissabledCargando()
                                self.navigationController?.popViewController(animated: true)
                                
                            } catch {
                                dissabledCargando()
                                print(error)
                            }
                        }}
                }
            

        } catch {
            dissabledCargando()
            sendAlert(titulo: "Error en Login", mensaje: "Ocurrio un error no especificado")
        }
    }
    @IBAction func olvidastePass(_ sender: Any) {
        var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "RecuperarPwr")
        self.navigationController?.pushViewController(login, animated: true)
        
        
    }
    @IBAction func registrar(_ sender: Any) {
        var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "WebRegistrar")
        self.navigationController?.pushViewController(login, animated: true)
    }
    @IBAction func Ingresar(_ sender: Any) {

        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{

            if (esCarga) {
                enabledCargando(msg: "Espera unos segundos")
                self.cargarMenu()
            }else {
            self.logeando()
            }
        }
        
    }
        func sendAlert(titulo: String, mensaje: String){
            let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        

    
    enum RutValidator {
        public static func isValid(rut: String, verifier: String) -> Bool {
            return verifier.uppercased() == verifierCharacter(rut: rut)
        }
        
        public static func verifierCharacter(rut: String) -> String {
            let digits = rut.characters.flatMap { Int(String($0)) }
            let indexedDigits = Array(digits.reversed().enumerated())
            let verifierCode = mod11(enumeratedDigits: indexedDigits)
            return verifierCharacter(code: verifierCode)
        }
        
        public static let K = "K"
        
        private static func makeFactor(index: Int) -> Int {
            return 2 + index % 6
        }
        
        private static func mod11(enumeratedDigits: [(offset: Int, element: Int)]) -> Int {
            let sum = enumeratedDigits.reduce(0) { (m, e) in
                return m + e.element * makeFactor(index: e.offset)
            }
            let code = 11 - sum % 11
            return code % 11
        }
        
        private static func verifierCharacter(code: Int) -> String {
            switch code {
            case 0...9: return String(code)
            case 10: return K
            default: fatalError("Invalid numeric code generated by mod11 algorithm")
            }
        }
    }

    func validateUser(rut:String, password:String){
       // self.guardarPersona()
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Login/"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do{
            var bodyData = "rut=\(rut)&password=\(password)"
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
        }catch let error {
            print(error.localizedDescription)
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            print(String(decoding: data, as: UTF8.self))
            print("access: \(self.access)")
            do {
                let decoder = JSONDecoder()
                let courses = try decoder.decode(LoginResponse.self, from: data)
                if(courses.status == "success"){
                    self.access = true
                    //siguientes metodos
                     self.obtenerDatosPersona()
                }
                self.group.leave()
            } catch let error {
                dissabledCargando()
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

struct UserBancosResponse: Decodable{
    var data: DataBancosResponse?
    var status: String?
}
struct DataBancosResponse: Decodable{
    var cuentaBancaria: BancoDetailResponse
  
}
struct BancoDetailResponse: Decodable{
    var numeroCuenta: Int?
    var tipoCuenta : TipoCuentaResponse
    var banco : BancoResponse
}
struct TipoCuentaResponse: Decodable{
    var descripcion: String?
    var codigo: Int?
    var identificador: String?
}
struct BancoResponse: Decodable{
    var descripcion: String?
    var codigo: Int?
}

struct UserInfoResponse: Decodable{
    var data: DataResponse?
    var status: String
}
struct UserInfoResponseSimple: Decodable{
    var data: DataResponseSimple?
    var status: String
}

struct DataResponse: Decodable{
    var persona: PersonaResponse
    var direccionPersona: DireccionResponse
    var detallesContactoPersona: DetallesResponse
    var listaInformacionComercial: informacionComercialListResponse
}
struct DataResponseSimple: Decodable{
    var persona: PersonaResponse
    var direccionPersona: DireccionResponse
    var detallesContactoPersona: DetallesResponse
    var listaInformacionComercial: informacionComercialListResponseSimple
}

struct PersonaResponse: Decodable{
    var rut : Int
    var fechaNacimiento : String
    var nombre : String
    var apellidoMaterno : String
    var apellidoPaterno : String
    var digitoVerificador : Int
    var ingresos : IngresosResponse
    var regimenSalud : DescripcionResponse
    var estadoCivil : DescripcionResponse
    var sexo : DescripcionResponse
}
struct DetallesResponse: Decodable{
    var numeroMovil : Int
    var numeroTelefono : Int
    var email : String = ""
    var codigoTelefonoMovil : CodCelResponse
    var codigoTelefono : CodTelResponse
}
struct CodTelResponse: Decodable{
  
    var descripcion : Int
      var codigo : Int
    
}
struct CodCelResponse: Decodable{
    var codigo : Int
    var descripcion : Int
    
}
struct DireccionResponse: Decodable{
    var calle : String
    var ciudad : CiudadResponse
    var comuna : ComunaResponse
     var region : RegionResponse
}
struct CiudadResponse: Decodable{
    var codigo : Int
    var descripcion : String
    
}

struct ComunaResponse: Decodable{
    var codigo : Int
    var descripcion : String
    
}
struct RegionResponse: Decodable{
    var codigo : Int
    var descripcion : String
    
}
struct IngresosResponse: Decodable{
    var rentaLiquida: Int
    var otrosIngresos: Int
}

struct DescripcionResponse: Decodable{
    var descripcion: String?
    var codigo: Int
}
