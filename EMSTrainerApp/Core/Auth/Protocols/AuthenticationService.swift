//
//  AuthenticationService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation

protocol AuthenticationService {

    func loggedIn() -> Bool
    
    func login(email: String, password: String, withCompletion: @escaping (AppError?)-> Void)
    
    func register(name: String, email: String, password: String, passwordConfirmation: String, withCompletion completion:@escaping (AppError?)->Void)
    
    func logout()
}
