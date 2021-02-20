//
//  Auth.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

protocol AuthDelegate {
    func onLogout(_ force: Bool)
}

class Auth {
    static let shared = Auth()
    
    private var token: String?
    
    public var delegate: AuthDelegate?
    
    init() {
        if let savedToken = UserDefaults.standard.string(forKey: "Token") {
            token = savedToken
        }
    }
    
    private func setToken(_ token: String?) {
        self.token = token
        UserDefaults.standard.set(token, forKey: "Token")
    }
    
    private func processUserResponse(response: UserResponse) {
        UserService.shared.setUser(response.user)
        if let token = response.accessToken {
            self.setToken(token)
        }
    }
    
    func getToken() -> String? {
        return self.token
    }
    
    func login(email:String,password:String, withCompletion completion:@escaping (AppError?)->Void) {
        Api.shared.post(LoginResource(), data: LoginData(email: email, password: password), onSuccess: {
            self.processUserResponse(response: $0!)
            completion(nil)
        }){
            completion($0)
        }
    }
    
    func register(name: String, email: String, password: String, passwordConfirmation: String, withCompletion completion:@escaping (AppError?)->Void) {
        Api.shared.post(RegisterResource(), data: RegisterData(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation), onSuccess: {
            self.processUserResponse(response: $0!)
            completion(nil)
        }){
            completion($0)
        }
    }
    
    func logout() {
        Api.shared.get(LogoutResource(), params: nil,onSuccess: { _ in }){ _ in}
        self.onLogout()
    }
    
    func onLogout(_ force: Bool = false) {
        self.setToken(nil)
        UserService.shared.setUser(nil)
        self.delegate?.onLogout(force)
    }
}
