//
//  CreditoDetailController.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/13/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import Foundation
class CreditoDetailController: UIViewController {
    
    @IBOutlet weak var estadoLbl: UILabel!
    @IBOutlet weak var saldoCapLbl: UILabel!
    @IBOutlet weak var valorCuotaLbl: UILabel!
    @IBOutlet weak var codigoCredLbl: UILabel!
    
    @IBOutlet weak var fechOtorgLbl: UILabel!
    @IBOutlet weak var cuotasPagLbl: UILabel!
    @IBOutlet weak var tasaInteresLbl: UILabel!
    
    @IBOutlet weak var fechTermLbl: UILabel!
    @IBOutlet weak var coutasMorLbl: UILabel!
    @IBOutlet weak var monedaLbl: UILabel!
    
    @IBOutlet weak var lblPorcentajePag: UILabel!
    @IBOutlet weak var pagadoLbl: UILabel!
    @IBOutlet weak var solicitadoLbl: UILabel!
    @IBOutlet weak var progBar: UIProgressView!
    @IBOutlet weak var progresPorcent: UILabel!
    var loadingView : LoadingView!
    var codCredito = ""
    var porcentaje = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        progBar.transform = progBar.transform.scaledBy(x: 1, y: 10)
        self.loadingView = LoadingView(uiView: view, message: "Cargando tus datos")
        self.loadingView.show()
        print(self.codCredito)
        
        self.obtenerCreditosDetalle()
        // Do any additional setup after loading the view.
    }
    func setValuesLabels(datosCred : CreditosDetalle)  {
        
        estadoLbl.text = datosCred.estadoCredito
        saldoCapLbl.text = "$\(String(datosCred.saldoCapital.formattedWithSeparator))"
        valorCuotaLbl.text = "$\(String(datosCred.valorCuota.formattedWithSeparator))"
        codigoCredLbl.text = datosCred.codigoCredito
        fechOtorgLbl.text = datosCred.fechaOtorgamiento
        cuotasPagLbl.text = String(datosCred.cuotasPagadas)
        //tasaInteresLbl.text = datosCred
        fechTermLbl.text = datosCred.fechaTermino
        coutasMorLbl.text = String(datosCred.cuotasMorosas)
        //monedaLbl.text = datosCred.
        pagadoLbl.text = String(datosCred.pagado.formattedWithSeparator)
        solicitadoLbl.text = String(datosCred.montoOtorgado.formattedWithSeparator)
        tasaInteresLbl.text = "\(String(datosCred.tasaInteres)) %"
        monedaLbl.text = datosCred.moneda
        lblPorcentajePag.text = "Has pagado un \(self.porcentaje)% de tu crédito"
        print(self.porcentaje)
        let valueProg = Double(self.porcentaje)!/100
        self.progresPorcent.text = "\(String(self.porcentaje)) %"
        progBar.setProgress(Float(valueProg), animated: false)
        
    }
    func obtenerCreditosDetalle(){
        var tempDatos: [MisCreditosData] = []
        let codSend = self.codCredito.replacingOccurrences(of: " ", with: "%20")
        print(codSend)
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Creditos/Detalle?codigo=\(codSend)"//13%20%20.0511555-6"
        // let urlString2 = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Creditos/Detalle?codigo=\(self.codCredito)"//13%20%20.0511555-6"
        //print(urlString2)
        print(urlString)
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
                    let courses = try decoder.decode(UserCreditosDetResponse.self, from: data)
                    if (courses.data != nil){
                        
                        var lista  = (courses.data?.detalleCredito)
                        let montoDiv = lista!.listaCuadroDePago[1].montoDividendo
                        let cantCoutas = lista!.listaCuadroDePago.count
                        let solicitado = cantCoutas * montoDiv
                        let pagado = montoDiv * (lista?.cuotasPagadas)!
                        
                        self.porcentaje =  String((pagado * 100)/solicitado)
                        
                        var detalleCred  : CreditosDetalle = CreditosDetalle(estadoCredito: (lista?.estadoCredito)!, saldoCapital: (lista?.saldoCapital)!, montoOtorgado:solicitado, comisionPrepago: (lista?.comisionPrepago)!, cuotasEmitidas: (lista?.cuotasEmitidas)!, cuotasPagadas: (lista?.cuotasPagadas)!, saldoDeuda: 2342, fechaOtorgamiento: (lista?.fechaOtorgamiento)!, cuotasMorosas: (lista?.cuotasMorosas)!, fechaTermino: (lista?.fechaTermino)!, codigoCredito: (lista?.codigoCredito)!, tasaInteres: ((lista?.tasaInteres)!), valorCuota: lista!.listaCuadroDePago[1].montoDividendo, pagado: pagado, moneda: ((lista?.Moneda.descripcion)!))
                        self.loadingView.hide()
                        self.setValuesLabels(datosCred: detalleCred)
                        /*for item in lista {
                         var cred = MisCreditosData(fechaOtorg: item.fechaOtorgamiento, estado: item.estado, monto: item.montoOtorgado)
                         self.misCreditosList.append(cred)
                         }*/
                        print(lista!.comisionPrepago)
                        //self.loadingView.hide()
                    }else{
                        print("error")
                        self.loadingView.hide()
                        let alert = UIAlertController(title: "Ups!", message: "Ocurrió un error en el servidor", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                    self.loadingView.hide()
                }
            }
            }.resume()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func setValueCodCred(codigo: String)  {
        print(codigo)
        self.codCredito = codigo
    }
}

struct UserCreditosDetResponse: Decodable{
    var data: DataCreditosDetResponse?
    var status: String
}
struct DataCreditosDetResponse: Decodable{
    var detalleCredito: CreditosDetailResponse
    
}

struct CreditosDetailResponse: Decodable {
    var estadoCredito: String
    var montoOtorgado: Int
    var comisionPrepago: Int
    var saldoCapital: Int
    var cuotasEmitidas: Int
    var cuotasPagadas: Int
    var saldoDeuda : Int
    var fechaOtorgamiento : String
    var cuotasMorosas : Int
    var fechaTermino : String
    var codigoCredito : String
    var tasaInteres : Double
    var listaCuadroDePago : [listaCuadroDePagoResp]
    var Moneda : MonedaResponse
}
struct listaCuadroDePagoResp: Decodable{
    var montoDividendo: Int
    
}
struct MonedaResponse: Decodable{
    var descripcion: String
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? "."
    }
}
