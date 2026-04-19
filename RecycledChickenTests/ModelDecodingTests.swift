//
//  ModelDecodingTests.swift
//  RecycledChickenTests
//
//  Covers: AccountInfo, LoginResponse, SignUpInfo, ActivityCodeInfo, InviteCodeInfo,
//          ProfileNewInfo, LevelInfo, CarbonReductionLogInfo, PersonalRecycleAmountAndTargetInfo,
//          FixInfo, CommodityVoucherInfo, CouponsCategory, PointRecord, SpendPointInfo,
//          SpendPointResponse, SMSInfo, VerificationCodeType, RecycleLogInfo,
//          ApiResult, ApiStatus, UseRecordInfo, RecycleType, RecycleDetails
//

import XCTest
@testable import RecycledChicken

final class ModelDecodingTests: XCTestCase {

    // MARK: - AccountInfo

    func test_accountInfo_encodesAndDecodes() throws {
        let original = AccountInfo(userPhoneNumber: "0912345678", userPassword: "abc12345")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AccountInfo.self, from: data)
        XCTAssertEqual(decoded.userPhoneNumber, "0912345678")
        XCTAssertEqual(decoded.userPassword, "abc12345")
    }

    // MARK: - LoginResponse

    func test_loginResponse_decodesToken() throws {
        let json = """
        { "token": "eyJhbGciOiJIUzI1NiJ9.abc" }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(LoginResponse.self, from: json)
        XCTAssertEqual(response.token, "eyJhbGciOiJIUzI1NiJ9.abc")
    }

    // MARK: - SignUpInfo / ActivityCodeInfo / InviteCodeInfo

    func test_signUpInfo_encodesAndDecodes() throws {
        let info = SignUpInfo(userPhoneNumber: "0987654321", userPassword: "pass1234", smsCode: "123456")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(SignUpInfo.self, from: data)
        XCTAssertEqual(decoded.userPhoneNumber, "0987654321")
        XCTAssertEqual(decoded.smsCode, "123456")
    }

    func test_activityCodeInfo_encodesAndDecodes() throws {
        let info = ActivityCodeInfo(userID: "user001", activityCode: "ACT2024")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(ActivityCodeInfo.self, from: data)
        XCTAssertEqual(decoded.userID, "user001")
        XCTAssertEqual(decoded.activityCode, "ACT2024")
    }

    func test_inviteCodeInfo_encodesAndDecodes() throws {
        let info = InviteCodeInfo(userID: "user002", inviteCode: "INV999")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(InviteCodeInfo.self, from: data)
        XCTAssertEqual(decoded.inviteCode, "INV999")
    }

    // MARK: - ProfileNewInfo

    func test_profileNewInfo_decodesAllFields() throws {
        let json = """
        {
            "userEmail": "test@example.com",
            "userName": "林小明",
            "userPhoneNumber": "0912345678",
            "userBirth": "1990-01-01",
            "inviteCode": "INV001",
            "inputInviteCode": "INV002",
            "linkedToBuenoMart": true,
            "point": 500,
            "expirePoint": 100,
            "experiencePoint": 25000
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(ProfileNewInfo.self, from: json)
        XCTAssertEqual(info.userEmail, "test@example.com")
        XCTAssertEqual(info.userName, "林小明")
        XCTAssertEqual(info.userPhoneNumber, "0912345678")
        XCTAssertEqual(info.userBirth, "1990-01-01")
        XCTAssertEqual(info.inviteCode, "INV001")
        XCTAssertEqual(info.inputInviteCode, "INV002")
        XCTAssertEqual(info.linkedToBuenoMart, true)
        XCTAssertEqual(info.point, 500)
        XCTAssertEqual(info.expirePoint, 100)
        XCTAssertEqual(info.experiencePoint, 25000)
    }

    func test_profileNewInfo_emptyJSON_allNil() throws {
        let info = try JSONDecoder().decode(ProfileNewInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(info.userEmail)
        XCTAssertNil(info.point)
        XCTAssertNil(info.experiencePoint)
    }

    func test_profileNewInfo_decodesLevelInfo() throws {
        // 驗證 levelInfo 有被正確解碼（修正前此欄位永遠為 nil）
        let json = """
        {
            "userEmail": "test@example.com",
            "experiencePoint": 25000,
            "levelInfo": {
                "progress": 5,
                "chickenLevel": 3
            }
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(ProfileNewInfo.self, from: json)
        XCTAssertNotNil(info.levelInfo, "levelInfo 應該能被解碼，不應為 nil")
        XCTAssertEqual(info.levelInfo?.progress, 5)
        XCTAssertEqual(info.levelInfo?.chickenLevel, .three)
    }

    func test_profileNewInfo_missingLevelInfo_isNil() throws {
        let json = """
        { "userEmail": "test@example.com" }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(ProfileNewInfo.self, from: json)
        XCTAssertNil(info.levelInfo)
    }

    // MARK: - LevelInfo

    func test_levelInfo_encodesAndDecodes() throws {
        let info = LevelInfo(progress: 7, chickenLevel: .three)
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(LevelInfo.self, from: data)
        XCTAssertEqual(decoded.progress, 7)
        XCTAssertEqual(decoded.chickenLevel, .three)
    }

    // MARK: - CarbonReductionLogInfo

    func test_carbonReductionLogInfo_decodesNestedStructs() throws {
        let json = """
        {
            "personalRecycleAmountAndTarget": [
                {
                    "itemName": "寶特瓶",
                    "target": 100,
                    "totalRecycled": 45,
                    "conversionRate": 1.26,
                    "infoLink": "https://example.com"
                }
            ],
            "fix": {
                "images": ["img1.png", "img2.png"],
                "convetValue": 500
            }
        }
        """.data(using: .utf8)!

        let log = try JSONDecoder().decode(CarbonReductionLogInfo.self, from: json)
        XCTAssertEqual(log.personalRecycleAmountAndTarget?.count, 1)
        XCTAssertEqual(log.personalRecycleAmountAndTarget?.first?.itemName, "寶特瓶")
        XCTAssertEqual(log.personalRecycleAmountAndTarget?.first?.target, 100)
        XCTAssertEqual(log.personalRecycleAmountAndTarget?.first?.totalRecycled, 45)
        let conversionRate = try XCTUnwrap(log.personalRecycleAmountAndTarget?.first?.conversionRate)
        XCTAssertEqual(conversionRate, 1.26, accuracy: 0.001)
        XCTAssertEqual(log.fix?.images, ["img1.png", "img2.png"])
        XCTAssertEqual(log.fix?.convetValue, 500)
    }

    func test_carbonReductionLogInfo_emptyJSON_allNil() throws {
        let log = try JSONDecoder().decode(CarbonReductionLogInfo.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(log.personalRecycleAmountAndTarget)
        XCTAssertNil(log.fix)
    }

    // MARK: - CommodityVoucherInfo + CouponsCategory

    func test_commodityVoucherInfo_decodesAllFields() throws {
        let json = """
        {
            "total": 10,
            "ttl": 123456789,
            "name": "優惠券A",
            "points": 200,
            "category": "ticket",
            "isUnlocked": false,
            "remainingQuantity": 5
        }
        """.data(using: .utf8)!

        let voucher = try JSONDecoder().decode(CommodityVoucherInfo.self, from: json)
        XCTAssertEqual(voucher.total, 10)
        XCTAssertEqual(voucher.ttl, 123456789)
        XCTAssertEqual(voucher.name, "優惠券A")
        XCTAssertEqual(voucher.points, 200)
        XCTAssertEqual(voucher.category, .ticket)
        XCTAssertEqual(voucher.isUnlocked, false)
        XCTAssertEqual(voucher.remainingQuantity, 5)
    }

    func test_couponsCategory_allRawValues() {
        XCTAssertEqual(CouponsCategory.ticket.rawValue, "ticket")
        XCTAssertEqual(CouponsCategory.event.rawValue, "event")
        XCTAssertEqual(CouponsCategory.partner.rawValue, "partner")
    }

    func test_couponsCategory_unknownDecodesAsNil() throws {
        let json = """
        { "category": "unknown_type" }
        """.data(using: .utf8)!
        let voucher = try JSONDecoder().decode(CommodityVoucherInfo.self, from: json)
        XCTAssertNil(voucher.category)
    }

    // MARK: - PointRecord

    func test_pointRecord_decodesAllFields() throws {
        let json = """
        {
            "userID": "user123",
            "time": "2024-06-01",
            "reason": "回收電池",
            "point": 50
        }
        """.data(using: .utf8)!

        let record = try JSONDecoder().decode(PointRecord.self, from: json)
        XCTAssertEqual(record.userID, "user123")
        XCTAssertEqual(record.time, "2024-06-01")
        XCTAssertEqual(record.reason, "回收電池")
        XCTAssertEqual(record.point, 50)
    }

    func test_pointRecord_emptyJSON_allNil() throws {
        let record = try JSONDecoder().decode(PointRecord.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(record.userID)
        XCTAssertNil(record.point)
    }

    // MARK: - SpendPointInfo / SpendPointResponse

    func test_spendPointInfo_encodesAndDecodes() throws {
        let info = SpendPointInfo(name: "抽獎券", createTime: "2024-01-01", count: 3, totalPoint: "300")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(SpendPointInfo.self, from: data)
        XCTAssertEqual(decoded.name, "抽獎券")
        XCTAssertEqual(decoded.count, 3)
        XCTAssertEqual(decoded.totalPoint, "300")
    }

    func test_spendPointResponse_decodes() throws {
        let json = """
        { "reuslt": "success", "message": "購買成功", "callTime": "2024-01-01" }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(SpendPointResponse.self, from: json)
        XCTAssertEqual(response.reuslt, "success")
        XCTAssertEqual(response.message, "購買成功")
        XCTAssertEqual(response.callTime, "2024-01-01")
    }

    func test_spendPointResponse_emptyJSON_allNil() throws {
        let response = try JSONDecoder().decode(SpendPointResponse.self, from: "{}".data(using: .utf8)!)
        XCTAssertNil(response.reuslt)
        XCTAssertNil(response.message)
    }

    // MARK: - SMSInfo

    func test_smsInfo_encodesAndDecodes() throws {
        let info = SMSInfo(userPhoneNumber: "0912345678")
        let data = try JSONEncoder().encode(info)
        let decoded = try JSONDecoder().decode(SMSInfo.self, from: data)
        XCTAssertEqual(decoded.userPhoneNumber, "0912345678")
    }

    // MARK: - ApiResult / ApiStatus

    func test_apiResult_decodesSuccess() throws {
        let json = """
        { "status": "success", "message": "操作成功" }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(ApiResult.self, from: json)
        XCTAssertEqual(result.status, .success)
        XCTAssertEqual(result.message, "操作成功")
    }

    func test_apiResult_decodesFailure() throws {
        let json = """
        { "status": "failure", "message": "操作失敗" }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(ApiResult.self, from: json)
        XCTAssertEqual(result.status, .failure)
    }

    func test_apiStatus_rawValues() {
        XCTAssertEqual(ApiStatus.success.rawValue, "success")
        XCTAssertEqual(ApiStatus.failure.rawValue, "failure")
    }

    // MARK: - UseRecordInfo / RecycleType / RecycleDetails

    func test_useRecordInfo_decodesAllFields() throws {
        let json = """
        {
            "userPhoneNumber": "0912345678",
            "storeName": "台北站",
            "storeID": "store001",
            "time": "2024-06-01T10:00:00Z",
            "type": "battery",
            "recycleDetails": { "battery": 3, "bottle": 2 }
        }
        """.data(using: .utf8)!

        let record = try JSONDecoder().decode(UseRecordInfo.self, from: json)
        XCTAssertEqual(record.userPhoneNumber, "0912345678")
        XCTAssertEqual(record.storeName, "台北站")
        XCTAssertEqual(record.storeID, "store001")
        XCTAssertEqual(record.type, .battery)
        XCTAssertEqual(record.recycleDetails?.battery, 3)
        XCTAssertEqual(record.recycleDetails?.bottle, 2)
    }

    func test_recycleType_allRawValues() {
        XCTAssertEqual(RecycleType.battery.rawValue, "battery")
        XCTAssertEqual(RecycleType.bottle.rawValue, "bottle")
        XCTAssertEqual(RecycleType.coloredBottle.rawValue, "coloredBottle")
        XCTAssertEqual(RecycleType.colorlessBottle.rawValue, "colorlessBottle")
        XCTAssertEqual(RecycleType.can.rawValue, "can")
        XCTAssertEqual(RecycleType.cup.rawValue, "cup")
    }

    func test_recycleType_allCasesCountIsSix() {
        XCTAssertEqual(RecycleType.allCases.count, 6)
    }

    func test_recycleDetails_decodesAllFields() throws {
        let json = """
        {
            "battery": 1, "bottle": 2, "coloredBottle": 3,
            "colorlessBottle": 4, "can": 5, "cup": 6
        }
        """.data(using: .utf8)!

        let details = try JSONDecoder().decode(RecycleDetails.self, from: json)
        XCTAssertEqual(details.battery, 1)
        XCTAssertEqual(details.bottle, 2)
        XCTAssertEqual(details.coloredBottle, 3)
        XCTAssertEqual(details.colorlessBottle, 4)
        XCTAssertEqual(details.can, 5)
        XCTAssertEqual(details.cup, 6)
    }
}
