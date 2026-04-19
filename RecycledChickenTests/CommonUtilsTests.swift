//
//  CommonUtilsTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class CommonUtilsTests: XCTestCase {

    // MARK: - convertWeight

    func test_convertWeight_belowKilo_staysInGrams() {
        let result = convertWeight(999)
        XCTAssertEqual(result.convertedValue, 999)
        XCTAssertEqual(result.unit, .gram)
    }

    func test_convertWeight_exactly1000_convertsToKilogram() {
        let result = convertWeight(1000)
        XCTAssertEqual(result.convertedValue, 1, accuracy: 0.001)
        XCTAssertEqual(result.unit, .kilogram)
    }

    func test_convertWeight_between1000And1million_convertsToKilogram() {
        let result = convertWeight(5000)
        XCTAssertEqual(result.convertedValue, 5, accuracy: 0.001)
        XCTAssertEqual(result.unit, .kilogram)
    }

    func test_convertWeight_exactly1million_convertsToTonne() {
        let result = convertWeight(1_000_000)
        XCTAssertEqual(result.convertedValue, 1, accuracy: 0.001)
        XCTAssertEqual(result.unit, .tonne)
    }

    func test_convertWeight_above1million_convertsToTonne() {
        let result = convertWeight(2_500_000)
        XCTAssertEqual(result.convertedValue, 2.5, accuracy: 0.001)
        XCTAssertEqual(result.unit, .tonne)
    }

    func test_convertWeight_zero_staysInGrams() {
        let result = convertWeight(0)
        XCTAssertEqual(result.convertedValue, 0)
        XCTAssertEqual(result.unit, .gram)
    }

    // MARK: - validateEmail

    func test_validateEmail_validAddresses() {
        XCTAssertTrue(validateEmail(text: "user@example.com"))
        XCTAssertTrue(validateEmail(text: "user.name+tag@sub.domain.org"))
        XCTAssertTrue(validateEmail(text: "USER@EXAMPLE.COM"))
        XCTAssertTrue(validateEmail(text: "user123@test.co.uk"))
    }

    func test_validateEmail_invalidAddresses() {
        XCTAssertFalse(validateEmail(text: ""))
        XCTAssertFalse(validateEmail(text: "notanemail"))
        XCTAssertFalse(validateEmail(text: "missing@domain"))
        XCTAssertFalse(validateEmail(text: "@nodomain.com"))
        XCTAssertFalse(validateEmail(text: "spaces in@email.com"))
        XCTAssertFalse(validateEmail(text: "double@@email.com"))
    }

    // MARK: - validatePassword

    func test_validatePassword_valid_8to12chars_alphanumeric() {
        XCTAssertTrue(validatePassword(text: "abc12345"))      // 8 chars
        XCTAssertTrue(validatePassword(text: "Abc12345"))      // 8 chars with uppercase
        XCTAssertTrue(validatePassword(text: "abc123456789"))  // 12 chars
    }

    func test_validatePassword_tooShort() {
        XCTAssertFalse(validatePassword(text: "abc123"))   // 6 chars
        XCTAssertFalse(validatePassword(text: "Ab1234"))   // 6 chars
    }

    func test_validatePassword_tooLong() {
        XCTAssertFalse(validatePassword(text: "abc1234567890"))  // 13 chars
    }

    func test_validatePassword_lettersOnly() {
        XCTAssertFalse(validatePassword(text: "abcdefgh"))   // no digits
    }

    func test_validatePassword_digitsOnly() {
        XCTAssertFalse(validatePassword(text: "12345678"))   // no letters
    }

    func test_validatePassword_containsSpecialChars() {
        XCTAssertFalse(validatePassword(text: "abc!2345"))   // special char not allowed
        XCTAssertFalse(validatePassword(text: "abc@1234"))
    }

    // MARK: - validateCellPhone

    func test_validateCellPhone_validTaiwanNumbers() {
        XCTAssertTrue(validateCellPhone(text: "0912345678"))
        XCTAssertTrue(validateCellPhone(text: "0987654321"))
        XCTAssertTrue(validateCellPhone(text: "0900000000"))
    }

    func test_validateCellPhone_invalidNumbers() {
        XCTAssertFalse(validateCellPhone(text: ""))
        XCTAssertFalse(validateCellPhone(text: "091234567"))    // 9 digits
        XCTAssertFalse(validateCellPhone(text: "09123456789"))  // 11 digits
        XCTAssertFalse(validateCellPhone(text: "1912345678"))   // doesn't start with 09
        XCTAssertFalse(validateCellPhone(text: "0812345678"))   // doesn't start with 09
        XCTAssertFalse(validateCellPhone(text: "091234567a"))   // contains letter
    }

    // MARK: - removeWhitespace

    func test_removeWhitespace_removesAllSpaces() {
        XCTAssertEqual(removeWhitespace(from: "hello world"), "helloworld")
    }

    func test_removeWhitespace_noSpaces_unchanged() {
        XCTAssertEqual(removeWhitespace(from: "helloworld"), "helloworld")
    }

    func test_removeWhitespace_multipleSpaces() {
        XCTAssertEqual(removeWhitespace(from: "a b c d"), "abcd")
    }

    func test_removeWhitespace_emptyString() {
        XCTAssertEqual(removeWhitespace(from: ""), "")
    }

    func test_removeWhitespace_onlySpaces() {
        XCTAssertEqual(removeWhitespace(from: "   "), "")
    }

    // MARK: - changeFormat

    func test_changeFormat_convertsYYYYdashMMdashDD_to_slashFormat() {
        XCTAssertEqual(changeFormat("2024-01-15"), "2024/01/15")
    }

    func test_changeFormat_withInvalidInput_returnsOriginal() {
        XCTAssertEqual(changeFormat("not-a-date"), "not-a-date")
        XCTAssertEqual(changeFormat(""), "")
    }

    func test_changeFormat_differentDates() {
        XCTAssertEqual(changeFormat("2023-12-31"), "2023/12/31")
        XCTAssertEqual(changeFormat("2000-06-01"), "2000/06/01")
    }

    // MARK: - convertDateFormat

    func test_convertDateFormat_validConversion() {
        let result = convertDateFormat(inputDateString: "2024-01-15",
                                       inputFormat: "yyyy-MM-dd",
                                       outputFormat: "dd/MM/yyyy")
        XCTAssertEqual(result, "15/01/2024")
    }

    func test_convertDateFormat_invalidInput_returnsNil() {
        let result = convertDateFormat(inputDateString: "invalid",
                                       inputFormat: "yyyy-MM-dd",
                                       outputFormat: "dd/MM/yyyy")
        XCTAssertNil(result)
    }

    func test_convertDateFormat_differentFormats() {
        let result = convertDateFormat(inputDateString: "15/06/2023",
                                       inputFormat: "dd/MM/yyyy",
                                       outputFormat: "yyyy-MM-dd")
        XCTAssertEqual(result, "2023-06-15")
    }

    // MARK: - WeightUnit rawValue

    func test_weightUnit_rawValues() {
        XCTAssertEqual(WeightUnit.gram.rawValue, "gCO₂e")
        XCTAssertEqual(WeightUnit.kilogram.rawValue, "kgCO₂e")
        XCTAssertEqual(WeightUnit.tonne.rawValue, "tCO₂e")
    }
}
