//
//  LoginViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func userDidRequestRegistration()
}

final class LoginViewController: UIViewController, AuthenticationStoryboardLodable {

    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onRegistrationButtonTap(_ sender: Any) {
        delegate?.userDidRequestRegistration()
    }
    
}
