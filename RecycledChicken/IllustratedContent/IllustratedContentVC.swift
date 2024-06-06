//
//  IllustratedContentVC.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/21.
//

import UIKit

class IllustratedContentVC: CustomVC {
    
    @IBOutlet weak var guideBackgroundImageView:UIImageView!
    
    @IBOutlet weak var illustratedGuideOfNameLabel:CustomLabel!
        
    @IBOutlet weak var illustratedGuideOfTextView:UITextView!
    
    @IBOutlet weak var illustratedGuideOfLevelLabel:UILabel!
    
    @IBOutlet weak var illustratedGuideOfExperienceLabel:UILabel!
    
    @IBOutlet weak var illustratedGuideOfAbilityLabel:UILabel!
    
    var illustratedGuideModelLevel:IllustratedGuideModelLevel?
    
    private var illustratedGuide:IllustratedGuide?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        if let illustratedGuideModelLevel = illustratedGuideModelLevel {
            illustratedGuide = getIllustratedGuide(illustratedGuideModelLevel)
            setValue()
        }
    }
    
    private func setValue() {
        guard let illustratedGuide = illustratedGuide else { return }
        guideBackgroundImageView.image = illustratedGuide.guideBackgroundImage
        illustratedGuideOfNameLabel.text = illustratedGuide.name
        illustratedGuideOfTextView.text = illustratedGuide.guide
        illustratedGuideOfLevelLabel.text = String(illustratedGuide.level)
        illustratedGuideOfAbilityLabel.text = illustratedGuide.ability
        illustratedGuideOfExperienceLabel.text = illustratedGuide.experience
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn(.clear)
    }
    
}
