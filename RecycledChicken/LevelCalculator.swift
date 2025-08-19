//
//  LevelCalculator.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/15.
//

import Foundation

struct LevelCalculator {
    
    // 等級門檻（經驗值）
    static let levelThresholds = [0, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000]
    
    // 進度門檻（每個等級內部的進度，基於平方數）
    static let progressThresholds = [0, 100, 400, 900, 1600, 2500, 3600, 4900, 6400, 8100, 10000]
    
    /// 根據經驗值計算等級和進度
    /// - Parameter experiencePoint: 經驗值
    /// - Returns: 包含等級和進度的 LevelInfo
    static func getLevelInfo(_ experiencePoint: Int) -> LevelInfo {
        // 計算等級：找到經驗值所在的等級區間
        let levelIndex = (levelThresholds.lastIndex(where: { experiencePoint >= $0 }) ?? 0)
        let level = IllustratedGuideModelLevel(rawValue: levelIndex + 1) ?? .one
        
        // 計算進度：找到經驗值所在的進度區間
        let progressIndex = (progressThresholds.lastIndex(where: { experiencePoint >= $0 }) ?? 0)
        let progress = progressIndex + 1
        
        return LevelInfo(progress: progress, chickenLevel: level)
    }
    
    /// 取得指定等級的經驗值門檻
    /// - Parameter level: 等級
    /// - Returns: 該等級的經驗值門檻
    static func getExperienceThreshold(for level: IllustratedGuideModelLevel) -> Int {
        let index = level.rawValue - 1
        guard index >= 0 && index < levelThresholds.count else { return 0 }
        return levelThresholds[index]
    }
    
    /// 取得指定等級的最大經驗值
    /// - Parameter level: 等級
    /// - Returns: 該等級的最大經驗值
    static func getMaxExperience(for level: IllustratedGuideModelLevel) -> Int {
        let index = level.rawValue
        guard index >= 0 && index < levelThresholds.count else { return 0 }
        return levelThresholds[index] - 1
    }
    
    /// 計算距離下一等級還需要多少經驗值
    /// - Parameter currentExperience: 當前經驗值
    /// - Returns: 距離下一等級的經驗值
    static func getExperienceToNextLevel(_ currentExperience: Int) -> Int {
        let currentLevel = getLevelInfo(currentExperience).chickenLevel
        let nextLevel = IllustratedGuideModelLevel(rawValue: currentLevel.rawValue + 1) ?? .ten
        
        let nextLevelThreshold = getExperienceThreshold(for: nextLevel)
        return max(0, nextLevelThreshold - currentExperience)
    }
    
    /// 計算當前等級的進度百分比
    /// - Parameter currentExperience: 當前經驗值
    /// - Returns: 進度百分比 (0.0 - 1.0)
    static func getProgressPercentage(_ currentExperience: Int) -> Double {
        let currentLevel = getLevelInfo(currentExperience).chickenLevel
        let levelStart = getExperienceThreshold(for: currentLevel)
        let levelEnd = getMaxExperience(for: currentLevel)
        
        guard levelEnd > levelStart else { return 1.0 }
        
        let levelProgress = Double(currentExperience - levelStart)
        let levelTotal = Double(levelEnd - levelStart)
        
        return min(1.0, max(0.0, levelProgress / levelTotal))
    }
}

// MARK: - 使用範例和測試
extension LevelCalculator {
    
    /// 測試用的範例
    static func runExamples() {
        print("=== 等級計算範例 ===")
        
        // 範例1：基本等級計算
        let testCases = [0, 5000, 15000, 25000, 35000, 45000, 55000, 65000, 75000, 85000, 95000]
        
        for experience in testCases {
            let levelInfo = getLevelInfo(experience)
            print("經驗值 \(experience) -> 等級 \(levelInfo.chickenLevel.rawValue), 進度 \(levelInfo.progress)")
        }
        
        print("\n=== 進度計算範例 ===")
        
        // 範例2：進度百分比
        let progressTests = [100, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
        
        for experience in progressTests {
            let percentage = getProgressPercentage(experience)
            let levelInfo = getLevelInfo(experience)
            print("經驗值 \(experience) -> 等級 \(levelInfo.chickenLevel.rawValue), 進度百分比: \(String(format: "%.1f%%", percentage * 100))")
        }
        
        print("\n=== 下一等級計算範例 ===")
        
        // 範例3：距離下一等級的經驗值
        let nextLevelTests = [5000, 15000, 25000, 35000, 45000]
        
        for experience in nextLevelTests {
            let needed = getExperienceToNextLevel(experience)
            let levelInfo = getLevelInfo(experience)
            print("等級 \(levelInfo.chickenLevel.rawValue) (經驗值 \(experience)) -> 距離下一等級還需要 \(needed) 經驗值")
        }
    }
}

