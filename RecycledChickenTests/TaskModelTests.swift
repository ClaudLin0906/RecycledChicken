//
//  TaskModelTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class TaskModelTests: XCTestCase {

    // MARK: - TaskInfo decoding

    func test_taskInfo_decodesAllStringFields() throws {
        let json = """
        {
            "createTime": "2024-01-01",
            "startTime": "2024-01-02",
            "endTime": "2024-12-31",
            "title": "測試任務",
            "description": "任務說明",
            "iconUrl": "https://example.com/icon.png",
            "requiredAmount": 5,
            "url": "https://example.com",
            "ttl": 9999,
            "leftIcon": "icon_left",
            "type": "battery",
            "isFinish": true,
            "isSpecifiedLocation": true,
            "isReceive": true
        }
        """.data(using: .utf8)!

        let task = try JSONDecoder().decode(TaskInfo.self, from: json)

        XCTAssertEqual(task.createTime, "2024-01-01")
        XCTAssertEqual(task.startTime, "2024-01-02")
        XCTAssertEqual(task.endTime, "2024-12-31")
        XCTAssertEqual(task.title, "測試任務")
        XCTAssertEqual(task.description, "任務說明")
        XCTAssertEqual(task.iconUrl, "https://example.com/icon.png")
        XCTAssertEqual(task.requiredAmount, 5)
        XCTAssertEqual(task.url, "https://example.com")
        XCTAssertEqual(task.ttl, 9999)
        XCTAssertEqual(task.leftIcon, "icon_left")
        XCTAssertEqual(task.type, .battery)
    }

    func test_taskInfo_boolFieldsAlwaysFalse_regardlessOfJSON() throws {
        // The custom init hardcodes isFinish/isSpecifiedLocation/isReceive to false
        let json = """
        { "isFinish": true, "isSpecifiedLocation": true, "isReceive": true }
        """.data(using: .utf8)!

        let task = try JSONDecoder().decode(TaskInfo.self, from: json)

        XCTAssertFalse(task.isFinish)
        XCTAssertFalse(task.isSpecifiedLocation)
        XCTAssertFalse(task.isReceive)
    }

    func test_taskInfo_emptyJSON_hasNilOptionals() throws {
        let task = try JSONDecoder().decode(TaskInfo.self, from: "{}".data(using: .utf8)!)

        XCTAssertNil(task.title)
        XCTAssertNil(task.type)
        XCTAssertNil(task.reward)
        XCTAssertNil(task.sites)
    }

    func test_taskInfo_decodesReward() throws {
        let json = """
        {
            "reward": {
                "type": "point",
                "amount": 100
            }
        }
        """.data(using: .utf8)!

        let task = try JSONDecoder().decode(TaskInfo.self, from: json)
        XCTAssertEqual(task.reward?.type, .point)
        XCTAssertEqual(task.reward?.amount, 100)
    }

    func test_taskInfo_decodesSitesArray() throws {
        let json = """
        { "sites": ["siteA", "siteB", "siteC"] }
        """.data(using: .utf8)!

        let task = try JSONDecoder().decode(TaskInfo.self, from: json)
        XCTAssertEqual(task.sites, ["siteA", "siteB", "siteC"])
    }

    // MARK: - TaskType enum

    func test_taskType_allRawValues() {
        XCTAssertEqual(TaskType.share.rawValue, "share")
        XCTAssertEqual(TaskType.advertise.rawValue, "advertise")
        XCTAssertEqual(TaskType.battery.rawValue, "battery")
        XCTAssertEqual(TaskType.bottle.rawValue, "bottle")
        XCTAssertEqual(TaskType.can.rawValue, "can")
        XCTAssertEqual(TaskType.cup.rawValue, "cup")
    }

    func test_taskType_decodesFromJSON() throws {
        let types: [(String, TaskType)] = [
            ("share", .share), ("advertise", .advertise),
            ("battery", .battery), ("bottle", .bottle),
            ("can", .can), ("cup", .cup),
        ]
        for (rawValue, expected) in types {
            let json = "{\"type\": \"\(rawValue)\"}".data(using: .utf8)!
            struct Wrapper: Decodable { let type: TaskType }
            let w = try JSONDecoder().decode(Wrapper.self, from: json)
            XCTAssertEqual(w.type, expected)
        }
    }

    // MARK: - TaskReward decoding

    func test_taskReward_decodesAllFields() throws {
        let json = """
        {
            "type": "coupons",
            "amount": 50,
            "rewardTime": "2024-06-01",
            "remainingQuantity": 10,
            "description": "折扣券",
            "name": "優惠券",
            "category": "ticket"
        }
        """.data(using: .utf8)!

        let reward = try JSONDecoder().decode(TaskReward.self, from: json)

        XCTAssertEqual(reward.type, .coupons)
        XCTAssertEqual(reward.amount, 50)
        XCTAssertEqual(reward.rewardTime, "2024-06-01")
        XCTAssertEqual(reward.remainingQuantity, 10)
        XCTAssertEqual(reward.description, "折扣券")
        XCTAssertEqual(reward.name, "優惠券")
        XCTAssertEqual(reward.category, "ticket")
    }

    func test_taskReward_emptyObject_allNil() throws {
        let reward = try JSONDecoder().decode(TaskReward.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(reward.type)
        XCTAssertNil(reward.amount)
        XCTAssertNil(reward.name)
    }

    // MARK: - TaskRewardType enum

    func test_taskRewardType_rawValues() {
        XCTAssertEqual(TaskRewardType.point.rawValue, "point")
        XCTAssertEqual(TaskRewardType.coupons.rawValue, "coupons")
        XCTAssertEqual(TaskRewardType.lottery.rawValue, "lottery")
    }

    // MARK: - TaskStatus enum

    func test_taskStatus_rawValues() {
        XCTAssertEqual(TaskStatus.success.rawValue, "success")
        XCTAssertEqual(TaskStatus.failure.rawValue, "failure")
    }

    // MARK: - TaskResponseStatus decoding

    func test_taskResponseStatus_success() throws {
        let json = """
        { "status": "success", "message": "完成" }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(TaskResponseStatus.self, from: json)
        XCTAssertEqual(response.status, .success)
        XCTAssertEqual(response.message, "完成")
    }

    func test_taskResponseStatus_failure() throws {
        let json = """
        { "status": "failure", "message": "失敗" }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(TaskResponseStatus.self, from: json)
        XCTAssertEqual(response.status, .failure)
    }

    func test_taskResponseStatus_unknownStatus_isNil() throws {
        let json = """
        { "status": "unknown" }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(TaskResponseStatus.self, from: json)
        XCTAssertNil(response.status)
    }

    // MARK: - ActiveTime decoding

    func test_activeTime_decodes() throws {
        let json = """
        { "startTime": "2024-01-01", "endTime": "2024-12-31" }
        """.data(using: .utf8)!

        let activeTime = try JSONDecoder().decode(ActiveTime.self, from: json)
        XCTAssertEqual(activeTime.startTime, "2024-01-01")
        XCTAssertEqual(activeTime.endTime, "2024-12-31")
    }

    func test_activeTime_emptyObject_allNil() throws {
        let activeTime = try JSONDecoder().decode(ActiveTime.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(activeTime.startTime)
        XCTAssertNil(activeTime.endTime)
    }

    // MARK: - TaskStatusRequest encoding

    func test_taskStatusRequest_encodes() throws {
        let request = TaskStatusRequest(createTime: "2024-06-15")
        let data = try JSONEncoder().encode(request)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertEqual(dict?["createTime"] as? String, "2024-06-15")
    }

    // MARK: - FinishTaskInfo encoding

    func test_finishTaskInfo_encodes() throws {
        let info = FinishTaskInfo(createTime: "2024-01-01", type: "battery")
        let data = try JSONEncoder().encode(info)
        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertEqual(dict?["createTime"] as? String, "2024-01-01")
        XCTAssertEqual(dict?["type"] as? String, "battery")
    }
}
