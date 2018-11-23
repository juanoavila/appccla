//
//  ConveniosViewController.swift
//  CajaLosAndesApp
//
//  Created by Diego Corbinaud on 12-11-18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

private var Loading: UIView = {
    let screen = UIScreen.main.bounds
    
    let view = UIView()
    view.bounds = screen
    view.backgroundColor = .black
    view.alpha = 0.7
    
    return view
}()

class ConveniosViewController: UIViewController, MKMapViewDelegate {
    
    class pinConvenios: MKPointAnnotation{
        var index: Int?
        var nombreImagen: String!
    }
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 0.1
    var centerMap = true
    var userLocation = CLLocation()
    let async = DispatchGroup()
    let screen = UIScreen.main.bounds.size
    var tableView = UITableView()
    var estructuraConvenios = EstructuraConvenios()
    var listaConvenios: [Convenio] = []
    var search: [Convenio] = []
    var searching = false
    var viewSearchFail = UIView()
    var centerLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var layoutExist = false
    var convenioSeleccionado = Convenio()
    
    let alertSettings = ShowAlertSettings(message: "Para poder ubicarte en el mapa puedes activar los servicios de ubicación en la pantalla de ajustes.", buttonTitle: "Ir a ajustes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Más Beneficios"
        
        Loading.frame = view.frame
        
        view.addSubview(Loading)
        Loading.isHidden = false
        

        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Loading.isHidden = true
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
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
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
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            self.centerViewOnUserLocation()
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
        
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private var popupOffset: CGFloat = 0
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
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
        let nibName = UINib(nibName: "ConvenioTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "ConvenioTableViewCell")

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
    let discountLabel = UILabel()
    let detailsInfo = UITextView()
    let detailsHowToGetButton = UIButton.init(type: .roundedRect)
    let detailsWantGoButton = UIButton.init(type: .roundedRect)
    var howToGetLatitude = ""
    var howToGetLongitude = ""
    let textColor = UIColor.init(red: 74/255, green: 85/255, blue: 91/255, alpha: 1.0)
    let greenIcon = UIImageView()
    let detailImage = UIImageView()
    
    @objc func singleTap(_ sender: UIButton){
        detailsView.isHidden = true
    }
    
    private lazy var detailsView: UIView = {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 30, width: screen.width, height: screen.height)
        view.backgroundColor = UIColor.white
        
        //Exit button
        let detailsExit = UIButton()
        detailsExit.frame = CGRect(x: screen.width - 30, y: 10, width: 20, height: 20)
        detailsExit.setImage(#imageLiteral(resourceName: "cerrar_mapa"), for: .normal)
        detailsExit.isUserInteractionEnabled = true
        detailsExit.addTarget(self, action: #selector(self.singleTap(_:)), for: .touchUpInside)
        
        view.addSubview(detailsExit)
        
        //Image
        detailImage.frame = CGRect(x: 10, y: 35, width: 40, height: 40)
        
        view.addSubview(detailImage)
        
        // Title label
        detailsTitle.frame = CGRect(x: 60, y: 35, width: screen.width - 70, height: 20)
        detailsTitle.font = UIFont(name: Fonts.RawsonProSemiBold, size: 18)
        detailsTitle.textColor = textColor
        //detailsTitle.text = "MORANDE"
        
        view.addSubview(detailsTitle)
        
        //Direction label
        detailsSubTitle.frame = CGRect(x: 60, y: 63, width: screen.width - 80, height: 20)
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
        
        //Discount label
        discountLabel.frame = CGRect(x: screen.width - 180, y: 33, width: 170, height: 50)
        discountLabel.font = UIFont(name: Fonts.RawsonProRegular, size: 13)
        discountLabel.lineBreakMode = .byWordWrapping
        discountLabel.numberOfLines = 3
        discountLabel.textAlignment = .right
        discountLabel.textColor = textColor
        
        view.addSubview(discountLabel)
        
        detailsHowToGetButton.frame = CGRect(x: screen.width - 85, y: 53, width: 80, height: 40)
        detailsHowToGetButton.tintColor = UIColor.init(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
        detailsHowToGetButton.titleLabel?.font = UIFont(name: Fonts.RawsonProRegular, size: 13)
        detailsHowToGetButton.setTitle("Cómo llegar", for: .normal)
        detailsHowToGetButton.addTarget(self, action: #selector(self.openApplication(_:)), for: .touchUpInside)
        
        view.addSubview(detailsHowToGetButton)
        
        //I want it
        detailsWantGoButton.frame = CGRect(x: 60, y: 103, width: percentScreen(percent: 70, position: "x")!, height: 40)
        detailsWantGoButton.setTitle("¡Lo quiero!", for: .normal)
        detailsWantGoButton.titleLabel?.font = UIFont(name: Fonts.RawsonProBold, size: 19)
        detailsWantGoButton.backgroundColor = UIColor.init(red: 249/255, green: 190/255, blue: 0/255, alpha: 1.0)
        detailsWantGoButton.tintColor = UIColor.white
        detailsWantGoButton.layer.cornerRadius = 3.0
        detailsWantGoButton.addTarget(self, action: #selector(self.alertWantGoButton(_:)), for: .touchUpInside)
        
        view.addSubview(detailsWantGoButton)
        
        let label = UILabel()
        label.frame = CGRect(x: 60, y: 150, width: percentScreen(percent: 70, position: "x")!, height: 40)
        label.text = "Detalle del beneficio"
        label.font = UIFont(name: Fonts.RawsonProRegular, size: 15)
        label.textColor = textColor
        
        view.addSubview(label)
        
        let subLine = UIView()
        subLine.frame = CGRect(x: 60, y: 180, width: percentScreen(percent: 70, position: "x")!, height: 1)
        subLine.backgroundColor = textColor
        
        view.addSubview(subLine)
        
        detailsInfo.frame = CGRect(x: 60, y: 190, width: percentScreen(percent: 70, position: "x")!, height: view.frame.height - 200)
        detailsInfo.font = UIFont(name: Fonts.RawsonProRegular, size: 14)
        detailsInfo.textColor = textColor
        detailsInfo.isUserInteractionEnabled = false
        detailsInfo.isEditable = false
        detailsInfo.isSelectable = false
        
        view.addSubview(detailsInfo)
        
        
        
        return view
    }()
    
    @objc func alertWantGoButton(_ sender: UIButton){
        let data = self.convenioSeleccionado
        
        if data.texto_sms == nil || data.texto_sms == ""{
            
            let alert = UIAlertController(title: "¡Bien!", message: "Sólo debes presentar tu cédula de identidad al momento de la compra.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/ConvenioSolicitudCodigo/?rut=183297260&nombre=Diego&codigo=\(data.texto_sms)"
        }
        
        
        
        
//        "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/ConvenioSolicitudCodigo/?rut=183297260&nombre=Diego&codigo=DOMINO"
        
    }
    
    @objc func openApplication(_ sender: UIButton){
        
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
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
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
    
    func mostrarConvenio(index: Int) {
        let data = self.listaConvenios[index]
        convenioSeleccionado = data
        
        var distance: Double = 0
        
        do{
            distance = calculateDistance(uLatitude: String(self.userLocation.coordinate.latitude), uLongitude: String(self.userLocation.coordinate.longitude), sLatitude: data.latitud!, sLongitude: data.longitud!)
        }catch{
            distance = calculateDistance(uLatitude: data.latitud!, uLongitude: data.longitud!, sLatitude: data.latitud!, sLongitude: data.longitud!)
        }
        
        let formatedDistance = "\(String(format:"%.1f", distance)) kms"
        
        var positionX = percentScreen(percent: 50, position: "x") ?? 0
        var widthButton = percentScreen(percent: 30, position: "x") ?? 0
        
        detailsTitle.text = data.nombre
        detailsSubTitle.text = data.direccion
        detailsDistace.text = formatedDistance
        discountLabel.text = data.descripcion_corta
        let descripcion = data.descripcion_canje
        
        detailsInfo.text = descripcion
        
        switch(data.nombre_pilar){
        case "SALUD":
            detailImage.image = UIImage(named: "circulo_salud")
            break
        case "EDUCACÍON":
            detailImage.image = UIImage(named: "circulo_educacion")
            break
        case "TURISMO":
            detailImage.image = UIImage(named: "circulo_viaje")
            break
        case "APOYO SOCIAL":
            detailImage.image = UIImage(named: "circulo_social")
            break
        case "RECREACION":
            detailImage.image = UIImage(named: "circulo_teatro")
            break
        case "EDUCACIÓN SUPERIOR":
            detailImage.image = UIImage(named: "circulo_educacion")
            break
        default:
            detailImage.image = UIImage(named: "sucursal_circulo_amarillo")
            break
        }
        
        
//        if data.turnomovil == nil || data.turnomovil == "" {
//            detailsWantGoButton.isHidden = true
//            detailsTurnoMovilInformation.isHidden = true
//            detailsHowToGetButton.frame = CGRect(x: positionX - widthButton / 2, y: 95, width: widthButton, height: 40)
//        } else {
//            detailsWantGoButton.isHidden = false
//            detailsTurnoMovilInformation.isHidden = false
//            urlTurnoMovil = data.turnomovil
//            detailsHowToGetButton.frame = CGRect(x: positionX - widthButton / 2, y: 175, width: widthButton, height: 40)
//        }
//
        howToGetLatitude = data.latitud!.replacingOccurrences(of: ",", with: ".")
        howToGetLongitude = data.longitud!.replacingOccurrences(of: ",", with: ".")
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(data.latitud!)!, longitude: CLLocationDegrees(data.longitud!)!)
        let span = MKCoordinateSpan.init(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
        let region = MKCoordinateRegion.init(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
        //var pin = mapView.annotations.first(where: {$0.title == data.nombreSucursal}) as! customPin
        
        //mapView.selectAnnotation(pin, animated: true)
        
        detailsView.isHidden = false
    }

}

extension ConveniosViewController: UITableViewDelegate{
    
}

extension ConveniosViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searching {
            return self.listaConvenios.count
        }else{
            return self.search.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true);
        mostrarConvenio(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvenioTableViewCell", for: indexPath) as! ConvenioTableViewCell
        
        if self.listaConvenios.count > 0 {
            var data = self.listaConvenios[indexPath.row]
            
            if searching {
                if self.search.count > 0{
                    data = self.search[indexPath.row]
                    self.searching = false
                }
            }
            
            var distance: Double = 0
            var formatedDistance = ""
            
            if locationManager.location?.coordinate.latitude == nil {
                formatedDistance = "N/A"
            }else {
                do{
                    distance = calculateDistance(uLatitude: String(locationManager.location!.coordinate.latitude), uLongitude: String(locationManager.location!.coordinate.longitude), sLatitude: data.latitud!, sLongitude: data.longitud!)
                }catch{
                    distance = calculateDistance(uLatitude: data.latitud!, uLongitude: data.longitud!, sLatitude: data.latitud!, sLongitude: data.longitud!)
                }
                
                formatedDistance = "\(String(format:"%.1f", distance)) kms"
                
            }
            
            cell.cellConfig(titulo: data.nombre!, distancia: formatedDistance, descuento: data.descripcion_corta!, imagen: data.nombre_pilar!)
        }
        
        
        
        
//
//        cell.commonInit(title: "\(data.nombreSucursal)", direction: "\(data.direccion.calle)", distance: formatedDistance)
        
        return cell
    }
    
}

extension ConveniosViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            if let lista = self.estructuraConvenios.respuesta?.convenios {
             
                self.listaConvenios = lista.filter{$0.nombre!.uppercased().contains(searchText.uppercased())}
                print(searchText.uppercased())
                for item in lista{
                    if item.nombre!.uppercased().contains(searchText.uppercased()) {
                        print(item.nombre)
                    }
                }
                
                //self.searching = true
                
                if self.listaConvenios.count == 0 {
                    self.tableView.isHidden = true
                    self.viewSearchFail.isHidden = false
                }
                
            
            }
        }else{
            self.view.endEditing(true);
            self.searching = false
            self.tableView.isHidden = false
            self.viewSearchFail.isHidden = true
            self.listaConvenios = (self.estructuraConvenios.respuesta?.convenios)!
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

extension ConveniosViewController: CLLocationManagerDelegate{
    
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        let pin = annotation as! pinConvenios
        
        annotationView?.image = UIImage(named: pin.nombreImagen)
        
        annotationView?.canShowCallout = true
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if(!CheckConnection.Connection()){
            showAlertInfo(msg: "No estás conectado a internet", title: "¡Ups!", txtButton: "Aceptar", controller: self)
        }else{
            let locationOriginalCenter = CLLocation.init(latitude: self.centerLocation.latitude, longitude: self.centerLocation.longitude)
            let locationNewCenter = CLLocation.init(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            if locationOriginalCenter.distance(from: locationNewCenter) >= 2500{
                
                //Loading.isHidden = false
                
                self.mapView.overlays.forEach {
                    print("overlay -> \($0)")
                        self.mapView.removeOverlay($0)
                }
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                

                
                let circle = MKCircle(center: mapView.centerCoordinate, radius: 2500)
                mapView.addOverlay(circle)
                
                self.centerLocation = mapView.centerCoordinate
                
                print("cambio de region")
                
                listaConvenios = []
                tableView.reloadData()
                
                
                async.enter()
                self.obtenerConvenios(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                async.wait()
                
                tableView.reloadData()
                
                if !layoutExist {
                    self.layout()
                    layoutExist = true
                }
                
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! pinConvenios
        mostrarConvenio(index: annotation.index!)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "pin_sucursal")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.strokeColor = UIColor.init(red: 250/255, green: 64/255, blue: 52/255, alpha: 1)
            circleRenderer.alpha = 0.5
            
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func obtenerConvenios(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let radio = "2.5"
        let urlString = "https://mfpqa-cajalosandes.mybluemix.net/mfp/api/adapters/ConveniosV2/getConveniosV2?lat=\(latitude)&lon=\(longitude)&radio=\(radio)"
        
        print(urlString)
        
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("didn't work, \(String(describing: error))")
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    //just deal
                }
            } else {
                do {
                    let decoder = JSONDecoder()
                    self.estructuraConvenios = try decoder.decode(EstructuraConvenios.self, from: data!)
                    var countIndex = 0
                    if self.estructuraConvenios.codigo == "1" {
                        
                        self.listaConvenios = (self.estructuraConvenios.respuesta?.convenios)!
                        for (item) in self.listaConvenios {
                            let nombre = item.nombre
                            let direccion = item.direccion
                            let latitud = Double(item.latitud!)
                            let longitud = Double(item.longitud!)
                            let index = countIndex
                            countIndex = countIndex + 1
                            
                            
                            let pin = pinConvenios()
                            pin.coordinate = CLLocationCoordinate2D(latitude: latitud!, longitude: longitud!)
                            pin.title = nombre
                            pin.subtitle = direccion
                            pin.index = index
                            
                            switch(item.nombre_pilar){
                            case "SALUD":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pinsalud"
                                break
                            case "EDUCACÍON":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pineducacion"
                                break
                            case "TURISMO":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pinviajes"
                                break
                            case "APOYO SOCIAL":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pinesapoyosocial"
                                break
                            case "RECREACION":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pinespectaculo"
                                break
                            case "EDUCACIÓN SUPERIOR":
                                // set to false to disable all right utility buttons appearing
                                pin.nombreImagen = "pineducacion"
                                break
                            default:
                                pin.nombreImagen = "pin_convenio"
                                break
                            }
                            
                            
                            self.mapView.addAnnotation(pin)
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                    
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        //just deal
                    }
                }
                self.async.leave()
            }
            }.resume()
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
