//
//  DashboardViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

protocol DashboardViewControllerDelegate: class {
    func userDidRequestAccountPage()
    func userDidRequestWorkoutSetupPage()
}

class DashboardViewController: UIViewController, MainStoryboardLodable {
    
    weak var authDelegate: AuthenticationDelegate?
    
    weak var delegate: DashboardViewControllerDelegate?
    
    var viewModel: DashboardViewModel!
    
    @IBOutlet var workoutListView: WorkoutsList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        workoutListView.delegate = self
        viewModel.test()
    }
    
    func setupUI() {
        title = "Dashboard"
        self.extendedLayoutIncludesOpaqueBars = true
        let statBtn = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(self.showAccount))
        navigationItem.rightBarButtonItems = [statBtn]
    }
    
    @objc func showAccount() {
        self.delegate?.userDidRequestAccountPage()
    }

    @IBAction func onWorkoutSetupTap(_ sender: Any) {
        self.delegate?.userDidRequestWorkoutSetupPage()
    }
    
}

extension DashboardViewController: WorkoutListDelegate {
    func onItemsChanged() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
