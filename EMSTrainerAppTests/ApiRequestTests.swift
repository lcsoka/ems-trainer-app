//
//  ApiRequestTests.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import XCTest
@testable import EMSTrainerApp

class ApiRequestTests: XCTestCase {
    
    var api: ApiService!
    var tokenService: TokenService!
    var mockNetworkEngine: NetworkEngineMock!
    var mockResource: MockApiResource!
    var mockData: MockRequest!
    var mockApiResponse: ApiResponse<MockResponse>!
    var mockApiErrorResponse: ApiErrorResponse!
    
    // MARK: - Set Up
    
    override func setUp() {
        mockNetworkEngine = NetworkEngineMock()
        tokenService = MockTokenService()
        api = Api(engine: mockNetworkEngine, tokenService: tokenService)
        mockResource = MockApiResource()
        mockData = MockRequest(data: "mock")
        mockApiResponse = MockApiResponseFactory.create(of: MockResponse(data: "mock"))
        mockApiErrorResponse = MockApiResponseFactory.createError(of: ApiErrorResponse.ApiError(errorCode: "MOCK_ERROR", errorMessage: "This is a mock error."))
    }
    
    // MARK: - Tear Down
    
    override func tearDown() {
        api = nil
        tokenService.token = nil
        mockNetworkEngine = nil
        mockResource = nil
        mockData = nil
        mockApiResponse = nil
        mockApiErrorResponse = nil
    }
    
    // MARK: - Handle responses and errors
    
    func testHandleEmptyApiResponse() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = nil
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .unknown)
    }
    
    
    func testHandleNotValidApiResponse() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = Data(base64Encoded: "mock")
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .decode)
    }
    
    func testSuccessfulApiResponse() throws {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 200
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNotNil(apiResponse,"Api response cannot be nil")
        XCTAssertNil(appError, "App error should be nil on successful api request.")
        let res = try XCTUnwrap(apiResponse)
        XCTAssertEqual(res.data, mockApiResponse.data.data)
    }
    
    func testHandle400Status() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 400
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .api)
    }
    
    func testHandle401Status() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 401
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .unauthorized)
    }
    
    func testHandle422Status() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 422
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .validation)
    }
    
    
    func testHandle500Status() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 500
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .server)
    }
    
    func testHandle5xxStatus() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 501
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .unknown)
    }
    
    func testHandleInvalidHTTPStatus() {
        var apiResponse: MockResponse?
        var appError: AppError?
        mockNetworkEngine.statusCode = 666
        mockNetworkEngine.data = try! JSONEncoder().encode(mockApiErrorResponse)
        
        api.post(mockResource, data: mockData, onSuccess: { response in
            apiResponse = response
        }, onError: { error in
            appError = error
        })
        
        XCTAssertNil(apiResponse, "Api response should be nil when decode was unsuccessful.")
        XCTAssertNotNil(appError, "App error cannot be nil.")
        XCTAssertEqual(appError!.code, .unknown)
    }
    
    // MARK: - Checking request data
    func testAuthenticationHeaderIfTokenIsNotAvailable() {
        tokenService.token = nil
        api.post(mockResource, data: mockData, onSuccess: { response in }, onError: { error in })
        
        XCTAssertNotNil(mockNetworkEngine.urlRequest, "Url request must be saved")
        XCTAssertNil(mockNetworkEngine.urlRequest.allHTTPHeaderFields!["Authorization"], "Shouldn't set authorization header when token is nil" )
    }
    
    func testAuthenticationHeaderIfTokenIsAvailable() {
        tokenService.token = "token"
        api.post(mockResource, data: mockData, onSuccess: { response in }, onError: { error in })
        
        XCTAssertNotNil(mockNetworkEngine.urlRequest, "Url request must be saved")
        XCTAssertEqual(mockNetworkEngine.urlRequest.allHTTPHeaderFields!["Authorization"], "Bearer token")
    }
    
    func testPostMethodShouldSendPOSTRequest() {
        api.post(mockResource, data: mockData, onSuccess: { response in }, onError: { error in })
        XCTAssertEqual(mockNetworkEngine.urlRequest.httpMethod, "POST")
    }
    
    func testGetMethodShouldSendGETRequest() {
        api.get(mockResource, params: nil, onSuccess: { response in }, onError: { error in })
        XCTAssertEqual(mockNetworkEngine.urlRequest.httpMethod, "GET")
    }
    
    
    
}
