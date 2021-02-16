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
        let loginData = LoginData(email: "lcsoka@inf.elte.hu", password: "eclick1122")
        Api.shared.post(LoginResource(), data: loginData) { response in
            print(response)
        }
    }


}

