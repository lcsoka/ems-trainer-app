//
//  Coordinator.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import UIKit
import Swinject

protocol Coordinator {
    var container: Container { get }

    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}
