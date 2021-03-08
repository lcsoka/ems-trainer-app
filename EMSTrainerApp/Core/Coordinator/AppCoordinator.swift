//
//  AppCoordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import Swinject

enum AppChildCoordinator {
    case authentication
    case home
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    let container: Container
    private var auth: AuthenticationService!
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let navigationController: UINavigationController
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        auth = container.resolve(AuthenticationService.self)
        navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.backgroundColor = UIColor(named: "Gray800")
        navigationController.navigationBar.barTintColor = UIColor(named: "Gray800")
        navigationController.navigationBar.tintColor = UIColor(named: "Green500")
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        self.window.rootViewController = navigationController
    }
    
    func start() {
        if auth.loggedIn() {
            showHome()
            return
        }
        showAuthentication()
    }
    
    private func showAuthentication() {
        let authenticationCoordinator = AuthenticationCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.authentication] = authenticationCoordinator
        authenticationCoordinator.delegate = self
        authenticationCoordinator.start()
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.home] = homeCoordinator
        homeCoordinator.delegate = self
        homeCoordinator.start()
    }
    
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationCoordinatorFinish() {
        childCoordinators[.authentication] = nil
        showHome()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func homeCoordinatorFinish() {
        childCoordinators[.home] = nil
        showAuthentication()
    }
}

