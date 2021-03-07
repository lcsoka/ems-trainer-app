//
//  DashboardViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

class DashboardViewController: UIViewController, HomeStoryboardLodable {
    
    weak var authDelegate: AuthenticationDelegate?
    
    var auth: AuthenticationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLogoutTap(_ sender: Any) {
        auth.logout()
        authDelegate?.onAuthenticationStateChanged(loggedIn: false)
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
