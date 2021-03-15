//
//  Router.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import UIKit

class Router: NSObject, RouterProtocol {
    let navigationController: UINavigationController
    private var closures: [String:NavigationBackClosure] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    func push(_ presentable: Presentable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = presentable.viewController else {
            return
        }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.pushViewController(presentable.viewController!, animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description)  else { return }
        closure()
    }
    
    
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(previousController) else {
            return
        }
        executeClosure(previousController)
    }
}
