//
//  NetworkErrorTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class NetworkErrorTests: XCTestCase {

    // MARK: - errorDescription

    func test_invalidURL_description() {
        XCTAssertEqual(NetworkError.invalidURL.errorDescription, "Invalid URL")
    }

    func test_invalidResponse_description() {
        XCTAssertEqual(NetworkError.invalidResponse.errorDescription, "Invalid response")
    }

    func test_noData_description() {
        XCTAssertEqual(NetworkError.noData.errorDescription, "No data received")
    }

    func test_httpError_withMessage_usesMessage() {
        let error = NetworkError.httpError(statusCode: 404, message: "Not Found")
        XCTAssertEqual(error.errorDescription, "Not Found")
    }

    func test_httpError_withNilMessage_usesStatusCode() {
        let error = NetworkError.httpError(statusCode: 500, message: nil)
        XCTAssertEqual(error.errorDescription, "HTTP Error: 500")
    }

    func test_httpError_401_withMessage() {
        let error = NetworkError.httpError(statusCode: 401, message: "Unauthorized")
        XCTAssertEqual(error.errorDescription, "Unauthorized")
    }

    func test_decodingError_prefixedWithDecodingError() {
        let underlying = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "bad format"])
        let error = NetworkError.decodingError(underlying)
        XCTAssertTrue(error.errorDescription?.hasPrefix("Decoding error:") == true)
        XCTAssertTrue(error.errorDescription?.contains("bad format") == true)
    }

    func test_encodingError_prefixedWithEncodingError() {
        let underlying = NSError(domain: "TestDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "cannot encode"])
        let error = NetworkError.encodingError(underlying)
        XCTAssertTrue(error.errorDescription?.hasPrefix("Encoding error:") == true)
        XCTAssertTrue(error.errorDescription?.contains("cannot encode") == true)
    }

    func test_unknown_withError_usesUnderlyingDescription() {
        let underlying = NSError(domain: "Test", code: 99, userInfo: [NSLocalizedDescriptionKey: "something went wrong"])
        let error = NetworkError.unknown(underlying)
        XCTAssertEqual(error.errorDescription, "something went wrong")
    }

    func test_unknown_withNilError_returnsUnknownError() {
        let error = NetworkError.unknown(nil)
        XCTAssertEqual(error.errorDescription, "Unknown error")
    }

    // MARK: - LocalizedError conformance

    func test_networkError_conformsToLocalizedError() {
        let error: Error = NetworkError.invalidURL
        XCTAssertEqual(error.localizedDescription, "Invalid URL")
    }

    // MARK: - All cases have non-nil description

    func test_allCases_haveNonNilDescription() {
        let sampleError = NSError(domain: "T", code: 0)
        let cases: [NetworkError] = [
            .invalidURL,
            .invalidResponse,
            .noData,
            .httpError(statusCode: 400, message: "Bad Request"),
            .httpError(statusCode: 500, message: nil),
            .decodingError(sampleError),
            .encodingError(sampleError),
            .unknown(sampleError),
            .unknown(nil),
        ]
        for error in cases {
            XCTAssertNotNil(error.errorDescription, "\(error) should have a non-nil errorDescription")
        }
    }
}
