//
//  Sidebar.swift
//  mySidebar2
//
//  Created by Muskan on 10/12/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
    
}
var numerodo:Int = 2
var numerodoult:Int = 8
enum Row: String {
    case saludo
    case primero
    case segundo
    case tercero
    case cuarto
    case quinto
    case sexto
    case septimo
    case octavo
    case noveno
    case cerrar
    
    init(row: Int) {
        
        
        switch row {
        case 1: self = .saludo
        case 2: self = .primero
        case 3: self = .segundo
        case 4: self = .tercero
        case 5: self = .cuarto
        case 6: self = .quinto
        case 7: self = .sexto
        case 8: self = .septimo
        case 9: self = .octavo
        case 10: self = .noveno
        default: self = .cerrar
        }
    }
}

class SidebarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var titleArr = [String]()
    weak var delegate: SidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        self.clipsToBounds=true
        titleArr = UserDefaults.standard.value(forKey: "arregloMenuNom") as! [String]
        
        setupViews()
        
        myTableView.delegate=self
        myTableView.dataSource=self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView=UIView()
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //cambiar none por singleline
        myTableView.allowsSelection = true
        myTableView.bounces=false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor = UIColor.clear
        //myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myTableView.frame.size.width, height: 1))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        if indexPath.row == 0 {
            cell.backgroundColor=UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
            cell.contentView.frame(forAlignmentRect:CGRect(x: 55, y: 10, width: 160, height: 250))
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: 80, y: 10, width: 90, height: 90))
            
            if (false){
                //TODO cargar foto del usuario
            }else{
                cellImg.image = UIImage(named: "icon_user")!
            }
            cell.addSubview(cellImg)
            
            
        } else if indexPath.row == 1  {
            //cell.selectionStyle = .none
            let cellLbl = UILabel(frame: CGRect(x: 15, y:-10, width: 190, height: 90)) 
            cell.backgroundColor=UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
            cell.addSubview(cellLbl)
            cellLbl.text = titleArr[indexPath.row]
            cellLbl.font = UIFont(name:"RawsonPro-Bold", size:16)
            cellLbl.textColor=UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
            
//            let cellImg2: UIImageView!
//            cellImg2 = UIImageView(frame: CGRect(x: 2, y: 20, width: 35, height: 30))
//            cellImg2.contentMode = .scaleAspectFill
//            cellImg2.layer.masksToBounds=true
//            cellImg2.image = UIImage(named: "ic_micuenta_gris")!
//            cell.addSubview(cellImg2)
        }/*else if indexPath.row == 2  {
             let cellLbl = UILabel(frame: CGRect(x: 50, y: -10, width: 190, height: 90))
             
             let line = UIView(frame: CGRect(x: 20, y: cell.frame.height-40, width: cell.frame.width - 200, height: 1))
             line.backgroundColor = UIColor(red: 148/255, green: 152/255, blue: 158/255, alpha: 1.0)
             
             cell.backgroundColor=UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
             cell.addSubview(cellLbl)
             cell.addSubview(line)
             print(titleArr[indexPath.row])
             cellLbl.text = titleArr[indexPath.row]
             cellLbl.font=UIFont.systemFont(ofSize: 16)
             cellLbl.textColor=UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
             
             let cellImg2: UIImageView!
             cellImg2 = UIImageView(frame: CGRect(x: 2, y: 20, width: 35, height: 30))
             cellImg2.contentMode = .scaleAspectFill
             cellImg2.layer.masksToBounds=true
             let iconMenuHome  = setImagenName(nombre: titleArr[indexPath.row])
             cellImg2.image = UIImage(named: iconMenuHome)!
             cell.addSubview(cellImg2)
             }else if(indexPath.row == (titleArr.count-1)){
             print("cerrar")
             let cellLbl2 = UILabel(frame: CGRect(x: 50, y: -10, width: 190, height: 90))
             cellLbl2.textColor=UIColor(red: 148/255, green: 152/255, blue: 158/255, alpha: 1.0)
             cellLbl2.font=UIFont.systemFont(ofSize: 13)
             cellLbl2.text = "Cerrar sesión"
             let cellImg2: UIImageView!
             cellImg2 = UIImageView(frame: CGRect(x: 2, y: 20, width: 35, height: 30))
             cellImg2.contentMode = .scaleAspectFill
             cellImg2.layer.masksToBounds=true
             cellImg2.image = UIImage(named: "ic_cerrar_gris")!
             cell.addSubview(cellLbl2)
             cell.addSubview(cellImg2)
             }*/
        else {
            cell.selectionStyle = .none
            //cell.textLabel?.text=titleArr[indexPath.row]
            cell.contentView.frame(forAlignmentRect:CGRect(x: 0, y: 0, width: 190, height: 70))
            cell.backgroundColor=UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
            //cell.textLabel?.textColor=UIColor.gray
            let cellLbl2 = UILabel(frame: CGRect(x: 40, y: -5, width: 190, height: 90))
            let line = UIView(frame: CGRect(x: 5, y: cell.frame.height-40, width: cell.frame.width - 15, height: 1))
            line.backgroundColor = UIColor(red: 148/255, green: 152/255, blue: 158/255, alpha: 1.0)
            cellLbl2.font = UIFont(name:"RawsonPro-Regular", size:15)
            cell.addSubview(line)
            
            cellLbl2.text = titleArr[indexPath.row]
            
            cellLbl2.textColor=UIColor(red: 148/255, green: 152/255, blue: 158/255, alpha: 1.0)
            
            let iconMenu  = setImagenName(nombre: titleArr[indexPath.row])
            print(titleArr.count)
            let cellImg2: UIImageView!
            cellImg2 = UIImageView(frame: CGRect(x: 2, y: 20, width: 35, height: 30))
            cellImg2.contentMode = .scaleAspectFill
            cellImg2.layer.masksToBounds=true
            cellImg2.image = UIImage(named: iconMenu)!
            
            
            print(indexPath.row)
            print(titleArr.count)
            /*if(indexPath.row == 11) {
             cellLbl2.text = "Cerrar sesión"
             cellImg2.image = UIImage(named: "ic_cerrar_gris")!
             }*/
            cell.addSubview(cellLbl2)
            cell.addSubview(cellImg2)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 50
        }
    }
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let myTableView: UITableView = {
        let table=UITableView()
        table.translatesAutoresizingMaskIntoConstraints=false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImagenName(nombre: String) -> String {
        
        switch nombre {
        case "Sucursales":
            return "ic_sucursal_gris"
        //self.navigationController?.pushViewController(login, animated: true)
        case "Convenios":
            return "ic_convenio_gris"
        case "Licencias Médicas":
            return "ic_licmed_gris"
        case "Licencias":
            return "ic_licmed_gris"
        case "Mi cuenta":
            return "ic_micuenta_gris"
        case "Mis Beneficios":
            return "ic_beneficios_gris"
        case "Buzón de Mensajes":
            return "ic_inbox_gris"
        case "Vendomatica":
            return "ic_credito_gris"
        case "Home":
            return "ic_home_gris"
        case "Empresas":
            return "menu_empresa_off"
        case "¿Te Ayudamos?":
            return "ic_ayuda_gris"
        case "Cerrar sesión":
            return "ic_cerrar_gris"
        default:
            return "ic_credito_gris"
        }
    }
}


