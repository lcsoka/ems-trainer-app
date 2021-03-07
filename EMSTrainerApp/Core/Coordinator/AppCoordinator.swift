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
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let navigationController: UINavigationController
    
    
    // TODO: Services
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        // TODO: Load services from container
        
        navigationController = UINavigationController()
        
        
        self.window.rootViewController = navigationController
    }
    
    func start() {
        // TODO: Check auth data
        showAuthentication()
//        showHome()
    }
    
    private func showAuthentication() {
        let authenticationCoordinator = AuthenticationCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.authentication] = authenticationCoordinator
        // TODO: Delegation
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

