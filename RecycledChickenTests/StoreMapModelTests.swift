//
//  StoreMapModelTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

// MARK: - Test-only convenience initializers

extension MapInfo {
    static func make(
        name: String? = nil,
        machineStatus: MachineStatus? = nil,
        machineRemaining: MachineRemaining? = nil,
        machineLocation: MachineLocation? = nil,
        address: String? = nil,
        description: String? = nil
    ) -> MapInfo {
        var info = try! JSONDecoder().decode(MapInfo.self, from: "{}".data(using: .utf8)!)
        info.name = name
        info.machineStatus = machineStatus
        info.machineRemaining = machineRemaining
        info.machineLocation = machineLocation
        info.address = address
        info.description = description
        return info
    }
}

extension MachineRemaining {
    static func make(
        battery: Int? = nil,
        bottle: Int? = nil,
        coloredBottle: Int? = nil,
        colorlessBottle: Int? = nil,
        can: Int? = nil,
        cup: Int? = nil,
        hdpeBottle: Int? = nil,
        foilPack: Int? = nil,
        cartonBox: Int? = nil
    ) -> MachineRemaining {
        var r = try! JSONDecoder().decode(MachineRemaining.self, from: "{}".data(using: .utf8)!)
        r.battery = battery
        r.bottle = bottle
        r.coloredBottle = coloredBottle
        r.colorlessBottle = colorlessBottle
        r.can = can
        r.cup = cup
        r.hdpeBottle = hdpeBottle
        r.foilPack = foilPack
        r.cartonBox = cartonBox
        return r
    }
}

// MARK: - Tests

final class StoreMapModelTests: XCTestCase {

    // MARK: - MapInfo JSON Decoding

    func test_mapInfo_decodesAllFields() throws {
        let json = """
        {
            "name": "台北站",
            "remaining": { "battery": 3, "bottle": 5, "can": 2, "cup": 0 },
            "status": "可投",
            "location": { "latitude": "25.047924", "longitude": "121.517082" },
            "address": "台北市中正區",
            "description": "特殊任務說明"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(MapInfo.self, from: json)

        XCTAssertEqual(info.name, "台北站")
        XCTAssertEqual(info.machineStatus, .submit)
        XCTAssertEqual(info.address, "台北市中正區")
        XCTAssertEqual(info.description, "特殊任務說明")
        XCTAssertEqual(info.machineLocation?.latitude, "25.047924")
        XCTAssertEqual(info.machineLocation?.longitude, "121.517082")
        XCTAssertEqual(info.machineRemaining?.battery, 3)
        XCTAssertEqual(info.machineRemaining?.bottle, 5)
        XCTAssertEqual(info.machineRemaining?.can, 2)
        XCTAssertEqual(info.machineRemaining?.cup, 0)
    }

    func test_mapInfo_decodesMachineStatus_full() throws {
        let info = try decodeMapInfoWithStatus("滿位")
        XCTAssertEqual(info.machineStatus, .full)
    }

    func test_mapInfo_decodesMachineStatus_submit() throws {
        let info = try decodeMapInfoWithStatus("可投")
        XCTAssertEqual(info.machineStatus, .submit)
    }

    func test_mapInfo_decodesMachineStatus_underMaintenance() throws {
        let info = try decodeMapInfoWithStatus("維護")
        XCTAssertEqual(info.machineStatus, .underMaintenance)
    }

    func test_mapInfo_unknownStatusDecodesAsNil() throws {
        let info = try decodeMapInfoWithStatus("未知狀態")
        XCTAssertNil(info.machineStatus)
    }

    func test_mapInfo_handlesEmptyObject() throws {
        let json = "{}".data(using: .utf8)!
        let info = try JSONDecoder().decode(MapInfo.self, from: json)

        XCTAssertNil(info.name)
        XCTAssertNil(info.machineStatus)
        XCTAssertNil(info.machineRemaining)
        XCTAssertNil(info.machineLocation)
        XCTAssertNil(info.address)
        XCTAssertNil(info.description)
    }

    // MARK: - MachineRemaining JSON Decoding

    func test_machineRemaining_decodesAllFields() throws {
        let json = """
        {
            "battery": 10, "bottle": 20, "coloredBottle": 5,
            "colorlessBottle": 3, "can": 8, "cup": 1
        }
        """.data(using: .utf8)!

        let remaining = try JSONDecoder().decode(MachineRemaining.self, from: json)

        XCTAssertEqual(remaining.battery, 10)
        XCTAssertEqual(remaining.bottle, 20)
        XCTAssertEqual(remaining.coloredBottle, 5)
        XCTAssertEqual(remaining.colorlessBottle, 3)
        XCTAssertEqual(remaining.can, 8)
        XCTAssertEqual(remaining.cup, 1)
    }

    func test_machineRemaining_handlesPartialFields() throws {
        let json = """
        { "battery": 5 }
        """.data(using: .utf8)!
        let remaining = try JSONDecoder().decode(MachineRemaining.self, from: json)

        XCTAssertEqual(remaining.battery, 5)
        XCTAssertNil(remaining.bottle)
        XCTAssertNil(remaining.coloredBottle)
        XCTAssertNil(remaining.colorlessBottle)
        XCTAssertNil(remaining.can)
        XCTAssertNil(remaining.cup)
    }

    func test_machineRemaining_handlesEmptyObject() throws {
        let json = "{}".data(using: .utf8)!
        let remaining = try JSONDecoder().decode(MachineRemaining.self, from: json)
        XCTAssertNil(remaining.battery)
        XCTAssertNil(remaining.bottle)
        XCTAssertNil(remaining.can)
        XCTAssertNil(remaining.cup)
    }

    // MARK: - MachineLocation

    func test_machineLocation_decodesValidCoordinates() throws {
        let json = """
        { "latitude": "25.047924", "longitude": "121.517082" }
        """.data(using: .utf8)!

        let location = try JSONDecoder().decode(MachineLocation.self, from: json)

        XCTAssertEqual(location.latitude, "25.047924")
        XCTAssertEqual(location.longitude, "121.517082")
        XCTAssertNotNil(Double(location.latitude!))
        XCTAssertNotNil(Double(location.longitude!))
    }

    func test_machineLocation_nonNumericStringFailsDoubleConversion() throws {
        let json = """
        { "latitude": "not_a_number", "longitude": "also_not" }
        """.data(using: .utf8)!

        let location = try JSONDecoder().decode(MachineLocation.self, from: json)

        XCTAssertNil(Double(location.latitude ?? ""))
        XCTAssertNil(Double(location.longitude ?? ""))
    }

    // MARK: - machineStatus business rule (mirrors viewWillAppear logic)

    func test_statusRule_setToSubmit_whenStatusNilButHasBattery() {
        var info = MapInfo.make(machineStatus: nil, machineRemaining: .make(battery: 1))
        applyMachineStatusRule(&info)
        XCTAssertEqual(info.machineStatus, .submit)
    }

    func test_statusRule_setToSubmit_whenStatusNilButHasBottle() {
        var info = MapInfo.make(machineStatus: nil, machineRemaining: .make(bottle: 3))
        applyMachineStatusRule(&info)
        XCTAssertEqual(info.machineStatus, .submit)
    }

    func test_statusRule_setToSubmit_whenStatusNilButHasCan() {
        var info = MapInfo.make(machineStatus: nil, machineRemaining: .make(can: 2))
        applyMachineStatusRule(&info)
        XCTAssertEqual(info.machineStatus, .submit)
    }

    func test_statusRule_remainsNil_whenAllRemainingAreZero() {
        var info = MapInfo.make(machineStatus: nil, machineRemaining: .make(battery: 0, bottle: 0, can: 0, cup: 0))
        applyMachineStatusRule(&info)
        XCTAssertNil(info.machineStatus)
    }

    func test_statusRule_remainsNil_whenRemainingIsNil() {
        var info = MapInfo.make(machineStatus: nil, machineRemaining: nil)
        applyMachineStatusRule(&info)
        XCTAssertNil(info.machineStatus)
    }

    func test_statusRule_doesNotOverrideExistingFullStatus() {
        var info = MapInfo.make(machineStatus: .full, machineRemaining: .make(battery: 10))
        applyMachineStatusRule(&info)
        XCTAssertEqual(info.machineStatus, .full)
    }

    func test_statusRule_doesNotOverrideExistingMaintenanceStatus() {
        var info = MapInfo.make(machineStatus: .underMaintenance, machineRemaining: .make(bottle: 5))
        applyMachineStatusRule(&info)
        XCTAssertEqual(info.machineStatus, .underMaintenance)
    }

    // MARK: - Helpers

    private func decodeMapInfoWithStatus(_ status: String) throws -> MapInfo {
        let json = "{\"status\": \"\(status)\"}".data(using: .utf8)!
        return try JSONDecoder().decode(MapInfo.self, from: json)
    }

    /// Applies the same business rule used in StoreMapVC.viewWillAppear
    private func applyMachineStatusRule(_ info: inout MapInfo) {
        guard info.machineStatus == nil, let remaining = info.machineRemaining else { return }
        if remaining.battery ?? 0 > 0
            || remaining.bottle ?? 0 > 0
            || remaining.colorlessBottle ?? 0 > 0
            || remaining.coloredBottle ?? 0 > 0
            || remaining.can ?? 0 > 0
            || remaining.cup ?? 0 > 0 {
            info.machineStatus = .submit
        }
    }
}
