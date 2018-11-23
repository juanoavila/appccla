//
//  BluetoothViewController.swift
//  Vendomatica
//
//  Created by Diego Corbinaud on 25-10-18.
//  Copyright © 2018 Diego Corbinaud. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOk.backgroundColor = UIColor.init(red: 255/255, green: 180/255, blue: 2/255, alpha: 1)
        btnOk.layer.cornerRadius = 6
    }

    @IBAction func touchOkButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
