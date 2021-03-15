//
//  MainCoordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import UIKit
import Swinject

enum MainChildCoordinator {
    case dashboard
    case account
    case workouts
    case workoutSetup
}

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorFinish()
}

final class MainCoordinator: NavigationCoordinator {
    let container: Container
    var navigationController: UINavigationController
    var auth: AuthenticationService!
    var userService: UserService!
    weak var delegate: MainCoordinatorDelegate?
    private var childCoordinators = [MainChildCoordinator: Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.auth = container.resolve(AuthenticationService.self)
        self.userService = container.resolve(UserService.self)
    }
    
    func start() {
        let vc = container.resolve(DashboardViewController.self)!
        vc.authDelegate = self
        vc.delegate = self
        vc.auth = auth
        vc.navigationItem.hidesBackButton = true

        // Remove previous view controllers from the stack
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showAccount() {
        let vc = container.resolve(AccountViewController.self)!
        vc.userService = self.userService
//        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: true)
    }
    
    
    private func showWorkoutSetup() {
        let vc = container.resolve(WorkoutSetupViewController.self)!
        
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: AuthenticationDelegate {
    func onAuthenticationStateChanged(loggedIn: Bool) {
        if !loggedIn {
            delegate?.mainCoordinatorFinish()
        }
    }
}

extension MainCoordinator: DashboardViewControllerDelegate {
    func userDidRequestAccountPage() {
        showAccount()
    }
    
    func userDidRequestWorkoutSetupPage() {
        showWorkoutSetup()
    }
}
