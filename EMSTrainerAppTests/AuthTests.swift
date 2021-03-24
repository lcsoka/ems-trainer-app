//
//  AuthTests.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import XCTest
@testable import EMSTrainerApp

class AuthTests: XCTestCase {
    
    private var mockUserService: UserService!
    private var mockTokenService: TokenService!
    private var mockNetworkEngine: NetworkEngineMock!
    private var api: ApiService!
    private var auth: AuthenticationService!
    
    private var mockSuccessResponse: ApiResponse<UserResponse>!
    private var mockErrorResponse: ApiErrorResponse!
    
    private var mockUser = User(id: 0, email: "mock@mock.com", name: "Mock User")
    private var mockToken = "mock_token_123"
    
    override func setUp()  {
        mockUserService = MockUserService()
        mockTokenService = MockTokenService()
        mockNetworkEngine = NetworkEngineMock()
        api = Api(engine: mockNetworkEngine, tokenService: mockTokenService)
        auth = Auth(userService: mockUserService, tokenService: mockTokenService, api: api)
        
        mockSuccessResponse = MockApiResponseFactory.create(of: UserResponse(user: mockUser, accessToken: mockToken))
        mockErrorResponse = MockApiResponseFactory.createError(of: ApiErrorResponse.ApiError(errorCode: "MOCK_ERROR", errorMessage: "This is a mock error."))
        
    }

    override func tearDown()  {
        mockUserService = nil
        mockTokenService = nil
        mockNetworkEngine = nil
        api = nil
        auth = nil
    }
    
    // MARK: LoggedIn
    
    func testLoggedInWhenNoTokenAvailable() {
        mockTokenService.token = nil
        XCTAssertFalse(auth.loggedIn())
    }
    
    func testLoggedInWhenTokenAvailable() {
        mockTokenService.token = "token"
        XCTAssertTrue(auth.loggedIn())
    }
    
    // MARK: Login, Register with response handling
    
    func testUserResponseSaveOnSuccessfulLogin() {
        mockTokenService.token = nil
        mockUserService.currentUser = nil
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = try! JSONEncoder().encode(mockSuccessResponse)
        
        auth.login(email: "", password: "", withCompletion: { _ in
            
        })
        XCTAssertNotNil(mockTokenService.token, "The token should be set on successful login.")
        XCTAssertEqual(mockTokenService.token, mockSuccessResponse.data.accessToken, "The token should be the exact same as in the response.")
        XCTAssertNotNil(mockUserService.currentUser, "The user object should be set on successful login.")
        XCTAssertEqual(mockUserService.currentUser, mockSuccessResponse.data.user, "The user object should be the exact same as the response object.")
    }
    
    func testUserResponseSaveOnSuccessfulRegistration() {
        mockTokenService.token = nil
        mockUserService.currentUser = nil
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = try! JSONEncoder().encode(mockSuccessResponse)
        
        auth.register(name: "", email: "", password: "", passwordConfirmation: "", withCompletion: { _ in
            
        })
        XCTAssertNotNil(mockTokenService.token, "The token should be set on successful login.")
        XCTAssertEqual(mockTokenService.token, mockSuccessResponse.data.accessToken, "The token should be the exact same as in the response.")
        XCTAssertNotNil(mockUserService.currentUser, "The user object should be set on successful login.")
        XCTAssertEqual(mockUserService.currentUser, mockSuccessResponse.data.user, "The user object should be the exact same as the response object.")
    }
    
    // MARK: Logout
    func testLogoutShouldRemoveStoredData() {
        mockUserService.currentUser = mockUser
        mockTokenService.token = mockToken

        auth.logout()
        
        XCTAssertNil(mockTokenService.token,"The token should be empty after login.")
        XCTAssertNil(mockUserService.currentUser,"The user object should be empty after login.")
    }
    
}
