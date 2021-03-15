//
//  MainCoordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import UIKit
import Swinject

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorFinish()
}

final class MainCoordinator: NavigationCoordinator {
    let container: Container
    var navigationController: UINavigationController
    var auth: AuthenticationService!
    weak var delegate: MainCoordinatorDelegate?
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.auth = container.resolve(AuthenticationService.self)
    }
    
    func start() {
        let vc = container.resolve(DashboardViewController.self)!
        vc.authDelegate = self
        vc.auth = auth
        vc.navigationItem.hidesBackButton = true

        // Remove previous view controllers from the stack
        navigationController.setViewControllers([vc], animated: true)
    }
}

extension MainCoordinator: AuthenticationDelegate {
    func onAuthenticationStateChanged(loggedIn: Bool) {
        if !loggedIn {
            delegate?.mainCoordinatorFinish()
        }
    }
}
