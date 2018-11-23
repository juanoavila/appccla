//
//  SucursalesViewController.swift
//  CajaLosAndesIosNativo
//
//  Created by Diego Corbinaud on 01-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UIKit.UIGestureRecognizerSubclass
import RealmSwift

class SucursalesViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let screen = UIScreen.main.bounds.size
    let locationManager = CLLocationManager()
    let table = UITableView()
    let regionInMeters: Double = 0.1
    let label = UIView()
    var userLocation = CLLocation()
    var listaSucursales: [sucursal] = []
    var listaSucursalesDummy: [dummySucursales] = []
    var search: [dummySucursales] = []
    var tableView = UITableView()
    var searching = false
    var viewSearchFail = UIView()
    let textColor = UIColor.init(red: 74/255, green: 85/255, blue: 91/255, alpha: 1.0)
    var centerMap = true
    let async = DispatchGroup()
    
    let alertSettings = ShowAlertSettings(message: "Para poder ubicarte en el mapa puedes activar los servicios de ubicación en la pantalla de ajustes.", buttonTitle: "Ir a ajustes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sucursales"
        
        async.enter()
        obtenerSucursales()
        async.wait()
        
        self.checkLocationServices()
        
        self.tableView.reloadData()
    }
    
    func setupLocationManager(){
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapView.setRegion(region, animated: true)
            self.async.leave()
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            self.present(alertSettings, animated: true, completion: nil)
        }
    }
    
    func checkLocationAuthorization() {
        //Agregar pines en el mapa
        for (index, dummy) in listaSucursalesDummy.enumerated(){
            
            let nombre = dummy.nombreSucursal
            let calle = dummy.direccion.calle
            let latitud = Double(dummy.latitud)
            let longitud = Double(dummy.longitud)
            
            let pin = customPin(pinTitle: nombre, pinSubtitle: calle, location: CLLocationCoordinate2D(latitude: latitud!, longitude: longitud!), index: index)
            
            pin.setAnnotation(annotation: pin)
            
            mapView.addAnnotation(pin)
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            async.enter()
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            async.wait()
            async.enter()
            layout()
            async.wait()
            
            let centerUser = UIButton()
            centerUser.frame = CGRect(x: screen.width - 40, y: 10 , width: 30, height: 30)
            centerUser.backgroundColor = .white
            centerUser.addTarget(self, action: #selector(buttonCenter), for: .touchUpInside)
            centerUser.layer.cornerRadius = centerUser.frame.height / 2
            centerUser.setImage(UIImage(named: "icono_centrar_usuario"), for: .normal)
            mapView.addSubview(centerUser)
            break
        case .denied:
            self.present(alertSettings, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    @objc func buttonCenter(_ sender: UIButton!){
        async.enter()
        centerViewOnUserLocation()
        async.wait()
    }
    
    func addAnnotations(latitude:Double, logitude: Double, title: String, image: String, id: String) {
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = "London"
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.image = UIImage(named: "pin_sucursal")
        
        annotationView?.canShowCallout = true
        
        return annotationView
        
    }
    
    func obtenerSucursales(){
        
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/Sucursales/"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("didn't work, \(String(describing: error))")
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    //just deal
                }
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                    
                    for (key, value) in parsedData {
                        if (key == "Envelope"){
                            
                            let Body = value["Body"] as AnyObject
                            var array = Body["EntBusquedaSucursalConCajaListaOutABM"] as AnyObject
                            var array2 = array["sucursalLista"] as AnyObject
                            var objSucursal = array2["sucursal"] as! [AnyObject]
                            
                            for datos in objSucursal{
                                var objDireccion = datos["direccion"] as! AnyObject
                                let calle = objDireccion["calle"] as! String
                                
                                var nombre: String = ""
                                var latOp: String? = ""
                                var lonOp: String? = ""
                                var latitud: String = ""
                                var longitud: String = ""
                                var horario: String = ""
                                var turnomovil: String = ""
                                
                                if let lat = datos["latitud"] {
                                    do{
                                        latOp = try lat as? String
                                        if latOp != nil {
                                            latitud = latOp?.replacingOccurrences(of: ",", with: ".") as! String
                                        }
                                    }catch{
                                        //print error
                                    }
                                }
                                
                                if let long = datos["longitud"] {
                                    do{
                                        lonOp = try long as? String
                                        if lonOp != nil {
                                            longitud = lonOp?.replacingOccurrences(of: ",", with: ".") as! String
                                        }
                                    }catch{
                                        //print error
                                    }
                                }
                                
                                if let hor = datos["horario"] {
                                    do{
                                        var horarioOp = try hor as? String
                                        if horarioOp != nil {
                                            horario = horarioOp as! String
                                        }
                                    }catch{
                                        //print error
                                    }
                                }
                                
                                if let nombreSucursal = datos["nombreSucursal"] {
                                    do{
                                        var nombreSuc = try nombreSucursal as? String
                                        if nombreSuc != nil {
                                            nombre = nombreSuc as! String
                                        }
                                    }catch{
                                        //print error
                                    }
                                }
                                
                                if let urlTurnoMovil = datos["turnomovil"] {
                                    do{
                                        var urlTurno = try urlTurnoMovil as? String
                                        if urlTurno != nil {
                                            turnomovil = urlTurno as! String
                                        }
                                    }catch{
                                        //print error
                                    }
                                }
                                
                                
                                let obj = dummySucursales()
                                obj.nombreSucursal = nombre
                                obj.longitud = longitud
                                obj.latitud = latitud
                                obj.direccion.calle = calle
                                obj.horario = horario
                                obj.turnomovil = turnomovil
                                
                                if longitud != "" {
                                    self.listaSucursalesDummy.append(obj)
                                }
                                
                            }
                            
                        }
                    }
                    
                    self.async.leave()
                    
                } catch let error as NSError {
                    print(error)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        //just deal
                    }
                }
                
            }
            }.resume()
    }
    
    /*
     Inicio sub view
     */
    
    // --- Sub View para la tabla de sucursales
    private var bottomConstraint = NSLayoutConstraint()
    
    private var popupOffset: CGFloat = 0
    
    
    private lazy var popupView: UIView = {
        
        let positionY = percentScreen(percent: 65, position: "y") ?? 0
        let positionX = percentScreen(percent: 40, position: "x") ?? 0
        let lineWidth = percentScreen(percent: 20, position: "x") ?? 0
        
        popupOffset = positionY
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        
        let viewSlide = UIView()
        viewSlide.frame = CGRect(x: 10, y: 5, width: screen.width - 20, height: 20)
        viewSlide.backgroundColor = UIColor.white
        
        //Add animations
        viewSlide.addGestureRecognizer(panRecognizer)
        
        view.addSubview(viewSlide)
        
        //Line in the middle of the view
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: positionX, y: 10, width: lineWidth, height: 7)
        line.layer.cornerRadius = line.frame.height / 2
        line.backgroundColor = UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1.0)
        
        view.addSubview(line)
        
        //Search Bar
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 20, y: 30, width: screen.width - 40, height: 40)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        
        view.addSubview(searchBar)
        
        //Table view
        var tableHeightDiference = percentScreen(percent: 22, position: "y")
        self.tableView.frame = CGRect(x: 0, y: 80, width: screen.width, height: screen.height - tableHeightDiference!)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Assing cell to table view
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
        
        view.addSubview(self.tableView)
        
        //View search fail
        self.viewSearchFail.frame = CGRect(x: 0, y: 80, width: screen.width, height: screen.height)
        viewSearchFail.isHidden = true
        
        view.addSubview(viewSearchFail)
        
        let imageNoSearch = UIImageView()
        imageNoSearch.image = #imageLiteral(resourceName: "no_busqueda")
        imageNoSearch.frame = CGRect(x: (percentScreen(percent: 50, position: "x"))! - 20, y: 0, width: 40, height: 40)
        
        viewSearchFail.addSubview(imageNoSearch)
        
        let infoLabel = UILabel()
        infoLabel.frame = CGRect(x: (percentScreen(percent: 50, position: "x"))! - 100, y: 45, width: 200, height: 40)
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.numberOfLines = 2
        infoLabel.textAlignment = .center
        infoLabel.text = """
        ¡Ups! Sin resultados.
        Prueba moviéndote en el mapa
        """
        
        viewSearchFail.addSubview(infoLabel)
        
        detailsView.isHidden = true
        
        view.addSubview(detailsView)
        
        return view
    }()
    
    let detailsTitle = UILabel()
    let detailsSubTitle = UILabel()
    let detailsDistace = UILabel()
    let detailsInformation = UILabel()
    let detailsHowToGetButton = UIButton.init(type: .roundedRect)
    let detailsWantGoButton = UIButton.init(type: .roundedRect)
    var howToGetLatitude = ""
    var howToGetLongitude = ""
    var urlTurnoMovil = ""
    let detailsTurnoMovilInformation = UIView()
    
    @objc func singleTap(_ sender: UIButton){
        detailsView.isHidden = true
    }
    
    private lazy var detailsView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 30, width: screen.width, height: screen.height)
        view.backgroundColor = UIColor.white
        
        //Image
        let detailImage = UIImageView()
        detailImage.image = #imageLiteral(resourceName: "sucursal_circulo_amarillo")
        detailImage.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        
        view.addSubview(detailImage)
        
        // Title label
        detailsTitle.frame = CGRect(x: 60, y: 10, width: screen.width - 70, height: 20)
        detailsTitle.font = UIFont(name: Fonts.RawsonProSemiBold, size: 18)
        detailsTitle.textColor = textColor
        //detailsTitle.text = "MORANDE"
        
        view.addSubview(detailsTitle)
        
        //Exit button
        let detailsExit = UIButton()
        detailsExit.frame = CGRect(x: screen.width - 30, y: 10, width: 20, height: 20)
        detailsExit.setImage(#imageLiteral(resourceName: "cerrar_mapa"), for: .normal)
        detailsExit.isUserInteractionEnabled = true
        detailsExit.addTarget(self, action: #selector(self.singleTap(_:)), for: .touchUpInside)
        
        view.addSubview(detailsExit)
        
        //Direction label
        detailsSubTitle.frame = CGRect(x: 60, y: 32, width: screen.width - 80, height: 20)
        detailsSubTitle.font = UIFont(name: Fonts.RawsonProRegular, size: 14)
        detailsSubTitle.textColor = textColor
        //detailsSubTitle.text = "HUERFANOS 1133"
        view.addSubview(detailsSubTitle)
        
        //Distance label
        detailsDistace.frame = CGRect(x: screen.width - 60, y: 32, width: 60, height: 20)
        detailsDistace.font = UIFont(name: Fonts.RawsonProRegular, size: 14)
        detailsDistace.textColor = textColor
        //detailsDistace.text = "3,4 kms"
        
        view.addSubview(detailsDistace)
        
        //Info label
        detailsInformation.frame = CGRect(x: 60, y: 43, width: (percentScreen(percent: 60, position: "x"))!, height: 50)
        detailsInformation.font = UIFont(name: Fonts.RawsonProRegular, size: 13)
        detailsInformation.lineBreakMode = .byWordWrapping
        detailsInformation.numberOfLines = 3
        detailsInformation.textColor = textColor
        //detailsInformation.text = "Lunes a Jueves de 09:00 a 17:00 Hrs. - Viernes de 09:00 a 16:00 Hrs."
        
        view.addSubview(detailsInformation)
        
        //Turno movil info
        
        detailsTurnoMovilInformation.frame = CGRect(x: 60, y: 95, width: percentScreen(percent: 70, position: "x")!, height: 70)
        view.addSubview(detailsTurnoMovilInformation)
        
        let greenIcon = UIImageView()
        greenIcon.image = #imageLiteral(resourceName: "sucurlas_circulo")
        greenIcon.frame = CGRect(x: 0, y: 5, width: 20, height: 20)
        
        detailsTurnoMovilInformation.addSubview(greenIcon)
        
        let message = UILabel()
        message.frame = CGRect(x: 30, y: 0, width: detailsTurnoMovilInformation.frame.width - 20, height: 30)
        message.font = UIFont(name: Fonts.RawsonProRegularIt, size: 12)
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 2
        message.textColor = textColor
        message.text = "ven a conocer el nuevo modelo atencional en esta sucursal"
        
        detailsTurnoMovilInformation.addSubview(message)
        
        //Button web View
        detailsWantGoButton.frame = CGRect(x: 0, y: 40, width: detailsTurnoMovilInformation.frame.width, height: 40)
        detailsWantGoButton.setTitle("Agendar visita", for: .normal)
        detailsWantGoButton.titleLabel?.font = UIFont(name: Fonts.RawsonProBold, size: 19)
        detailsWantGoButton.backgroundColor = UIColor.init(red: 249/255, green: 190/255, blue: 0/255, alpha: 1.0)
        detailsWantGoButton.tintColor = UIColor.white
        detailsWantGoButton.layer.cornerRadius = 5.0
        detailsWantGoButton.addTarget(self, action: #selector(self.webView(_:)), for: .touchUpInside)
        
        detailsTurnoMovilInformation.addSubview(detailsWantGoButton)
        
        //link button
        var positionX = percentScreen(percent: 50, position: "x") ?? 0
        var widthButton = percentScreen(percent: 30, position: "x") ?? 0
        //var widthButton = percentScreen(percent: 35, position: "x") ?? 0
        detailsHowToGetButton.frame = CGRect(x: positionX - widthButton / 2, y: 180, width: widthButton, height: 40)
        detailsHowToGetButton.tintColor = UIColor.init(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
        detailsHowToGetButton.titleLabel?.font = UIFont(name: Fonts.RawsonProRegular, size: 16)
        detailsHowToGetButton.setTitle("¿Cómo llegar?", for: .normal)
        detailsHowToGetButton.addTarget(self, action: #selector(self.openApplication(_:)), for: .touchUpInside)
        
        view.addSubview(detailsHowToGetButton)
        
        return view
    }()
    
    @objc func openApplication(_ sender: UIButton){
        
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let coordinates = "\(howToGetLatitude),\(howToGetLongitude)"
            
            let wazeUrl = URL(string: "waze://?ll=\(coordinates)&navigate=yes")
            let googleUrl = URL(string: "comgooglemaps://" + "?daddr=\(coordinates)")
            let appleUrl = URL(string: "http://maps.apple.com/?daddr=\(coordinates)")
            
            if UIApplication.shared.canOpenURL(appleUrl!){
                UIApplication.shared.open(appleUrl!)
            } else if UIApplication.shared.canOpenURL(googleUrl!){
                UIApplication.shared.canOpenURL(googleUrl!)
            } else if UIApplication.shared.canOpenURL(wazeUrl!){
                UIApplication.shared.canOpenURL(wazeUrl!)
            }else {
                let title = "No existe aplicación para navegar"
                let message = "No tienes instalado Waze, Apple Maps o Google Maps"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func webView(_ sender: UIButton){
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let islogin  = UserDefaults.standard.bool(forKey: "loggin")
            
            //open webView
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SucursalesWebViewControllerIdentity") as? SucursalesWebViewController{
                let uid = "nombre + apellidoPat + apellidoMat + rut"
                let nombre = "nombre completo sin espacios"
                
                //            urlTurnoMovil.replacingOccurrences(of: "[uid]", with: uid)
                //            urlTurnoMovil.replacingOccurrences(of: "[nombre]", with: nombre)
                //            urlTurnoMovil.replacingOccurrences(of: "[rut]", with: "rut con puntos")
                //            urlTurnoMovil.replacingOccurrences(of: "usertest@zeroq.cl", with: "rut persona en caso de que tenga")
                
                vc.url = urlTurnoMovil
                
                if islogin {
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                    let login = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
                    login?.vc = vc
                   // login?.mensaje = "Sucursales"
                    self.navigationController?.pushViewController(login!, animated: true)
                }
                
            }
        }
    }
    
    private func layout() {
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: screen.height).isActive = true
        
        
        self.async.leave()
        
    }
    
    /*
     Fin sub view
     */
    
    /*
     Inicio animación de la sub view
     */
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        let navigationHeight = (self.navigationController?.navigationBar.frame.height)!
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let height = navigationHeight + statusHeight
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            self.view.endEditing(true);
            switch state {
            case .open:
                
                self.bottomConstraint.constant = height
                self.popupView.layer.cornerRadius = 20
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
                self.popupView.layer.cornerRadius = 0
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = height
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // start all animators
        transitionAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: popupView)
            var fraction = -translation.y / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: popupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    /*
     Fin animación de la sub view
     */
    
    
    
    func showSucursal(index: Int) {
        let data = self.listaSucursalesDummy[index]
        
        var distance: Double = 0
        
        //        do{
        //            distance = calculateDistance(uLatitude: String(self.userLocation.coordinate.latitude), uLongitude: String(self.userLocation.coordinate.longitude), sLatitude: data.latitud, sLongitude: data.longitud)
        //        }catch{
        //            distance = calculateDistance(uLatitude: data.latitud, uLongitude: data.longitud, sLatitude: data.latitud, sLongitude: data.longitud)
        //        }
        
        do{
            distance = calculateDistance(uLatitude: String(self.userLocation.coordinate.latitude), uLongitude: String(self.userLocation.coordinate.longitude), sLatitude: data.latitud, sLongitude: data.longitud)
        }catch{
            distance = calculateDistance(uLatitude: data.latitud, uLongitude: data.longitud, sLatitude: data.latitud, sLongitude: data.longitud)
        }
        
        let formatedDistance = "\(String(format:"%.1f", distance)) kms"
        
        var positionX = percentScreen(percent: 50, position: "x") ?? 0
        var widthButton = percentScreen(percent: 30, position: "x") ?? 0
        
        detailsTitle.text = data.nombreSucursal
        detailsSubTitle.text = data.direccion.calle
        detailsDistace.text = formatedDistance
        detailsInformation.text = data.horario
        
        if data.turnomovil == nil || data.turnomovil == "" {
            detailsWantGoButton.isHidden = true
            detailsTurnoMovilInformation.isHidden = true
            detailsHowToGetButton.frame = CGRect(x: positionX - widthButton / 2, y: 95, width: widthButton, height: 40)
        } else {
            detailsWantGoButton.isHidden = false
            detailsTurnoMovilInformation.isHidden = false
            urlTurnoMovil = data.turnomovil
            detailsHowToGetButton.frame = CGRect(x: positionX - widthButton / 2, y: 175, width: widthButton, height: 40)
        }
        
        howToGetLatitude = data.latitud.replacingOccurrences(of: ",", with: ".")
        howToGetLongitude = data.longitud.replacingOccurrences(of: ",", with: ".")
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(data.latitud)!, longitude: CLLocationDegrees(data.longitud)!)
        let span = MKCoordinateSpan.init(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
        let region = MKCoordinateRegion.init(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
        var pin = mapView.annotations.first(where: {$0.title == data.nombreSucursal}) as! customPin
        
        mapView.selectAnnotation(pin, animated: true)
        
        detailsView.isHidden = false
    }
    
}

extension SucursalesViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(centerMap){
            guard let location = locations.last else { return }
            
            self.userLocation = location
            
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let span = MKCoordinateSpan.init(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
            let region = MKCoordinateRegion.init(center: center, span: span)
            
            centerMap = false
            
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! customPin
        showSucursal(index: annotation.index)
        view.image = UIImage(named: "pin_sucursal_amarillo")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "pin_sucursal")
    }
}

extension SucursalesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.search = listaSucursalesDummy.filter{$0.nombreSucursal.uppercased().contains(searchText.uppercased())}
            self.searching = true
            
            if self.search.count == 0 {
                self.tableView.isHidden = true
                self.viewSearchFail.isHidden = false
            }
            
        }else{
            self.view.endEditing(true);
            self.searching = false
            self.tableView.isHidden = false
            self.viewSearchFail.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true);
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.endEditing(true);
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true);
    }
}

extension SucursalesViewController: UITableViewDelegate{
    
}

extension SucursalesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if !searching {
            return self.listaSucursalesDummy.count
        }else{
            return self.search.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true);
        showSucursal(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
    
        
        var data = self.listaSucursalesDummy[indexPath.row]
        
        if searching {
            data = self.search[indexPath.row]
            self.searching = false
        }
        
        //        while self.userLocation.coordinate.latitude == 0.0 {
        //            print("no location")
        //        }
        
        var distance: Double = 0
        var formatedDistance = ""
        
        if locationManager.location?.coordinate.latitude == nil {
            formatedDistance = "N/A"
        }else {
            do{
                distance = calculateDistance(uLatitude: String(locationManager.location!.coordinate.latitude), uLongitude: String(locationManager.location!.coordinate.longitude), sLatitude: data.latitud, sLongitude: data.longitud)
            }catch{
                distance = calculateDistance(uLatitude: data.latitud, uLongitude: data.longitud, sLatitude: data.latitud, sLongitude: data.longitud)
            }
            
            formatedDistance = "\(String(format:"%.1f", distance)) kms"
            
        }
        
        cell.commonInit(title: "\(data.nombreSucursal)", direction: "\(data.direccion.calle)", distance: formatedDistance)
        
        return cell
    }
    
    func calculateDistance(uLatitude: String, uLongitude: String, sLatitude: String, sLongitude: String) -> (Double){
        
        let uLatitudeNumber = textToNumber(number: uLatitude)
        let uLongitudeNumber = textToNumber(number: uLongitude)
        let sLatitudeNumber = textToNumber(number: sLatitude)
        let sLongitudeNumber = textToNumber(number: sLongitude)
        
        let uCoordenate = CLLocation(latitude: uLatitudeNumber, longitude: uLongitudeNumber)
        let sCoordinate = CLLocation(latitude: sLatitudeNumber, longitude: sLongitudeNumber)
        
        let distanceInMeters = uCoordenate.distance(from: sCoordinate)
        
        //distance in Kms
        return (distanceInMeters / 1000)
    }
    
    func textToNumber(number: String) -> (Double){
        var result: Double = 0
        let decimalStringNumber = number.replacingOccurrences(of: ",", with: ".")
        
        if let decimal = Double(decimalStringNumber){
            result = decimal
        }
        
        return result
    }
    
    
}

private enum State {
    case closed
    case open
}

extension State{
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}


class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var index: Int
    var annotation: MKAnnotation?
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D, index: Int){
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
        self.index = index
    }
    
    func setAnnotation(annotation: MKAnnotation){
        self.annotation = annotation
    }
    
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}

class dummySucursales{
    var nombreSucursal: String = ""
    var longitud: String = ""
    var latitud: String = ""
    var horario: String = ""
    var codigoSucursal: String? = ""
    var turnomovil: String = ""
    var direccion = direccion2()
    var distance: String = ""
}

class listaDireccion: Object {
    @objc dynamic var calle: String = ""
}

class listaSucursal: Object {
    let direccion = listaDireccion()
    @objc dynamic var nombreSucursal = ""
    @objc dynamic var longitud: String = ""
    @objc dynamic var latitud: String = ""
    @objc dynamic var horario: String = ""
    @objc dynamic var codigoSucursal: String? = ""
    @objc dynamic var turnomovil: String = ""
    @objc dynamic var distance: String = ""
}

class direccion2{
    var calle: String = ""
}

