//
//  LoginViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func userDidRequestRegistration()
}

final class LoginViewController: UIViewController, AuthenticationStoryboardLodable {
    
    weak var authDelegate: AuthenticationDelegate?
    
    weak var delegate: LoginViewControllerDelegate?
    
    var viewModel: LoginViewModel! {
        didSet {
            viewModel.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        // Do any additional setup after loading the view.
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func onRegistrationButtonTap(_ sender: Any) {
        delegate?.userDidRequestRegistration()
    }
    
    @IBAction func onLoginTap(_ sender: Any) {
        if viewModel.isValid {
            viewModel.login()
        } else {
            let errorMessage = viewModel.brokenRules[0].message
            showErrorAlert(message: errorMessage)
        }
    }
    
}

extension LoginViewController: LoginViewModelDelegate {
    func onSuccessfulLogin() {
        self.authDelegate?.onAuthenticationStateChanged(loggedIn: true)
    }
    func onErrorLogin(error: AppError) {
        if let apiError = error.messages[0] as? ApiErrorResponse.ApiError {
            showErrorAlert(message: apiError.errorMessage)
        }
    }
}
