//
//  Auth.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

class Auth: AuthenticationService {
    
    private var userService: UserService?
    private var tokenService: TokenService?
    private var api: ApiService
    
    init(userService: UserService, tokenService: TokenService, api: ApiService) {
        self.userService = userService
        self.tokenService = tokenService
        self.api = api
    }
    
    private func processUserResponse(response: UserResponse) {
        userService?.currentUser = response.user
        tokenService?.token = response.accessToken
    }
    
    func login(email:String,password:String, withCompletion completion:@escaping (AppError?)->Void) {
        api.post(LoginResource(), data: LoginData(email: email, password: password), onSuccess: {
            self.processUserResponse(response: $0!)
            completion(nil)
        }){
            completion($0)
        }
    }
    
    func register(name: String, email: String, password: String, passwordConfirmation: String, withCompletion completion:@escaping (AppError?)->Void) {
        api.post(RegisterResource(), data: RegisterData(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation), onSuccess: {
            self.processUserResponse(response: $0!)
            completion(nil)
        }){
            completion($0)
        }
    }
    
    func logout() {
        api.get(LogoutResource(), params: nil,onSuccess: { _ in }){ _ in}
        tokenService?.token = nil
    }
}
