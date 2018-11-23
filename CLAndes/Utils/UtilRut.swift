//
//  FormValidator.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 19-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import CryptoSwift

enum RutError: Error{
    
    case InvalidRut(message : String)
    
}

class UtilRut: NSObject {
    static func validadorRut(input: String!)  throws -> String?{
        
        var rut = input.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range : nil)
        rut = rut.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range : nil)
        rut = rut.uppercased()
        
        if (rut.count < 8 || rut.count > 10){
            throw RutError.InvalidRut(message: "Largo de RUT no válido")
        }
        
        let rutRegex = "^(\\d{1,3}(\\.?\\d{3}){2})\\-?([\\dkK])$"
        
        let rutTest = NSPredicate(format: "SELF MATCHES %@", rutRegex)
        
        if (!rutTest.evaluate(with: rut)) {
            throw RutError.InvalidRut(message: "RUT con fomato no válido")
        }
        
        let runTovalidate = getRutDv(value: input)
        
        let rutNumber = runTovalidate.0
        let rutDV = runTovalidate.1
        
        let calculatedDV = validateDV(rut: rutNumber)
        if (rutDV != calculatedDV){
            throw RutError.InvalidRut(message: "Digito verificador no válido")
        }
        
        return rut
    }
    
    static func getRutDv(value: String) -> (String, String){
        if (value.isEmpty || value.count < 2){
            return ("", "")
        }
        
        var rut = value.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
        rut = rut.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let dv: String = String(rut.last!)
        let run: String = String(rut.dropLast())
        
        return (run, dv)
    }
    
    static func validateDV(rut: String) -> String?{
        var acumulado : Int = 0
        var ti : Int = 2
        print(rut.count)
        for index in stride(from: rut.count-1, through: 0, by: -1) {
            let n = Array(rut)[index]
            let nl = String(n)
            guard let vl = Int(nl) else {
                return ""
            }
            
            
            acumulado += vl * ti
            
            if (ti == 7) {
                ti = 1
            }
            ti += 1
        }
        
        let resto : Int = acumulado % 11
        let numericDigit : Int = 11 - resto
        var digito : String = ""
        
        
        if (numericDigit <= 9){
            digito = String(numericDigit);
        }else if (numericDigit == 10){
            digito = "K"
        }else{
            digito = "0"
        }
        
        return digito
    }
    
    static func encryptarPass(pass : String )-> String{
        var retorno: String = ""
        if let aes = try? AES(key: "Bar12345Bar12345", iv: "RandomInitVector"),
            let encrypted = try? aes.encrypt(Array(pass.utf8)) {
            let result = encrypted.toBase64()
            let formatedResult = result?.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
            retorno = formatedResult as! String
        }
        
        return retorno
    }
    
    
    static func formatoRut(rut: String) -> String {
        
        var strReturn: String = ""
        var sRut1 : String = ""
        var nPos: Int = 0
        var sInvertido: String = ""
        var sRut: String = ""
        
        sRut1 = rut.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
        sRut1 = sRut1.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        sRut1 = sRut1.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        var largo = sRut1.count
        
        for i in (0 ..< largo).reversed(){
            
            sInvertido.append("\(sRut1.last!)")
            sRut1.removeLast()
            if(i == largo-1){
                sInvertido.append("-")
            }else if(nPos == 3 && i != 0){
                sInvertido += "."
                nPos = 0;
            }
            nPos = nPos+1
        }
        
        largo = sInvertido.count
        for j in (0 ..< largo).reversed(){
            
            let i4 = sInvertido.last!
            
            if("\(i4)" != "."){
                sRut.append("\(i4)")
            }else if(j != sInvertido.count){
                sRut.append("\(i4)")
            }
            sInvertido.removeLast()
        }
        
        strReturn = sRut.uppercased()
        
        return strReturn
    }
    
}

