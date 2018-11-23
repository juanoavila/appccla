//
//  ListadoMensajesTableViewController.swift
//  CajaLosAndesApp
//
//  Created by mac-desa on 19-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class ListadoMensajesTableViewController: UITableViewController {

    var respuesta = [MensajeResponse]()
    let identifier: String = "inboxCell"
    let segueIdenfity: String = "inboxDetail"
    let viewEmpty = UIView()
    let group = DispatchGroup()
    var respDefault = InboxDefaultResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rut = UserDefaults.standard.string(forKey: "rut")
        
        self.group.enter()
        //self.obtenerMensajes(rutUsuario: "16.521.588-5")
        self.obtenerMensajes(rutUsuario: rut!)
        self.group.wait()
        
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = UIView()
        //vista cuando no se encuentran datos
        
        viewEmpty.frame = view.frame
        viewEmpty.backgroundColor = .white
        
        //TODO cambiar mensaje e imagen
        let imageEmpty = UIImageView()
        imageEmpty.frame = CGRect(x: view.frame.width / 2 - 50, y: 40, width: 100, height: 100)
        imageEmpty.image = UIImage(named: "no_mensajes")
        viewEmpty.addSubview(imageEmpty)
        
        let emptyMessage = UILabel()
        emptyMessage.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: 40)
        emptyMessage.text = "No tienes mensajes."
        emptyMessage.textAlignment = .center
        emptyMessage.textColor = UIColor(red:0.09, green:0.59, blue:0.83, alpha:1)
        //emptyMessage.font = emptyMessage.font.withSize(22)
        emptyMessage.font = UIFont(name: "RawsonPro-Regular" , size: 20)
        viewEmpty.addSubview(emptyMessage)
        
        if self.respuesta.count == 0{
            //                    self.tableView.backgroundView = self.viewEmpty
            self.tableView.addSubview(self.viewEmpty)
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InboxCell {
            cell.configurateTheCell(respuesta[indexPath.row])
            tableView.rowHeight = 200
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if respuesta.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return respuesta.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: segueIdenfity, sender: cell)
    }
    
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            
            let alert = UIAlertController(title: "Eliminar mensaje", message: "¿Deseas eliminar este mensaje?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .default, handler: {
                (alert: UIAlertAction!) in
                self.delete(index: indexPath.row)
                if(self.respDefault.codigo == "1"){
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            }))
            self.present(alert, animated: true)
            completionHandler(true)
        })
        action.image = UIImage(named: "basurero")
        action.backgroundColor = .orange
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }
    
    func delete(index: Int){
        print("DELETE ID: \(self.respuesta[index].id!)")
        self.group.enter()
        self.borrarMensaje(codigoMensaje: self.respuesta[index].id!)
        self.group.wait()
        if(self.respDefault.codigo == "1"){
            self.respuesta.remove(at: index)
        }
        
    }
    
    //segue para la trsansicion de ventana de listado a detalle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdenfity,
            let indexPath = self.tableView?.indexPathForSelectedRow,
            let destinationViewController: DetalleInboxViewController = segue.destination as? DetalleInboxViewController {
            destinationViewController.mensajeInbox = respuesta[indexPath.row]
        }
    }

    
    func obtenerMensajes(rutUsuario: String){
        
        //
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Inbox/getInbox?rut=\(rutUsuario)"
        
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let mensajes = try decoder.decode(InboxGetResponse.self, from: data)
                    if(mensajes.codigo == "1" && mensajes.respuesta!.count > 0){
                        self.respuesta = mensajes.respuesta ?? [MensajeResponse]()
                    }
                    if mensajes.respuesta?.count == 0 || mensajes.codigo == "0" {
                        self.tableView.addSubview(self.viewEmpty)
                    }
                    
                    self.group.leave()
                    
                } catch let error {
                    self.group.leave()
                    print(error.localizedDescription)
                }
            
            
        } )
        task.resume()
    }
    
    func borrarMensaje(codigoMensaje: String){
        
        //
        let urlString = "http://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Inbox/deleteInbox?id=\(codigoMensaje)"
        
        guard let url = URL(string: urlString) else { return}
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "access_token")
        request.addValue("\(token!)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.respDefault = try decoder.decode(InboxDefaultResponse.self, from: data)
                self.group.leave()
                
            } catch let error {
                self.group.leave()
                print(error.localizedDescription)
            }
            
        } )
        task.resume()
    }
    
}
