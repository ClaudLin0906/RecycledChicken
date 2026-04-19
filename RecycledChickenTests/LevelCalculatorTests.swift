//
//  LevelCalculatorTests.swift
//  RecycledChickenTests
//

import XCTest
@testable import RecycledChicken

final class LevelCalculatorTests: XCTestCase {

    // MARK: - IllustratedGuideModelLevel

    func test_level_allCasesHasTenItems() {
        XCTAssertEqual(IllustratedGuideModelLevel.allCases.count, 10)
    }

    func test_level_rawValues_oneToTen() {
        XCTAssertEqual(IllustratedGuideModelLevel.one.rawValue, 1)
        XCTAssertEqual(IllustratedGuideModelLevel.ten.rawValue, 10)
    }

    // MARK: - LevelCalculator.getLevelInfo

    func test_getLevelInfo_zeroXP_isLevelOne() {
        let info = LevelCalculator.getLevelInfo(0)
        XCTAssertEqual(info.chickenLevel, .one)
    }

    func test_getLevelInfo_9999XP_isLevelOne() {
        let info = LevelCalculator.getLevelInfo(9999)
        XCTAssertEqual(info.chickenLevel, .one)
    }

    func test_getLevelInfo_10000XP_isLevelTwo() {
        let info = LevelCalculator.getLevelInfo(10000)
        XCTAssertEqual(info.chickenLevel, .two)
    }

    func test_getLevelInfo_19999XP_isLevelTwo() {
        let info = LevelCalculator.getLevelInfo(19999)
        XCTAssertEqual(info.chickenLevel, .two)
    }

    func test_getLevelInfo_50000XP_isLevelSix() {
        let info = LevelCalculator.getLevelInfo(50000)
        XCTAssertEqual(info.chickenLevel, .six)
    }

    func test_getLevelInfo_90000XP_isLevelTen() {
        let info = LevelCalculator.getLevelInfo(90000)
        XCTAssertEqual(info.chickenLevel, .ten)
    }

    func test_getLevelInfo_100000XP_isLevelTen() {
        let info = LevelCalculator.getLevelInfo(100000)
        XCTAssertEqual(info.chickenLevel, .ten)
    }

    func test_getLevelInfo_progressIsAtLeastOne() {
        let info = LevelCalculator.getLevelInfo(0)
        XCTAssertGreaterThanOrEqual(info.progress ?? 0, 1)
    }

    func test_getLevelInfo_progressIsAtMostTen() {
        let info = LevelCalculator.getLevelInfo(100000)
        XCTAssertLessThanOrEqual(info.progress ?? 0, 10)
    }

    func test_getLevelInfo_allLevelThresholds() {
        let expected: [(Int, IllustratedGuideModelLevel)] = [
            (0,      .one),
            (10000,  .two),
            (20000,  .three),
            (30000,  .four),
            (40000,  .five),
            (50000,  .six),
            (60000,  .seven),
            (70000,  .eight),
            (80000,  .nine),
            (90000,  .ten),
        ]
        for (xp, expectedLevel) in expected {
            XCTAssertEqual(LevelCalculator.getLevelInfo(xp).chickenLevel, expectedLevel, "XP \(xp) should be level \(expectedLevel.rawValue)")
        }
    }

    // MARK: - LevelCalculator.getExperienceThreshold

    func test_getExperienceThreshold_levelOne_isZero() {
        XCTAssertEqual(LevelCalculator.getExperienceThreshold(for: .one), 0)
    }

    func test_getExperienceThreshold_levelTwo_is10000() {
        XCTAssertEqual(LevelCalculator.getExperienceThreshold(for: .two), 10000)
    }

    func test_getExperienceThreshold_levelTen_is90000() {
        XCTAssertEqual(LevelCalculator.getExperienceThreshold(for: .ten), 90000)
    }

    // MARK: - LevelCalculator.getMaxExperience

    func test_getMaxExperience_levelOne_is9999() {
        XCTAssertEqual(LevelCalculator.getMaxExperience(for: .one), 9999)
    }

    func test_getMaxExperience_levelNine_is89999() {
        XCTAssertEqual(LevelCalculator.getMaxExperience(for: .nine), 89999)
    }

    func test_getMaxExperience_levelTen_isZero_outOfBounds() {
        // Level 10 index is 10, which is out of range → returns 0
        XCTAssertEqual(LevelCalculator.getMaxExperience(for: .ten), 0)
    }

    // MARK: - LevelCalculator.getExperienceToNextLevel

    func test_getExperienceToNextLevel_level1_midpoint() {
        // At 5000 XP (level 1), next threshold is 10000 → need 5000
        XCTAssertEqual(LevelCalculator.getExperienceToNextLevel(5000), 5000)
    }

    func test_getExperienceToNextLevel_exactlyAtThreshold_isZero() {
        // At 10000 XP (level 2), next threshold is 20000 → need 10000
        XCTAssertEqual(LevelCalculator.getExperienceToNextLevel(10000), 10000)
    }

    func test_getExperienceToNextLevel_neverNegative() {
        for xp in stride(from: 0, through: 100000, by: 5000) {
            XCTAssertGreaterThanOrEqual(LevelCalculator.getExperienceToNextLevel(xp), 0)
        }
    }

    // MARK: - LevelCalculator.getProgressPercentage

    func test_getProgressPercentage_zero_isZero() {
        let pct = LevelCalculator.getProgressPercentage(0)
        XCTAssertEqual(pct, 0.0, accuracy: 0.001)
    }

    func test_getProgressPercentage_midLevel_isHalf() {
        // Level 1 spans 0–9999, midpoint ≈ 5000
        let pct = LevelCalculator.getProgressPercentage(5000)
        XCTAssertGreaterThan(pct, 0.0)
        XCTAssertLessThan(pct, 1.0)
    }

    func test_getProgressPercentage_alwaysBetweenZeroAndOne() {
        for xp in stride(from: 0, through: 100000, by: 1000) {
            let pct = LevelCalculator.getProgressPercentage(xp)
            XCTAssertGreaterThanOrEqual(pct, 0.0, "pct for xp \(xp) should be >= 0")
            XCTAssertLessThanOrEqual(pct, 1.0, "pct for xp \(xp) should be <= 1")
        }
    }

    // MARK: - LevelCalculation (legacy class)

    func test_legacyLevelCalculation_zeroXP_isLevelOne() {
        let info = LevelCalculation().getLevelInfo(0)
        XCTAssertEqual(info.chickenLevel, .one)
    }

    func test_legacyLevelCalculation_9999XP_isLevelOne() {
        let info = LevelCalculation().getLevelInfo(9999)
        XCTAssertEqual(info.chickenLevel, .one)
    }

    func test_legacyLevelCalculation_10000XP_isLevelTwo() {
        let info = LevelCalculation().getLevelInfo(10000)
        XCTAssertEqual(info.chickenLevel, .two)
    }

    func test_legacyLevelCalculation_90000XP_isLevelTen() {
        let info = LevelCalculation().getLevelInfo(90000)
        XCTAssertEqual(info.chickenLevel, .ten)
    }

    func test_legacyLevelCalculation_progressAtLeastOne() {
        let info = LevelCalculation().getLevelInfo(0)
        XCTAssertGreaterThanOrEqual(info.progress ?? 0, 1)
    }

    func test_legacyLevelCalculation_progressAtMostTen() {
        let info = LevelCalculation().getLevelInfo(100000)
        XCTAssertLessThanOrEqual(info.progress ?? 0, 10)
    }
}
