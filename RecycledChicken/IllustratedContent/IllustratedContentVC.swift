//
//  IllustratedContentVC.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/21.
//

import UIKit

class IllustratedContentVC: CustomVC {
    
    @IBOutlet weak var guideBackgroundImageView:UIImageView!
    
    @IBOutlet weak var illustratedGuideOneOfNameLabel:CustomLabel!
        
    @IBOutlet weak var illustratedGuideguideOfTextView:UITextView!
    
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
        illustratedGuideOneOfNameLabel.text = illustratedGuide.name
        illustratedGuideguideOfTextView.text = illustratedGuide.guide
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn(.clear)
    }
    
}
