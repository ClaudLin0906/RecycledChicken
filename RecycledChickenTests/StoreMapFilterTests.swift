//
//  StoreMapFilterTests.swift
//  RecycledChickenTests
//
//  Tests the search/filter logic from StoreMapVC.textFieldDidChange
//

import XCTest
@testable import RecycledChicken

final class StoreMapFilterTests: XCTestCase {

    // MARK: - Filter logic (extracted from textFieldDidChange)

    /// Mirrors the filter inside StoreMapVC.textFieldDidChange
    private func filterMapInfos(_ infos: [MapInfo], query: String) -> [MapInfo] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard trimmed != "" else { return infos }

        return infos.filter { mapInfo in
            if let name = mapInfo.name, name.contains(trimmed) { return true }
            if let address = mapInfo.address, address.contains(trimmed) { return true }
            return false
        }
    }

    // MARK: - Sample data

    private var sampleInfos: [MapInfo] = {
        [
            MapInfo.make(name: "台北車站",   address: "台北市中正區北平西路3號"),
            MapInfo.make(name: "信義店",     address: "台北市信義區松壽路12號"),
            MapInfo.make(name: "板橋站",     address: "新北市板橋區縣民大道二段7號"),
            MapInfo.make(name: nil,          address: "高雄市苓雅區"),
            MapInfo.make(name: "台南站",     address: nil),
        ]
    }()

    // MARK: - Tests

    func test_filter_emptyQuery_returnsAllInfos() {
        let result = filterMapInfos(sampleInfos, query: "")
        XCTAssertEqual(result.count, sampleInfos.count)
    }

    func test_filter_whitespaceOnlyQuery_returnsAllInfos() {
        let result = filterMapInfos(sampleInfos, query: "   ")
        XCTAssertEqual(result.count, sampleInfos.count)
    }

    func test_filter_matchesByName() {
        // "板橋" only appears in "板橋站" (name) and its own address — single record
        let result = filterMapInfos(sampleInfos, query: "板橋站")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "板橋站")
    }

    func test_filter_matchesByAddress() {
        let result = filterMapInfos(sampleInfos, query: "新北市")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "板橋站")
    }

    func test_filter_matchesBothNameAndAddress() {
        // "台北" matches "台北車站" by name, and "信義店" by its address "台北市信義區..."
        // "台北市" also matches "台北車站" by address "台北市中正區..."
        let result = filterMapInfos(sampleInfos, query: "台北")
        XCTAssertEqual(result.count, 2)
    }

    func test_filter_noMatch_returnsEmpty() {
        let result = filterMapInfos(sampleInfos, query: "不存在的關鍵字")
        XCTAssertTrue(result.isEmpty)
    }

    func test_filter_nilName_matchedByAddress() {
        // The entry with nil name and "高雄市苓雅區" address
        let result = filterMapInfos(sampleInfos, query: "高雄")
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result.first?.name)
    }

    func test_filter_nilAddress_matchedByName() {
        // "台南站" has a nil address
        let result = filterMapInfos(sampleInfos, query: "台南")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "台南站")
    }

    func test_filter_bothNilNameAndNilAddress_neverMatched() {
        let infos = [MapInfo.make(name: nil, address: nil)]
        let result = filterMapInfos(infos, query: "anything")
        XCTAssertTrue(result.isEmpty)
    }

    func test_filter_caseSensitive_chineseQuery() {
        // The filter uses String.contains which is case-sensitive by default
        let result = filterMapInfos(sampleInfos, query: "信義")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "信義店")
    }

    func test_filter_partialMatch_returnsCorrectSubset() {
        let result = filterMapInfos(sampleInfos, query: "站")
        // 台北車站, 板橋站, 台南站
        XCTAssertEqual(result.count, 3)
    }

    func test_filter_emptyInfos_returnsEmpty() {
        let result = filterMapInfos([], query: "台北")
        XCTAssertTrue(result.isEmpty)
    }
}
