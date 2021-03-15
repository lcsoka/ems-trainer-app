//
//  AuthenticationCoordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import Swinject
import UIKit

enum AuthenticationChildCoordinator {
    case login
    case register
}

protocol AuthenticationCoordinatorDelegate: class {
    func authenticationCoordinatorFinish()
}

final class AuthenticationCoordinator: NavigationCoordinator {
    
    let container: Container
    var navigationController: UINavigationController
    weak var delegate: AuthenticationCoordinatorDelegate?
    private var childCoordinators = [AuthenticationChildCoordinator: Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        print("Before \(navigationController.viewControllers)")
        
        let isNavigationStackEmpty = navigationController.viewControllers.isEmpty
        let vc = container.resolve(LoginViewController.self)!
        vc.auth = container.resolve(AuthenticationService.self)!
        vc.delegate = self
        vc.authDelegate = self
        vc.navigationItem.hidesBackButton = true
//        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(vc, animated: true)
        
        if !isNavigationStackEmpty {
            let removed = navigationController.viewControllers.remove(at: 0)
        }
        print("After \(navigationController.viewControllers)")
    }
    
    private func showLoginScreen() {
        
    }
    
    private func showRegistrationScreen() {
        let vc = container.resolve(RegistrationViewController.self)!
        vc.authDelegate = self
//        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(vc, animated: true)
        print(navigationController.viewControllers)
    }
}

extension AuthenticationCoordinator: LoginViewControllerDelegate {
    func userDidRequestRegistration() {
        showRegistrationScreen()
    }
}


extension AuthenticationCoordinator: AuthenticationDelegate {
    func onAuthenticationStateChanged(loggedIn: Bool) {
        if loggedIn {
            delegate?.authenticationCoordinatorFinish()
        }
    }
}
