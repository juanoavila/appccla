//
//  DetalleInboxViewController.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 20-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class DetalleInboxViewController: UIViewController {

    var mensajeInbox: MensajeResponse?
    
    @IBOutlet weak var lblTituloText: UILabel!
    @IBOutlet weak var lblFechaText: UILabel!
    @IBOutlet weak var lblMensajeText: UILabel!
    @IBOutlet weak var lblCodigoText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarDatos()
        // Do any additional setup after loading the view.
    }
    
    func inicializarDatos(){
        lblTituloText.text = mensajeInbox!.titulo
        lblFechaText.text = UtilDate.formatDate(input: String(mensajeInbox!.created_at!.dropLast(3)))
        lblMensajeText.text = mensajeInbox!.mensaje!
        
        if(mensajeInbox!.codigo != nil && mensajeInbox!.codigo != "" && mensajeInbox!.codigo != "null"){
            lblCodigoText.text = "Código: \(mensajeInbox!.codigo!)"
        }else{
            lblCodigoText.text = ""
        }
        
        resizeAndPositionViews()
    }
    
    func resizeAndPositionViews(){
        let lines = lblMensajeText.calculateMaxLines()
        
        lblMensajeText.numberOfLines = lines
        lblMensajeText.frame = CGRect(x: lblMensajeText.frame.minX, y: lblMensajeText.frame.minY,
                                     width: lblMensajeText.frame.width, height: CGFloat(lines * 20))
        
        let posY = lblMensajeText.frame.minY + lblMensajeText.frame.height + 20
        lblCodigoText.frame = CGRect(x: lblCodigoText.frame.minX, y: posY,
                width: lblCodigoText.frame.width, height: lblCodigoText.frame.height)
    }

}
