//
//  PersonMessageVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit
import SkeletonView

class PersonMessageVC: CustomVC {
    
    @IBOutlet weak var personMessageTableView:UITableView!
    
    private var personMessageInfos:[PersonMessageInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "personalNotifications".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getData()
    }
    
    private func UIInit(){
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(showDeleteAllMessage(_:)))
        backBtn.tintColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        navigationItem.rightBarButtonItem = backBtn
        personMessageTableView.setSeparatorLocation()
        personMessageTableView.showAnimatedSkeleton()
    }
    
    @objc private func showDeleteAllMessage(_ sender:UIBarButtonItem) {
        let deleteAllMessageAlertView = DeleteAllMessageAlertView(frame: UIScreen.main.bounds)
        deleteAllMessageAlertView.delegate = self
        keyWindow?.addSubview(deleteAllMessageAlertView)
    }

    private func getData() {
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.message,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: [PersonMessageInfo].self) { [weak self] result in
            switch result {
            case .success(let personMessageInfos):
                self?.personMessageInfos.removeAll()
                self?.personMessageInfos = personMessageInfos
                DispatchQueue.main.async {
                    self?.personMessageTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.personMessageTableView.stopSkeletonAnimation()
                        self?.view.hideSkeleton()
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                }
            }
        }
    }
}

extension PersonMessageVC: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        PersonMessageTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personMessageInfos.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PersonMessageContent", bundle: Bundle.main).instantiateViewController(identifier: "PersonMessageContent") as? PersonMessageContentVC {
            VC.personMessageInfo = personMessageInfos[indexPath.row]
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personMessageInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonMessageTableViewCell.identifier, for: indexPath) as! PersonMessageTableViewCell
        cell.delegate = self
        let info = personMessageInfos[indexPath.row]
        cell.setCell(info)
        return cell
    }
    
    private func deleteMessage(_ personMessageInfosDic: [[String: Any]]) {
        guard personMessageInfosDic.count > 0 else { return }
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.messageDelete,
                                    parametersArray: personMessageInfosDic,
                                    authorizationToken: CommonKey.shared.authToken,
                                    responseType: ApiResult.self) { [weak self] result in
            switch result {
            case .success(let apiResult):
                if let status = apiResult.status {
                    switch status {
                    case .success:
                        DispatchQueue.main.async {
                            if let navigationController = self?.navigationController {
                                navigationController.popViewController(animated: true)
                            }
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            showAlert(VC: self, title: apiResult.message ?? "")
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

extension PersonMessageVC:PersonMessageTableViewCellDelegate {
    
    func callBack(_ personMessageInfo: PersonMessageInfo) {
        if let index = personMessageInfos.firstIndex(where: { $0.createTime == personMessageInfo.createTime }) {
            personMessageInfos[index].isShowDeleteView = true
        }
    }
    
    func tapDeleteViewPress(_ indexPath: IndexPath) {
        guard personMessageInfos.count > 0, let dic = try? personMessageInfos[indexPath.row].asDictionary() else { return }
        var personMessageInfosDic:[[String:Any]] = []
        personMessageInfosDic.append(dic)
        deleteMessage(personMessageInfosDic)
    }
    
}

extension PersonMessageVC:DeleteAllMessageAlertViewDelegate {
    
    func deleteAllMessage() {
        guard personMessageInfos.count > 0 else { return }
        var personMessageInfosDic:[[String:Any]] = []
        personMessageInfos.forEach { info in
            if let infoDic = try? info.asDictionary() {
                personMessageInfosDic.append(infoDic)
            }
        }
        deleteMessage(personMessageInfosDic)
    }
    
}
