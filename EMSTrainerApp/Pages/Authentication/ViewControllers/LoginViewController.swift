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

    weak var authDelegate: AuthenticationDelegate?
    
    weak var delegate: LoginViewControllerDelegate?
    
    var auth: AuthenticationService!
    
    @IBOutlet var waveView: WaveView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var ampSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
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
    
    @IBAction func onLoginTap(_ sender: Any) {
        let loginData = LoginData(email: "lcsoka@inf.elte.hu", password: "eclick1122")
        auth.login(email: loginData.email, password: loginData.password) { error in
            if error != nil {
                return
            }
            self.authDelegate?.onAuthenticationStateChanged(loggedIn: true)
        }
    }
//    @IBAction func sliderChanged(_ sender: Any) {
//        waveView.frequency =  CGFloat(slider.value)
//        let delta = 1 - (CGFloat(slider.value) - 4) / 2
//        let acc = 0.05 * delta
//        waveView.speed = 0.1 - acc
//    }
//    @IBAction func ampChanged(_ sender: Any) {
//        waveView.master = CGFloat(ampSlider.value)
//    }
}
