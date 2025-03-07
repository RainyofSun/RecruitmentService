//
//  RSAPPRequirementConditionVC.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/13.
//

import UIKit
import LJContactManager
import Toast_Swift

class RSAPPRequirementConditionVC: APBaseViewController {

    private lazy var processView: RSAPPNewRequirementProcessView = RSAPPNewRequirementProcessView(frame: CGRectZero)
    private lazy var ageView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Enum, requirementType: RequirementInfoType.RequirementInfo_Age)
    private lazy var sexView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Enum, requirementType: RequirementInfoType.RequirementInfo_Sex)
    private lazy var educationView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Enum, requirementType: RequirementInfoType.RequirementInfo_Education)
    private lazy var experienceView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Enum, requirementType: RequirementInfoType.RequirementInfo_Experience)
    private lazy var stopTimeView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Time, requirementType: RequirementInfoType.RequirementInfo_StopTime)
    private lazy var contactPhoneView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text_Number, requirementType: RequirementInfoType.RequirementInfo_ContactPhone)
    private lazy var backupPhoneView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text_Number, requirementType: RequirementInfoType.RequirementInfo_BackupPhone)
    private lazy var addressView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_City, requirementType: RequirementInfoType.RequirementInfo_Address)
    private lazy var detailAddressView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text, requirementType: RequirementInfoType.RequirementInfo_DetailLocation)
    private lazy var nextBtn: RSAPPLoadingButton = RSAPPLoadingButton.buildLoadingButton(RSAPPLanguage.localValue("publish_requirement_next"), cornerRadius: 4)
    
    private var requirementModel: RSAPPRequirementModel?
    private var imageArray: [String]?
    
    init(requirementModel: RSAPPRequirementModel? = nil, imageArray: [String]? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.requirementModel = requirementModel
        self.imageArray = imageArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("publish_new_task_nav_title")
        
        self.nextBtn.addTarget(self, action: #selector(clickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.ageView.setInfoItemPlaceHolder("publish_requirement_age_place", titleTip: "publish_requirement_age")
        self.sexView.setInfoItemPlaceHolder("publish_requirement_sex_place", titleTip: "publish_requirement_sex")
        self.educationView.setInfoItemPlaceHolder("publish_requirement_education_place", titleTip: "publish_requirement_education")
        self.experienceView.setInfoItemPlaceHolder("publish_requirement_experience_place", titleTip: "publish_requirement_experience")
        self.stopTimeView.setInfoItemPlaceHolder("publish_requirement_stop_time_place", titleTip: "publish_requirement_stop_time")
        self.contactPhoneView.setInfoItemPlaceHolder("publish_requirement_contact_place", titleTip: "publish_requirement_contact")
        self.backupPhoneView.setInfoItemPlaceHolder("publish_requirement_backup_place", titleTip: "publish_requirement_backup")
        self.addressView.setInfoItemPlaceHolder("publish_requirement_address_place", titleTip: "publish_requirement_address")
        self.detailAddressView.setInfoItemPlaceHolder("publish_requirement_detail_address_place", titleTip: "publish_requirement_detail_address")
        
        self.ageView.infoDelegate = self
        self.sexView.infoDelegate = self
        self.educationView.infoDelegate = self
        self.experienceView.infoDelegate = self
        self.stopTimeView.infoDelegate = self
        self.contactPhoneView.infoDelegate = self
        self.backupPhoneView.infoDelegate = self
        self.addressView.infoDelegate = self
        self.detailAddressView.infoDelegate = self
        
        self.processView.setProcessSteo(step: ProcessStep.Step_Two)
        self.contentView.addSubview(self.processView)
        self.contentView.addSubview(self.ageView)
        self.contentView.addSubview(self.sexView)
        self.contentView.addSubview(self.educationView)
        self.contentView.addSubview(self.experienceView)
        self.contentView.addSubview(self.stopTimeView)
        self.contentView.addSubview(self.contactPhoneView)
        self.contentView.addSubview(self.backupPhoneView)
        self.contentView.addSubview(self.addressView)
        self.contentView.addSubview(self.detailAddressView)
        self.view.addSubview(self.nextBtn)
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
        
        self.ageView.snp.makeConstraints { make in
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT * 7)
            make.horizontalEdges.equalTo(self.processView)
        }
        
        self.sexView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.ageView)
            make.top.equalTo(self.ageView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.educationView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.sexView)
            make.top.equalTo(self.sexView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.experienceView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.educationView)
            make.top.equalTo(self.educationView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.stopTimeView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.experienceView)
            make.top.equalTo(self.experienceView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.contactPhoneView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.stopTimeView)
            make.top.equalTo(self.stopTimeView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.backupPhoneView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contactPhoneView)
            make.top.equalTo(self.contactPhoneView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.addressView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.backupPhoneView)
            make.top.equalTo(self.backupPhoneView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.detailAddressView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.addressView)
            make.top.equalTo(self.addressView.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
            make.height.equalTo(47)
        }
    }
}

extension RSAPPRequirementConditionVC: APPRequirementInfoItemProtocol {
    func didBeginEditingText(infoItem: RSAPPRequirementInfoItem) {
        if infoItem.info_type == .RequirementInfo_Age {
            let array = [RSAPPLanguage.localValue("age_1"), RSAPPLanguage.localValue("age_2"), RSAPPLanguage.localValue("age_3"), RSAPPLanguage.localValue("age_4"), RSAPPLanguage.localValue("age_5")]
            self.view.showSingleChoiseView(dataSource: array, title: "publish_requirement_age_place") {[weak self] (value: String?) in
                infoItem.reloadTextFiledText(value)
                self?.requirementModel?.age = value
            }
        }
        
        if infoItem.info_type == .RequirementInfo_Sex {
            let array = [RSAPPLanguage.localValue("sex_1"), RSAPPLanguage.localValue("sex_2"), RSAPPLanguage.localValue("sex_3")]
            self.view.showSingleChoiseView(dataSource: array, title: "publish_requirement_sex_place") {[weak self] (value: String?) in
                infoItem.reloadTextFiledText(value)
                self?.requirementModel?.sex = value
            }
        }
        
        if infoItem.info_type == .RequirementInfo_Education {
            let array = [RSAPPLanguage.localValue("education_1"), RSAPPLanguage.localValue("education_2"), RSAPPLanguage.localValue("education_3"), RSAPPLanguage.localValue("education_4"), RSAPPLanguage.localValue("education_5")]
            self.view.showSingleChoiseView(dataSource: array, title: "publish_requirement_education_place") {[weak self] (value: String?) in
                infoItem.reloadTextFiledText(value)
                self?.requirementModel?.education = value
            }
        }
        
        if infoItem.info_type == .RequirementInfo_Experience {
            let array = [RSAPPLanguage.localValue("experience_1"), RSAPPLanguage.localValue("experience_2"), RSAPPLanguage.localValue("experience_3"), RSAPPLanguage.localValue("experience_4"), RSAPPLanguage.localValue("experience_5")]
            self.view.showSingleChoiseView(dataSource: array, title: "publish_requirement_experience_place") {[weak self] (value: String?) in
                infoItem.reloadTextFiledText(value)
                self?.requirementModel?.experience = value
            }
        }
        
        if infoItem.info_type == .RequirementInfo_StopTime {
            self.view.showTimePicker(title: "publish_requirement_stop_time_place") {[weak self] (sel_time_text: String?) in
                infoItem.reloadTextFiledText(sel_time_text)
                self?.requirementModel?.stopTime = sel_time_text
            }
        }
        
        if infoItem.info_type == .RequirementInfo_ContactPhone || infoItem.info_type == .RequirementInfo_BackupPhone {
            if RSAPPDeviceAuthorizationTool.contactAuthorizationStatus() != .authorized && RSAPPDeviceAuthorizationTool.contactAuthorizationStatus() != .limited {
                LJContactManager.sharedInstance().requestAddressBookAuthorization {[weak self] (auth: Bool) in
                    guard auth else {
                        self?.showSystemStyleSettingAlert(content: RSAPPLanguage.localValue("alert_addressbook_system"))
                        return
                    }
                    
                    LJContactManager.sharedInstance().selectContact(at: self) {[weak self] (_: String?, phone: String?) in
                        infoItem.reloadTextFiledText(phone)
                        if infoItem.info_type == .RequirementInfo_ContactPhone {
                            self?.requirementModel?.contactPhone = phone
                        }
                        
                        if infoItem.info_type == .RequirementInfo_BackupPhone {
                            self?.requirementModel?.backupPhone = phone
                        }
                    }
                }
            } else {
                LJContactManager.sharedInstance().selectContact(at: self) {[weak self] (_: String?, phone: String?) in
                    infoItem.reloadTextFiledText(phone)
                    if infoItem.info_type == .RequirementInfo_ContactPhone {
                        self?.requirementModel?.contactPhone = phone
                    }
                    
                    if infoItem.info_type == .RequirementInfo_BackupPhone {
                        self?.requirementModel?.backupPhone = phone
                    }
                }
            }
        }
        
        if infoItem.info_type == .RequirementInfo_Address {
            if RSAPPDeviceAuthorizationTool.locationAuthorizationStatus() != .authorized && RSAPPDeviceAuthorizationTool.locationAuthorizationStatus() != .limited {
                RSAPPDeviceLocation.shareInstance.startLoaction()
                RSAPPDeviceLocation.shareInstance.locationEndClosure = {(value: String) in
                    infoItem.reloadTextFiledText(value)
                    self.requirementModel?.address = value
                }
            } else {
                RSAPPDeviceLocation.shareInstance.startLoaction()
                RSAPPDeviceLocation.shareInstance.locationEndClosure = {[weak self] (value: String) in
                    infoItem.reloadTextFiledText(value)
                    self?.requirementModel?.address = value
                }
            }
        }
    }
    
    func didEndEditingText(value: String?, infoItem: RSAPPRequirementInfoItem) {
        if infoItem.info_type == .RequirementInfo_DetailLocation {
            self.requirementModel?.detailAddress = value
        }
    }
}

// MARK: Target
@objc private extension RSAPPRequirementConditionVC {
    func clickNextButton(sender: RSAPPLoadingButton) {
        CocoaLog.debug("------- \n \(self.requirementModel?.toJSONString() ?? "空") \n--------")
        guard self.requirementModel?.age != nil && self.requirementModel?.sex != nil && self.requirementModel?.address != nil
        && self.requirementModel?.education != nil && self.requirementModel?.experience != nil && self.requirementModel?.stopTime != nil
        && self.requirementModel?.contactPhone != nil && self.requirementModel?.backupPhone != nil && self.requirementModel?.address != nil
        && self.requirementModel?.detailAddress != nil else {
            self.view.makeToast(RSAPPLanguage.localValue("pop_complete_requirement"), position: ToastPosition.center)
            return
        }
        
        self.navigationController?.pushViewController(RSAPPRequirementDetailVC(status: RequirementStatus.ToBePublished, requirementModel: self.requirementModel, imageArray: self.imageArray, canSaveToDraft: true, showNext: true), animated: true)
    }
}
