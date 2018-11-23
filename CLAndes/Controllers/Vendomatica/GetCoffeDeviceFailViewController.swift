//
//  GetCoffeDeviceFailViewController.swift
//  Vendomatica
//
//  Created by Diego Corbinaud on 25-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit

class GetCoffeDeviceFailViewController: UIViewController {

    @IBOutlet weak var btnTryAgain: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnTryAgain.backgroundColor = UIColor.init(red: 255/255, green: 180/255, blue: 2/255, alpha: 1)
        btnTryAgain.layer.cornerRadius = 6
    }
    
    @IBAction func touchTryAgain(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
