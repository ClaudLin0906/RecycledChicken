//
//  BuyCommodityVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyCommodityVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!
    
    var commodityVoucherInfo:CommodityVoucherInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兌換商品序號"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.setConfirmBtnTitle("confirmBuy".localized)
        spendPointView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        if let commodityVoucherInfo = commodityVoucherInfo {
            spendPointView.commodityVoucherInfo = commodityVoucherInfo
        }
    }


}

extension BuyCommodityVC: SpendPointViewDelegate {
    
    func alertMessage(_ message: String) {
        showAlert(VC: self, title: message, message: nil)
    }
    
    func btnAction(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointAlertView = SpendPointAlertView(frame: UIScreen.main.bounds)
        spendPointAlertView.spendPointInfo = info
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }
    
}

extension BuyCommodityVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointInfoDic = try? info.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.couponsBuy, parameters: spendPointInfoDic, AuthorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let spendPointResponse = try? JSONDecoder().decode(SpendPointResponse.self, from: data) {
                getUserNewInfo(VC: self) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let completeTaskAlertView = SpendPointCompleteAlertView(frame: UIScreen.main.bounds)
                        fadeInOutAni(showView: completeTaskAlertView, finishAction: nil)
                        if let navigationController = navigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}

