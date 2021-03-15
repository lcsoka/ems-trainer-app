//
//  DashboardViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

protocol DashboardViewControllerDelegate: class {
    func userDidRequestAccountPage()
}

class DashboardViewController: UIViewController, MainStoryboardLodable {
    
    weak var authDelegate: AuthenticationDelegate?
    
    weak var delegate: DashboardViewControllerDelegate?
    
    var auth: AuthenticationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        title = "Dashboard"
        self.extendedLayoutIncludesOpaqueBars = true
        let statBtn = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(self.test))
        navigationItem.rightBarButtonItems = [statBtn]
//        self.navigationBar.add
    }
    
    @IBAction func onLogoutTap(_ sender: Any) {
        auth.logout()
        authDelegate?.onAuthenticationStateChanged(loggedIn: false)
    }
    
    @objc func test() {
        self.delegate?.userDidRequestAccountPage()
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
