//
//  SignLoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class SignLoginVC: CustomLoginVC {

    @IBOutlet weak var signUpBtn:UIButton!

    @IBOutlet weak var loginBtn:UIButton!

    @IBOutlet weak var guestLabelWidth:NSLayoutConstraint!

    @IBOutlet weak var label:UILabel!

    /// 原本「訪客登入」的文字連結／底線／可點擊區塊；改用圓形圖示按鈕後隱藏這三個。
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var guestUnderline: UIView!
    @IBOutlet weak var guestInvisibleButton: UIButton!

    /// 「或者使用其他帳戶登入」標題；文字/字型/位置都在 storyboard 設定，這裡只需要套用動態色彩。
    @IBOutlet weak var hintLabel: UILabel!

    @IBOutlet weak var guestLoginBtn: UIButton!
    @IBOutlet weak var hsinchuTongLoginBtn: UIButton!
    @IBOutlet weak var hsinchuTongLoadingIndicator: UIActivityIndicatorView!
    private var isExchangingHsinchuTong = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        setupSocialLoginOptions()
        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: HsinchuTongOAuth.authorizationCodeDidReceive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkVersion()
        forcedConversionLanguage(self, .traditionalChinese)
    }
    
    private func showUpdateAppAlertView() {
        let updateAppAlertView = UpdateAppAlertView(frame: UIScreen.main.bounds)
        keyWindow?.addSubview(updateAppAlertView)
    }
    
    private func checkVersion() {
        // 使用舊的 API，因為這是外部 API，返回格式可能不同
        NetworkManager.shared.getJSONBody(urlString: APIUrl.checkAppleStoreVersion) { data, statusCode, errosMSG in
            guard let data = data, statusCode == 200 else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = json["results"] as? [[String: Any]] {
                if let appleStoreVersion = results[0]["version"] as? String, let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    let compareResult = self.compareVersions(currentVersion, appleStoreVersion)
                    switch compareResult {
                    case .orderedAscending:
                        self.showUpdateAppAlertView()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func compareVersions(_ currentVersion: String, _ appleStoreVersion: String) -> ComparisonResult {
        let components1 = currentVersion.split(separator: ".").compactMap { Int($0) }
        let components2 = appleStoreVersion.split(separator: ".").compactMap { Int($0) }
        
        for i in 0..<min(components1.count, components2.count) {
            if components1[i] < components2[i] {
                return .orderedAscending
            } else if components1[i] > components2[i] {
                return .orderedDescending
            }
        }
        
        if components1.count < components2.count {
            return .orderedAscending
        } else if components1.count > components2.count {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }


    private func UIInit(){
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        let attributes = [NSAttributedString.Key.font:label.font,NSAttributedString.Key.paragraphStyle: paraph]
        label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        label.textAlignment = .center
        if getLanguage() == .english {
            guestLabelWidth.constant = 100
        }
    }
    
    @IBAction func LoginBtnAction(_ sender:UIButton) {
        dismissAndPresent(from: self, storyboard: "Login", identifier: "Login")
    }
    
    @IBAction func SignUpBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            goToSignVC()
        }
    }
    
    private func loginSuccess(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            LoginSuccess = true
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func guestBtnAction(_ sender: UIButton) {
        let loginInfo = AccountInfo(userPhoneNumber: GuestInfo.shared.guestAccount, userPassword: GuestInfo.shared.guestPassword)
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.login,
                                    parameters: loginInfoDic,
                                    authorizationToken: "",
                                    responseType: LoginResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                CommonKey.shared.authToken = ""
                CommonKey.shared.authToken = response.token
                self?.loginSuccess()
            case .failure:
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: nil)
                }
            }
        }
    }

    // MARK: - 登入選項（訪客登入／新竹通登入）

    /// 新竹通品牌圖示裡文字的深藍色，訪客登入圖示的人形也用同一色，兩顆圓形按鈕視覺才一致。
    private static let socialIconTintColor = UIColor(red: 0.1137254902, green: 0.1490196078, blue: 0.3019607843, alpha: 1)

    private func setupSocialLoginOptions() {
        // 原本「訪客登入」是文字連結樣式，改成跟新竹通一致的圓形圖示按鈕後，把舊的文字/底線/點擊區隱藏。
        guestLabel.isHidden = true
        guestUnderline.isHidden = true
        guestInvisibleButton.isHidden = true

        // 標題/提示文字、訪客登入與新竹通登入兩顆按鈕都已在 storyboard 排版好；
        // 這裡只套用需要動態取值（共用色票）的樣式。
        hintLabel.textColor = CommonColor.shared.color5

        setupGuestLoginButton()
        setupHsinchuTongLoginButton()
    }

    private func setupGuestLoginButton() {
        var config = UIButton.Configuration.plain()
        // UIButton.Configuration 會用自己的背景層畫底色/圓角，直接設定 layer.cornerRadius 會被蓋掉；
        // 用 .capsule 讓正方形 frame 直接變成正圓形，跟新竹通那顆圖片按鈕視覺一致。
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "person.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        config.imagePlacement = .top
        config.imagePadding = 2
        config.title = "訪客登入"
        config.baseForegroundColor = Self.socialIconTintColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 2, bottom: 6, trailing: 2)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "GenJyuuGothic-Medium", size: 9) ?? UIFont.systemFont(ofSize: 9)
            return outgoing
        }
        guestLoginBtn.configuration = config
    }

    private func setupHsinchuTongLoginButton() {
        hsinchuTongLoginBtn.imageView?.contentMode = .scaleAspectFit
        hsinchuTongLoadingIndicator.color = Self.socialIconTintColor

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hsinchuTongAuthorizationCodeReceived(_:)),
            name: HsinchuTongOAuth.authorizationCodeDidReceive,
            object: nil
        )
    }

    @IBAction private func hsinchuTongLoginTapped(_ sender: UIButton) {
        // 步驟 1：在 App 內的 WKWebView 開啟後端登入起始網址；OAuth 交握由後端處理。
        let webVC = HsinchuTongLoginWebVC()
        webVC.modalPresentationStyle = .fullScreen
        webVC.onComplete = { [weak self] loginCode in
            guard let self = self else { return }
            guard let loginCode = loginCode, !loginCode.isEmpty else { return } // 取消或失敗
            self.exchangeHsinchuTongCode(loginCode)
        }
        present(webVC, animated: true)
    }

    /// 拿到 login_code，傳給我方後端換取使用者資料。
    @objc private func hsinchuTongAuthorizationCodeReceived(_ notification: Notification) {
        guard let loginCode = notification.userInfo?["login_code"] as? String, !loginCode.isEmpty else { return }
        exchangeHsinchuTongCode(loginCode)
    }

    private func setHsinchuTongLoading(_ loading: Bool) {
        hsinchuTongLoginBtn.isEnabled = !loading
        hsinchuTongLoginBtn.alpha = loading ? 0.4 : 1
        loading ? hsinchuTongLoadingIndicator.startAnimating() : hsinchuTongLoadingIndicator.stopAnimating()
    }

    private func exchangeHsinchuTongCode(_ loginCode: String) {
        // WKWebView 攔截與 Universal Link 備援可能同時觸發，避免重複打 API。
        guard !isExchangingHsinchuTong else { return }
        isExchangingHsinchuTong = true
        setHsinchuTongLoading(true)
        let exchangeURL = APIUrl.domainName + APIUrl.hsinchuTongExchange
        HsinchuTongOAuth.log("換資料請求 → POST \(exchangeURL)　login_code=\(loginCode)")
        NetworkManager.shared.post(
            url: exchangeURL,
            parameters: ["login_code": loginCode, "provider": HsinchuTongOAuth.expectedProvider],
            responseType: HsinchuTongLoginResult.self
        ) { [weak self] result in
            guard let self = self else { return }
            self.isExchangingHsinchuTong = false
            self.setHsinchuTongLoading(false)

            switch result {
            case .success(let member):
                // 新竹通帳號尚未完成電話認證：導去外部瀏覽器讓使用者到新竹通官網補電話號碼，
                // 完成後由使用者自行回到 App 重新按一次「新竹通」登入。
                guard let phone = member.phoneNumber, !phone.isEmpty else {
                    HsinchuTongOAuth.log("新竹通資料缺少電話號碼，導去外部瀏覽器讓使用者完成電話認證")
                    let openPortalAction = UIAlertAction(title: "confirm".localized, style: .default) { _ in
                        guard let url = URL(string: HsinchuTongOAuth.memberPortalURL) else { return }
                        UIApplication.shared.open(url)
                    }
                    showAlert(VC: self, title: nil, message: "此新竹通帳號尚未完成電話認證，請先至新竹通補上電話號碼後再重新登入", alertAction: openPortalAction)
                    return
                }
                HsinchuTongOAuth.log("解析成功　phone=\(phone)　name=\(member.name ?? "nil")　email=\(member.email ?? "nil")　birthday=\(member.birthday ?? "nil")　openid=\(member.openid ?? "nil")")
                self.loginWithHsinchuTong(member)
            case .failure(let error):
                HsinchuTongOAuth.log("換資料失敗：\(error.localizedDescription)")
                showAlert(VC: self, title: nil, message: "登入失敗，請稍後再試")
            }
        }
    }

    /// 電話號碼已驗證：走「新竹通直接登入」API 直接換 token。
    /// TODO: 等後端補上 `APIUrl.hsinchuTongLogin` 後移除此註解；request/response 格式若與 LoginResponse（{ token }）不同，
    /// 需同步調整這裡的 parameters 與 responseType。
    private func loginWithHsinchuTong(_ member: HsinchuTongLoginResult) {
        let loginURL = APIUrl.domainName + APIUrl.hsinchuTongLogin
        HsinchuTongOAuth.log("新竹通登入請求 → POST \(loginURL)　openid=\(member.openid ?? "nil")")
        NetworkManager.shared.post(
            url: loginURL,
            parameters: ["openid": member.openid ?? "", "provider": HsinchuTongOAuth.expectedProvider],
            responseType: LoginResponse.self
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                HsinchuTongOAuth.log("新竹通登入成功")
                CommonKey.shared.authToken = ""
                CommonKey.shared.authToken = response.token
                self.loginSuccess()
            case .failure(let error):
                HsinchuTongOAuth.log("新竹通登入失敗：\(error.localizedDescription)")
                showAlert(VC: self, title: nil, message: "登入失敗，請稍後再試")
            }
        }
    }
}
