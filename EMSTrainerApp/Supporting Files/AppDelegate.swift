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
        container.register(ApiService.self) { r in
            let api = Api(engine: URLSession(configuration: .default, delegate: nil, delegateQueue: .main), tokenService: r.resolve(TokenService.self)!)
            return api
        }.inObjectScope(ObjectScope.container)
        container.autoregister(AuthenticationService.self, initializer: Auth.init).inObjectScope(ObjectScope.container)
    
        // viewmodels
        
        // view controllers
        container.registerViewController(LoginViewController.self) {r, c in
//            c.viewModel
        }
        
        container.registerViewController(RegistrationViewController.self) {r, c in
            
        }
        
        container.registerViewController(DashboardViewController.self) {r, c in
            
        }
        
    }
}
