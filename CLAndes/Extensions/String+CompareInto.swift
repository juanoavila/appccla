//
//  String+CompareInto.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 15-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

extension String {
    
    func containsIgnoringCase(find: String) -> Bool{
        var str:String = self.replacingOccurrences(of: " ", with: "")
        var strFind:String = find.replacingOccurrences(of: " ", with: "")
        
        if(str == strFind){
            print("TEST")
        }
        
        return str.range(of: strFind, options: .caseInsensitive) != nil
    }
    
    func equalsStr(find: String) -> Bool{
        var str:String = self.replacingOccurrences(of: " ", with: "")
        var strFind:String = find.replacingOccurrences(of: " ", with: "")
        
        return (str.lowercased() == strFind.lowercased())
    }
    
    
}
