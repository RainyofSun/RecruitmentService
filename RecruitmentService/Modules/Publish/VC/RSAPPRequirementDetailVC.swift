//
//  RSAPPRequirementDetailVC.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/14.
//

import UIKit

class RSAPPRequirementDetailVC: APBaseViewController {

    private lazy var processView: RSAPPNewRequirementProcessView = RSAPPNewRequirementProcessView(frame: CGRectZero)
//    private lazy var bannerView: UIImageView = UIImageView(image: UIImage(named: "home_banner"))
    private lazy var nextBtn: RSAPPLoadingButton = RSAPPLoadingButton.buildLoadingButton(RSAPPLanguage.localValue("publish_requirement_next"), cornerRadius: 4)
    private lazy var titleLab: UILabel = UILabel.buildLabel(titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 17))
    private lazy var saveToDraftBoxBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("publish_requirement_draft"), titleColor: BLUE_COLOR_1874FF, titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), backgroudColor: .clear)
    
    private lazy var subContentView1: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLab1: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("publish_process_step_one"), titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 14))
    private lazy var timeLab: UILabel = UILabel.buildLabel()
    private lazy var addressLab: UILabel = UILabel.buildLabel()
    private lazy var phoneLab: UILabel = UILabel.buildLabel()
    
    private lazy var subContentView2: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLab2: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("publish_process_step_two"), titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 14))
    private lazy var ageLab: UILabel = UILabel.buildLabel()
    private lazy var sexLab: UILabel = UILabel.buildLabel()
    private lazy var educationLab: UILabel = UILabel.buildLabel()
    private lazy var experienceLab: UILabel = UILabel.buildLabel()
    
    private lazy var subContentView3: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLab3: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("publish_process_step_three"), titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 14))
    private lazy var introLab: UILabel = UILabel.buildLabel(titleColor: UIColor.hexString("#4B5563"), labFont: UIFont.systemFont(ofSize: 14))
    
    private var status: RequirementStatus = .ToBePublished
    private var requirementModel: RSAPPRequirementModel?
    private var imageArray: [String]?
    private var can_save_draft: Bool = false
    private var show_next: Bool = false
    
    init(status: RequirementStatus, requirementModel: RSAPPRequirementModel? = nil, imageArray: [String]? = nil, canSaveToDraft save: Bool = false, showNext next: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.status = status
        self.requirementModel = requirementModel
        self.imageArray = imageArray
        self.can_save_draft = save
        self.show_next = next
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("publish_new_task_nav_title")
        
        if self.can_save_draft {
            self.buildRightItem(rightItem: self.saveToDraftBoxBtn)
            self.saveToDraftBoxBtn.addTarget(self, action: #selector(saveToDraftBoxButton(sender: )), for: UIControl.Event.touchUpInside)
        }
        
        self.nextBtn.addTarget(self, action: #selector(clickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.titleLab1.textAlignment = .left
        self.titleLab2.textAlignment = .left
        self.titleLab3.textAlignment = .left
        self.timeLab.textAlignment = .left
        self.addressLab.textAlignment = .left
        self.phoneLab.textAlignment = .left
        self.ageLab.textAlignment = .left
        self.sexLab.textAlignment = .left
        self.educationLab.textAlignment = .left
        self.experienceLab.textAlignment = .left
        
        self.processView.setProcessSteo(step: ProcessStep.Step_Three)
        self.contentView.addSubview(self.processView)
//        self.contentView.addSubview(self.bannerView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.subContentView1)
        self.subContentView1.addSubview(self.titleLab1)
        self.subContentView1.addSubview(self.timeLab)
        self.subContentView1.addSubview(self.addressLab)
        self.subContentView1.addSubview(self.phoneLab)
        self.contentView.addSubview(self.subContentView2)
        self.subContentView2.addSubview(self.titleLab2)
        self.subContentView2.addSubview(self.ageLab)
        self.subContentView2.addSubview(self.sexLab)
        self.subContentView2.addSubview(self.educationLab)
        self.subContentView2.addSubview(self.experienceLab)
        self.contentView.addSubview(self.subContentView3)
        self.subContentView3.addSubview(self.titleLab3)
        self.subContentView3.addSubview(self.introLab)
        self.view.addSubview(self.nextBtn)
        
        self.initData()
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_navigationFullHeight())
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT)
        }
        
        self.processView.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
        }
        
//        self.bannerView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
//            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT)
//            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 6, height: (ScreenWidth - PADDING_UNIT * 6) * 0.44))
//        }
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.subContentView1.snp.makeConstraints { make in
            make.left.equalTo(self.titleLab)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 6)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.titleLab1.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.timeLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.top.equalTo(self.titleLab1.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.addressLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.timeLab)
            make.top.equalTo(self.timeLab.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.phoneLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.addressLab)
            make.top.equalTo(self.addressLab.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
        
        self.subContentView2.snp.makeConstraints { make in
            make.top.equalTo(self.subContentView1.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.horizontalEdges.equalTo(self.subContentView1)
        }
        
        self.titleLab2.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.ageLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.top.equalTo(self.titleLab2.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.sexLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.ageLab)
            make.top.equalTo(self.ageLab.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.educationLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.sexLab)
            make.top.equalTo(self.sexLab.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.experienceLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.educationLab)
            make.top.equalTo(self.educationLab.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
        
        self.subContentView3.snp.makeConstraints { make in
            make.top.equalTo(self.subContentView2.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.horizontalEdges.equalTo(self.subContentView2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 2)
        }
        
        self.titleLab3.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.introLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.top.equalTo(self.titleLab3.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
            make.height.equalTo(47)
        }
    }
}

private extension RSAPPRequirementDetailVC {
    func initData() {
        if let _type = self.requirementModel?.requirementType {
            var str = RSAPPLanguage.localValue("task_type\(_type.rawValue)")
            if let _subtype = self.requirementModel?.requirementSubType1 {
                str = str + ":" + RSAPPLanguage.localValue("task_suubtype\(_type.rawValue)_\(_subtype.rawValue)")
            }
            
            if let _subType = self.requirementModel?.requirementSubType2 {
                str = str + ":" + RSAPPLanguage.localValue("task_suubtype\(_type.rawValue)_\(_subType.rawValue)")
            }
            
            self.titleLab.text = str
        }
        
        if var _time = self.requirementModel?.stopTime {
            _time = RSAPPLanguage.localValue("publish_requirement_stop_time") + ": " + _time
            self.timeLab.attributedText = NSAttributedString.attachmentImage("task_time", attributeString: _time, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _address = self.requirementModel?.address, let _address1 = self.requirementModel?.detailAddress {
            _address = RSAPPLanguage.localValue("publish_requirement_address") + ": " + _address + "\n" + _address1
            self.addressLab.attributedText = NSAttributedString.attachmentImage("task_location", attributeString: _address, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _phone = self.requirementModel?.contactPhone {
            _phone = RSAPPLanguage.localValue("publish_requirement_contact") + ": " + _phone
            self.phoneLab.attributedText = NSAttributedString.attachmentImage("task_phone", attributeString: _phone, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _age = self.requirementModel?.age {
            _age = RSAPPLanguage.localValue("publish_requirement_age") + ": " + _age
            self.ageLab.attributedText = NSAttributedString.attachmentImage("task_age", attributeString: _age, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _sex = self.requirementModel?.sex {
            _sex = RSAPPLanguage.localValue("publish_requirement_sex") + ": " + _sex
            self.sexLab.attributedText = NSAttributedString.attachmentImage("task_sex", attributeString: _sex, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _education = self.requirementModel?.education {
            _education = RSAPPLanguage.localValue("publish_requirement_education") + ": " + _education
            self.educationLab.attributedText = NSAttributedString.attachmentImage("task_education", attributeString: _education, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _experience = self.requirementModel?.experience {
            _experience = RSAPPLanguage.localValue("publish_requirement_experience") + ": " + _experience
            self.experienceLab.attributedText = NSAttributedString.attachmentImage("task_experience", attributeString: _experience, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if let _intro = self.requirementModel?.requirementIntro {
            self.introLab.textColor = BLACK_COLOR_4B5563
            self.introLab.font = UIFont.systemFont(ofSize: 14)
            self.introLab.textAlignment = .left
            self.introLab.text = _intro
        }
        
        switch self.status {
        case .ToBePublished:
            self.nextBtn.setTitle(RSAPPLanguage.localValue("publish_requirement_publish"), for: UIControl.State.normal)
        case .Published:
            self.nextBtn.setTitle(RSAPPLanguage.localValue("publish_requirement_stop"), for: UIControl.State.normal)
        case .RecruitmentEnded:
            self.nextBtn.setTitle(RSAPPLanguage.localValue("publish_requirement_publish"), for: UIControl.State.normal)
        }
        
        if self.status == .RecruitmentEnded || !self.show_next {
            self.nextBtn.isHidden = true
        } else {
            self.nextBtn.isHidden = false
        }
    }
}

// MARK: Target
@objc private extension RSAPPRequirementDetailVC {
    func saveToDraftBoxButton(sender: UIButton) {
        CocoaLog.debug("------- \n \(self.requirementModel?.toJSONString() ?? "空") \n--------")
        
        var info_key: String = ""
        if let _time_key = self.requirementModel?.requirementTimeKey {
            info_key = SAVE_REQUIREMENT_KEY + _time_key
        }
        self.requirementModel?.status = .ToBePublished
        self.requirementModel?.requirementKey = info_key
        guard let _json = self.requirementModel?.toJSON(), !info_key.isEmpty else {
            return
        }
        
        CocoaLog.debug("--------- 存储草稿 -----------\n \(info_key) \n -------------------")
        NetworkRequest(RSAPPNetworkAPI.SaveRequirementParams(paramsJson: _json, key: info_key), modelType: RSAPPBaseResponseModel.self) {[weak self] (res: HandyJSON, res1: SuccessResponse) in
            self?.view.makeToast(RSAPPLanguage.localValue("alert_save_draft_success"), position: .center, completion: { didTap in
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func clickNextButton(sender: RSAPPLoadingButton) {
        CocoaLog.debug("------- \n \(self.requirementModel?.toJSONString() ?? "空") \n--------")
        guard let _time_key = self.requirementModel?.requirementTimeKey else {
            return
        }
        
        var info_key: String = ""
        var tip: String = ""
        // 改变招工信息状态
        switch self.status {
        case .ToBePublished, .RecruitmentEnded:
            // 发布招工信息
            self.requirementModel?.status = .Published
            info_key = PUBLISH_REQUIREMENT_KEY + _time_key
            tip = "alert_publish_success"
        case .Published:
            // 停止招工信息
            self.requirementModel?.status = .RecruitmentEnded
            info_key = STOP_REQUIREMENT_KEY + _time_key
            tip = "alert_stop_success"
        }
        
        self.requirementModel?.requirementKey = info_key
        guard let _json = self.requirementModel?.toJSON() else {
            return
        }
        
        CocoaLog.debug("--------- 点击Next, 发布或者停止招工信息 -----------\n \(info_key) \n -------------------")
        NetworkRequest(RSAPPNetworkAPI.SaveRequirementParams(paramsJson: _json, key: info_key), modelType: RSAPPBaseResponseModel.self) {[weak self] (res: HandyJSON, res1: SuccessResponse) in
            self?.view.makeToast(RSAPPLanguage.localValue(tip), position: .center, completion: { didTap in
                self?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}
