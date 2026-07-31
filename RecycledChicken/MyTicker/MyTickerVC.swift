//
//  MyTickerVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
import SkeletonView
class MyTickerVC: CustomVC {
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    @IBOutlet weak var lotteryTableView:UITableView!
    
    @IBOutlet weak var voucherTableView:UITableView!

    private var myTickertInfos:[MyTickertLotteryInfo] = []
    
    private var myVoucherInfos:[MyTickertCouponsInfo] = []
    
    private lazy var tableViews = [lotteryTableView, voucherTableView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "myWallet".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(MyTickertTitles)
        segmentedControl.delegate = self
        lotteryTableView.setSeparatorLocation()
        lotteryTableView.startSkeletonAnimation()
        voucherTableView.setSeparatorLocation()
    }
    
    private func getVoucherData() {
        Task {
            do {
                let voucherInfos = try await fetchVoucherDataAsync()
                await MainActor.run {
                    self.myVoucherInfos = voucherInfos
                    self.reloadTableViewWithAnimation(self.voucherTableView)
                }
            } catch {
                await MainActor.run {
                    if let netError = error as? NetworkError {
                        self.handleNetworkError(netError)
                    } else {
                        showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getLotteryData() {
        Task {
            do {
                let lotteryInfos = try await fetchLotteryDataAsync()
                await MainActor.run {
                    self.myTickertInfos = lotteryInfos
                    self.reloadTableViewWithAnimation(self.lotteryTableView)
                }
            } catch {
                await MainActor.run {
                    if let netError = error as? NetworkError {
                        self.handleNetworkError(netError)
                    } else {
                        showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func fetchLotteryDataAsync() async throws -> [MyTickertLotteryInfo] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.havingLottery,authorizationToken: CommonKey.shared.authToken, responseType: [MyTickertLotteryInfo].self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchVoucherDataAsync() async throws -> [MyTickertCouponsInfo] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.havingCoupons, authorizationToken: CommonKey.shared.authToken, responseType: [MyTickertCouponsInfo].self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func reloadTableViewWithAnimation(_ tableView: UITableView?) {
        tableView?.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tableView?.stopSkeletonAnimation()
            self.view.hideSkeleton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getLotteryData()
        getVoucherData()
    }
    
    private func getNumberOfRowsInSection(_ tableView:UITableView) -> Int {
        if tableView == lotteryTableView {
            return myTickertInfos.count
        }
        if tableView == voucherTableView {
            return myVoucherInfos.count
        }
        return 0
    }
    
    private func pushToCheckStoreNumberVC(_ info: MyTickertCouponsInfo) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CheckStoreNumber", bundle: Bundle.main).instantiateViewController(identifier: "CheckStoreNumber") as? CheckStoreNumberVC {
            VC.myTickertCouponsInfo = info
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func showQRCodeBottomSheet(_ info: MyTickertCouponsInfo) {
        let centerImage = UIImage(named: "ic_normal_mark")
        guard let code = info.code, let payload = makeQRCodePayload(info), let qrImage = generateQRCode(from: payload, centerImage: centerImage) else {
            showAlert(VC: self, title: "error".localized)
            return
        }
        let vc = CouponQRCodeBottomSheetVC(qrImage: qrImage, code: code)
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    private func makeQRCodePayload(_ info: MyTickertCouponsInfo) -> String? {
        guard let name = info.name, let code = info.code else { return nil }
        let userID = CurrentUserInfo.shared.currentProfileNewInfo?.userPhoneNumber ?? CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber
        guard !userID.isEmpty else { return nil }
        let payload = CouponQRCodePayload(name: name, userID: userID, code: code)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(payload) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private func generateQRCode(from string: String, centerImage: UIImage?) -> UIImage? {
        guard let data = string.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else { return nil }
        let backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.84, alpha: 1)
        let coloredImage = outputImage.applyingFilter("CIFalseColor", parameters: [
            "inputColor0": CIColor(color: .black),
            "inputColor1": CIColor(color: backgroundColor)
        ])
        let transformedImage = coloredImage.transformed(by: CGAffineTransform(scaleX: 12, y: 12))
        let context = CIContext()
        guard let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) else { return nil }
        let qrImage = UIImage(cgImage: cgImage)
        guard let centerImage = centerImage else { return qrImage }
        return drawCenterImage(centerImage, on: qrImage)
    }
    
    private func drawCenterImage(_ centerImage: UIImage, on qrImage: UIImage) -> UIImage {
        let backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.84, alpha: 1)
        let renderer = UIGraphicsImageRenderer(size: qrImage.size)
        return renderer.image { context in
            qrImage.draw(in: CGRect(origin: .zero, size: qrImage.size))
            
            let imageSide = qrImage.size.width * 0.12
            let padding = imageSide * 0.16
            let backgroundSide = imageSide + padding * 2
            let backgroundRect = CGRect(
                x: (qrImage.size.width - backgroundSide) / 2,
                y: (qrImage.size.height - backgroundSide) / 2,
                width: backgroundSide,
                height: backgroundSide
            )
            let imageRect = backgroundRect.insetBy(dx: padding, dy: padding)
            
            context.cgContext.saveGState()
            UIBezierPath(roundedRect: backgroundRect, cornerRadius: backgroundSide * 0.2).addClip()
            backgroundColor.setFill()
            UIRectFill(backgroundRect)
            centerImage.draw(in: imageRect)
            context.cgContext.restoreGState()
        }
    }

}

extension MyTickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == lotteryTableView {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == lotteryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerTableViewCell.identifier, for: indexPath) as! MyTickerTableViewCell
            cell.setCell(myTickertInfos[indexPath.row])
            return cell
        }
        if tableView == voucherTableView {
            let row = indexPath.row
            let myVoucherInfo = myVoucherInfos[row]
            if let link = myVoucherInfo.link, !link.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerVoucherTableViewCell.identifier, for: indexPath) as! MyTickerVoucherTableViewCell
                cell.setCell(myVoucherInfo)
                return cell
            }
            if let pwd = myVoucherInfo.pwd, !pwd.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerYiRuiTableViewCell.identifier, for: indexPath) as! MyTickerYiRuiTableViewCell
                cell.delegate = self
                cell.setCell(myVoucherInfo)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketVoucherSerialNumberTableViewCell.identifier, for: indexPath) as! MyTicketVoucherSerialNumberTableViewCell
                cell.delegate = self
                cell.setCell(myVoucherInfo)
                if myVoucherInfo.status == "complete" {
                    cell.compeletedAction()
                } else {
                    cell.noCompeletedAction()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension MyTickerVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == lotteryTableView {
            return MyTickerTableViewCell.identifier
        }
        if skeletonView == voucherTableView {
            return MyTickerVoucherTableViewCell.identifier
        }
        return ""
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(skeletonView)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
}


extension MyTickerVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        for tableView in tableViews {
            let tag = tableView?.tag
            if tag == index {
                tableView?.isHidden = false
            }
            if tag != index {
                tableView?.isHidden = true
            }
        }
    }
    
}

extension MyTickerVC: MyTickerYiRuiTableViewCellDelegate {
    
    func button(_ sender: UIButton, info: MyTickertCouponsInfo) {
        if info.redeemType != nil {
            showQRCodeBottomSheet(info)
            return
        }
        if let partner = info.partner, !partner.isEmpty {
            pushToCheckStoreNumberVC(info)
            return
        }
        guard let link = info.link, let url = URL(string: link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func copyPassword(_ password: String) {
        UIPasteboard.general.string = password
        showAlert(VC: self, title: "copySuccess".localized)
    }
}

extension MyTickerVC: MyTicketVoucherSerialNumberTableViewCellDelegate {}

private struct CouponQRCodePayload: Encodable {
    let name: String
    let userID: String
    let code: String
}

private final class CouponQRCodeBottomSheetVC: UIViewController {
    
    private let qrImage: UIImage
    private let code: String
    
    init(qrImage: UIImage, code: String) {
        self.qrImage = qrImage
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.84, alpha: 1)
        setupUI()
    }
    
    private func setupUI() {
        let imageView = UIImageView(image: qrImage)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = view.backgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let codeLabel = UILabel()
        codeLabel.text = code
        codeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        codeLabel.textColor = .darkGray
        codeLabel.textAlignment = .center
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeLabel)
        
        let closeButton = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: symbolConfig), for: .normal)
        closeButton.tintColor = .darkGray
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: closeButton.bottomAnchor, constant: 8),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.85),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            codeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            codeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }
}

