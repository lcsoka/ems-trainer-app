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
    case workout
}

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorFinish()
}

final class MainCoordinator: NavigationCoordinator {
    let container: Container
    var navigationController: UINavigationController
    var api: ApiService!
    var auth: AuthenticationService!
    var userService: UserService!
    weak var delegate: MainCoordinatorDelegate?
    private var childCoordinators = [MainChildCoordinator: Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.api =  container.resolve(DeviceApi.self)
        self.auth = container.resolve(AuthenticationService.self)
        self.userService = container.resolve(UserService.self)
    }
    
    func start() {
        let vc = container.resolve(DashboardViewController.self)!
        vc.authDelegate = self
        vc.delegate = self
        vc.navigationItem.hidesBackButton = true

        // Remove previous view controllers from the stack
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showAccount() {
        let vc = container.resolve(AccountViewController.self)!
        vc.delegate = self
        vc.userService = self.userService
        vc.auth = auth
//        vc.modalPresentationStyle = .overCurrentContext
        navigationController.present(vc, animated: true)
    }
    
    
    private func showWorkoutSetup() {
        let vc = container.resolve(WorkoutSetupViewController.self)!
        vc.delegate = self
        let mdnsFinder = MDNSFinder(api: api)
        vc.finder = mdnsFinder
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showWorkout(client: EMSClient) {
        let vc = container.resolve(WorkoutViewController.self)!
        vc.client = client
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
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

extension MainCoordinator: AccountViewControllerDelegate {
    func userDidLogout() {
        delegate?.mainCoordinatorFinish()
    }
}

extension MainCoordinator: WorkoutSetupViewControllerDelegate {
    func userRequestWorkoutPage(client: EMSClient) {
     showWorkout(client: client)
    }
}
