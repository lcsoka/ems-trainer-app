//
//  LoginViewModelTests.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import XCTest
@testable import EMSTrainerApp
class LoginViewModelTests: XCTestCase {
    
    private var mockUserService: UserService!
    private var mockTokenService: TokenService!
    private var mockNetworkEngine: NetworkEngineMock!
    private var api: ApiService!
    private var auth: AuthenticationService!
    
    private var mockSuccessResponse: ApiResponse<UserResponse>!
    private var mockErrorResponse: ApiErrorResponse!
    
    private var mockUser = User(id: 0, email: "mock@mock.com", name: "Mock User")
    private var mockToken = "mock_token_123"
    
    var viewModel: LoginViewModel!
    
    override func setUp() {
        mockUserService = MockUserService()
        mockTokenService = MockTokenService()
        mockNetworkEngine = NetworkEngineMock()
        api = Api(engine: mockNetworkEngine, tokenService: mockTokenService)
        auth = Auth(userService: mockUserService, tokenService: mockTokenService, api: api)
        
        mockSuccessResponse = MockApiResponseFactory.create(of: UserResponse(user: mockUser, accessToken: mockToken))
        mockErrorResponse = MockApiResponseFactory.createError(of: ApiErrorResponse.ApiError(errorCode: "MOCK_ERROR", errorMessage: "This is a mock error."))
        
        viewModel = LoginViewModel(auth: auth)
    }
    
    override func tearDown() {
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
    
    func testEmptyEmailValidation() {
        viewModel.brokenRules = []
        viewModel.email.value = ""
        viewModel.validate()
        
        let emailError = viewModel.brokenRules.filter({$0.propertyName=="email"})
        
        XCTAssertNotEqual(emailError.count, 0, "Email error shouldn't be empty")
    }
    
    func testEmptyPasswordValidation() {
        viewModel.brokenRules = []
        viewModel.password.value = ""
        viewModel.validate()
        
        let passwordError = viewModel.brokenRules.filter({$0.propertyName=="password"})
        
        XCTAssertNotEqual(passwordError.count, 0, "Password error shouldn't be empty")
    }
    
    func testIsValidFunctionWhenThereArentAnyError() {
        viewModel.brokenRules = []
        viewModel.email.value = "mock@user.com"
        viewModel.password.value = "mock"
        
        XCTAssertTrue(viewModel.isValid, "There is no validation error in the  model, the isValid function should return false.")
    }
    
    func testIsValidFunctionWhenThereIsAnError() {
        viewModel.brokenRules = []
        viewModel.brokenRules.append(BrokenRule(propertyName: "mock", message: "Mock error."))
        
        XCTAssertFalse(viewModel.isValid, "There is an error in the model, the isValid function should return true.")
    }
    
    // MARK: Login function
    func testSuccessfulLogin() {
        let spyDelegate = SpyLoginViewModelDelegate()
        viewModel.delegate = spyDelegate
        let loginExpectation = expectation(description:  "LoginViewModel calls the onSuccessfulLogin delegate function when the login was successful.")
        spyDelegate.successfulLoginExpectation = loginExpectation
        
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = try! JSONEncoder().encode(mockSuccessResponse)
        viewModel.login()
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertTrue(spyDelegate.didCallSuccessfulLogin, "It should call the onSuccessfulLogin method.")
            XCTAssertFalse(spyDelegate.didCallErrorLogin, "It shouldn't call the onErrorLogin method.")
        }
    }
    
    func testUnsuccessfulLogin() {
        
        let spyDelegate = SpyLoginViewModelDelegate()
        viewModel.delegate = spyDelegate
        let loginExpectation = expectation(description:  "LoginViewModel calls the onErrorLogin delegate function when the login was unsuccessful.")
        spyDelegate.errorLoginExpectation = loginExpectation
        
        mockNetworkEngine.statusCode = 400
        mockNetworkEngine.data = try! JSONEncoder().encode(mockErrorResponse)
        viewModel.login()
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertTrue(spyDelegate.didCallErrorLogin, "It should call the onErrorLogin method.")
            XCTAssertFalse(spyDelegate.didCallSuccessfulLogin, "It shouldn't call the onSuccessfulLogin method.")
        }
    }
}
