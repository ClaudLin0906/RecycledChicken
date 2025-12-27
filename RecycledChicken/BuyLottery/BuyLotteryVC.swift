//
//  BuyLotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyLotteryVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!
    
    var lotteryInfo:LotteryInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兌換抽獎/活動序號"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        if let lotteryInfo = lotteryInfo {
            spendPointView.lotteryInfo = lotteryInfo
        }
    }


}

extension BuyLotteryVC: SpendPointViewDelegate {
    
    func alertMessage(_ message: String) {
        showAlert(VC: self, title: message, message: nil)
    }
    
    func btnAction(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointAlertView = SpendPointAlertView(frame: view.frame)
        spendPointAlertView.spendPointInfo = info
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }

}

extension BuyLotteryVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointInfoDic = try? info.asDictionary()
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.lotteryBuy, parameters: spendPointInfoDic, authorizationToken: CommonKey.shared.authToken, responseType: SpendPointResponse.self) { [weak self] result in
            switch result {
            case .success:
                getUserNewInfo(VC: self!) {
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        let completeTaskAlertView = SpendPointCompleteAlertView(frame: UIScreen.main.bounds)
                        fadeInOutAni(showView: completeTaskAlertView, finishAction: nil)
                        if let navigationController = self.navigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                }
            }
        }
    }
    
}
