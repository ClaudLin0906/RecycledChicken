//
//  RecycleItemTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class RecycleItemTests: XCTestCase {

    // MARK: - remaining(from:) - bottle

    func test_bottle_remaining_sumsBothColoredAndColorlessAndPlain() {
        let remaining = MachineRemaining.make(bottle: 10, coloredBottle: 3, colorlessBottle: 2)
        XCTAssertEqual(RecycleItem.bottle.remaining(from: remaining), 15)
    }

    func test_bottle_remaining_returnsNil_whenAllBottleFieldsNil() {
        let remaining = MachineRemaining.make(battery: 5, can: 3)
        XCTAssertNil(RecycleItem.bottle.remaining(from: remaining))
    }

    func test_bottle_remaining_treatsNilSubfieldsAsZero() {
        let remaining = MachineRemaining.make(bottle: 7, coloredBottle: nil, colorlessBottle: nil)
        XCTAssertEqual(RecycleItem.bottle.remaining(from: remaining), 7)
    }

    func test_bottle_remaining_withOnlyColoredBottle() {
        let remaining = MachineRemaining.make(coloredBottle: 4)
        XCTAssertEqual(RecycleItem.bottle.remaining(from: remaining), 4)
    }

    func test_bottle_remaining_withOnlyColorlessBottle() {
        let remaining = MachineRemaining.make(colorlessBottle: 6)
        XCTAssertEqual(RecycleItem.bottle.remaining(from: remaining), 6)
    }

    // MARK: - remaining(from:) - battery

    func test_battery_remaining_returnsValue() {
        let remaining = MachineRemaining.make(battery: 8)
        XCTAssertEqual(RecycleItem.battery.remaining(from: remaining), 8)
    }

    func test_battery_remaining_returnsNil_whenFieldNil() {
        let remaining = MachineRemaining.make(bottle: 3)
        XCTAssertNil(RecycleItem.battery.remaining(from: remaining))
    }

    // MARK: - remaining(from:) - papperCub (cup)

    func test_papperCub_remaining_returnsValue() {
        let remaining = MachineRemaining.make(cup: 5)
        XCTAssertEqual(RecycleItem.papperCub.remaining(from: remaining), 5)
    }

    func test_papperCub_remaining_returnsNil_whenFieldNil() {
        let remaining = MachineRemaining.make(battery: 1)
        XCTAssertNil(RecycleItem.papperCub.remaining(from: remaining))
    }

    // MARK: - remaining(from:) - aluminumCan

    func test_aluminumCan_remaining_returnsValue() {
        let remaining = MachineRemaining.make(can: 12)
        XCTAssertEqual(RecycleItem.aluminumCan.remaining(from: remaining), 12)
    }

    func test_aluminumCan_remaining_returnsNil_whenFieldNil() {
        let remaining = MachineRemaining.make(battery: 2)
        XCTAssertNil(RecycleItem.aluminumCan.remaining(from: remaining))
    }

    // MARK: - remaining(from:) - milkCan / foilPack / paperCarton always nil

    func test_milkCan_remaining_alwaysNil() {
        let remaining = MachineRemaining.make(battery: 5, bottle: 5, can: 5, cup: 5)
        XCTAssertNil(RecycleItem.milkCan.remaining(from: remaining))
    }

    func test_foilPack_remaining_alwaysNil() {
        let remaining = MachineRemaining.make(battery: 5, bottle: 5, can: 5, cup: 5)
        XCTAssertNil(RecycleItem.foilPack.remaining(from: remaining))
    }

    func test_paperCarton_remaining_alwaysNil() {
        let remaining = MachineRemaining.make(battery: 5, bottle: 5, can: 5, cup: 5)
        XCTAssertNil(RecycleItem.paperCarton.remaining(from: remaining))
    }

    // MARK: - from(apiName:)

    func test_fromApiName_bottle() {
        XCTAssertEqual(RecycleItem.from(apiName: "寶特瓶"), .bottle)
    }

    func test_fromApiName_battery() {
        XCTAssertEqual(RecycleItem.from(apiName: "電池"), .battery)
    }

    func test_fromApiName_papperCub() {
        XCTAssertEqual(RecycleItem.from(apiName: "紙杯"), .papperCub)
    }

    func test_fromApiName_aluminumCan() {
        XCTAssertEqual(RecycleItem.from(apiName: "鋁罐"), .aluminumCan)
    }

    func test_fromApiName_milkCan() {
        XCTAssertEqual(RecycleItem.from(apiName: "牛奶罐"), .milkCan)
    }

    func test_fromApiName_foilPack() {
        XCTAssertEqual(RecycleItem.from(apiName: "鋁箔包"), .foilPack)
    }

    func test_fromApiName_paperCarton() {
        XCTAssertEqual(RecycleItem.from(apiName: "紙盒包"), .paperCarton)
    }

    func test_fromApiName_unknownReturnsNil() {
        XCTAssertNil(RecycleItem.from(apiName: "不存在"))
        XCTAssertNil(RecycleItem.from(apiName: ""))
    }

    // MARK: - allCases coverage

    func test_allCasesContainsSevenItems() {
        XCTAssertEqual(RecycleItem.allCases.count, 7)
    }

    func test_everyItemHasNonEmptyApiName() {
        RecycleItem.allCases.forEach { item in
            XCTAssertFalse(item.apiName.isEmpty, "\(item) should have a non-empty apiName")
        }
    }

    func test_everyItemHasNonEmptyIconName() {
        RecycleItem.allCases.forEach { item in
            XCTAssertFalse(item.iconName.isEmpty, "\(item) should have a non-empty iconName")
        }
    }

    func test_everyItemHasNonEmptyRecycleUnit() {
        RecycleItem.allCases.forEach { item in
            XCTAssertFalse(item.recycleUnit.isEmpty, "\(item) should have a non-empty recycleUnit")
        }
    }

    // MARK: - colorRecycledValue

    func test_colorRecycledValue_bottle() {
        XCTAssertEqual(RecycleItem.bottle.colorRecycledValue, 1260)
    }

    func test_colorRecycledValue_battery() {
        XCTAssertEqual(RecycleItem.battery.colorRecycledValue, 182000)
    }

    func test_colorRecycledValue_aluminumCan() {
        XCTAssertEqual(RecycleItem.aluminumCan.colorRecycledValue, 120100)
    }

    func test_colorRecycledValue_papperCub() {
        XCTAssertEqual(RecycleItem.papperCub.colorRecycledValue, 9060)
    }

    func test_colorRecycledValue_untracked_isZero() {
        XCTAssertEqual(RecycleItem.milkCan.colorRecycledValue, 0)
        XCTAssertEqual(RecycleItem.foilPack.colorRecycledValue, 0)
        XCTAssertEqual(RecycleItem.paperCarton.colorRecycledValue, 0)
    }

    // MARK: - availableItems filter (mirrors StoreMapVC.getMakerIcon logic)

    func test_availableItems_filtersCorrectly_withPartialRemaining() {
        let remaining = MachineRemaining.make(battery: 2, bottle: nil, can: nil, cup: nil)
        let availableItems = RecycleItem.allCases.filter { $0.remaining(from: remaining) != nil }
        XCTAssertEqual(availableItems, [.battery])
    }

    func test_availableItems_returnsAllTrackable_whenAllPresent() {
        let remaining = MachineRemaining.make(battery: 1, bottle: 1, can: 1, cup: 1)
        let availableItems = RecycleItem.allCases.filter { $0.remaining(from: remaining) != nil }
        XCTAssertTrue(availableItems.contains(.battery))
        XCTAssertTrue(availableItems.contains(.bottle))
        XCTAssertTrue(availableItems.contains(.aluminumCan))
        XCTAssertTrue(availableItems.contains(.papperCub))
        XCTAssertFalse(availableItems.contains(.milkCan))
        XCTAssertFalse(availableItems.contains(.foilPack))
        XCTAssertFalse(availableItems.contains(.paperCarton))
    }

    func test_availableItems_emptyWhenNoRemaining() {
        let remaining = MachineRemaining.make()
        let availableItems = RecycleItem.allCases.filter { $0.remaining(from: remaining) != nil }
        XCTAssertTrue(availableItems.isEmpty)
    }
}
