//
//  BeneficiosMainController.swift
//  CajaLosAndesApp
//
//  Created by admin on 11/6/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import Foundation
import UIKit

class BeneficiosMainController: UIViewController {
     var loadingView : LoadingView!
    override func viewDidLoad() {
        
        self.loadingView = LoadingView(uiView: view, message: "Cargando tus datos")
        self.loadingView.show()
        var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "BeneficiosViewController")
        self.navigationController?.pushViewController(login, animated: true)
        print("BENEFICIOS")
    }
}
