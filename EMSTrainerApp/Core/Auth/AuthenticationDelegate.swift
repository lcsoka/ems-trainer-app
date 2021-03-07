//
//  AuthenticationDelegate.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation

protocol AuthenticationDelegate: class {
    func onAuthenticationStateChanged(loggedIn: Bool)
}

