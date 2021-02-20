//
//  ViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = Auth.shared.getToken() {
            // Logged in
            setButtonVisibility(loggedIn: true)
        } else {
            setButtonVisibility(loggedIn: false)
        }
        
    }
    
    private func setButtonVisibility(loggedIn: Bool) {
        btnLogin.isHidden = loggedIn
        btnLogout.isHidden = !loggedIn
        
    }
    
    @IBAction func login(_ sender: Any) {
        let loginData = LoginData(email: "lcsoka@inf.elte.hu", password: "eclick1122")
        Auth.shared.login(email: loginData.email, password: loginData.password) { error in
            if error != nil {
                return
            }
            
            self.setButtonVisibility(loggedIn: true)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        Auth.shared.logout()
        setButtonVisibility(loggedIn: false)
    }
}

