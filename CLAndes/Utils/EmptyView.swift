//
//  EmptyView.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 22-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit


public func getEmptyView(vista: UIView)-> UIView{

    let viewEmpty = UIView()
    viewEmpty.frame = vista.frame
    viewEmpty.backgroundColor = UIColor.lightGray
    //viewEmpty.alpha = 0.75
    
    return viewEmpty
}
