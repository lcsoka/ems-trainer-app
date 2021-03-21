//
//  RegistrationViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

class RegistrationViewController: UIViewController, AuthenticationStoryboardLodable {

    weak var authDelegate: AuthenticationDelegate?
    var viewModel: RegistrationViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    @IBOutlet var nameInput: BorderTextField! {
        didSet {
            nameInput.bind { self.viewModel.name.value = $0 }
        }
    }
    @IBOutlet var emailInput: BorderTextField! {
        didSet {
            emailInput.bind { self.viewModel.email.value = $0 }
        }
    }
    @IBOutlet var passwordInput: BorderTextField! {
        didSet {
            passwordInput.bind { self.viewModel.password.value = $0 }
        }
    }
    @IBOutlet var passwordConfirmationInput: BorderTextField! {
        didSet {
            passwordConfirmationInput.bind { self.viewModel.passwordConfirmation.value = $0 }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.title = "Sign up"
        // Do any additional setup after loading the view.
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func onSignUpTap(_ sender: Any) {
        if viewModel.isValid {
            // TODO: Show loader
            viewModel.register()
        } else {
            let errorMessage = viewModel.brokenRules[0].message
            showErrorAlert(message: errorMessage)
        }
    }
    
    @IBAction func onTestRegTap(_ sender: Any) {
        authDelegate?.onAuthenticationStateChanged(loggedIn: true)
    }


}

extension RegistrationViewController: RegistrationViewModelDelegate {
    func onSuccessfulRegistration() {
        authDelegate?.onAuthenticationStateChanged(loggedIn: true)
    }
    
    func onErrorRegistration(error: AppError) {
        if let apiError = error.messages[0] as? ApiErrorResponse.ApiError {
            showErrorAlert(message: apiError.errorMessage)
        }
    }
}
