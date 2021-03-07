//
//  AppDelegate.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AuthDelegate {
    
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
        
        // Set Auth delegate to app delegate, to catch the logout event
        Auth.shared.delegate = self
        
        return true
    }
    
    func onLogout(_ force: Bool) {
        print("Logged out")
    }    
}


extension AppDelegate {
    func setupDependencies() {
        // services
        
        // viewmodels
        
        // view controllers
        container.registerViewController(LoginViewController.self) {r, c in
//            c.viewModel
        }
        
        container.registerViewController(RegistrationViewController.self) {r, c in
            
        }
        
    }
}
