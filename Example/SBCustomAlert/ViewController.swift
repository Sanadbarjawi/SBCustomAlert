//
//  ViewController.swift
//  SBCustomAlert
//
//  Created by sanadbarjawi on 12/03/2018.
//  Copyright (c) 2018 sanadbarjawi. All rights reserved.
//

import UIKit
import SBCustomAlert
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showAlert()
        }
        
    }
    
    fileprivate func showAlert() {
        let alert = SBCustomAlert(title: "Alert Title", message: "alert message which is multilined supported")
        let alertOkButton = CustomAlertButton(title: "Ok", textColor: .black, dismissOnTap: true) {
            
        }
        alert.addButtons([alertOkButton])
        alert.build()
        alert.show(animated: true)
    }
    
}

