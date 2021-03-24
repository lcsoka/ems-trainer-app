//
//  LoginViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import Foundation

protocol LoginViewModelDelegate {
    func onSuccessfulLogin()
    func onErrorLogin(error: AppError)
}

class LoginViewModel: FormViewModel {
    var email = Dynamic<String>("")
    var password = Dynamic<String>("")
    
    var brokenRules: [BrokenRule] = [BrokenRule]()
    
    var isValid: Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.validate()
            return brokenRules.isEmpty
        }
    }

    var delegate: LoginViewModelDelegate?
    
    private var auth: AuthenticationService!
    
    init(auth: AuthenticationService) {
        self.auth = auth
    }
    
    func validate() {
        if email.value?.count == 0 {
            self.brokenRules.append(BrokenRule(propertyName: "email", message: "Email cannot be empty."))
        }
        
        if password.value?.count == 0 {
            self.brokenRules.append(BrokenRule(propertyName: "password", message: "Password cannot be empty."))
        }
    }
    
    func login() {
        auth.login(email: email.value!, password: password.value!) { result in
            if let error = result {
                self.delegate?.onErrorLogin(error: error)
                return
            }
            self.delegate?.onSuccessfulLogin()
        }
    }
    
}
