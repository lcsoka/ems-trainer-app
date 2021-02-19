//
//  ViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loginData = LoginData(email: "lcsoka@inf.elte.hu", password: "eclick11222")
        Api.shared.post(LoginResource(), data: loginData, onSuccess: {
            print($0)
        }) {
            print($0)
        }
        
//        Api.shared.get(MeResource(), params: nil, onSuccess: {
//            print($0)
//        }) {
//            print($0)
//        }
    }
}

