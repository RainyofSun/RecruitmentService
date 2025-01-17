//
//  RSAPPLoginViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/17.
//

import UIKit
import JWAquites

class RSAPPLoginViewController: APBaseViewController, HideNavigationBarProtocol {
    
    open var hideVistorLogin: Bool = false {
        didSet {
            self.vistorBtn.isHidden = hideVistorLogin
        }
    }
    
    private lazy var vistorBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("login_vistor"), titleColor: BLACK_COLOR_333333, titleFont: UIFont.systemFont(ofSize: 16), backgroudColor: UIColor.clear)
    private lazy var logoImgView: UIImageView = UIImageView(image: UIImage(named: "applogoSmall"))
    private lazy var titleLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("login_tip"), titleColor: BLACK_COLOR_333333, labFont: UIFont.systemFont(ofSize: 15))
    private lazy var phoneTextFiled: RSAPPCustomTextFiled = {
        let view = RSAPPCustomTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        view.attributedPlaceholder = NSAttributedString(string: RSAPPLanguage.localValue("login_phone_placeholder"), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 14)])
        view.textColor = BLACK_COLOR_333333
        view.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return view
    }()
    
    private lazy var codeTextFiled: RSAPPCustomTextFiled = {
        let view = RSAPPCustomTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        view.attributedPlaceholder = NSAttributedString(string: RSAPPLanguage.localValue("login_code_placeholder"), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 14)])
        view.textColor = BLACK_COLOR_333333
        view.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return view
    }()
    
    private lazy var timeBtn: RSAPPTimeButton = RSAPPTimeButton(frame: CGRectZero)
    private lazy var tipLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("login_login_tip"), titleColor: UIColor.hexString("#6B7280"), labFont: UIFont.systemFont(ofSize: 12))
    private lazy var loginBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("login_btn_title"), titleColor: .white)
    
    private lazy var protocolBtn: UIButton = UIButton.buildImageButton(normalImg: "login_protocol_nor", selectedImg: "login_protocol_sel")
    
    private lazy var privacyTextView: UITextView = {
        let view = UITextView(frame: CGRectZero)
        let ocStr: NSString = RSAPPLanguage.localValue("login_protocol1") + RSAPPLanguage.localValue("login_protocol2") + RSAPPLanguage.localValue("login_protocol3") + RSAPPLanguage.localValue("login_protocol4") as NSString
        let contentStr: NSMutableAttributedString = NSMutableAttributedString(string: ocStr as String, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.hexString("#4B5563")])
        contentStr.addAttributes([.foregroundColor: BLUE_COLOR_1874FF], range: NSMakeRange(RSAPPLanguage.localValue("login_protocol1").count, RSAPPLanguage.localValue("login_protocol2").count))
        contentStr.addAttributes([.foregroundColor: BLUE_COLOR_1874FF], range: NSMakeRange(ocStr.length - RSAPPLanguage.localValue("login_protocol4").count, RSAPPLanguage.localValue("login_protocol4").count))
        // 5.关键代码 添加事件
        let range1 = ocStr.range(of: RSAPPLanguage.localValue("login_protocol2"), options: .regularExpression, range: NSMakeRange(0,contentStr.length))
        let range2 = ocStr.range(of: RSAPPLanguage.localValue("login_protocol4"), options: .regularExpression, range: NSMakeRange(0,contentStr.length))
        contentStr.addAttribute(NSAttributedString.Key.link, value: "frist://", range: range1)
        contentStr.addAttribute(NSAttributedString.Key.link, value: "second://", range: range2)
        // 6.赋值
        view.attributedText = contentStr
        view.isEditable = false
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 13)
        view.backgroundColor = .clear
        return view
    }()
    
    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        
        self.privacyTextView.delegate = self
        
        self.vistorBtn.addTarget(self, action: #selector(clickVistorButton(sender: )), for: UIControl.Event.touchUpInside)
        self.timeBtn.addTarget(self, action: #selector(clickCodeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.loginBtn.addTarget(self, action: #selector(clickLoginButton(sender: )), for: UIControl.Event.touchUpInside)
        self.protocolBtn.addTarget(self, action: #selector(clickProtocolBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.vistorBtn)
        self.contentView.addSubview(self.logoImgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.phoneTextFiled)
        self.contentView.addSubview(self.codeTextFiled)
        self.contentView.addSubview(self.timeBtn)
        self.contentView.addSubview(self.tipLab)
        self.contentView.addSubview(self.loginBtn)
        self.contentView.addSubview(self.protocolBtn)
        self.contentView.addSubview(self.privacyTextView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.vistorBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_safeDistanceTop() + PADDING_UNIT * 4)
            make.right.equalTo(self.view).offset(-PADDING_UNIT * 4)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((ScreenWidth - 128) * 0.5)
            make.top.equalTo(self.vistorBtn.snp.bottom).offset(PADDING_UNIT * 18)
            make.size.equalTo(128)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalTo(self.logoImgView)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(PADDING_UNIT)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        self.phoneTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 7)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 11)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 14, height: 42))
        }
        
        self.codeTextFiled.snp.makeConstraints { make in
            make.left.height.equalTo(self.phoneTextFiled)
            make.top.equalTo(self.phoneTextFiled.snp.bottom).offset(PADDING_UNIT * 5)
            make.width.equalTo(self.phoneTextFiled).multipliedBy(0.67)
        }
        
        self.timeBtn.snp.makeConstraints { make in
            make.height.top.equalTo(self.codeTextFiled)
            make.right.equalTo(self.phoneTextFiled)
            make.left.equalTo(self.codeTextFiled.snp.right).offset(PADDING_UNIT * 1.5)
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.centerX.equalTo(self.phoneTextFiled)
            make.top.equalTo(self.codeTextFiled.snp.bottom).offset(PADDING_UNIT * 5)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        self.loginBtn.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 6)
            make.height.horizontalEdges.equalTo(self.phoneTextFiled)
        }
        
        self.protocolBtn.snp.makeConstraints { make in
            make.left.equalTo(self.loginBtn)
            make.centerY.equalTo(self.privacyTextView)
            make.size.equalTo(15)
        }
        
        self.privacyTextView.snp.makeConstraints { make in
            make.top.equalTo(self.loginBtn.snp.bottom).offset(PADDING_UNIT * 5)
            make.left.equalTo(self.protocolBtn.snp.right).offset(PADDING_UNIT * 1.5)
            make.right.equalTo(self.loginBtn)
        }
    }
}

// MARK: Target
@objc private extension RSAPPLoginViewController {
    func clickVistorButton(sender: UIButton) {
        self.timeBtn.stopTimer()
        WebPro.enterMainPage(APBaseTabBarController())
    }
    
    func clickCodeButton(sender: RSAPPTimeButton) {
        guard let _phone = self.phoneTextFiled.text else {
            return
        }
        
        WebPro.sendSms(toPhone: _phone) { (success: Bool) in
            guard success else {
                return
            }
            sender.isEnabled = false
            sender.startTimer()
        }
    }
    
    func clickLoginButton(sender: UIButton) {
        guard let _phone = self.phoneTextFiled.text, let _code = self.codeTextFiled.text else {
            return
        }
        
        WebPro.loginPhone(_phone, withCode: _code)
    }
    
    func clickProtocolBtn(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

extension RSAPPLoginViewController: UITextViewDelegate {
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "frist" {
            CocoaLog.debug("------ 用户协议 -------")
            return false
        }
        if URL.scheme == "second" {
            CocoaLog.debug("------ 隐私政策 -------")
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldShowMenuFor characterAtIndex: Int) -> Bool {
        return false // 总是返回false，禁用弹出菜单
    }
}
