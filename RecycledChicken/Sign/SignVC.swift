//
//  SignVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit
import M13Checkbox
import WebKit

class SignVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var passwordTextfield:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var registerBtn:CustomButton!
    
    @IBOutlet weak var birthdayTextfield: UITextField!
    
    @IBOutlet weak var genderSelectionView: GenderSelectionView!
    
    private let privacyCheckBox = M13Checkbox()
    private let privacyStackView = UIStackView()
    private let hsinchuTongLoginBtn = CustomButton()
    private let hsinchuTongLoadingIndicator = UIActivityIndicatorView(style: .medium)

    /// 新竹通回傳、但註冊頁目前沒有對應輸入欄位的資料，先暫存待後續註冊流程使用。
    private var hsinchuTongUserName: String?
    private var hsinchuTongUserEmail: String?
    private var hsinchuTongOpenID: String?
    private var isExchangingHsinchuTong = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        setupDatePicker()
        setupPrivacyCheckbox()
        setupHsinchuTongLoginButton()
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
        if getLanguage() == .english {
            let font = passwordTextfield.font?.withSize(12) ?? UIFont.systemFont(ofSize: 12)
            let attributes: [NSAttributedString.Key: Any] = [ .font: font, .foregroundColor: UIColor.gray]
            let attributedPlaceholder = NSAttributedString(string: passwordTextfield.placeholder ?? "", attributes: attributes)
            passwordTextfield.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        birthdayTextfield.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneClick))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneBtn], animated: false)
        birthdayTextfield.inputAccessoryView = toolbar
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        birthdayTextfield.text = formatter.string(from: sender.date)
    }
    
    @objc private func doneClick() {
        if birthdayTextfield.text?.isEmpty == true, let datePicker = birthdayTextfield.inputView as? UIDatePicker {
            dateChanged(datePicker)
        }
        view.endEditing(true)
    }
    
    private func goToVerificationCode(phone:String, password:String, birth: String?, gender: Gender? ){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.currentType = .sign
                VC.modalPresentationStyle = .fullScreen
                VC.password = password
                VC.phone = phone
                VC.userBirth = birth
                VC.gender = gender
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func sendVerificationCode(_ sender: UIButton) {
        guard let inputs = getValidatedInputs() else { return }
        goToVerificationCode(phone: inputs.phone, password: inputs.password, birth: inputs.birth, gender: inputs.gender)
    }
    
    private func getValidatedInputs() -> (phone: String, password: String, birth: String, gender: Gender)? {
        guard let phone = phoneTextfield.text, !phone.isEmpty else {
            showAlert(VC: self, title: nil, message: "電話不能為空", alertAction: nil)
            return nil
        }
        guard validateCellPhone(text: phone) else {
            showAlert(VC: self, title: nil, message: "電話格式不對", alertAction: nil)
            return nil
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showAlert(VC: self, title: nil, message: "密碼不能為空", alertAction: nil)
            return nil
        }
        guard validatePassword(text: password) else {
            showAlert(VC: self, title: nil, message: "密碼格式不對", alertAction: nil)
            return nil
        }
        
        guard let birth = birthdayTextfield.text, !birth.isEmpty else {
            showAlert(VC: self, title: nil, message: "生日不能為空", alertAction: nil)
            return nil
        }
        
        guard let gender = genderSelectionView.selectedGender else {
            showAlert(VC: self, title: nil, message: "性別不能為空", alertAction: nil)
            return nil
        }
        
        guard privacyCheckBox.checkState == .checked else {
            showAlert(VC: self, title: nil, message: "請閱讀並同意隱私政策", alertAction: nil)
            return nil
        }
        
        return (phone, password, birth, gender)
    }
    
    private func setupPrivacyCheckbox() {
        privacyCheckBox.boxType = .square
        privacyCheckBox.stateChangeAnimation = .fill
        privacyCheckBox.tintColor = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
        privacyCheckBox.isUserInteractionEnabled = false
        privacyCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        let privacyLabel = UILabel()
        privacyLabel.text = "閱讀隱私政策並同意"
        privacyLabel.font = UIFont(name: "GenJyuuGothic-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        privacyLabel.textColor = .black
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        privacyStackView.axis = .horizontal
        privacyStackView.spacing = 8
        privacyStackView.alignment = .center
        privacyStackView.distribution = .fill
        privacyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        privacyStackView.addArrangedSubview(privacyCheckBox)
        privacyStackView.addArrangedSubview(privacyLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyStackView.addGestureRecognizer(tap)
        privacyStackView.isUserInteractionEnabled = true
        
        view.addSubview(privacyStackView)
        
        var backgroundView: UIView? = nil
        if let oldConstraint = view.constraints.first(where: {
            ($0.firstItem as? UIView == registerBtn && $0.firstAttribute == .top)
        }) {
            backgroundView = oldConstraint.secondItem as? UIView
            oldConstraint.isActive = false
        }
        
        NSLayoutConstraint.activate([
            privacyCheckBox.widthAnchor.constraint(equalToConstant: 18),
            privacyCheckBox.heightAnchor.constraint(equalToConstant: 18),
            
            privacyStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyStackView.topAnchor.constraint(equalTo: backgroundView?.bottomAnchor ?? view.topAnchor, constant: 10),
            registerBtn.topAnchor.constraint(equalTo: privacyStackView.bottomAnchor, constant: 15)
        ])
    }
    
    private func setupHsinchuTongLoginButton() {
        hsinchuTongLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        hsinchuTongLoginBtn.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3529411765, blue: 0.3098039216, alpha: 1)
        hsinchuTongLoginBtn.layer.cornerRadius = 20
        hsinchuTongLoginBtn.titleLabel?.font = UIFont(name: "GenJyuuGothic-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        hsinchuTongLoginBtn.setTitle("使用新竹通登入", for: .normal)
        hsinchuTongLoginBtn.setTitleColor(.white, for: .normal)
        hsinchuTongLoginBtn.addTarget(self, action: #selector(hsinchuTongLoginTapped), for: .touchUpInside)

        hsinchuTongLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        hsinchuTongLoadingIndicator.color = .white
        hsinchuTongLoadingIndicator.hidesWhenStopped = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hsinchuTongAuthorizationCodeReceived(_:)),
            name: HsinchuTongOAuth.authorizationCodeDidReceive,
            object: nil
        )

        view.addSubview(hsinchuTongLoginBtn)
        hsinchuTongLoginBtn.addSubview(hsinchuTongLoadingIndicator)
        NSLayoutConstraint.activate([
            hsinchuTongLoadingIndicator.centerXAnchor.constraint(equalTo: hsinchuTongLoginBtn.centerXAnchor),
            hsinchuTongLoadingIndicator.centerYAnchor.constraint(equalTo: hsinchuTongLoginBtn.centerYAnchor)
        ])

        // 「新竹通登入」夾在「註冊並收取驗證碼」與「回首頁」之間，
        // 因此把 storyboard 裡「回首頁 top 貼齊 registerBtn bottom」的約束拆掉改接。
        if let goHomeTopConstraint = view.constraints.first(where: {
            ($0.firstItem as? UIView == goHomeBtn && $0.firstAttribute == .top)
        }) {
            goHomeTopConstraint.isActive = false
        }

        NSLayoutConstraint.activate([
            hsinchuTongLoginBtn.centerXAnchor.constraint(equalTo: registerBtn.centerXAnchor),
            hsinchuTongLoginBtn.widthAnchor.constraint(equalTo: registerBtn.widthAnchor),
            hsinchuTongLoginBtn.heightAnchor.constraint(equalTo: registerBtn.heightAnchor),
            hsinchuTongLoginBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 10),
            goHomeBtn.topAnchor.constraint(equalTo: hsinchuTongLoginBtn.bottomAnchor, constant: 10)
        ])
    }

    @objc private func hsinchuTongLoginTapped() {
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

    /// 步驟 4、5：拿到 login_code，傳給我方後端換取使用者資料。
    @objc private func hsinchuTongAuthorizationCodeReceived(_ notification: Notification) {
        guard let loginCode = notification.userInfo?["login_code"] as? String, !loginCode.isEmpty else { return }
        exchangeHsinchuTongCode(loginCode)
    }

    private func setHsinchuTongLoading(_ loading: Bool) {
        hsinchuTongLoginBtn.isEnabled = !loading
        hsinchuTongLoginBtn.setTitle(loading ? "" : "使用新竹通登入", for: .normal)
        loading ? hsinchuTongLoadingIndicator.startAnimating() : hsinchuTongLoadingIndicator.stopAnimating()
    }

    private func exchangeHsinchuTongCode(_ loginCode: String) {
        // WKWebView 攔截與 Universal Link 備援可能同時觸發，避免重複打 API。
        guard !isExchangingHsinchuTong else { return }
        isExchangingHsinchuTong = true
        setHsinchuTongLoading(true)
        let exchangeURL = APIUrl.domainName + APIUrl.hsinchuTongExchange
        HsinchuTongOAuth.log("換資料請求 → POST \(exchangeURL)　login_code=\(loginCode)")
        NetworkManager.shared.requestWithJSONBody(
            urlString: exchangeURL,
            parameters: ["login_code": loginCode, "provider": HsinchuTongOAuth.expectedProvider]
        ) { [weak self] data, statusCode, errorMessage in
            guard let self = self else { return }
            self.isExchangingHsinchuTong = false
            self.setHsinchuTongLoading(false)

            let bodyString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<nil>"
            HsinchuTongOAuth.log("換資料回應 ← status=\(statusCode.map(String.init) ?? "nil")　error=\(errorMessage ?? "nil")　body=\(bodyString)")

            guard statusCode == 200, let data = data else {
                showAlert(VC: self, title: nil, message: errorMessage ?? "新竹通登入失敗，請稍後再試", alertAction: nil)
                return
            }
            do {
                let result = try JSONDecoder().decode(HsinchuTongLoginResult.self, from: data)
                guard result.isSuccess, let member = result.member else {
                    HsinchuTongOAuth.log("回應 status 非 success 或缺 member：status=\(result.status ?? "nil")")
                    showAlert(VC: self, title: nil, message: "新竹通登入結果異常，請稍後再試", alertAction: nil)
                    return
                }
                HsinchuTongOAuth.log("解析成功　phone=\(member.phoneNumber ?? "nil")　name=\(member.name ?? "nil")　email=\(member.email ?? "nil")　birthday=\(member.birthday ?? "nil")　openid=\(member.openid ?? "nil")")
                self.applyHsinchuTongMember(member)
            } catch {
                HsinchuTongOAuth.log("JSON 解析失敗：\(error)")
                showAlert(VC: self, title: nil, message: "新竹通資料解析失敗", alertAction: nil)
            }
        }
    }

    /// 把後端整理好的資料帶入註冊頁，讓使用者確認／補完。
    /// 新竹通不提供性別，性別欄位維持讓使用者自行選擇。
    private func applyHsinchuTongMember(_ member: HsinchuTongLoginResult.Member) {
        if let phone = member.phoneNumber, !phone.isEmpty {
            phoneTextfield.text = phone
        }
        if let birthday = member.birthday, !birthday.isEmpty {
            birthdayTextfield.text = normalizedBirthday(birthday)
        }
        // 註冊頁目前沒有姓名 / Email 欄位，先暫存，待註冊流程串接。
        hsinchuTongUserName = member.name
        hsinchuTongUserEmail = member.email
        hsinchuTongOpenID = member.openid

        showAlert(VC: self, title: nil, message: "已帶入新竹通資料，請確認並補完後完成註冊", alertAction: nil)
    }

    /// 把新竹通生日字串正規化為註冊頁使用的 yyyy/MM/dd；無法解析時回傳原字串。
    private func normalizedBirthday(_ raw: String) -> String {
        let output = DateFormatter()
        output.locale = Locale(identifier: "en_US_POSIX")
        output.dateFormat = "yyyy/MM/dd"

        for format in ["yyyy-MM-dd", "yyyy/MM/dd", "yyyyMMdd", "yyyy-MM-dd'T'HH:mm:ss"] {
            let input = DateFormatter()
            input.locale = Locale(identifier: "en_US_POSIX")
            input.dateFormat = format
            if let date = input.date(from: raw) {
                return output.string(from: date)
            }
        }
        return raw
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: HsinchuTongOAuth.authorizationCodeDidReceive, object: nil)
    }

    @objc private func privacyTapped() {
        let privacyView = PrivacyAlertView(frame: UIScreen.main.bounds)
        privacyView.onAgree = { [weak self] in
            self?.privacyCheckBox.checkState = .checked
        }
        privacyView.onCancel = { [weak self] in
            self?.privacyCheckBox.checkState = .unchecked
        }
        keyWindow?.addSubview(privacyView)
    }

}

// MARK: - 新竹通登入 WebView

/// 在 App 內以 WKWebView 跑新竹通 OAuth 登入頁，攔截後端導回 callback 網址中的 `login_code`。
/// 不需要 AASA / custom scheme；風險是 id.hccg.gov.tw SSO 可能擋內嵌 webview。
final class HsinchuTongLoginWebVC: UIViewController {

    /// 完成回呼：帶回 login_code；使用者取消或載入失敗時回傳 nil。
    var onComplete: ((String?) -> Void)?

    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let progressView = UIActivityIndicatorView(style: .large)
    private var barBottomAnchor: NSLayoutYAxisAnchor?
    private var didFinishFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBar()
        setupWebView()
        loadLoginStart()
    }

    private func setupBar() {
        let bar = UIView()
        bar.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3529411765, blue: 0.3098039216, alpha: 1)
        bar.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "新竹通登入"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "GenJyuuGothic-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("關閉", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.titleLabel?.font = UIFont(name: "GenJyuuGothic-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
        closeBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bar)
        bar.addSubview(titleLabel)
        bar.addSubview(closeBtn)
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: view.topAnchor),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            titleLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bar.bottomAnchor, constant: -10),

            closeBtn.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -16),
            closeBtn.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        barBottomAnchor = bar.bottomAnchor
    }

    private func setupWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.hidesWhenStopped = true

        view.addSubview(webView)
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: barBottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadLoginStart() {
        guard let url = URL(string: HsinchuTongOAuth.loginStartURL) else {
            HsinchuTongOAuth.log("loginStartURL 無效：\(HsinchuTongOAuth.loginStartURL)")
            finish(with: nil)
            return
        }
        HsinchuTongOAuth.log("WebView 載入起始頁：\(url.absoluteString)")
        webView.load(URLRequest(url: url))
    }

    private func finish(with loginCode: String?) {
        guard !didFinishFlow else { return }
        didFinishFlow = true
        HsinchuTongOAuth.log("流程結束　login_code=\(loginCode ?? "nil（取消或失敗）")")
        let handler = onComplete
        dismiss(animated: true) { handler?(loginCode) }
    }

    @objc private func closeTapped() {
        finish(with: nil)
    }
}

extension HsinchuTongLoginWebVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        HsinchuTongOAuth.log("導航 → \(url?.absoluteString ?? "nil")")
        if let url = url, let code = HsinchuTongOAuth.loginCode(from: url) {
            HsinchuTongOAuth.log("攔到 callback，取消導航，login_code=\(code)")
            decisionHandler(.cancel)
            finish(with: code)
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.stopAnimating()
        HsinchuTongOAuth.log("頁面載入完成：\(webView.url?.absoluteString ?? "nil")")
        // 備援：callback 若以 client-side 方式補上 #fragment，decidePolicyFor 不會再觸發。
        if let url = webView.url, let code = HsinchuTongOAuth.loginCode(from: url) {
            finish(with: code)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.stopAnimating()
        HsinchuTongOAuth.log("didFail：\(error)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.stopAnimating()
        HsinchuTongOAuth.log("didFailProvisionalNavigation：\(error)　didFinishFlow=\(didFinishFlow)")
        // 我方主動 .cancel（攔到 callback）也會走到這裡，且流程結束後不需再提示。
        // NSURLErrorCancelled(-999) 或 WebKitErrorDomain 102（frame load interrupted）都是取消造成的。
        let ns = error as NSError
        let isCancel = ns.code == NSURLErrorCancelled || (ns.domain == "WebKitErrorDomain" && ns.code == 102)
        if didFinishFlow || isCancel { return }
        showAlert(VC: self, title: nil, message: "無法開啟新竹通登入頁，請稍後再試", alertAction: UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            self?.finish(with: nil)
        })
    }
}
