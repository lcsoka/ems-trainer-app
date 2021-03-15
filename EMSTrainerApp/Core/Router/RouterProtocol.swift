//
//  RouterProtocol.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import Foundation

typealias NavigationBackClosure = (()->())

protocol RouterProtocol: class {
    func push(_ presentable: Presentable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
}
