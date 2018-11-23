//
//  BeneficiosViewController.swift
//  Beneficios
//
//  Created by Diego Corbinaud on 27-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit

class BeneficiosViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let tableView = UITableView()
    let cellID = "BeneficioViewCell"
    var collectionView: UICollectionView?
    var listaCampanas: [Campana] = []
    let async = DispatchGroup()
    var loadingView : LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        //let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.bordered, target: self, action: "back:")
        //self.navigationItem.leftBarButtonItem = newBackButton
      //  self.navigationItem.leftBarButtonItem = newBackButton
        self.loadingView = LoadingView(uiView: view, message: "Cargando tus datos")
        self.loadingView.show()
        if CheckConnection.Connection(){
            
            async.enter()
            cargarCampanas()
            async.wait()
            
            // Do any additional setup after loading the view, typically from a nib
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            layout.itemSize = CGSize(width: 330, height: 138)
            layout.minimumLineSpacing = 22
            layout.scrollDirection = .vertical
            
            collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            collectionView!.backgroundColor = UIColor.white
            collectionView!.dataSource = self
            collectionView!.delegate = self
            
            let nibCell = UINib(nibName: cellID, bundle: nil)
            collectionView!.register(nibCell, forCellWithReuseIdentifier: cellID)
            self.view.addSubview(collectionView!)
            self.loadingView.show()
            
        }else{
            ShowAlert(message: "No podemos presentar los beneficios. Revisa tu internet", buttonTitle: "OK")
        }
        
    }

    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("atrasss")
    }
    func cargarCampanas(){
        let request = NSMutableURLRequest(url: NSURL(string: "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/CampanasV2/consulta")! as URL)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let rutConDig = UserDefaults.standard.value(forKey: "rutDig") as! String
       // let lastChar =
       
        let dv =  rutConDig[rutConDig.index(before: rutConDig.endIndex)]//"4"
         let rut = rutConDig.substring(to: rutConDig.index(before: rutConDig.endIndex))//"12114692"
        
        let postString = "{'rut': '\(rut)','dv': '\(dv)'}"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
            guard error == nil && data != nil else{
                print("error")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                self.ShowAlert(message: "Ha ocurrido un error y no podemos mostrarle sus beneficios", buttonTitle: "OK")
            }
            
            guard let data = data else { return }
            
            do{
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                let array = parsedData["Envelope"] as AnyObject
                let array2 = array["EntObtenerCampaniaOutABM"] as AnyObject
                let body = array2["body"] as! AnyObject
                let campanas = body["Campanas"] as! [AnyObject]
                
                for item in campanas{
                    let objCampana = Campana()
                    let objAccion = item["accion"] as AnyObject
                    let objFuncionalidad = item["funcionalidad"] as AnyObject
                    let objPrioridad = item["prioridad"] as AnyObject
                    let objBoton = item["boton"] as AnyObject
                    
                    objCampana.bajada = item["bajada"] as? String ?? ""
                    objCampana.url_imagen = item["url_imagen"] as? String ?? ""
                    
                    objCampana.accion.codigo = objAccion["codigo"] as? String ?? ""
                    objCampana.accion.tipo = objAccion["tipo"] as? String ?? ""
                    objCampana.accion.destino = objAccion["destino"] as? String ?? ""
                    
                    objCampana.funcionalidad.codigo = objFuncionalidad["codigo"] as? String ?? ""
                    objCampana.funcionalidad.nombre = objFuncionalidad["nombre"] as? String ?? ""
                    
                    objCampana.masiva = item["masiva"] as! Bool
                    objCampana.titulo = item["titulo"] as? String ?? ""
                    
                    objCampana.prioridad.codigo = objPrioridad["codigo"] as? String ?? ""
                    objCampana.prioridad.nombre = objPrioridad["nombre"] as? String ?? ""
                    
                    objCampana.boton.texto = objBoton["texto"] as? String ?? ""
                    objCampana.boton.color = objBoton["color"] as? String ?? ""
                    
                    if objCampana.funcionalidad.codigo == "BEF"{
                        self.listaCampanas.append(objCampana)
                    }
                }
                print(self.listaCampanas.count)
                //                if self.listaCampanas.count > 0{
                //                    self.listaCampanas = self.listaCampanas.sorted(by: {$0.prioridad.nombre < $1.prioridad.nombre})
                //                }
                
            } catch let jsonErr {
                self.ShowAlert(message: "Ha ocurrido un error y no podemos mostrarle sus beneficios", buttonTitle: "OK")
            }
            
            self.async.leave()
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaCampanas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BeneficioViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 5
        
        let data = listaCampanas[indexPath.row]
        
        cell.CustomInit(data: data, navigation: self.navigationController)
        
        return cell
    }
    
    func ShowAlert(message: String, buttonTitle: String){
        
        let alert = UIAlertController(title: "Ups!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


