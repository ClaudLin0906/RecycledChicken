//
//  MyTickerModelTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class MyTickerModelTests: XCTestCase {

    // MARK: - MyTickertLotteryInfo

    func test_lotteryInfo_decodesAllFields() throws {
        let json = """
        {
            "activityStartTime": "2024-06-01",
            "activityEndTime": "2024-06-30",
            "lotteryDrawDate": "2024-07-01",
            "buyTime": "2024-06-15T10:00:00",
            "UUID": "abc-123-xyz",
            "userPhoneNumber": "0912345678",
            "itemName": "iPhone 15 Pro",
            "drawDate": "2024-07-01",
            "ttl": 1234567890
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(MyTickertLotteryInfo.self, from: json)
        XCTAssertEqual(info.activityStartTime, "2024-06-01")
        XCTAssertEqual(info.activityEndTime, "2024-06-30")
        XCTAssertEqual(info.lotteryDrawDate, "2024-07-01")
        XCTAssertEqual(info.buyTime, "2024-06-15T10:00:00")
        XCTAssertEqual(info.UUID, "abc-123-xyz")
        XCTAssertEqual(info.userPhoneNumber, "0912345678")
        XCTAssertEqual(info.itemName, "iPhone 15 Pro")
        XCTAssertEqual(info.drawDate, "2024-07-01")
        XCTAssertEqual(info.ttl, 1234567890)
    }

    func test_lotteryInfo_emptyJSON_allNil() throws {
        let info = try JSONDecoder().decode(MyTickertLotteryInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(info.UUID)
        XCTAssertNil(info.itemName)
        XCTAssertNil(info.ttl)
    }

    func test_lotteryInfo_partialFields() throws {
        let json = """
        {
            "itemName": "雞會來了！",
            "UUID": "uuid-001"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(MyTickertLotteryInfo.self, from: json)
        XCTAssertEqual(info.itemName, "雞會來了！")
        XCTAssertEqual(info.UUID, "uuid-001")
        XCTAssertNil(info.buyTime)
    }

    // MARK: - MyTickertCouponsInfo

    func test_couponsInfo_decodesAllFields() throws {
        let json = """
        {
            "name": "Avier 100元折價券",
            "code": "CODE123",
            "reward": "100元折扣",
            "pwd": "1234",
            "data": "extra_data",
            "instruction": "使用說明",
            "buyTime": "2024-06-15",
            "point": 10,
            "picture": "https://example.com/pic.png",
            "expire": "2024-12-31",
            "link": "https://example.com",
            "partner": "Avier"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(MyTickertCouponsInfo.self, from: json)
        XCTAssertEqual(info.name, "Avier 100元折價券")
        XCTAssertEqual(info.code, "CODE123")
        XCTAssertEqual(info.reward, "100元折扣")
        XCTAssertEqual(info.pwd, "1234")
        XCTAssertEqual(info.instruction, "使用說明")
        XCTAssertEqual(info.buyTime, "2024-06-15")
        XCTAssertEqual(info.point, 10)
        XCTAssertEqual(info.expire, "2024-12-31")
        XCTAssertEqual(info.link, "https://example.com")
        XCTAssertEqual(info.partner, "Avier")
    }

    func test_couponsInfo_emptyJSON_allNil() throws {
        let info = try JSONDecoder().decode(MyTickertCouponsInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(info.name)
        XCTAssertNil(info.code)
        XCTAssertNil(info.point)
    }

    func test_couponsInfo_negativePoint() throws {
        let json = """
        { "point": -50, "name": "退款券" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(MyTickertCouponsInfo.self, from: json)
        XCTAssertEqual(info.point, -50)
    }
}
