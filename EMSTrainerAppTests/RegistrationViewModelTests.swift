//
//  RegistrationViewModelTests.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import XCTest
@testable import EMSTrainerApp
class RegistrationViewModelTests: XCTestCase {

    private var mockUserService: UserService!
    private var mockTokenService: TokenService!
    private var mockNetworkEngine: NetworkEngineMock!
    private var api: ApiService!
    private var auth: AuthenticationService!
    
    private var mockSuccessResponse: ApiResponse<UserResponse>!
    private var mockErrorResponse: ApiErrorResponse!
    
    private var mockUser = User(id: 0, email: "mock@mock.com", name: "Mock User")
    private var mockToken = "mock_token_123"
    
    var viewModel: RegistrationViewModel!
    
    override func setUp() {
        mockUserService = MockUserService()
        mockTokenService = MockTokenService()
        mockNetworkEngine = NetworkEngineMock()
        api = Api(engine: mockNetworkEngine, tokenService: mockTokenService)
        auth = Auth(userService: mockUserService, tokenService: mockTokenService, api: api)
        
        mockSuccessResponse = MockApiResponseFactory.create(of: UserResponse(user: mockUser, accessToken: mockToken))
        mockErrorResponse = MockApiResponseFactory.createError(of: ApiErrorResponse.ApiError(errorCode: "MOCK_ERROR", errorMessage: "This is a mock error."))
        
        viewModel = RegistrationViewModel(auth: auth)
    }

    override func tearDown()  {
        viewModel = nil
        mockUserService = nil
        mockTokenService = nil
        mockNetworkEngine = nil
        api = nil
        auth = nil
        mockSuccessResponse = nil
        mockErrorResponse = nil
    }
    
    // MARK: Validations
    
    func testEmptyValidations() {
        viewModel.brokenRules = []
        viewModel.name.value = ""
        viewModel.email.value = ""
        viewModel.password.value = ""
        viewModel.passwordConfirmation.value = "a"
        
        viewModel.validate()
        
        let nameError = viewModel.brokenRules.filter({$0.propertyName=="name"})
        let emailError = viewModel.brokenRules.filter({$0.propertyName=="email"})
        let passwordError = viewModel.brokenRules.filter({$0.propertyName=="password"})
//        let passwordConfirmationError = viewModel.brokenRules.filter({$0.propertyName=="passwordConfirmation"})
        
        XCTAssertFalse(nameError.count == 0, "There should be an error for the name field.")
        XCTAssertFalse(emailError.count == 0, "There should be an error for the email field.")
        XCTAssertFalse(passwordError.count == 0, "There should be an error for the password field.")
//        XCTAssertFalse(passwordConfirmationError.count == 0, "There should be an error for the passwordConfirmation field.")
    }
    
    func testEmailFormatValidation() {
        let invalidEmails = ["a", "a@", "a@a", "a@a.", "a.hu", "a@a.h"]
        let validEmails = ["a@a.hu"]
        
        for email in invalidEmails {
            let v = RegistrationViewModel(auth: auth)
            v.email.value = email
            v.validate()
            let emailError = v.brokenRules.filter({$0.propertyName=="email"})
            XCTAssertFalse(emailError.count == 0, "Invalid email address.")
        }
        
        for email in validEmails {
            let v = RegistrationViewModel(auth: auth)
            v.email.value = email
            v.validate()
            let emailError = v.brokenRules.filter({$0.propertyName=="email"})
            XCTAssertTrue(emailError.count == 0, "Valid email address.")
        }
    }
    
    func testPasswordValidation() {
        let invalidPassword = ["","a","aa","aaa","aaaa","aaaaa","aaaaa"]
        let validPassword = ["aaaaaa"]
        
        for password in invalidPassword {
            let v = RegistrationViewModel(auth: auth)
            v.password.value = password
            v.validate()
            let passwordError = v.brokenRules.filter({$0.propertyName=="password"})
            XCTAssertFalse(passwordError.count == 0, "Password must be at least 6 characters long.")
        }
        
        for password in validPassword {
            let v = RegistrationViewModel(auth: auth)
            v.password.value = password
            v.validate()
            let passwordError = v.brokenRules.filter({$0.propertyName=="password"})
            XCTAssertTrue(passwordError.count == 0, "A 6 character long password should be OK")
        }
    }
    
    func testValidateConfirmationPassword() {
        viewModel.brokenRules = []
        viewModel.password.value = "test"
        viewModel.passwordConfirmation.value = "mock"
        viewModel.validate()
        
        let passwordConfirmationError = viewModel.brokenRules.filter({$0.propertyName=="passwordConfirmation"})
        XCTAssertFalse(passwordConfirmationError.count == 0, "The two password didn't match, it should throw error.")
    }
    
    func testIsValidFunctionWhenThereArentAnyError() {
        viewModel.brokenRules = []
        viewModel.name.value = "Mock"
        viewModel.email.value = "mock@user.com"
        viewModel.password.value = "mockmock"
        viewModel.passwordConfirmation.value = "mockmock"
        
        XCTAssertTrue(viewModel.isValid, "There is no validation error in the  model, the isValid function should return false.")
    }
    
    func testIsValidFunctionWhenThereIsAnError() {
        viewModel.brokenRules = []
        viewModel.brokenRules.append(BrokenRule(propertyName: "mock", message: "Mock error."))
        
        XCTAssertFalse(viewModel.isValid, "There is an error in the model, the isValid function should return true.")
    }
    
    // MARK: Registration function
    func testSuccessfulRegistration() {
        let spyDelegate = SpyRegistrationViewModelDelegate()
        viewModel.delegate = spyDelegate
        let registrationExpectation = expectation(description: "RegistrationViewModel calls the onSuccessfulRegistration function when the registration was successful.")
        spyDelegate.successfulRegistrationExpectation = registrationExpectation
        
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = try! JSONEncoder().encode(mockSuccessResponse)
        viewModel.register()
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(spyDelegate.didCallSuccessfulRegistration, "It should call the onSuccesssfulRegistration method.")
            XCTAssertFalse(spyDelegate.didCallErrorRegistration, "It shouldn't call the onErrorRegistration method.")
        }
    }
    
    func testUnsuccessfulRegistration() {
        let spyDelegate = SpyRegistrationViewModelDelegate()
        viewModel.delegate = spyDelegate
        let registrationExpectation = expectation(description: "RegistrationViewModel calls the onErrorRegistration function when the registration was unsuccessful.")
        spyDelegate.errorRegistrationExpectation = registrationExpectation
        
        mockNetworkEngine.statusCode = 400
        mockNetworkEngine.data = try! JSONEncoder().encode(mockErrorResponse)
        viewModel.register()
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(spyDelegate.didCallErrorRegistration, "It should call the didCallErrorRegistration method.")
            XCTAssertFalse(spyDelegate.didCallSuccessfulRegistration, "It shouldn't call the didCallSuccessfulRegistration method.")
        }
    }
}
