//
//  RSAPPNotificationRequirementView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

protocol APPNotificationRequirementProtocol: AnyObject {
    func checkRequirementDetail()
}

class RSAPPNotificationRequirementView: UIView {

    weak open var delegate: APPNotificationRequirementProtocol?
    
    private lazy var typeLab: UILabel = UILabel.buildLabel(titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 16))
    private lazy var tagLab: UILabel = UILabel.buildLabel()
    private lazy var stopTimeLab: UILabel = UILabel.buildLabel()
    private lazy var locationLab: UILabel = UILabel.buildLabel()
    private lazy var checkBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("notification_check_btn_title"), titleColor: UIColor.hexString("#3176FF"), titleFont: UIFont.systemFont(ofSize: 12), backgroudColor: .clear)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.checkBtn.addTarget(self, action: #selector(clickCheckButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.typeLab)
        self.addSubview(self.tagLab)
        self.addSubview(self.stopTimeLab)
        self.addSubview(self.locationLab)
        self.addSubview(self.checkBtn)
        
        self.typeLab.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.typeLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
        
        self.tagLab.snp.makeConstraints { make in
            make.left.equalTo(self.typeLab)
            make.top.equalTo(self.typeLab.snp.bottom).offset(PADDING_UNIT)
        }
        
        self.stopTimeLab.snp.makeConstraints { make in
            make.left.equalTo(self.tagLab)
            make.top.equalTo(self.tagLab.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.locationLab.snp.makeConstraints { make in
            make.left.equalTo(self.stopTimeLab)
            make.top.equalTo(self.stopTimeLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadRequirementDetail(_ taskModel: RSAPPRequirementModel) {
        if let _type = taskModel.requirementType {
            self.typeLab.text = RSAPPLanguage.localValue("task_type\(_type.rawValue)")
        }
        
        let tagAttribute: NSMutableAttributedString = NSMutableAttributedString(string: "")
        if let _sex = taskModel.sex {
            tagAttribute.append(NSAttributedString(string: " \(_sex) ", attributes: [.foregroundColor: UIColor.hexString("#967545"), .font: UIFont.systemFont(ofSize: 10), .backgroundColor: UIColor.hexString("#F7F2E7")]))
        }
        
        if let _education = taskModel.education {
            tagAttribute.append(NSAttributedString(string: "  ", attributes: nil))
            tagAttribute.append(NSAttributedString(string: " \(_education) ", attributes: [.foregroundColor: UIColor.hexString("#967545"), .font: UIFont.systemFont(ofSize: 10), .backgroundColor: UIColor.hexString("#F7F2E7")]))
        }
        
        if let _age = taskModel.age {
            tagAttribute.append(NSAttributedString(string: "  ", attributes: nil))
            tagAttribute.append(NSAttributedString(string: " \(_age) ", attributes: [.foregroundColor: UIColor.hexString("#967545"), .font: UIFont.systemFont(ofSize: 10), .backgroundColor: UIColor.hexString("#F7F2E7")]))
        }
        
        self.tagLab.attributedText = tagAttribute
        
        if var _time = taskModel.stopTime {
            _time = RSAPPLanguage.localValue("publish_requirement_stop_time") + ": " + _time
            self.stopTimeLab.attributedText = NSAttributedString.attachmentImage("task_time", attributeString: _time, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        if var _address = taskModel.address, let _address1 = taskModel.detailAddress {
            _address = RSAPPLanguage.localValue("publish_requirement_address") + ": " + _address + "\n" + _address1
            self.locationLab.attributedText = NSAttributedString.attachmentImage("task_location", attributeString: _address, textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
    }
}

@objc private extension RSAPPNotificationRequirementView {
    func clickCheckButton(sender: UIButton) {
        self.delegate?.checkRequirementDetail()
    }
}
