//
//  LotteryModelTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class LotteryModelTests: XCTestCase {

    // MARK: - LotteryInfo

    func test_lotteryInfo_decodesAllFields() throws {
        let json = """
        {
            "itemName": "iPhone 15 Pro",
            "createTime": "2024-06-01T10:00:00",
            "productImage": "https://example.com/img.png",
            "point": 50,
            "eventStartTime": "2024-06-01",
            "eventEndTime": "2024-06-30",
            "drawDate": "2024-07-01",
            "description": "大獎抽獎活動",
            "notes": "每人限購一張",
            "purchaserCount": 120,
            "isUnlocked": true,
            "url": "https://example.com",
            "order": 1
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(LotteryInfo.self, from: json)
        XCTAssertEqual(info.itemName, "iPhone 15 Pro")
        XCTAssertEqual(info.point, 50)
        XCTAssertEqual(info.purchaserCount, 120)
        XCTAssertEqual(info.isUnlocked, true)
        XCTAssertEqual(info.order, 1)
        XCTAssertEqual(info.url, "https://example.com")
    }

    func test_lotteryInfo_defaultCategory_isTicket() throws {
        let json = """
        { "itemName": "測試獎品" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(LotteryInfo.self, from: json)
        XCTAssertEqual(info.category, .ticket)
    }

    func test_lotteryInfo_emptyJSON_allOptionalNil() throws {
        let info = try JSONDecoder().decode(LotteryInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(info.itemName)
        XCTAssertNil(info.point)
        XCTAssertNil(info.isUnlocked)
    }

    func test_lotteryInfo_isUnlocked_false() throws {
        let json = """
        { "isUnlocked": false }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(LotteryInfo.self, from: json)
        XCTAssertEqual(info.isUnlocked, false)
    }

    // MARK: - CheckVerifyApiResult

    func test_checkVerifyApiResult_decodesAllFields() throws {
        let json = """
        {
            "status": "success",
            "message": "解鎖成功",
            "unlockedAt": "2024-06-15T12:00:00",
            "isUnlocked": true
        }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(CheckVerifyApiResult.self, from: json)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.message, "解鎖成功")
        XCTAssertEqual(result.unlockedAt, "2024-06-15T12:00:00")
        XCTAssertEqual(result.isUnlocked, true)
    }

    func test_checkVerifyApiResult_failureStatus() throws {
        let json = """
        { "status": "failure", "message": "驗證碼錯誤" }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(CheckVerifyApiResult.self, from: json)
        XCTAssertEqual(result.status, .failure)
        XCTAssertNil(result.isUnlocked)
    }

    func test_checkVerifyApiResult_unknownStatus_isNil() throws {
        let json = """
        { "status": "pending" }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(CheckVerifyApiResult.self, from: json)
        XCTAssertNil(result.status)
    }

    func test_checkVerifyApiResult_emptyJSON() throws {
        let result = try JSONDecoder().decode(CheckVerifyApiResult.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(result.status)
        XCTAssertNil(result.message)
    }

    // MARK: - CheckVerifyCode

    func test_checkVerifyCode_encodesAndDecodes() throws {
        let code = CheckVerifyCode(
            name: "iPhone 15 Pro",
            createTime: "2024-06-01",
            category: "ticket",
            unlockCode: "ABC123"
        )
        let data = try JSONEncoder().encode(code)
        let decoded = try JSONDecoder().decode(CheckVerifyCode.self, from: data)

        XCTAssertEqual(decoded.name, "iPhone 15 Pro")
        XCTAssertEqual(decoded.createTime, "2024-06-01")
        XCTAssertEqual(decoded.category, "ticket")
        XCTAssertEqual(decoded.unlockCode, "ABC123")
    }
}
