//
//  AppDelegate.swift
//  mySidebar2
//
//  Created by Muskan on 10/12/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import Foundation

import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var arrayNomHome : [String]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      // let dato = "[{\"titulo\":\"Cr\\u00e9ditos\",\"vista_ios\":\"ButtonCreditos\",\"visible\":\"t\"},{\"titulo\":\"Licencias M\\u00e9dicas\",\"vista_ios\":\"ButtonLicencias\",\"visible\":\"t\"},{\"titulo\":\"Sucursales\",\"vista_ios\":\"ButtonSucursales\",\"visible\":\"t\"},{\"titulo\":\"Mi cuenta\",\"vista_ios\":\"ButtonCuenta\",\"visible\":\"t\"},{\"titulo\":\"Convenios\",\"vista_ios\":\"ButtonConvenios\",\"visible\":\"t\"},{\"titulo\":\"\\u00bfTe Ayudamos?\",\"vista_ios\":\"ButtonAyuda\",\"visible\":\"t\"},{\"titulo\":\"Mis Beneficios\",\"vista_ios\":\"ButtonBeneficios\",\"visible\":\"t\"},{\"titulo\":\"Home\",\"vista_ios\":\"ButtonHome\",\"visible\":\"t\"},{\"titulo\":\"Empresas\",\"vista_ios\":\"ButtonEmpresas\",\"visible\":\"t\"},{\"titulo\":\"Certificados\",\"vista_ios\":\"ButtonCertificados\",\"visible\":\"f\"},{\"titulo\":\"Buz\\u00f3n de Mensajes\",\"vista_ios\":\"ButtonInbox\",\"visible\":\"t\"},{\"titulo\":\"Cerrar sesi\\u00f3n\",\"vista_ios\":\"ButtonLogout\",\"visible\":\"t\"},{\"titulo\":\"Vendomatica\",\"vista_ios\":\"ButtonVendomatic\",\"visible\":\"f\"},{\"titulo\":\"On Boarding\",\"vista_ios\":\"ButtonOnBoarding\",\"visible\":\"t\"}]".data(using: .utf8)!
         UserDefaults.standard.set("afiliado" , forKey: "esCarga")
        IQKeyboardManager.shared.enable = true
      self.llenaArray()
        self.construyeMenu()
        
 
      
        
        return true
    }
    func llenaArray() {
        
        var arrayNomHome = UserDefaults.standard.value(forKey: "arregloHomeNom")
        if (arrayNomHome == nil) {
            let arregloNomMenu = ["Bienvenido","bienvenido", "Home", "Mi cuenta","Buzón de Mensajes","Sucursales", "Convenios", "Licencias Médicas", "Mis Beneficios", "¿Te Ayudamos?" ]
            
            arrayNomHome = ["Licencias Médicas","Sucursales","Convenios","Mis Beneficios", "¿Te Ayudamos?","Buzón de Mensajes","Vendomatica","Créditos"]
            
            
            UserDefaults.standard.set(arrayNomHome , forKey: "arregloHomeNom")
            UserDefaults.standard.set(arregloNomMenu , forKey: "arregloMenuNom")
            
        }
        
       
    }
    func construyeMenu(){
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            window.backgroundColor = UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
            
            let nav = UINavigationController()
            nav.navigationBar.barTintColor = UIColor(red: 24/255, green: 150/255, blue: 211/255, alpha: 1.0)
            let mainView = ViewController()
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            nav.viewControllers = [mainView]
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

