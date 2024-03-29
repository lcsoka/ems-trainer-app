//
//  AppDelegate.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import UIKit
import Swinject
import SwinjectAutoregistration

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    internal let container = Container()
    
    private var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupDependencies()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(NSHomeDirectory())
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window!, container: container)
        appCoordinator.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}


extension AppDelegate {
    func setupDependencies() {
        // services
        container.autoregister(UserService.self, initializer: UserDefaultsUserService.init).inObjectScope(ObjectScope.container)
        container.autoregister(TokenService.self, initializer: UserDefaultsTokenService.init).inObjectScope(ObjectScope.container)
        container.autoregister(AchievementsService.self, initializer: UserDefaultsAchievementsService.init).inObjectScope(ObjectScope.container)
        
        container.register(DeviceApi.self) { r in
            let api = DeviceApi(engine: URLSession(configuration: .default, delegate: nil, delegateQueue: .main))
            return api
        }.inObjectScope(ObjectScope.container)
        
        container.register(ApiService.self) { r in
            let api = Api(engine: URLSession(configuration: .default, delegate: nil, delegateQueue: .main), tokenService: r.resolve(TokenService.self)!)
            return api
        }
        container.autoregister(AuthenticationService.self, initializer: Auth.init).inObjectScope(ObjectScope.container)
        
        container.register(TrainingsProvider.self) { r in
            let provider = TrainingsProvider()
            return provider
        }.inObjectScope(ObjectScope.container)
    
        // viewmodels
        container.autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
        container.autoregister(RegistrationViewModel.self, initializer: RegistrationViewModel.init)
        container.autoregister(DashboardViewModel.self, initializer: DashboardViewModel.init)
        container.autoregister(WorkoutListViewModel.self, initializer: WorkoutListViewModel.init)
        container.autoregister(WorkoutSetupViewModel.self, initializer: WorkoutSetupViewModel.init)
        container.autoregister(WorkoutViewModel.self, initializer: WorkoutViewModel.init)
        container.autoregister(WorkoutDetailsViewModel.self, initializer: WorkoutDetailsViewModel.init)
        
        // view controllers
        container.registerViewController(LoginViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(RegistrationViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(DashboardViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(AccountViewController.self) {r, c in
            
        }

        container.registerViewController(WorkoutListViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(WorkoutSetupViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(WorkoutViewController.self) {r, c in
            c.viewModel = r~>
        }
        
        container.registerViewController(DeviceFinderViewController.self) {r, c in
            
        }
        
        container.registerViewController(ChannelSettingsViewController.self) {r, c in
            
        }
        
        container.registerViewController(WorkoutDetailsViewController.self) {r,c in
            c.viewModel = r~>
        }
        
    }
}
