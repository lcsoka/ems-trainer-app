//
//  HomeCoordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import UIKit
import Swinject

protocol HomeCoordinatorDelegate: class {
    func homeCoordinatorFinish()
}

final class HomeCoordinator: NavigationCoordinator {
    let container: Container
    var navigationController: UINavigationController
    var auth: AuthenticationService!
    weak var delegate: HomeCoordinatorDelegate?
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.auth = container.resolve(AuthenticationService.self)
    }
    
    func start() {
        let isNavigationStackEmpty = navigationController.viewControllers.isEmpty
        let vc = container.resolve(DashboardViewController.self)!
//        vc.delegate = self
        vc.authDelegate = self
        vc.auth = auth
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
        
        if !isNavigationStackEmpty {
            navigationController.viewControllers.remove(at: 0)
        }
    }
}

extension HomeCoordinator: AuthenticationDelegate {
    func onAuthenticationStateChanged(loggedIn: Bool) {
        if !loggedIn {
            delegate?.homeCoordinatorFinish()
        }
    }
}
