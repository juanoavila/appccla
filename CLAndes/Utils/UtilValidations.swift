//
//  UtilValidations.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 07-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

class UtilValidations{

    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
