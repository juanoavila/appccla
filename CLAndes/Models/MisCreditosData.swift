//
//  MisCreditosData.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/12/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

class MisCreditosData {
    var fechaOtorg : String
    var estado : String
    var codigo : String
    var monto : Int
    init(fechaOtorg: String, estado : String,codigo : String, monto: Int) {
        self.fechaOtorg = fechaOtorg
        self.estado = estado
        self.codigo = codigo
        self.monto = monto
    }
}


class CreditosDetalle {
    var estadoCredito : String
    var saldoCapital : Int
    var montoOtorgado : Int
    var comisionPrepago : Int
    var cuotasEmitidas : Int
    var cuotasPagadas : Int
    var saldoDeuda : Int
    var fechaOtorgamiento : String
    var cuotasMorosas : Int
    var fechaTermino : String
    var codigoCredito : String
    var tasaInteres : Double
    var valorCuota : Int
    var pagado : Int
    var moneda : String
    
    init(estadoCredito: String, saldoCapital : Int, montoOtorgado: Int, comisionPrepago: Int, cuotasEmitidas: Int, cuotasPagadas: Int, saldoDeuda: Int, fechaOtorgamiento: String, cuotasMorosas: Int, fechaTermino: String, codigoCredito: String, tasaInteres:Double, valorCuota:Int, pagado:Int, moneda: String) {
        self.estadoCredito  = estadoCredito
        self.saldoCapital = saldoCapital
        self.montoOtorgado = montoOtorgado
        self.comisionPrepago = comisionPrepago
        self.cuotasEmitidas = cuotasEmitidas
        self.cuotasPagadas = cuotasPagadas
        self.saldoDeuda = saldoDeuda
        self.fechaOtorgamiento = fechaOtorgamiento
        self.cuotasMorosas = cuotasMorosas
        self.fechaTermino = fechaTermino
        self.codigoCredito = codigoCredito
        self.tasaInteres = tasaInteres
        self.valorCuota = valorCuota
        self.pagado = pagado
        self.moneda = moneda
    }
}
