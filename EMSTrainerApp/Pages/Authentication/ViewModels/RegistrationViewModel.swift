//
//  RegistrationViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import Foundation

protocol RegistrationViewModelDelegate {
    func onSuccessfulRegistration()
    func onErrorRegistration(error: AppError)
}

class RegistrationViewModel: FormViewModel {

    // Properties
    var name = Dynamic<String>("")
    var email = Dynamic<String>("")
    var password = Dynamic<String>("")
    var passwordConfirmation = Dynamic<String>("")
    
    var brokenRules: [BrokenRule] = [BrokenRule]()

    var isValid: Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.validate()
            return brokenRules.isEmpty
        }
    }
    
    var delegate: RegistrationViewModelDelegate?
    
    // Rules
    private let minPasswordLength = 6
    
    private var auth: AuthenticationService!
    
    init(auth: AuthenticationService) {
        self.auth = auth
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func validate() {
        if name.value?.count == 0 {
            self.brokenRules.append(BrokenRule(propertyName: "name", message: "Name cannot be empty."))
        }
        
        if let emailAddress = email.value {
            if  !isValidEmail(emailAddress) {
                self.brokenRules.append(BrokenRule(propertyName: "email", message: "Email is not valid."))
            }
        }
        
        if (password.value?.count)! < 6 {
            self.brokenRules.append(BrokenRule(propertyName: "password", message: "The password cannot be shorter than \(minPasswordLength) characters."))
        }
        
        if password.value != passwordConfirmation.value {
            self.brokenRules.append(BrokenRule(propertyName: "passwordConfirmation", message: "Passwords must match."))
        }
        
    }
    
    func register() {
        auth.register(name: name.value!, email: email.value!, password: password.value!, passwordConfirmation: passwordConfirmation.value!) { result in
            if let error = result {
                self.delegate?.onErrorRegistration(error: error)
                return
            }
            self.delegate?.onSuccessfulRegistration()
        }
    }
}
