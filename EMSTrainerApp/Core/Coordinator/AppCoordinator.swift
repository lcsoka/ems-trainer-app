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
    case main
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    let container: Container
    private var auth: AuthenticationService!
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let navigationController: UINavigationController
//    private var router: RouterProtocol
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        auth = container.resolve(AuthenticationService.self)
        navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.backgroundColor = UIColor(named: "Gray800")
        navigationController.navigationBar.barTintColor = UIColor(named: "Gray800")
        navigationController.navigationBar.tintColor = UIColor(named: "Green500")
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        router = Router(navigationController: navigationController)
        self.window.rootViewController = navigationController
    }
    
    func start() {
        if auth.loggedIn() {
            showMain()
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
    
    private func showMain() {
        let mainCoordinator = MainCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.main] = mainCoordinator
        mainCoordinator.delegate = self
        mainCoordinator.start()
    }
    
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationCoordinatorFinish() {
        childCoordinators[.authentication] = nil
        showMain()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorFinish() {
        
        // Delete Core Data
        let trainingsProvider = container.resolve(TrainingsProvider.self)
        trainingsProvider?.deleteAll()
        
        childCoordinators[.main] = nil
        showAuthentication()
    }
}

