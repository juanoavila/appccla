//
//  CreditosController.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/12/18.
//  Copyright © 2018 akhil. All rights reserved.
//
import Foundation

import Alamofire
import UIKit
import RealmSwift

class CreditosController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let lista = ["Mis créditos"]
    var loadingView : LoadingView!
    var misCreditosList: [MisCreditosData] = []
    
    
    override func viewDidLoad() {
        self.loadingView = LoadingView(uiView: view, message: "Cargando tus datos")
        self.loadingView.show()
        self.obtenerCreditos()
      //
    }
    func obtenerCreditos(){
        
        let rut = UserDefaults.standard.string(forKey: "rut")
        var tempDatos: [MisCreditosData] = []
        let rutSnPoint = rut!.replacingOccurrences(of: ".", with: "")
        let rutSend = rutSnPoint.replacingOccurrences(of: "-", with: "")
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Creditos/?rut=\(rutSend)"//160101474"
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
                    let courses = try decoder.decode(UserCreditosResponse.self, from: data)
                    
                    var lista  = (courses.data?.creditos)!
                    for item in lista {
                        var cred = MisCreditosData(fechaOtorg: item.fechaOtorgamiento, estado: item.estado,codigo: item.codigoCredito, monto: item.montoOtorgado)
                        self.misCreditosList.append(cred)
                    }
                    
                    self.loadingView.hide()
                    
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                       self.loadingView.hide()
                }
            }
            }.resume()
        
    }
}

extension CreditosController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lista.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellCreditos//UITableViewCell(style: .default, reuseIdentifier: "cell")
        //  cell.textLabel?.text = lista[indexPath.row]
        cell.lblCreditos.text = lista[indexPath.row]
        print(cell)
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.textLabel)
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        
        if (misCreditosList.count < 1){
            
        var SnCred = storyboard.instantiateViewController(withIdentifier: "SinCreditosController") as! SinCreditosController
            self.navigationController?.pushViewController(SnCred, animated: true)
        }else{
            var creditos = storyboard.instantiateViewController(withIdentifier: "MisCreditos") as! MisCreditos
            creditos.recibeArray(list: self.misCreditosList)
            self.navigationController?.pushViewController(creditos, animated: true)
        }
        
       // print(self.misCreditosList)
       
       
    }
}
