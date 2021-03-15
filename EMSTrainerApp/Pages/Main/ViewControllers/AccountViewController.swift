//
//  AccountViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

class AccountViewController: UIViewController, MainStoryboardLodable {

    var userService: UserService!
    
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
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
}
