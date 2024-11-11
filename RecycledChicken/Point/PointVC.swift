//
//  PointVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class PointVC: CustomRootVC {
    
    @IBOutlet weak var ponitRecordBtn:UIButton!
    
    @IBOutlet weak var myTicker:UIButton!
    
    @IBOutlet weak var myPoint:UILabel!
        
    @IBOutlet weak var lotteryBtn:UIButton!
    
    @IBOutlet weak var giftVoucherBtn:UIButton!
    
    @IBOutlet weak var productBtn:UIButton!
    
    @IBOutlet weak var ponitRecordBtnWidth:NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    

    private func UIInit(){
        ponitRecordBtn.layer.borderWidth = 1
        ponitRecordBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
//        myTicker.layer.borderWidth = 1
//        myTicker.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        
//        if getLanguage() == .english {
//            lotteryBtn.setImage(UIImage(named: "lottery_english"), for: .normal)
//            giftVoucherBtn.setImage(UIImage(named: "giftVoucher_english"), for: .normal)
//            productBtn.setImage(UIImage(named: "Product_english"), for: .normal)
//            ponitRecordBtnWidth.constant = 200
//        }
    }
    
    private func signAlert(){
        let alertAction = UIAlertAction(title: "sign".localized, style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
        showAlert(VC: self, title: "加入修復計畫，即可獲得來自泥滑島贈與的金幣！", message: nil, alertAction: alertAction, cancelAction: cancelAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserNewInfo(VC: self) {
            if let point = CurrentUserInfo.shared.currentProfileNewInfo?.point {
                self.myPoint.text = String(point)
            }
        }
        getBtnImage { [weak self] pointBtnImage in
            guard let self = self else { return }
            setBtnImage(self.lotteryBtn, urlStr: pointBtnImage.eventLottery)
            setBtnImage(self.giftVoucherBtn, urlStr: pointBtnImage.coupon)
            setBtnImage(self.productBtn, urlStr: pointBtnImage.product)
        }
    }
    
    private func setBtnImage(_ btn:UIButton, urlStr:String?) {
        DispatchQueue.main.async {
            guard let urlStr = urlStr, let url = URL(string: urlStr), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else { return }
            btn.setImage(image, for: .normal)
        }
    }
    
    @IBAction func goToCommodityVoucher(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CommodityVoucher", bundle: Bundle.main).instantiateViewController(identifier: "CommodityVoucher") as? CommodityVoucherVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func productProcess(_ sender:UIButton) {
        let isEmpty = UserDefaults().object(forKey: UserDefaultKey.shared.isFirstProduct)
        if isEmpty == nil {
            UserDefaults().setValue(true, forKey: UserDefaultKey.shared.isFirstProduct)
            goToProductAlert()
        }
        if isEmpty != nil {
            goToProduct()
        }
    }
    
    private func getBtnImage(finishAction: @escaping ((PointBtnImage)->())) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.uiPoint, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else { return }
            if let pointBtnImage = try? JSONDecoder().decode(PointBtnImage.self, from: data) {
                finishAction(pointBtnImage)
            }
        }
    }
    
    private func goToProductAlert() {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ProductAlert", bundle: Bundle.main).instantiateViewController(identifier: "ProductAlert") as? ProductAlertVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func goToProduct() {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Product", bundle: Bundle.main).instantiateViewController(identifier: "Product") as? ProductVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToLottery(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Lottery", bundle: Bundle.main).instantiateViewController(identifier: "Lottery") as? LotteryVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPointRule(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PointRule", bundle: Bundle.main).instantiateViewController(identifier: "PointRule") as? PointRuleVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPointRecord(_ sener:CustomButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PointRecord", bundle: Bundle.main).instantiateViewController(identifier: "PointRecord") as? PointRecordVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToMyTicker(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert()
            return
        }
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "MyTicker", bundle: Bundle.main).instantiateViewController(identifier: "MyTicker") as? MyTickerVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    
}
