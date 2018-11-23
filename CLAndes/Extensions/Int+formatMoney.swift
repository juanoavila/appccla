//
//  Int+formatMoney.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 05-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation


extension Int {
    
    func FormatMoney() -> String {
                if(self == 0){
            return "$000.000"
                    }
        var strValue: String = ""
        var sValue1 : String = ""
        var nPos: Int = 1
        var sInvertido: String = ""
        var sValue: String = ""
        sValue1 = String(self)
        var largo = sValue1.count
        
        for i in (0 ..< largo).reversed(){
            sInvertido.append("\(sValue1.last!)")
            sValue1.removeLast()
            if(nPos == 3 && i != 0){
                sInvertido += "."
                nPos = 0;
            }
            nPos = nPos+1
        }
        largo = sInvertido.count
        for j in (0 ..< largo).reversed(){
            let i4 = sInvertido.last!
                if("\(i4)" != "."){
                 sValue.append("\(i4)")
            }else if(j != sInvertido.count){
                sValue.append("\(i4)")
            }
            sInvertido.removeLast()
        }
        strValue = sValue.uppercased()
        return "$\(strValue)"
        }

    
}
