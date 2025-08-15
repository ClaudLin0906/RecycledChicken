//
//  LevelCalculation.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/15.
//

import Foundation
import UIKit


class LevelCalculation {
    
    func getLevelInfo(_ experiencePoint: Int) -> LevelInfo {
        let levelValue = min(experiencePoint / 10000 + 1, 10)
        let chickenLevel = IllustratedGuideModelLevel(rawValue: levelValue) ?? .ten
        let levelStartXP = (levelValue - 1) * 10000 // 當前等級的起始經驗值
        let xpInCurrentLevel = experiencePoint - levelStartXP // 在當前等級內的經驗值
        let progressThresholds = (1...10).map { $0 * $0 * 100 }
        let progress = progressThresholds.firstIndex { xpInCurrentLevel <= $0 }?.advanced(by: 1) ?? 10
        return LevelInfo(progress: progress, chickenLevel: chickenLevel)
    }
    
}

struct IllustratedGuide {
    let level: Int
    let levelImage: UIImage
    let iconImage: UIImage
    let guideImage: UIImage
    let guideBackgroundImage: UIImage
    let name: String
    let title: String
    let guide: String
    let discover: String
    let ability: String
    let experience: String
    let attack: String
}

enum IllustratedGuideModelLevel: Int, CaseIterable, Codable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
}

// MARK: - 資料配置

private struct LevelConfig {
    let level: IllustratedGuideModelLevel
    let nameKey: String
    let titleKey: String
    let guideKey: String
    let discover: String
    let ability: String
    let experience: String
    let attack: String
}

private let levelConfigurations: [LevelConfig] = [
    LevelConfig(level: .one, nameKey: "illustratedGuideOneOfName", titleKey: "illustratedGuideOneOfTitle", guideKey: "illustratedGuideOneOfGuide", discover: "", ability: "5056", experience: "0", attack: "物理攻擊"),
    LevelConfig(level: .two, nameKey: "illustratedGuideTwoOfName", titleKey: "illustratedGuideTwoOfTitle", guideKey: "illustratedGuideTwoOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "7424", experience: "10000", attack: "治癒"),
    LevelConfig(level: .three, nameKey: "illustratedGuideThreeOfName", titleKey: "illustratedGuideThreeOfTitle", guideKey: "illustratedGuideThreeOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "1800", experience: "20000", attack: "魔性攻擊"),
    LevelConfig(level: .four, nameKey: "illustratedGuideFourOfName", titleKey: "illustratedGuideFourOfTitle", guideKey: "illustratedGuideFourOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "7130", experience: "30000", attack: "魔性攻擊"),
    LevelConfig(level: .five, nameKey: "illustratedGuideFiveOfName", titleKey: "illustratedGuideFiveOfTitle", guideKey: "illustratedGuideFiveOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2500", experience: "40000", attack: "防禦"),
    LevelConfig(level: .six, nameKey: "illustratedGuideSixOfName", titleKey: "illustratedGuideSixOfTitle", guideKey: "illustratedGuideSixOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "63", experience: "50000", attack: "物理攻擊"),
    LevelConfig(level: .seven, nameKey: "illustratedGuideSevenOfName", titleKey: "illustratedGuideSevenOfTitle", guideKey: "illustratedGuideSevenOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2013", experience: "60000", attack: "魔性攻擊"),
    LevelConfig(level: .eight, nameKey: "illustratedGuideEightOfName", titleKey: "illustratedGuideEightOfTitle", guideKey: "illustratedGuideEightOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2535", experience: "70000", attack: "物理攻擊"),
    LevelConfig(level: .nine, nameKey: "illustratedGuideNineOfName", titleKey: "illustratedGuideNineOfTitle", guideKey: "illustratedGuideNineOfGuide", discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "13625", experience: "80000", attack: "治癒"),
    LevelConfig(level: .ten, nameKey: "illustratedGuideTenOfName", titleKey: "illustratedGuideTenOfTitle", guideKey: "illustratedGuideTenOfGuide", discover: "各位地球的智慧生命呀 感謝你們一同努力減少排碳量！ 接下來有碳長的帶領 相信我們的世界一定會越來越好", ability: "2190", experience: "90000", attack: "防禦")
]

private func loadImage(named name: String) -> UIImage {
    UIImage(named: name) ?? UIImage()
}

func getChickenLevel() -> IllustratedGuideModelLevel {
    CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo?.chickenLevel ?? .one
}

func getIllustratedGuide(_ level: IllustratedGuideModelLevel) -> IllustratedGuide {
    guard let config = levelConfigurations.first(where: { $0.level == level }) else {
        // 若找不到配置，回退到第一級
        return getIllustratedGuide(.one)
    }
    
    return IllustratedGuide(level: level.rawValue, levelImage: loadImage(named: "level\(level.rawValue)"), iconImage: loadImage(named: "level\(level.rawValue)-icon"), guideImage: loadImage(named: "level\(level.rawValue)-guide"), guideBackgroundImage: loadImage(named: "level\(level.rawValue)-guideBackground"), name: NSLocalizedString(config.nameKey, comment: ""), title: NSLocalizedString(config.titleKey, comment: ""), guide: NSLocalizedString(config.guideKey, comment: ""), discover: config.discover, ability: config.ability, experience: config.experience, attack: config.attack
    )
}

