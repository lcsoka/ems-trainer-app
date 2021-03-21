//
//  AccountViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

protocol AccountViewControllerDelegate {
    func userDidLogout()
}
class AccountViewController: UIViewController, MainStoryboardLodable {

    var userService: UserService!
    var auth: AuthenticationService!
    var delegate: AccountViewControllerDelegate?
    
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        lblVersion.text = "v\(Bundle.main.appVersion)"
        
    }
    
    func setupUI() {
        if let user = userService.currentUser{
            lblName.text = user.name
            lblEmail.text = user.email
        }
    }

    @IBAction func onDoneTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onLogoutTap(_ sender: Any) {
        auth.logout()
        delegate?.userDidLogout()
        self.dismiss(animated: true)
    }
}
