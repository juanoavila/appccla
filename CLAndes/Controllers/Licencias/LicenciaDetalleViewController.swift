//
//  LicenciaDetalleViewController.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 04-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class LicenciaDetalleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var licencia: LicenciaResponse?
    var licenciaDetalle: DetalleLicenciaResponse?
    var countAsync: Int = 0
    var dataLicenciaDet: Data?
    let group = DispatchGroup()
    var estadoCompinTxt: String = ""
    var estadosTabuladoTxt: String = ""
    var estadoCLATxt: String = ""
    var estadoSolPago = EstadoSolPagoResponse()
    var formaPagoTxt: String = ""
    var asyncCallNum01: Int = 2
    var asyncCallNum02: Int = 2
    var licenciaDetail = LicenciasDetailResponse()
    var detalleCuotas = CuotasResponse()
    let realm = try! Realm()
    var srvDetCuotaEncontrado = false
    var srvLicDetailEncontrado = false
    var listaEstadoSolicitudPago = [EstadoSolPagoResponse]()
    var listaEmpresas = ListEmpresasResponse()
    var buttonStatus = false
    var rut = ""
    var loadView = UIView()
    
    let identifier: String = "cellDetCuota"
    var contCuotas: Int = 0
    
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var diasLicencia: UILabel!
    @IBOutlet weak var estadoResumido: UILabel!
    @IBOutlet weak var fechasLicencia: UILabel!
    @IBOutlet weak var numeroLicencia: UILabel!
    @IBOutlet weak var fEmisionLabel: UILabel!
    @IBOutlet weak var fREcepcionLabel: UILabel!
    @IBOutlet weak var estadoCompin: UILabel!
    @IBOutlet weak var labelEstadoCaja: UILabel!
    @IBOutlet weak var labelTitleEstadoCompin: UILabel!
    
    
    @IBOutlet weak var formaPagoLabel: UILabel!
    @IBOutlet weak var valorSubsidio: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewEstCLA: UIView!
    @IBOutlet weak var viewEstCompin: UIView!
    @IBOutlet weak var estadosCLATitle: UILabel!
    @IBOutlet weak var formaPagoTitle: UILabel!
    @IBOutlet weak var viewFormaPago: UIView!
    @IBOutlet weak var viewValorSubsidio: UIView!
    @IBOutlet weak var valorSubsidioTitle: UILabel!
    @IBOutlet var viewContainer1: UIView!
    @IBOutlet weak var viewContainer2: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnPagoDeposito: UIButton!
    @IBOutlet weak var viewEncabezadoDetalle: UIView!
    @IBOutlet weak var viewFechaEmision: UIView!
    @IBOutlet weak var viewFechaRecepcion: UIView!
    
    @IBOutlet weak var viewDiasLicencias: UIView!
    @IBOutlet weak var labelDiasLicenciaTxt: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.countAsync = 0
        self.buttonStatus = UserDefaults.standard.bool(forKey: "btnPagoLicencia") ?? false
        self.inicializarDatos(rutUSuario: "\(rut)")
        
        self.btnPagoDeposito.isHidden = true
        if !buttonStatus {
            self.btnPagoDeposito.isHidden = true
        }else{
            if licencia!.VMostrarBotonSolicitar! {
                self.btnPagoDeposito.isHidden = false
            }
            
            if licencia!.VMostrarBotonModificar! && !licencia!.VMostrarBotonSolicitar! {
                let btnModificar = UIButton()
                btnModificar.frame = self.btnPagoDeposito.frame
                btnModificar.backgroundColor = self.btnPagoDeposito.backgroundColor
                btnModificar.titleLabel?.font = UIFont(name: "RawsonPro-Bold" , size: 25)
                btnModificar.setTitle("Modificar pago por depósito", for: .normal)
                btnModificar.addTarget(self, action: #selector(segueModificarPago) , for: .touchUpInside)
                viewContainer2.addSubview(btnModificar)
                
            }
        }
        loadView.isHidden = true
        dissabledCargando()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        rut = UserDefaults.standard.string(forKey: "rut")!

        loadView = getEmptyView(vista: view)
        view.addSubview(loadView)
        enabledCargando(msg: "Espera unos segundos")
    }
    
    @objc func segueModificarPago(_ sender: UIButton!){
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "ModificarPagoPorDepositoViewControllerIndentity") as? ModificarPagoPorDepositoViewController{
                
                vc.licencia = self.licencia!
                vc.licenciaDetalle = self.licenciaDetalle!
                //vc.listaEstadoSolicitudPago = self.listaEstadoSolicitudPago
                
                if let navigator = navigationController {
                    navigator.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func inicializarDatos(rutUSuario: String){
        
        self.group.enter()
        self.obtenerDetalleLicencia(rutUsuario: rutUSuario, nroLicencia: licencia!.VNumeroLicencia)
        //self.obtenerDetalleLicencia(rutUsuario: "43636464", nroLicencia: 19047168)
        self.obtenerEstadosSolicitudesPago(rut: rutUSuario)
        //self.obtenerEstadosSolicitudesPago(rut: "71084604")
        self.group.wait()
        
        self.group.enter()
        recorrerEstadoSolicitud()
        self.group.wait()
        
        self.countAsync = 0
        self.group.enter()
        self.obtenerEstadoCompin(sucursal: licenciaDetalle!.VSucursalRec, folio: licenciaDetalle!.VFolio)
        //self.obtenerEstadoCompin(sucursal: "09", folio: 832011)
        self.obtenerEstadosTabuladosCLA(sucursal: licenciaDetalle!.VSucursalRec, folio: licenciaDetalle!.VFolio)
        //obtenerEstadosTabuladosCLA(sucursal: "01", folio: 184433)
        self.group.wait()
        
        
        self.group.enter()
        self.obtenerEmpresas(rutUsuario: rutUSuario)
        self.group.wait()
        
        let empresas = self.listaEmpresas.data?.empresas
        
        for item in empresas! {
            if(!self.srvLicDetailEncontrado){
                self.group.enter()
                self.obtenerLicenciaDetail(folio: licenciaDetalle!.VFolio, rutEmpresa: "\(item.datosEmpresa?.rut ?? 0)", sucursal: "\(licenciaDetalle!.VSucursalRec)")
                self.group.wait()
            }else{
                break
            }
        }
        
        for item in empresas! {
            if(!self.srvDetCuotaEncontrado){
                self.group.enter()
                self.obtenerDetalleCuotas(rutEmpresa: "\(item.datosEmpresa?.rut ?? 0)", rut: rutUSuario, nroLicencia: licencia!.VNumeroLicencia)
                self.group.wait()
            }else{
                break
            }
        }
        
        
        
        
        diasLicencia.text = "\(licenciaDetalle!.VDiasReposo)"
        estadoResumido.text = licencia!.VEstado
        numeroLicencia.text = "Número de licencia: \(licencia!.VNumeroLicencia)"
        fechasLicencia.text = "Desde el \(UtilDate.formatDate(input: licenciaDetalle!.VFechaInicio)) al \(UtilDate.formatDate(input: licenciaDetalle!.VFechaTermino))"
        fEmisionLabel.text = UtilDate.formatDate(input: licenciaDetalle!.VFechaEmision)
        fREcepcionLabel.text = UtilDate.formatDate(input: licenciaDetalle!.VFechaRecepcion)
        estadoCompin.text = self.estadoCompinTxt
        
        
        if(self.estadoCLATxt != ""){
            labelEstadoCaja.text = self.estadoCLATxt
        }else{
            labelEstadoCaja.text = "No tienes tramitación pendiente"
        }
        
        if(formaPagoTxt.isEmpty){
            self.formaPagoTxt = "Banco: \(estadoSolPago.nombreBanco) \n\n"
            self.formaPagoTxt.append("Tipo de cuenta: \(estadoSolPago.tipoCuenta) \n\n")
            self.formaPagoTxt.append("Número de cuenta: \(estadoSolPago.nroCuentaBanco)")
        }
        formaPagoLabel.text = self.formaPagoTxt
        
        if(self.buttonStatus){
            valorSubsidio.text? = "\(licenciaDetail.data?.disponibleParaCobro.montoPagado.FormatMoney() ?? "$000.000")"
        }
        
        
        
        self.tableView.reloadData()
        self.resizeAndPositionViews()
    }
    
    func resizeAndPositionViews(){
        
        var vwidth = CGFloat()
        if diasLicencia.text?.count ?? 1 > 2 {
            vwidth = CGFloat(10 * (diasLicencia.text?.count ?? 1) + 8)
        }else{
            vwidth = CGFloat(10 * (diasLicencia.text?.count ?? 1) + 10)
        }

        diasLicencia.frame = CGRect(x: 10, y: diasLicencia.frame.minY, width: vwidth, height: diasLicencia.frame.height)
        
        labelDiasLicenciaTxt.frame = CGRect(x: diasLicencia.frame.minX + diasLicencia.frame.width, y: labelDiasLicenciaTxt.frame.minY, width: labelDiasLicenciaTxt.frame.width, height: labelDiasLicenciaTxt.frame.height)
        
        let anchoVeiw = labelDiasLicenciaTxt.frame.maxX + diasLicencia.frame.minX
        viewDiasLicencias.frame = CGRect(x: viewDiasLicencias.frame.minX, y: viewDiasLicencias.frame.minY,
                width: anchoVeiw + 10, height: viewDiasLicencias.frame.height )
     
        viewDiasLicencias.layer.cornerRadius = 7
        viewDiasLicencias.clipsToBounds = true
        
//      ************ Final Sección dias licencias ***********
        
        estadoResumido.frame = CGRect(x: estadoResumido.frame.minX, y: estadoResumido.frame.minY,
                                      width: estadoResumido.frame.width, height: CGFloat(estadoResumido.calculateMaxLines() * 20))
        

        if (estadoResumido.text!.containsIgnoringCase(find: "Pagada") ||
            estadoResumido.text!.containsIgnoringCase(find: "En proceso de pago") ||
            estadoResumido.text!.containsIgnoringCase(find: "Disponible para pago") ||
            estadoResumido.text!.containsIgnoringCase(find: "sin requisitos pendientes en Caja")) {
            estadoResumido.textColor = UIColor.init(hexString: "#00bd70")
        }else if(estadoResumido.text!.containsIgnoringCase(find: "Rechazada") ||
            estadoResumido.text!.containsIgnoringCase(find: "Prescrita") ||
            estadoResumido.text!.containsIgnoringCase(find: "Devuelta por")){
            estadoResumido.textColor = UIColor.init(hexString: "#ff4337")
        }else if(estadoResumido.text!.containsIgnoringCase(find: "con requisitos pendientes en Caja")){
            estadoResumido.textColor = UIColor.init(hexString: "#f9be00")
        }
        
        let value = CGFloat((estadoResumido.calculateMaxLines() - 1) * 17)
        fechasLicencia.frame = CGRect(x: fechasLicencia.frame.minX, y: fechasLicencia.frame.minY + value,
                                      width: fechasLicencia.frame.width, height: fechasLicencia.frame.height)
        
        numeroLicencia.frame = CGRect(x: numeroLicencia.frame.minX, y: numeroLicencia.frame.minY + value,
                                      width: numeroLicencia.frame.width, height: numeroLicencia.frame.height)
        
        viewEncabezadoDetalle.frame = CGRect(x: viewEncabezadoDetalle.frame.minX, y: viewEncabezadoDetalle.frame.minY,
                                             width: viewEncabezadoDetalle.frame.width, height: viewEncabezadoDetalle.frame.height + value)
        
        viewEncabezadoDetalle.layer.cornerRadius = 7
        viewEncabezadoDetalle.clipsToBounds = true
//        *********** Final Sección encabezado detalle licencia
        viewFechaEmision.frame = CGRect(x: viewFechaEmision.frame.minX, y: viewFechaEmision.frame.minY + value,
                                        width: viewFechaEmision.frame.width, height: viewFechaEmision.frame.height)
        viewFechaEmision.layer.cornerRadius = 7
        viewFechaEmision.clipsToBounds = true
        
        viewFechaRecepcion.frame = CGRect(x: viewFechaRecepcion.frame.minX, y: viewFechaRecepcion.frame.minY  + value,
                                          width: viewFechaRecepcion.frame.width, height: viewFechaRecepcion.frame.height)

        viewFechaRecepcion.layer.cornerRadius = 7
        viewFechaRecepcion.clipsToBounds = true
//        ********** Final Sección fechas *******************
        
        labelTitleEstadoCompin.frame = CGRect(x: labelTitleEstadoCompin.frame.minX, y: labelTitleEstadoCompin.frame.minY  + value,
                                          width: labelTitleEstadoCompin.frame.width, height: labelTitleEstadoCompin.frame.height)
        
        viewEstCompin.frame = CGRect(x: viewEstCompin.frame.minX, y: viewEstCompin.frame.minY + value,
                                     width: viewEstCompin.frame.width, height: CGFloat(estadoCompin.calculateMaxLines() * 35))
        viewEstCompin.layer.cornerRadius = 5;
        viewEstCompin.layer.masksToBounds = true;
        //estadoCompin.lineBreakMode = .byWordWrapping
//      ************* Final Sección estado Compin ********************
        
        estadosCLATitle.frame = CGRect(x: estadosCLATitle.frame.minX, y: viewEstCompin.frame.minY + viewEstCompin.frame.height + 10,
                                       width: estadosCLATitle.frame.width, height: estadosCLATitle.frame.height)
        
        var valueEstCompin = CGFloat(0)
        if (estadoCompin.calculateMaxLines() <= 2){
            valueEstCompin = CGFloat(30)
        }
        
        viewEstCLA.frame = CGRect(x: viewEstCLA.frame.minX, y: estadosCLATitle.frame.minY + 25, width: viewEstCLA.frame.width, height: CGFloat(20 + (labelEstadoCaja.calculateMaxLines() * 20)))
        viewEstCLA.layer.cornerRadius = 5;
        viewEstCLA.layer.masksToBounds = true;
//      ************* Final Sección estado caja
        
        //estadoCLA.frame = CGRect(x: estadoCLA.frame.minX, y: viewEstCLA.frame.maxY, width: estadoCLA.frame.width, height: estadoCLA.frame.height)
        
        formaPagoTitle.frame = CGRect(x: formaPagoTitle.frame.minX, y: viewEstCLA.frame.minY + viewEstCLA.frame.height + 10,
                                      width: formaPagoTitle.frame.width, height: formaPagoTitle.frame.height)
        
        viewFormaPago.frame = CGRect(x: viewFormaPago.frame.minX, y: formaPagoTitle.frame.minY + formaPagoTitle.frame.height,
                                     width: viewFormaPago.frame.width, height: CGFloat(20 + (formaPagoLabel.calculateMaxLines() * 20)))
        viewFormaPago.layer.cornerRadius = 5;
        viewFormaPago.layer.masksToBounds = true;
        
        //formaPagoLabel.frame = CGRect(x: viewFormaPago.frame.minX, y: formaPagoTitle.frame.minY + formaPagoTitle.frame.height+10,
        //                           width: viewFormaPago.frame.width, height: CGFloat(formaPagoLabel.calculateMaxLines() * 20))
        
        
        if(self.buttonStatus){
        
            viewValorSubsidio.frame = CGRect(x: viewValorSubsidio.frame.minX, y: viewFormaPago.frame.maxY + 20,
                                             width: viewValorSubsidio.frame.width, height: CGFloat(40))
            viewValorSubsidio.layer.cornerRadius = 5;
            viewValorSubsidio.layer.masksToBounds = true;
            
            valorSubsidio.frame = CGRect(x: valorSubsidio.frame.minX, y: 10, width: valorSubsidio.frame.width, height: valorSubsidio.frame.height)
            valorSubsidioTitle.frame = CGRect(x: valorSubsidioTitle.frame.minX, y: 10, width: valorSubsidioTitle.frame.width, height: valorSubsidioTitle.frame.height)
        }else{
            viewValorSubsidio.isHidden = true
            valorSubsidio.isHidden = true
        }
        
            
        tableView.frame = CGRect(x: tableView.frame.minX, y: viewValorSubsidio.frame.maxY + 20, width: tableView.frame.width, height: CGFloat(130 * (detalleCuotas.data.cuotas?.count)!))
        btnPagoDeposito.frame = CGRect(x: 0, y: tableView.frame.maxY + 20, width: self.view.frame.width, height: 40)
        
        constraint1.constant = CGFloat(btnPagoDeposito.frame.minY+btnPagoDeposito.frame.height+2)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detalleCuotas.data.cuotas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DetalleCuotaCell {
            contCuotas += 1
            cell.selectionStyle = .none
            cell.configurateTheCell((detalleCuotas.data.cuotas?[indexPath.row])!, totalCuotas: detalleCuotas.data.cuotas?.count ?? 1, numCuota: contCuotas, sucursal: self.licenciaDetalle!.VSucursalRec, folio: (self.licenciaDetalle?.VFolio)!, navigation: self.navigationController, index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            if (segue.identifier == "pagoPorDeposito"){
                guard let vc = segue.destination as? PagoPorDepositoViewController else { return }
                vc.licencia = self.licencia!
                vc.licenciaDetalle = self.licenciaDetalle!
            }
        }
    }
    
    
    
    func obtenerDetalleLicencia(rutUsuario: String, nroLicencia: Int){
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/consultaDetalleLicencia/?rut=\(rutUsuario)&nroLicencia=\(nroLicencia)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                self.countAsync += 1
                let decoder = JSONDecoder()
                let detLicencias = try decoder.decode(DetLicenciaSrvResponse.self, from: data)
                if(detLicencias.status == "success"){
                    self.licenciaDetalle = detLicencias.data.DetalleLicenciaSalida.DetalleLicencia
                }
                
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            }
            
        } )
        task.resume()
    }
    
    
    
    func obtenerEstadoCompin(sucursal: String, folio: Int){
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/AdapterGestionCompinCLA/?SucRec=\(sucursal)&Folio=\(folio)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                self.countAsync += 1
                let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as AnyObject
                if let dts = json["data"] as? NSDictionary {
                    if(dts.count > 0){
                        
                        let status = json["status"] as! String
                        
                        if(status == "success"){
                            let estado = json["data"] as! [String: AnyObject]
                            if(estado["return"] != nil){
                                self.estadoCompinTxt = estado["return"] as! String
                            }
                        }
                    }
                }
                
                if(self.countAsync == self.asyncCallNum02){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
                if(self.countAsync == self.asyncCallNum02){
                    self.group.leave()
                }
            }
            
        } )
        task.resume()
    }
    
    
    func obtenerEstadosTabuladosCLA(sucursal: String, folio: Int){
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/EstadosTabulados/?sucursal=\(sucursal)&folio=\(folio)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                self.countAsync += 1
                let datos = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as AnyObject
                if let dts = datos["data"] as? NSDictionary {
                    if(dts.count > 0){
                        
                        let decoder = JSONDecoder()
                        let estTabulados = try decoder.decode(EstadosTabuladosResponse.self, from: data)
                        if(estTabulados.status == "success"){
                            let et = estTabulados.data
                            if (et == nil || et?.count == 0) {
                                self.estadoCLATxt = "No tiene tramitaciones pendientes"
                            }else{
                                var cont:Int = 1
                                for est in et! {
                                    if(cont < et!.count){
                                        self.estadoCLATxt.append("\(est.Descripcion)\n")
                                    }else{
                                        self.estadoCLATxt.append("\(est.Descripcion)")
                                    }
                                    cont += 1
                                }
                            }
                        }
                    }
                }
                
                if(self.countAsync == self.asyncCallNum02){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
                if(self.countAsync == self.asyncCallNum02){
                    self.group.leave()
                }
            }
            
        } )
        task.resume()
    }
    
    
    
    func obtenerEstadosSolicitudesPago(rut: String){
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/EstadoSolicitudesPago/?rut=\(rut)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                self.countAsync += 1
                print("DATOS: \(String(decoding: data, as: UTF8.self))")
                let datos = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as AnyObject
                if let dts = datos["data"] as? [NSDictionary] {
                    if(dts.count > 0){
                        let decoder = JSONDecoder()
                        let estados = try decoder.decode(EstadosSolicitudPagoResponse.self, from: data)
                        
                        if(estados.status == "success"){
                            let esp = estados.data
                            if (esp == nil || esp?.count == 0) {
                                self.formaPagoTxt = "Efectivo"
                            }else{
                                self.listaEstadoSolicitudPago = esp!
                                var flag = false;
                                for estado in esp! {
                                    if(estado.nroLicencia == self.licencia?.VNumeroLicencia){
                                        self.estadoSolPago = estado
                                        flag = true
                                        break
                                    }
                                }
                                if(flag == false){
                                    self.formaPagoTxt = "Efectivo"
                                }
                            }
                        }
                    }else{
                        self.formaPagoTxt = "Efectivo"
                    }
                }else{
                    self.formaPagoTxt = "Efectivo"
                }
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                print(error.localizedDescription)
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            }
            
        } )
        task.resume()
    }
    
    //Recorrer licencia
    func recorrerEstadoSolicitud(){
        
        self.listaEstadoSolicitudPago.enumerated().forEach{ (index, item) in
            if item.nroLicencia == self.licencia?.VNumeroLicencia {
                self.licencia?.VTipoFormulario = item.tipoFormulario
                self.licencia?.VFlag = 2
            }
        }
        self.group.leave()
        
    }
    
    //Sin oauth
    func obtenerLicenciaDetail(folio: Int, rutEmpresa: String, sucursal: String){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/LicenciasDetail/?folioLicencia=\(folio)&rutEmpresa=\(rutEmpresa)&sucursalCreacion=\(sucursal)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                self.countAsync += 1
                let decoder = JSONDecoder()
                self.licenciaDetail = try decoder.decode(LicenciasDetailResponse.self, from: data)
                
                if(self.licenciaDetail.status == "success"){
                    self.srvLicDetailEncontrado = true
                }
                
                self.group.leave()
            } catch let error {
                print(error.localizedDescription)
                self.group.leave()
            }
            
        } )
        task.resume()
    }
    
    //Sin Oauth
    func obtenerDetalleCuotas(rutEmpresa: String, rut: String, nroLicencia: Int){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/DetalleCuota/?rutEmpresa=\(rutEmpresa)&rut=\(rut)&nroLicencia=\(nroLicencia)"
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let datos = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as AnyObject
                if let dts = datos["data"] as? NSDictionary {
                    if(dts.count > 0){
                        let decoder = JSONDecoder()
                        self.detalleCuotas = try decoder.decode(CuotasResponse.self, from: data)
                        
                        if(self.detalleCuotas.status == "success"){
                            self.srvDetCuotaEncontrado = true
                        }
                    }
                }
                self.group.leave()
            } catch let error {
                print(error.localizedDescription)
                self.group.leave()
            }
        } )
        task.resume()
    }
    
    
    func obtenerEmpresas(rutUsuario: String){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Empresas/?rut=\(rutUsuario)"
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
                let datos = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as AnyObject
                if let dts = datos["data"] as? NSDictionary {
                    if(dts.count > 0){
                        let decoder = JSONDecoder()
                        self.listaEmpresas = try decoder.decode(ListEmpresasResponse.self, from: data)
                        
                    }
                }
                self.group.leave()
            } catch let error {
                print(error.localizedDescription)
                self.group.leave()
            }
            
        } )
        task.resume()
    }
    
}
