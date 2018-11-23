//
//  ViewController.swift
//  mySidebar2
//
//  Created by Muskan on 10/12/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var hola: UIButton!
    var sidebarView: SidebarView!
    var blackScreen: UIView!
    var home: UIView!
    var loadingView : LoadingView!
    var arregloImagenes = [AnyObject]()
    var btnCredito : UIButton!
    var yourArray = [String]()
    var islogin : Bool = false
    let a = DispatchGroup()
    let v = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem!.tintColor = UIColor.white
        self.title = "Más Caja para ti"
        self.islogin  = UserDefaults.standard.bool(forKey: "loggin")// this is how you retrieve the bool value
        print(self.islogin)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirAyuda(_:)), name: Notification.Name(rawValue: "¿Te Ayudamos?"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirPerfil(_:)), name: Notification.Name(rawValue: "Mi cuenta"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(abrirLicencias(_:)), name: Notification.Name(rawValue: "Licencias Médicas"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirBeneficios(_:)), name: Notification.Name(rawValue: "Mis Beneficios"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirCreditos(_:)), name: Notification.Name(rawValue: "Créditos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirSucursales(_:)), name: Notification.Name(rawValue: "Sucursales"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirConvenios(_:)), name: Notification.Name(rawValue: "Convenios"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abrirVendo(_:)), name: Notification.Name(rawValue: "Más Café"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cerrarSesion(_:)), name: Notification.Name(rawValue: "Cerrar sesión"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(abrirBuzon(_:)), name: Notification.Name(rawValue: "Buzón de Mensajes"), object: nil)

        
        let btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(btnMenuAction))
        btnMenu.tintColor=UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = btnMenu
        
        sidebarView=SidebarView(frame: CGRect(x: 30, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate=self
        sidebarView.layer.zPosition=100
        //self.tabBarItem.ba
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
        self.navigationController?.view.backgroundColor = UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
        
        
        self.view.isUserInteractionEnabled=true
        self.navigationController?.view.addSubview(sidebarView)
        
        blackScreen=UIView(frame: self.view.bounds)
        //blackScreen.backgroundColor=UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden=true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition=992
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
        home = ViewHome()
        
        
        var myVC  = Bundle.main.loadNibNamed("ViewHome", owner: self, options: nil)?[0] as? ViewHome
        var esCarga = ""
        do{
            esCarga = UserDefaults.standard.value(forKey: "esCarga") as! String
            
        }catch{
            print(error)
        }
        
        let arrayNomHome = UserDefaults.standard.value(forKey: "arregloHomeNom")as! [String]
        let arrayImageName = self.arrayImagen(arregloHome: arrayNomHome)
        myVC?.frame = CGRect(x: 0, y: 90, width:(myVC?.frame.width)!, height: (myVC?.frame.height)!)
        myVC?.setImagen(arregloImg: arrayImageName)
        myVC?.setNomButton(titulos: arrayNomHome as [AnyObject] )
        if (esCarga == "carga"){
            myVC?.setMenuCarga()
            myVC?.setImagenCarga(arregloImg: arrayImageName)
        }
        
        self.view.addSubview(myVC!)
    }
    
    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
        }) { (complete) in
            self.blackScreen.frame=CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    @objc func abrirAyuda(_ notification: Notification)  {
         abrirVista(vista: "AyudaController")
    }
    
    @objc func abrirLicencias(_ notification: Notification) {

        if self.islogin {
            print("LICENCIAS ")
            abrirVista(vista: "LicenciasTableViewController")
        }else {
            abrirVista(vista: "LoginController", mensajeModulo: "Licencias Médicas")
        }
 
    }
    
    
    @objc func abrirPerfil(_ notification: Notification) {
        print("PERFIL")
        if self.islogin {
             abrirVista(vista: "PerfilViewController")
        
        }else {
             abrirVista(vista: "LoginController")
        }
      
    }
    @objc func abrirBeneficios(_ notification: Notification) {
        
        if (self.islogin){
            print("BENEFICIOS")
            abrirVista(vista: "BeneficiosMainController")
        }else {
            abrirVista(vista: "LoginController", mensajeModulo: "Mis Beneficios")
        }
        /*
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }*/
      
    }
    @objc func abrirCreditos(_ notification: Notification) {
        print("CREDITOS")
        if (self.islogin){
            abrirVista(vista: "CreditosController")
        }else {
             abrirVista(vista: "LoginController", mensajeModulo: "Créditos" )
        }

        
        
    }
    @objc func abrirVendo(_ notification: Notification) {
         //let realm = try! Realm()
        //let puppies = realm.objects(MenuIos.self)
       // print(puppies)
         abrirVista(vista: "VendomaticaViewControllerIdentity")
        print("MAS CAFE")
        
    }
    @objc func abrirSucursales(_ notification: Notification) {
        print("SUCURSALES")
        abrirVista(vista: "SucursalesViewController")
  
    }
    @objc func abrirConvenios(_ notification: Notification) {
        print("CONVENIOS")
        abrirVista(vista: "ConveniosViewController")
    }

    @objc func abrirBuzon(_ notification: Notification) {
        
        if self.islogin {
            print("BUZON ")
            abrirVista(vista: "ListadoMensajesTableViewController")
        }else {
            abrirVista(vista: "LoginController", mensajeModulo: "Buzón de mensajes")
        }
        /*
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginController")
        self.navigationController?.pushViewController(login, animated: true)*/
        
    }
    @objc func cerrarSesion(_ notification: Notification)  {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        UserDefaults.standard.set("afiliado" , forKey: "esCarga")
        UserDefaults.standard.set(false , forKey: "loggin")
        let arregloNomMenu = ["Bienvenido","bienvenido", "Home", "Mi cuenta","Buzón de Mensajes","Sucursales", "Convenios", "Licencias Médicas", "Mis Beneficios", "¿Te Ayudamos?" ]
        
       let arrayNomHome = ["Licencias Médicas","Sucursales","Convenios","Mis Beneficios", "¿Te Ayudamos?","Buzón de Mensajes","Vendomatica","Créditos"]
        
        UserDefaults.standard.set(arrayNomHome , forKey: "arregloHomeNom")
        UserDefaults.standard.set(arregloNomMenu , forKey: "arregloMenuNom")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
       
        appDelegate?.llenaArray()
        appDelegate?.construyeMenu()
         self.viewDidLoad()
       /* var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginController")
        self.navigationController?.pushViewController(login, animated: true)*/
        
    }
    
    func abrirVista(vista : String, mensajeModulo: String = ""){
        
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: vista)
            self.navigationController?.pushViewController(login, animated: true)
            
            if(!self.islogin){
                UserDefaults.standard.set(mensajeModulo , forKey: "msjModuloLogin")
            }
        }
    }
    
    func arrayImagen (arregloHome: [String]) -> [String] {
        yourArray = []
        for arreglo in arregloHome {
            print(arreglo)
            //var algo: String = arreglo as! String
            switch arreglo
            {
            case "Buzón de Mensajes":
                yourArray.append("home_buzon")
            case "Licencias Médicas":
                yourArray.append("home_licencias")
            case "Convenios":
                yourArray.append("home_convenios")
            case "¿Te Ayudamos?":
                yourArray.append("home_ayuda")
            case "Mis Beneficios":
                yourArray.append("home_beneficios")
            case "Sucursales":
                yourArray.append("home_sucursal")
            case "Créditos":
                yourArray.append("home_credito")
            case "Vendomatica":
                yourArray.append("vendomatica")
            default:
                break
            }
        }
        return yourArray
    }
    
}


extension ViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        var titleArr = UserDefaults.standard.value(forKey: "arregloMenuNom") as! [String]
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        
        switch row {
        case .saludo:
            print(titleArr[1])
             NotificationCenter.default.post(name: Notification.Name(rawValue: "Mi cuenta"), object: nil)
        case .primero:
            print(titleArr[2])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[2]), object: nil)
        case .segundo:
            print(titleArr[3])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[3]), object: nil)
        case .tercero:
            print(titleArr[4])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[4]), object: nil)
        case .cuarto:
            print(titleArr[5])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[5]), object: nil)
        case .quinto:
            print(titleArr[6])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[6]), object: nil)
        case .sexto:
            print(titleArr[7])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[7]), object: nil)
        case .septimo:
            print(titleArr[8])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[8]), object: nil)
        case .octavo:
            print(titleArr[9])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[9]), object: nil)
        case .noveno:
            print(titleArr[10])
            NotificationCenter.default.post(name: Notification.Name(rawValue: titleArr[10]), object: nil)
        case .cerrar:
            print("cerrar")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Cerrar sesión"), object: nil)
            
          break
            
        }
    }
    
    struct ResponseObject: Codable {
        let envelope: Envelope
    }
    struct Envelope: Codable {
        let body: Body
    }
    struct Body: Codable {
        let entBusquedaSucursalConCajaListaOutABM: EntBusquedaSucursalConCajaListaOutABM
    }
    
    struct EntBusquedaSucursalConCajaListaOutABM: Codable {
        let sucursalLista: Sucursal
    }
    
    struct Sucursal: Codable {
        let sucursal: [NewsItem]
    }
    struct NewsItem: Codable {
        
        let horario: String
        let nombreSucursal: String
        enum CodingKeys: String, CodingKey {
            case horario = "horario"
            case nombreSucursal = "nombreSucursal"
            
            
        }
    }
    
}
struct respuestaObj: Codable {
    let data: Persona
}
struct Persona: Codable {
    let rut: String
    let digitoVerificador: String
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String
    enum CodingKeys: String, CodingKey {
        case rut = "rut"
        case digitoVerificador = "digitoVerificador"
        case nombre = "nombre"
        case apellidoPaterno = "apellidoPaterno"
        case apellidoMaterno = "apellidoMaterno"
        
    }
    
}
/*
 extension ViewController: UITabBarController{
 //override var editButtonItem: UIBarButtonItem
 let downloadViewController = LoginAuxViewController()
 downloadViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
 let bookmarkViewController = AyudaController()
 bookmarkViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
 let favoritesViewControllers = AyudaController()
 favoritesViewControllers.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
 let viewControllerList = [ downloadViewController, bookmarkViewController, favoritesViewControllers ]
 viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
 
 }*/
