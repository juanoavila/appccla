//
//  UtilDate.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 29-10-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

class UtilDate: NSObject {

    static func formateDateFromString(input: String)  -> Date?{
    
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let date = dateFormatterGet.date(from: input)
        return date
    }
    
    static func formatDate(input: String)  -> String{
        return input.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
    }
}
