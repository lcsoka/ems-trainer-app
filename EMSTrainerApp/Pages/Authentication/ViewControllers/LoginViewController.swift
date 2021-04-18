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
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if spinner.superview == nil, let superView = view {
            superView.addSubview(spinner)
            superView.bringSubviewToFront(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /**
     Enters  busy UI.
     Ensures the buttons can't be pressed again when the app is busy.
     */
    private func enterBusyUI() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        spinner.startAnimating()
    }

    /**
     Exits busy UI.
     */
    private func exitBusyUI() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.spinner.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     }

     @objc func keyboardWillShow(notification: NSNotification) {
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             if self.view.frame.origin.y == 0 {
                 self.view.frame.origin.y -= keyboardSize.height / 3
             }
         }
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         if self.view.frame.origin.y != 0 {
             self.view.frame.origin.y = 0
         }
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
            enterBusyUI()
            viewModel.login()
        } else {
            exitBusyUI()
            let errorMessage = viewModel.brokenRules[0].message
            showErrorAlert(message: errorMessage)
        }
    }
    
}

extension LoginViewController: LoginViewModelDelegate {
    func onSuccessfulLogin() {
        exitBusyUI()
        self.authDelegate?.onAuthenticationStateChanged(loggedIn: true)
    }
    func onErrorLogin(error: AppError) {
        exitBusyUI()
        if let apiError = error.messages[0] as? ApiErrorResponse.ApiError {
            showErrorAlert(message: apiError.errorMessage)
            return
        }
        
        if let errorMessage = error.messages[0] as? String {
            showErrorAlert(message: errorMessage)
            return
        }
    }
}
