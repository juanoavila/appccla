//
//  MisCreditos.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/12/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Alamofire
import UIKit
import RealmSwift

class MisCreditos: UIViewController{

    var misCreditosList: [MisCreditosData] = []
    @IBOutlet weak var tableView: UITableView!
    
   
    
    override func viewDidLoad() {
        self.title = "Créditos"
        if (misCreditosList.count < 1) {
            
        }
        for item in misCreditosList{
        print(item)
        }
     //   self.obtenerCreditos()
       // misCreditosList = createArray()
    }
 /*   func createArray() -> [MisCreditosData] {
        var tempDatos: [MisCreditosData] = []
        let dato1 = MisCreditosData(fechaOtorg: "07-10-2013", estado: "Vigente", monto: "$1.400.000")
         let dato2 = MisCreditosData(fechaOtorg: "07-10-2014", estado: "Vigente", monto: "$100.000")
         let dato3 = MisCreditosData(fechaOtorg: "07-10-2016", estado: "Vigente", monto: "$1.100.000")
         let dato4 = MisCreditosData(fechaOtorg: "07-10-2011", estado: "Vigente", monto: "$1.200.000")
         let dato5 = MisCreditosData(fechaOtorg: "07-10-2010", estado: "Vigente", monto: "$2.400.000")
         let dato6 = MisCreditosData(fechaOtorg: "07-10-2018", estado: "Vigente", monto: "$1.700.000")
        tempDatos.append(dato1)
        tempDatos.append(dato2)
        tempDatos.append(dato3)
        tempDatos.append(dato4)
        tempDatos.append(dato5)
        tempDatos.append(dato6)
        return tempDatos
    }*/
    
    func recibeArray(list: [MisCreditosData]){
        self.misCreditosList = list
    }
}

struct UserCreditosResponse: Decodable{
    var data: DataCreditosResponse?
    var status: String
}
struct DataCreditosResponse: Decodable{
    var creditos: [CreditosResponse]
    
}

struct CreditosResponse: Decodable {
    var codigoCredito: String
    var fechaOtorgamiento: String
    var montoOtorgado: Int
     var estado: String
     var tipoProducto: String
     var sucursal: CreditosSucursalResponse
}
struct CreditosSucursalResponse: Decodable {
    var descripcion: String
    var codigo: Int
   
}


extension MisCreditos: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (misCreditosList.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMisCred") as! CellMisCreditos//UITableViewCell(style: .default, reuseIdentifier: "cell")
        //  cell.textLabel?.text = lista[indexPath.row]
        let dato = misCreditosList[indexPath.row]
        cell.setDatos(datos: dato)
        print(cell)
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.textLabel)
        let codCred : String = misCreditosList[indexPath.row].codigo
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let detCred = storyboard.instantiateViewController(withIdentifier: "CreditoDetailController") as! CreditoDetailController
        detCred.setValueCodCred(codigo: codCred)
        self.navigationController?.pushViewController(detCred, animated: true)
    }
}
