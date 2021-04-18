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
    
    private func showWorkoutList() {
        let vc = container.resolve(WorkoutListViewController.self)!
        
        navigationController.pushViewController(vc, animated: true)     
    }
    
    private func showWorkoutSetup() {
        let vc = container.resolve(WorkoutSetupViewController.self)!
        vc.delegate = self
        vc.viewModel.delegate = vc
        vc.viewModel.finderViewModelDelegate = vc
        vc.viewModel.finder = MDNSFinder(api: api)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showWorkout(client: EMSClient, trainingMode: TrainingMode) {
        let vc = container.resolve(WorkoutViewController.self)!
        vc.delegate = self
        vc.viewModel.trainingMode = trainingMode
        vc.viewModel.client = client
        navigationController.navigationBar.backgroundColor = UIColor(named: "Gray700")
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
    
    func userDidRequestWorkoutListPage() {
        showWorkoutList()
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
    func userRequestWorkoutPage(device: DeviceHost, trainingMode: TrainingMode) {
        let vc = container.resolve(WorkoutSetupViewController.self)!
        let client = WebsocketClient(device)
        showWorkout(client: client, trainingMode: trainingMode)
    }
}

extension MainCoordinator: WorkoutViewControllerDelegate {
    func onShowDeviceFinder(from: WorkoutViewController) {
        let vc = container.resolve(DeviceFinderViewController.self)!
        vc.delegate = from
    
        let viewModel = FinderViewModel()
        viewModel.finder = MDNSFinder(api: api)
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .overFullScreen
        from.present(vc, animated: true, completion: nil)
    }
    
    func onReconnect(with: DeviceHost, from: WorkoutViewController) {
        let client = WebsocketClient(with)
        from.viewModel.client = client
    }
    
    func onShowChannelSettings(from: WorkoutViewController, channel: Int) {
        let vc = container.resolve(ChannelSettingsViewController.self)!
        vc.viewModel = from.viewModel
        vc.channelIndex = channel
        
        vc.modalPresentationStyle = .overFullScreen
        from.present(vc, animated: true, completion: nil)
    }
}
