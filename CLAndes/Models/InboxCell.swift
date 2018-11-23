//
//  InboxCell.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 19-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

class InboxCell: UITableViewCell {

    @IBOutlet weak var lblTituloTxt: UILabel!
    @IBOutlet weak var lblMensajeTxt: UILabel!
    @IBOutlet weak var lblFechaTxt: UILabel!
    @IBOutlet weak var lblIndicadorVisto: UILabel!
    
    func configurateTheCell(_ inbox: MensajeResponse){
        lblTituloTxt.text = inbox.titulo
        lblMensajeTxt.text = inbox.mensaje
        lblFechaTxt.text = UtilDate.formatDate(input: String(inbox.created_at!.dropLast(3)))
        
//        if(inbox.leido == "t"){
//            lblIndicadorVisto.isHidden = true
//        }else{
//            lblIndicadorVisto.isHidden = false
//        }
        
        lblIndicadorVisto.isHidden = true
    }

}
