//
//  LicenciasTableViewController.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 26-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class LicenciasTableViewController: UITableViewController {
    
    var licencias = [LicenciaResponse]()
    let identifier: String = "licenciaCell"
    let group = DispatchGroup()
    let viewEmpty = UIView()
    var convenioSIL = ConvenioSILResponse()
    var numeroLicencia = NumeroLicenciaResponce()
    var asyncCallNum01: Int = 3
    var countAsync: Int = 0
    var loadingView : LoadingView!
    var loadView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
     
        self.countAsync = 0
        inicializarLicencias()
        self.tableView.tableFooterView = UIView()
        //vista cuando no se encuentran datos
        
        viewEmpty.frame = view.frame
        viewEmpty.backgroundColor = .white
        
        let imageEmpty = UIImageView()
        imageEmpty.frame = CGRect(x: view.frame.width / 2 - 50, y: 40, width: 100, height: 100)
        imageEmpty.image = UIImage(named: "no_licencias")
        viewEmpty.addSubview(imageEmpty)
        
        let emptyMessage = UILabel()
        emptyMessage.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: 40)
        emptyMessage.text = "No tienes licencias médicas"
        emptyMessage.textAlignment = .center
        emptyMessage.textColor = UIColor(red:0.09, green:0.59, blue:0.83, alpha:1)
        //emptyMessage.font = emptyMessage.font.withSize(22)
        emptyMessage.font = UIFont(name: "RawsonPro-Regular" , size: 20)
        viewEmpty.addSubview(emptyMessage)
        
        loadView.isHidden = true
        dissabledCargando()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadView = getEmptyView(vista: view)
        view.addSubview(loadView)
        enabledCargando(msg: "Espera unos segundos")
        
    }
    
    
    func inicializarLicencias(){
        group.enter()
        let rut = UserDefaults.standard.string(forKey: "rut")
        self.obtenerLicencias(rutUsuario: rut!)
        self.obtenerConvenioSIL(rut: rut!)
        self.obtenerNumeroLicencia(rut: rut!)
        
        group.wait()
        
        group.enter()
        self.recorrerLicencias()
        group.wait()
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LicenciaCell {
            cell.configurateTheCell(licencias[indexPath.row])
            tableView.rowHeight = 200
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let licencia = licencias[indexPath.row]
        
        let count = licencia.VEstado.count
        
        if count > 30{
            return 140
        } else {
            return 110
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if licencias.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return licencias.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "licenciaDetail", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "licenciaDetail",
            let indexPath = self.tableView?.indexPathForSelectedRow,
            let destinationViewController: LicenciaDetalleViewController = segue.destination as? LicenciaDetalleViewController {
            print(licencias[indexPath.row])
            destinationViewController.licencia = licencias[indexPath.row]
        }
    }
    
    
    func obtenerLicencias(rutUsuario: String){
        
        print("RUT: \(rutUsuario)")
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/AdapterLicencias/?rut=\(rutUsuario)"
        
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
                let listaLicencias = try decoder.decode(LicenciasSrvResponse.self, from: data)
                if(listaLicencias.status == "success"){
                    self.licencias = listaLicencias.data.ListaLicenciasSalida?.ListLicencias ?? [LicenciaResponse]()
                }
                if self.licencias.count == 0{
                    self.tableView.addSubview(self.viewEmpty)
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
    
    
    func obtenerConvenioSIL(rut: String){
        
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/AdapterConvenioSIL/?rut=\(rut)"
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
                self.convenioSIL = try decoder.decode(ConvenioSILResponse.self, from: data)
                print(self.convenioSIL)
                if self.convenioSIL.data?.Convenio == "N"{
                    UserDefaults.standard.set(true, forKey: "btnPagoLicencia")
                }
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
    
    func obtenerNumeroLicencia(rut: String){
        
        print("NUMERO LICENCIAS: \(self.licencias)")
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/NumeroLicencia/?rut=\(rut)"
        print(urlString)
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
                print("NUMERO LICENCIAS: \(self.licencias)")
                self.countAsync += 1
                let decoder = JSONDecoder()
                self.numeroLicencia = try decoder.decode(NumeroLicenciaResponce.self, from: data)
                
                
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
            } catch let error {
                if(self.countAsync == self.asyncCallNum01){
                    self.group.leave()
                }
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
    func recorrerLicencias(){
        var numLicencias: [Int] = []
        print(self.numeroLicencia.data)
        if self.numeroLicencia.data != nil{
            for item in self.numeroLicencia.data!{
                if(item.nroFormulario != nil){
                    numLicencias.append(item.nroLicencia!)
                }
            }
        }
        
        self.licencias.enumerated().forEach{ (index, item) in
            self.licencias[index].VMostrarBotonSolicitar = false
            self.licencias[index].VMostrarBotonModificar = false
            
            if self.numeroLicencia.data != nil{
                if numLicencias.contains(item.VNumeroLicencia){
                    //Si se encuentra en la lista se muestra "Solicitar pago"
                    self.licencias[index].VMostrarBotonSolicitar = true
                    self.licencias[index].VTipoFormulario = self.numeroLicencia.data![index].nroFormulario
                    self.licencias[index].VFlag = 1
                }else{
                    //Si no se encuentra en la lista se verifica si el estado es distinto de "Pagada" para mostrar "Modificar pago"
                    if !item.VEstado.equalsStr(find: "Pagada"){
                        self.licencias[index].VMostrarBotonModificar = true
                    }else{
                        self.licencias[index].VMostrarBotonModificar = false
                    }
                }
            }
        }
        
        self.group.leave()
        
    }
    
}
