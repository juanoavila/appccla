//
//  BeneficioViewCell.swift
//  Beneficios
//
//  Created by Diego Corbinaud on 29-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit
import WebKit

class BeneficioViewCell: UICollectionViewCell, WKUIDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var accion = Accion()
    var webView: WKWebView!
    var navigation = UINavigationController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAction.backgroundColor = UIColor.init(red: 249/255, green: 190/255, blue: 0/255, alpha: 1.0)
        btnAction.layer.cornerRadius = 5
        
        
    }
    
    
    func CustomInit(data: Campana, navigation: UINavigationController?){
        self.navigation = navigation ?? UINavigationController()
        self.title.text = data.titulo
        self.body.text = data.bajada
        self.accion = data.accion
        self.btnAction.setTitle(data.boton.texto, for: .normal)
        
        if let url = NSURL(string: data.url_imagen) {
            if let dataImg = NSData(contentsOf: url as URL){
                print("dataImg -> \(dataImg)")
                self.imageView.image = UIImage(data: dataImg as Data)
            }
        }
        
        btnAction.addTarget(self, action: #selector(abrirModulo), for: .touchUpInside)
    }
    
    @objc func abrirModulo(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        
        //if(accion.tipo == "Whatsapp"){
            if let vc = storyboard.instantiateViewController(withIdentifier: "BeneficioWebViewControllerIdentity") as? BeneficioWebViewController{
                
                vc.url = self.accion.destino
                self.navigation.pushViewController(vc, animated: true)
            }
        //}
    }
    

}
