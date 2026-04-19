//
//  PersonMessageModelTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class PersonMessageModelTests: XCTestCase {

    // MARK: - isShowDeleteView is always false (hardcoded in init)

    func test_isShowDeleteView_alwaysFalse_whenJSONHasTrue() throws {
        let json = """
        {
            "title": "通知標題",
            "createTime": "2024-01-01",
            "message": "通知內容",
            "isShowDeleteView": true
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertFalse(info.isShowDeleteView,
            "isShowDeleteView should always be false regardless of JSON value")
    }

    func test_isShowDeleteView_alwaysFalse_whenJSONHasFalse() throws {
        let json = """
        { "isShowDeleteView": false }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertFalse(info.isShowDeleteView)
    }

    func test_isShowDeleteView_alwaysFalse_whenFieldMissing() throws {
        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertFalse(info.isShowDeleteView)
    }

    // MARK: - Other fields decode correctly

    func test_decodesTitle() throws {
        let json = """
        { "title": "系統公告" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertEqual(info.title, "系統公告")
    }

    func test_decodesCreateTime() throws {
        let json = """
        { "createTime": "2024-06-15T10:30:00Z" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertEqual(info.createTime, "2024-06-15T10:30:00Z")
    }

    func test_decodesMessage() throws {
        let json = """
        { "message": "您有新的活動可以參加！" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertEqual(info.message, "您有新的活動可以參加！")
    }

    func test_allFieldsNilWhenEmptyJSON() throws {
        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(info.title)
        XCTAssertNil(info.createTime)
        XCTAssertNil(info.message)
    }

    func test_decodesAllFields() throws {
        let json = """
        {
            "title": "標題",
            "createTime": "2024-03-01",
            "message": "內容"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(PersonMessageInfo.self, from: json)
        XCTAssertEqual(info.title, "標題")
        XCTAssertEqual(info.createTime, "2024-03-01")
        XCTAssertEqual(info.message, "內容")
        XCTAssertFalse(info.isShowDeleteView)
    }
}
