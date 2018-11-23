//
//  viewHome.swift
//  mySidebar2
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation

import UIKit

class ViewHome: UIView{
 

    @IBOutlet weak var btnPrimero: UIButton!
    @IBOutlet weak var btnSegundo: UIButton!
    @IBOutlet weak var btnTercero: UIButton!
    @IBOutlet weak var btnCuarto: UIButton!
    @IBOutlet weak var btnQuinto: UIButton!
    @IBOutlet weak var btnSexto: UIButton!
    @IBOutlet weak var btnSeptimo: UIButton!
    @IBOutlet weak var btnOctavo: UIButton!
    @IBOutlet weak var btnNoveno: UIButton!
    
    @IBOutlet weak var lblPrimero: UILabel!
    @IBOutlet weak var lblSegundo: UILabel!
    @IBOutlet weak var lblTercero: UILabel!
    @IBOutlet weak var lblCuarto: UILabel!
    @IBOutlet weak var lblQuinto: UILabel!
    @IBOutlet weak var lblSexto: UILabel!
    @IBOutlet weak var lblSeptimo: UILabel!
    @IBOutlet weak var lblOctavo: UILabel!
    @IBOutlet weak var lblNoveno: UILabel!
    
    @IBOutlet weak var imgPrimero: UIImageView!
    @IBOutlet weak var imgSegundo: UIImageView!
    @IBOutlet weak var imgTercero: UIImageView!
    @IBOutlet weak var imgCuarto: UIImageView!
    @IBOutlet weak var imgQuinto: UIImageView!
    @IBOutlet weak var imgSexto: UIImageView!
    @IBOutlet weak var imgSeptimo: UIImageView!
    @IBOutlet weak var imgNoveno: UIImageView!
    @IBOutlet weak var imgOctavo: UIImageView!
    
    
    var menuArray = [AnyObject]()
   
    
    @IBAction func btnPrimero(_ sender: Any) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: lblPrimero.text!), object: nil)
    }
    
    @IBAction func btnQuinto(_ sender: Any) {
        print(lblQuinto.text!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblQuinto.text!), object: nil)
    }
    @IBAction func btnTercero(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblTercero.text!), object: nil)
    }
    
    @IBAction func btnCuarto(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblCuarto.text!), object: nil)
    }
    
    @IBAction func btnSegundo(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblSegundo.text!), object: nil)
    }
    @IBAction func btnSexto(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblSexto.text!), object: nil)
    }
    
    @IBAction func btnSeptimo(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: lblSeptimo.text!), object: nil)
    }
    
    @IBAction func btnOctavo(_ sender: Any) {
         NotificationCenter.default.post(name: Notification.Name(rawValue: lblOctavo.text!), object: nil)
    }
    
    @IBAction func btnNoveno(_ sender: Any) {
         NotificationCenter.default.post(name: Notification.Name(rawValue: lblNoveno.text!), object: nil)
    }
    
    
    func setImagen(arregloImg: [String])  {
        let imagesArray = [imgPrimero,imgSegundo,imgTercero,imgCuarto,imgQuinto,imgSexto, imgOctavo,imgNoveno]
        var i : Int = 0
        for imagenNom in arregloImg {
             imagesArray[i]?.image =  UIImage(named: imagenNom)!
            
            i += 1
        }
       /* imgPrimero.image = UIImage(named: arregloImg[0])!
        imgSegundo.image = UIImage(named: arregloImg[1])!
        imgTercero.image = UIImage(named: arregloImg[2])!
        imgCuarto.image = UIImage(named: arregloImg[3])!
        imgQuinto.image = UIImage(named: arregloImg[4])!
        imgSexto.image = UIImage(named: arregloImg[5])!
        imgOctavo.image = UIImage(named: arregloImg[6])!
        imgNoveno.image = UIImage(named: arregloImg[7])*/

    }
    func setImagenCarga(arregloImg: [String])  {
        imgPrimero.image = UIImage(named: arregloImg[0])!
        imgSegundo.image = UIImage(named: arregloImg[1])!
        imgTercero.image = UIImage(named: arregloImg[2])!
        imgCuarto.image = UIImage(named: arregloImg[3])!
        imgQuinto.isHidden = true
        imgSexto.isHidden = true
        //imgQuinto.image = UIImage(named: arregloImg[4])!
       // imgSexto.image = UIImage(named: arregloImg[5])!
        imgPrimero.frame = imgSeptimo.frame
        imgSegundo.frame = imgSeptimo.frame
        imgTercero.frame = imgSeptimo.frame
        imgCuarto.frame = imgSeptimo.frame
        imgPrimero.frame.origin = CGPoint(x: 15, y: 55)
        imgSegundo.frame.origin = CGPoint(x: 15, y: 158)
        imgTercero.frame.origin = CGPoint(x: 15, y: 258)
        imgCuarto.frame.origin = CGPoint(x: 15, y: 358)
        
        imgNoveno.isHidden = true
        imgOctavo.isHidden = true
        lblNoveno.isHidden = true
        lblOctavo.isHidden = true
        btnNoveno.isHidden = true
        btnOctavo.isHidden = true
    }
    func setColorBtn(boton: UIButton, label:UILabel)  {
        
        switch label.text {
        case "Sucursales":
            boton.backgroundColor = UIColor(hexString: "#ff4337")
        case "Convenios":
            boton.backgroundColor =  UIColor(hexString: "#cd25b0")
        case "Mis Beneficios":
            boton.backgroundColor =  UIColor(hexString: "#873299")
        case "Licencias Médicas":
            boton.backgroundColor =  UIColor(hexString: "#b21e27")
        case "Créditos":
            boton.backgroundColor =  UIColor(hexString: "#00bd70")
        case "¿Te Ayudamos?":
            boton.backgroundColor =  UIColor(hexString: "#1e988a")
        case "Buzón de Mensajes":
            boton.backgroundColor =  UIColor(hexString: "#0076a9")
        case "Vendomatica":
            boton.backgroundColor =  UIColor(hexString: "#ff5100")
            label.text = "Más Café"

        default:
            break
        }
    }
    
    func setNomButton(titulos: [AnyObject] ){

        let labelArray = [self.lblPrimero, self.lblSegundo, self.lblTercero, self.lblCuarto, self.lblQuinto, self.lblSexto, self.lblOctavo,self.lblNoveno]
        let botonArray  = [btnPrimero,btnSegundo, btnTercero,btnCuarto,btnQuinto,btnSexto,btnOctavo,btnNoveno]
        var i : Int = 0
        for label in labelArray {
            label?.text = titulos[i] as? String
            setColorBtn(boton: botonArray[i]!, label: label!)
            i += 1
        }
        
    }
    func setMenuCarga()  {
        btnPrimero.setImage(UIImage(named: "ic-cerrar-gris"), for: .normal)
        btnPrimero.frame = btnSeptimo.frame
        btnSegundo.frame = btnSeptimo.frame
        btnTercero.frame = btnSeptimo.frame
        btnCuarto.frame = btnSeptimo.frame
        lblPrimero.frame = CGRect(x:150,y: 60,width: 200,height: 50)
        lblSegundo.frame = CGRect(x:150,y: 160,width: 200,height: 50)
        lblTercero.frame = CGRect(x:150,y: 260,width: 200,height: 50)
        lblCuarto.frame = CGRect(x:110,y: 360,width: 200,height: 50)
        btnPrimero.frame.origin = CGPoint(x: 15, y: 50)
        btnSegundo.frame.origin = CGPoint(x: 15, y: 150)
        btnTercero.frame.origin = CGPoint(x: 15, y: 250)
        btnCuarto.frame.origin = CGPoint(x: 15, y: 350)
        btnQuinto.isHidden = true
        btnSexto.isHidden = true
        btnSeptimo.isHidden = true
        lblQuinto.isHidden = true
        lblSexto.isHidden = true
        lblSeptimo.isHidden = true
    }
    
    func ShowLoader() -> (UIView){
        
        let screen = UIScreen.main.bounds.size
        
        let loadView = UIView()
        loadView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        loadView.backgroundColor = .black
        loadView.alpha = 0.75
        
        return loadView
        
    }
 
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
