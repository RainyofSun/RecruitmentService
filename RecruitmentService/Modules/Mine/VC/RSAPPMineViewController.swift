//
//  RSAPPMineViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit
import Kingfisher

class RSAPPMineViewController: APBaseViewController, HideNavigationBarProtocol {

    private lazy var avatarBtn: UIButton = UIButton.buildImageButton(normalImg: "user_default_image")
    private lazy var loginBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("mine_login_tatus_unlogin"), titleColor: BLACK_COLOR_333333, titleFont: UIFont.systemFont(ofSize: 16), backgroudColor: .clear)
    private lazy var taskContentView: UIView = UIView(frame: CGRectZero)
    private lazy var allTaskBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var publishTaskBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var waitPublishTaskBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var stopTaskBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    private lazy var tipLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("mine_login_tip"), titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 15))
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    private lazy var aboutItem: RSAPPMineItem = RSAPPMineItem(frame: CGRectZero, itemType: APPMineItemType.Mine_AboutUs)
    private lazy var userPrivacyItem: RSAPPMineItem = RSAPPMineItem(frame: CGRectZero, itemType: APPMineItemType.Mine_UserPrivacy)
    private lazy var privacyItem: RSAPPMineItem = RSAPPMineItem(frame: CGRectZero, itemType: APPMineItemType.Mine_Privacy)
    private lazy var cancelItem: RSAPPMineItem = RSAPPMineItem(frame: CGRectZero, itemType: APPMineItemType.Mine_Cancel)
    private lazy var loginoutBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("mine_logout"), titleColor: UIColor.hexString("#9CA3AF"), titleFont: UIFont.systemFont(ofSize: 15), backgroudColor: UIColor.hexString("#F3F6FE"), cornerRadius: 4)

    override func buildViewUI() {
        super.buildViewUI()
        self.loginoutBtn.layer.borderWidth = 1
        self.loginoutBtn.layer.borderColor = UIColor.hexString("#E1E1E1").cgColor
        self.loginBtn.titleLabel?.numberOfLines = .zero
        self.loginoutBtn.isHidden = true
        
        Global.shared.addObserver(self, forKeyPath: APP_LOGIN_KEY, options: .new, context: nil)
        self.avatarBtn.layer.cornerRadius = 32
        self.avatarBtn.clipsToBounds = true
        
        self.allTaskBtn.titleLabel?.numberOfLines = .zero
        self.allTaskBtn.titleLabel?.textAlignment = .center
        self.publishTaskBtn.titleLabel?.numberOfLines = .zero
        self.publishTaskBtn.titleLabel?.textAlignment = .center
        self.waitPublishTaskBtn.titleLabel?.numberOfLines = .zero
        self.waitPublishTaskBtn.titleLabel?.textAlignment = .center
        self.stopTaskBtn.titleLabel?.numberOfLines = .zero
        self.stopTaskBtn.titleLabel?.textAlignment = .center
        
        self.avatarBtn.addTarget(self, action: #selector(clickMineAvatar(sender: )), for: UIControl.Event.touchUpInside)
        self.loginBtn.addTarget(self, action: #selector(gotoLogin(sender: )), for: UIControl.Event.touchUpInside)
        self.aboutItem.addTarget(self, action: #selector(clickMineItem(sender: )), for: UIControl.Event.touchUpInside)
        self.privacyItem.addTarget(self, action: #selector(clickMineItem(sender: )), for: UIControl.Event.touchUpInside)
        self.userPrivacyItem.addTarget(self, action: #selector(clickMineItem(sender: )), for: UIControl.Event.touchUpInside)
        self.cancelItem.addTarget(self, action: #selector(clickMineItem(sender: )), for: UIControl.Event.touchUpInside)
        self.loginoutBtn.addTarget(self, action: #selector(clickLogoutButton(sender: )), for: UIControl.Event.touchUpInside)
        self.allTaskBtn.addTarget(self, action: #selector(clickTaskButton(sender: )), for: UIControl.Event.touchUpInside)
        self.publishTaskBtn.addTarget(self, action: #selector(clickTaskButton(sender: )), for: UIControl.Event.touchUpInside)
        self.waitPublishTaskBtn.addTarget(self, action: #selector(clickTaskButton(sender: )), for: UIControl.Event.touchUpInside)
        self.stopTaskBtn.addTarget(self, action: #selector(clickTaskButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.allTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item1")), for: UIControl.State.normal)
        self.publishTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item2")), for: UIControl.State.normal)
        self.waitPublishTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item3")), for: UIControl.State.normal)
        self.stopTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item4")), for: UIControl.State.normal)
        
        self.contentView.addSubview(self.avatarBtn)
        self.contentView.addSubview(self.loginBtn)
        self.contentView.addSubview(self.taskContentView)
        self.taskContentView.addSubview(self.allTaskBtn)
        self.taskContentView.addSubview(self.publishTaskBtn)
        self.taskContentView.addSubview(self.waitPublishTaskBtn)
        self.taskContentView.addSubview(self.stopTaskBtn)
        self.contentView.addSubview(self.tipLab)
        self.contentView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.aboutItem)
        self.subContentView.addSubview(self.userPrivacyItem)
        self.subContentView.addSubview(self.privacyItem)
        self.subContentView.addSubview(self.cancelItem)
        self.contentView.addSubview(self.loginoutBtn)
        
        self.pageRequest()
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.avatarBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(PADDING_UNIT * 5)
            make.size.equalTo(64)
        }
        
        self.loginBtn.snp.makeConstraints { make in
            make.left.equalTo(self.avatarBtn.snp.right).offset(PADDING_UNIT)
            make.centerY.equalTo(self.avatarBtn)
        }
        
        self.taskContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 8)
            make.top.equalTo(self.avatarBtn.snp.bottom).offset(PADDING_UNIT * 5)
        }
        
        self.allTaskBtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.publishTaskBtn.snp.makeConstraints { make in
            make.left.equalTo(self.allTaskBtn.snp.right)
            make.top.width.equalTo(self.allTaskBtn)
        }
        
        self.waitPublishTaskBtn.snp.makeConstraints { make in
            make.left.equalTo(self.publishTaskBtn.snp.right)
            make.top.width.equalTo(self.publishTaskBtn)
        }
        
        self.stopTaskBtn.snp.makeConstraints { make in
            make.left.equalTo(self.waitPublishTaskBtn.snp.right)
            make.top.width.equalTo(self.waitPublishTaskBtn)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.top.equalTo(self.allTaskBtn.snp.bottom).offset(PADDING_UNIT * 5)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.left.equalTo(self.tipLab)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 6)
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 3)
        }
        
        self.aboutItem.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        self.userPrivacyItem.snp.makeConstraints { make in
            make.top.equalTo(self.aboutItem.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.privacyItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.userPrivacyItem.snp.bottom)
        }
        
        self.cancelItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.privacyItem.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        self.loginoutBtn.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.top.equalTo(self.subContentView.snp.bottom).offset(PADDING_UNIT * 34)
            make.horizontalEdges.equalTo(self.subContentView)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 10)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        NetworkRequest(RSAPPNetworkAPI.GetUserHeadImage, modelType: RSAPPMineAvatarModel.self) { [weak self] (res: HandyJSON, res1: SuccessResponse) in
            guard let _avatarModel = res as? RSAPPMineAvatarModel, let _text_url = _avatarModel.headImage, let _url = URL(string: _text_url) else {
                return
            }
            
            self?.avatarBtn.kf.setImage(with: _url, for: UIControl.State.normal, options: [.transition(.fade(0.3))])
        }
        
        self.loginoutBtn.isHidden = !Global.shared.appLogin
        self.cancelItem.isHidden = self.loginoutBtn.isHidden
        
        if Global.shared.appLogin {
            if let _name = Global.shared.userData?.userId, let _phone = Global.shared.userData?.phone {
                let paramStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                paramStyle.paragraphSpacing = PADDING_UNIT * 2
                let tempStr1: NSMutableAttributedString = NSMutableAttributedString(string: "\(_name)\n", attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.boldSystemFont(ofSize: 18), .paragraphStyle: paramStyle])
                tempStr1.append(NSAttributedString(string: self.maskPhoneNumber(_phone), attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.systemFont(ofSize: 12)]))
                self.loginBtn.setAttributedTitle(tempStr1, for: UIControl.State.normal)
            }
            self.queryTask(ALL_REQUIREMENT_KEY, sender: self.allTaskBtn)
            self.queryTask(PUBLISH_REQUIREMENT_FUZZY_QUERY_KEY, sender: self.publishTaskBtn)
            self.queryTask(SAVE_REQUIREMENT_FUZZY_QUERY_KEY, sender: self.waitPublishTaskBtn)
            self.queryTask(STOP_REQUIREMENT_FUZZY_QUERY_KEY, sender: self.stopTaskBtn)
        } else {
            self.loginBtn.setAttributedTitle(nil, for: UIControl.State.normal)
            self.loginBtn.setTitle(RSAPPLanguage.localValue("mine_login_tatus_unlogin"), for: UIControl.State.normal)
            self.allTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item1")), for: UIControl.State.normal)
            self.publishTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item2")), for: UIControl.State.normal)
            self.waitPublishTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item3")), for: UIControl.State.normal)
            self.stopTaskBtn.setAttributedTitle(self.combineAttributeString(text1: "0", text2: RSAPPLanguage.localValue("publish_top_menu_item4")), for: UIControl.State.normal)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == APP_LOGIN_KEY {
            DispatchQueue.main.async(execute: {
                self.pageRequest()
            })
        }
    }
}

private extension RSAPPMineViewController {
    func combineAttributeString(text1: String, text2: String) -> NSAttributedString {
        let paramStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paramStyle.paragraphSpacing = PADDING_UNIT
        paramStyle.alignment = .center
        let tempStr1: NSMutableAttributedString = NSMutableAttributedString(string: "\(text1)\n", attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.boldSystemFont(ofSize: 21), .paragraphStyle: paramStyle])
        tempStr1.append(NSAttributedString(string: text2, attributes: [.foregroundColor: UIColor.hexString("#AAB0BA"), .font: UIFont.systemFont(ofSize: 12)]))
        
        return tempStr1
    }
    
    func maskPhoneNumber(_ phoneNumber: String) -> String {
        guard phoneNumber.count >= 10 else {
            return phoneNumber
        }
        
        let phoneLength = phoneNumber.count
        let startIndex = phoneNumber.startIndex
        let left: Int = 2
        let right: Int = 4
        let endIndex = phoneNumber.index(startIndex, offsetBy: left)
        let endIndex2 = phoneNumber.index(startIndex, offsetBy: phoneLength - right)
        var str: String = ""
        for _ in 0...(phoneLength - left - right) {
            str += "*"
        }
        let maskedNumber = phoneNumber.replacingCharacters(in: endIndex..<endIndex2, with: str)
        
        return maskedNumber
    }
    
    func queryTask(_ condition: String, sender: UIButton) {
        
        NetworkRequest(RSAPPNetworkAPI.queryRequirementList(key: condition), modelType: [RSAPPRequirementModel].self) {[weak self] (res: [HandyJSON?], res1: SuccessResponse) in
            guard let _models = res as? [RSAPPRequirementModel] else {
                return
            }
            
            if sender == self?.allTaskBtn {
                self?.allTaskBtn.setAttributedTitle(self?.combineAttributeString(text1: "\(_models.count)", text2: RSAPPLanguage.localValue("publish_top_menu_item1")), for: UIControl.State.normal)
            }
            
            if sender == self?.publishTaskBtn {
                self?.publishTaskBtn.setAttributedTitle(self?.combineAttributeString(text1: "\(_models.count)", text2: RSAPPLanguage.localValue("publish_top_menu_item2")), for: UIControl.State.normal)
            }
            
            if sender == self?.waitPublishTaskBtn {
                self?.waitPublishTaskBtn.setAttributedTitle(self?.combineAttributeString(text1: "\(_models.count)", text2: RSAPPLanguage.localValue("publish_top_menu_item3")), for: UIControl.State.normal)
            }
            
            if sender == self?.stopTaskBtn {
                self?.stopTaskBtn.setAttributedTitle(self?.combineAttributeString(text1: "\(_models.count)", text2: RSAPPLanguage.localValue("publish_top_menu_item4")), for: UIControl.State.normal)
            }
        }
    }
}

@objc private extension RSAPPMineViewController {
    func gotoLogin(sender: UIButton) {
        guard !Global.shared.appLogin else {
            return
        }
        let navController = APBaseNavigationController(rootViewController: RSAPPLoginViewController())
        navController.modalPresentationStyle = .fullScreen
        WebPro.enterLoginPage(navController)
    }
    
    func clickMineItem(sender: RSAPPMineItem) {
        switch sender.item_type {
        case .Mine_AboutUs:
            self.navigationController?.pushViewController(RSAPPMineAboutUsViewController(), animated: true)
        case .Mine_UserPrivacy:
//            let _protocolPop = RSAPPBaseAlertView.showAlertView(title: RSAPPLanguage.localValue("mine_protocol_pop_title"), content: RSAPPLanguage.localValue("mine_protocol_pop_content"), rightButtonTitle: RSAPPLanguage.localValue("mine_protocol_close"), superView: self.view) { _ in
//                
//            }
//            _protocolPop.protocolLayout()
            self.navigationController?.pushViewController(RSAPPWebViewController(link_url: USER_PRIVACY), animated: true)
        case .Mine_Privacy:
            self.navigationController?.pushViewController(RSAPPWebViewController(link_url: PRIVACY_POLICY), animated: true)
        case .Mine_Cancel:
            if Global.shared.userData == nil {
                RSAPPBaseAlertView.showAlertView(content: RSAPPLanguage.localValue("mine_pop_unlogin_tip"), rightButtonTitle: RSAPPLanguage.localValue("mine_pop_unlogin_right_title"), rightButtonBgColor: BLUE_COLOR_1874FF, superView: self.view) { (isConfirm: Bool) in
                    if isConfirm {
                        let navController = APBaseNavigationController(rootViewController: RSAPPLoginViewController())
                        navController.modalPresentationStyle = .fullScreen
                        WebPro.enterLoginPage(navController)
                    }
                }
                return
            }
            
            RSAPPBaseAlertView.showAlertView(content: RSAPPLanguage.localValue("mine_pop_cancel"), rightButtonTitle: RSAPPLanguage.localValue("mine_pop_cancel_right_title"), rightButtonBgColor: UIColor.hexString("#EA0000"), superView: self.view) { (isConfirm: Bool) in
                if isConfirm {
                    WebPro.logoutAccount()
                    Global.shared.userData = nil
                }
            }
        }
    }
    
    func clickMineAvatar(sender: UIButton) {
        if !Global.shared.appLogin {
            self.gotoLogin(sender: sender)
            return
        }
        
        self.showTZImagePicker(delegate: self)
    }
    
    func clickLogoutButton(sender: UIButton) {
        WebPro.logoutAccount()
        Global.shared.userData = nil
    }
    
    func clickTaskButton(sender: UIButton) {
        if Global.shared.userData == nil {
            RSAPPBaseAlertView.showAlertView(content: RSAPPLanguage.localValue("mine_pop_unlogin_tip"), rightButtonTitle: RSAPPLanguage.localValue("mine_pop_unlogin_right_title"), rightButtonBgColor: BLUE_COLOR_1874FF, superView: self.view) { (isConfirm: Bool) in
                if isConfirm {
                    let navController = APBaseNavigationController(rootViewController: RSAPPLoginViewController())
                    navController.modalPresentationStyle = .fullScreen
                    WebPro.enterLoginPage(navController)
                }
            }
            return
        }
        
        var status: RequirementStatus?
        if sender == self.publishTaskBtn {
            status = .Published
        }
        
        if sender == self.waitPublishTaskBtn {
            status = .ToBePublished
        }
        
        if sender == self.stopTaskBtn {
            status = .RecruitmentEnded
        }
        
        guard let _tabController = self.tabBarController as? APBaseTabBarController else {
            return
        }
        
        _tabController.selectedIndex = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            NotificationCenter.default.post(name: APPGoToPublishTabNotification, object: status)
        })
    }
}

// MARK: TZImagePickerControllerDelegate
extension RSAPPMineViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        guard let image = photos.first else {
            return
        }

        if let _img_compress_data = image.compressImageToTargetSize(maxLength: 1024 * 1024), let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first, let _compree_img = UIImage(data: _img_compress_data) {
            // 存储到临时路径下
            let _file_name = Date.jk.secondStamp
            let filePath: String = document + "/\(_file_name).png"
            do {
                try? _img_compress_data.write(to: URL(fileURLWithPath: filePath))
            }
            
            NetworkRequest(RSAPPNetworkAPI.UploadUserHeadImage(image: filePath), modelType: RSAPPBaseResponseModel.self) { [weak self] (res: HandyJSON, res1: SuccessResponse) in
                self?.avatarBtn.setImage(_compree_img, for: UIControl.State.normal)
            }
        }
    }
}
