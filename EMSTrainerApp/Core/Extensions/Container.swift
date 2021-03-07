//
//  Container.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import Swinject

extension Container {
    @discardableResult
    func registerViewController<ViewController: StoryboardLodable>(_ controllerType: ViewController.Type, initCompleted: ((Swinject.Resolver, ViewController) -> Void)?  = nil) -> Swinject.ServiceEntry<ViewController> {
        return register(ViewController.self) { r in
            let storyboard = UIStoryboard(name: controllerType.storyboardName, bundle: nil)
            let name = "\(controllerType)".replacingOccurrences(of: "ViewController", with: "")
            let viewController = storyboard.instantiateViewController(withIdentifier: name) as! ViewController
            initCompleted?(r, viewController)
            return viewController
        }
    }
}
