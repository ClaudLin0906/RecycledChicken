//
//  ExtensionTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

// MARK: - Helpers

private enum Direction: CaseIterable { case north, east, south, west }
private struct SampleEncodable: Codable { let name: String; let value: Int }

final class ExtensionTests: XCTestCase {

    // MARK: - Array.removingDuplicates

    func test_removingDuplicates_removesExtraInts() {
        let result = [1, 2, 2, 3, 1].removingDuplicates()
        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_removingDuplicates_preservesOrder() {
        let result = [3, 1, 2, 1, 3].removingDuplicates()
        XCTAssertEqual(result, [3, 1, 2])
    }

    func test_removingDuplicates_emptyArray() {
        let result = [Int]().removingDuplicates()
        XCTAssertTrue(result.isEmpty)
    }

    func test_removingDuplicates_noDuplicates_unchanged() {
        let result = [1, 2, 3].removingDuplicates()
        XCTAssertEqual(result, [1, 2, 3])
    }

    func test_removingDuplicates_strings() {
        let result = ["a", "b", "a", "c", "b"].removingDuplicates()
        XCTAssertEqual(result, ["a", "b", "c"])
    }

    func test_removeDuplicates_mutates() {
        var arr = [1, 2, 2, 3]
        arr.removeDuplicates()
        XCTAssertEqual(arr, [1, 2, 3])
    }

    // MARK: - CaseIterable.next()

    func test_next_wrapsFromLastToFirst() {
        XCTAssertEqual(Direction.west.next(), .north)
    }

    func test_next_advancesForward() {
        XCTAssertEqual(Direction.north.next(), .east)
        XCTAssertEqual(Direction.east.next(), .south)
        XCTAssertEqual(Direction.south.next(), .west)
    }

    func test_next_illuminatedGuideLevel_wraps() {
        XCTAssertEqual(IllustratedGuideModelLevel.ten.next(), .one)
        XCTAssertEqual(IllustratedGuideModelLevel.one.next(), .two)
    }

    // MARK: - Double.formatNumber

    func test_formatNumber_noGroupingSeparator_below1000() {
        XCTAssertEqual(Double(999).formatNumber(), "999")
    }

    func test_formatNumber_groupingSeparatorAt1000() {
        XCTAssertEqual(Double(1000).formatNumber(), "1,000")
    }

    func test_formatNumber_millions() {
        XCTAssertEqual(Double(1_000_000).formatNumber(), "1,000,000")
    }

    func test_formatNumber_zero() {
        XCTAssertEqual(Double(0).formatNumber(), "0")
    }

    // MARK: - Encodable.jsonString

    func test_jsonString_producesValidJSON() {
        let model = SampleEncodable(name: "test", value: 42)
        let json = model.jsonString
        XCTAssertFalse(json.isEmpty)
        XCTAssertTrue(json.contains("\"name\""))
        XCTAssertTrue(json.contains("\"test\""))
        XCTAssertTrue(json.contains("42"))
    }

    func test_jsonString_isRoundTrippable() throws {
        let model = SampleEncodable(name: "hello", value: 7)
        let json = model.jsonString
        let data = json.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(SampleEncodable.self, from: data)
        XCTAssertEqual(decoded.name, "hello")
        XCTAssertEqual(decoded.value, 7)
    }

    // MARK: - Encodable.dictionary

    func test_dictionary_containsCorrectKeys() {
        let model = SampleEncodable(name: "foo", value: 99)
        let dict = model.dictionary
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict?["name"] as? String, "foo")
        XCTAssertEqual(dict?["value"] as? Int, 99)
    }

    // MARK: - Encodable.asDictionary

    func test_asDictionary_success() throws {
        let model = SampleEncodable(name: "bar", value: 1)
        let dict = try model.asDictionary()
        XCTAssertEqual(dict["name"] as? String, "bar")
        XCTAssertEqual(dict["value"] as? Int, 1)
    }

    // MARK: - String.uniqueString

    func test_uniqueString_hasNoDashes() {
        let unique = String.uniqueString
        XCTAssertFalse(unique.contains("-"))
    }

    func test_uniqueString_has32Characters() {
        let unique = String.uniqueString
        XCTAssertEqual(unique.count, 32)
    }

    func test_uniqueString_generatesDistinctValues() {
        let a = String.uniqueString
        let b = String.uniqueString
        XCTAssertNotEqual(a, b)
    }

    // MARK: - String.urlEncoded

    func test_urlEncoded_plusSignIsEncoded() {
        let encoded = "a+b".urlEncoded()
        XCTAssertEqual(encoded, "a%2Bb")
    }

    func test_urlEncoded_spaceIsEncoded() {
        let encoded = "hello world".urlEncoded()
        XCTAssertTrue(encoded.contains("%20") || encoded.contains("+"))
    }

    func test_urlEncoded_plainAlphanumeric_unchanged() {
        let encoded = "abc123".urlEncoded()
        XCTAssertEqual(encoded, "abc123")
    }

    func test_urlEncoded_specialChars() {
        let encoded = "key=value&other=1".urlEncoded()
        XCTAssertFalse(encoded.isEmpty)
    }
}
