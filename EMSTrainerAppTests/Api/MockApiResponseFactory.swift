//
//  MockApiResponseFactory.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import Foundation
@testable import EMSTrainerApp
class MockApiResponseFactory {
    public static func create<T:Encodable>(of data: T) -> ApiResponse<T> {
        return ApiResponse(data: data)
    }
    
    public static func createError(of error: ApiErrorResponse.ApiError) -> ApiErrorResponse {
        return ApiErrorResponse(errors: [error])
    }
}
