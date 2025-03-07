//
//  RSAPPRequirementInfoItem.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/12.
//

import UIKit

enum InfoItemStyle {
    case Item_Enum
    case Item_Text
    case Item_Text_Multable
    case Item_Text_Number
    case Item_Time
    case Item_City
}

// 招工信息
enum RequirementInfoType {
    case RequirementInfo_Type
    case RequirementInfo_Name
    case RequirementInfo_Intro
    case RequirementInfo_Age
    case RequirementInfo_Sex
    case RequirementInfo_Education
    case RequirementInfo_Experience
    case RequirementInfo_StopTime
    case RequirementInfo_ContactPhone
    case RequirementInfo_BackupPhone
    case RequirementInfo_Address
    case RequirementInfo_DetailLocation
}

protocol APPRequirementInfoItemProtocol: AnyObject {
    func didBeginEditingText(infoItem: RSAPPRequirementInfoItem)
    func didEndEditingText(value: String?, infoItem: RSAPPRequirementInfoItem)
}

class RSAPPRequirementInfoItem: UIView {

    weak open var infoDelegate: APPRequirementInfoItemProtocol?
    
    private lazy var tipLab: UILabel = UILabel.buildLabel(titleColor: BLACK_COLOR_374151, labFont: UIFont.systemFont(ofSize: 13))
    private lazy var typeTextFiled: RSAPPCustomTextFiled = {
        let view = RSAPPCustomTextFiled(frame: CGRectZero)
        view.borderStyle = .none
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        view.textColor = BLACK_COLOR_333333
        return view
    }()
    
    private lazy var placeholderTextView: RSAPPPlaceholderTextView = {
        let view = RSAPPPlaceholderTextView.init(frame: CGRect.zero)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        view.textColor = BLACK_COLOR_333333
        view.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        view.placeholderFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.placeholderColor = GRAY_COLOR_9CA3AF
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // 关闭自动矫正
        view.autocorrectionType = .no
        return view
    }()
    
    private(set) var info_style: InfoItemStyle = .Item_Text
    private(set) var info_type: RequirementInfoType = .RequirementInfo_Type
    
    init(frame: CGRect, itemStyle style: InfoItemStyle, requirementType type: RequirementInfoType) {
        super.init(frame: frame)
        self.info_style = style
        self.info_type = type
        
        self.addSubview(self.tipLab)
        
        self.tipLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        if style == .Item_Text_Multable {
            self.placeholderTextView.endEditingClosure = {[weak self] (value: String?) in
                guard let _self = self else {
                    return
                }
                _self.infoDelegate?.didEndEditingText(value: value, infoItem: _self)
            }
            
            self.addSubview(self.placeholderTextView)
            self.placeholderTextView.snp.makeConstraints { make in
                make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 2)
                make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
                make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 7, height: 150))
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        } else {
            self.typeTextFiled.addTarget(self, action: #selector(textChange(textField: )), for: UIControl.Event.allEvents)
            self.typeTextFiled.delegate = self
            self.addSubview(self.typeTextFiled)
            self.typeTextFiled.snp.makeConstraints { make in
                make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 2)
                make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
                make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 7, height: 44))
                make.bottom.equalToSuperview().offset(-PADDING_UNIT)
            }
        }
        
        self.setInfoItemRightView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setInfoItemPlaceHolder(_ placeholder: String, titleTip tip: String) {
        
        if self.info_style == .Item_Text_Multable {
            self.placeholderTextView.placeholder = RSAPPLanguage.localValue(placeholder)
        } else {
            self.typeTextFiled.attributedPlaceholder = NSAttributedString(string: RSAPPLanguage.localValue(placeholder), attributes: [.foregroundColor: GRAY_COLOR_9CA3AF, .font: UIFont.systemFont(ofSize: 14)])
        }
        
        self.tipLab.text = RSAPPLanguage.localValue(tip)
    }
    
    public func reloadTextFiledText(_ text: String?) {
        if let _t = text {
            self.typeTextFiled.text = _t
        }
    }
    
    private func setInfoItemRightView() {
        var imgname: String?
        
        if self.info_style == .Item_Enum || self.info_style == .Item_City {
            imgname = "home_arrow"
        } else if self.info_style == .Item_Time {
            imgname = "publish_time"
        }
        
        if let _img_name = imgname {
            let view = UIImageView(image: UIImage(named: _img_name))
            self.typeTextFiled.rightView = view
            self.typeTextFiled.rightViewMode = .always
        }
        
        if self.info_style == .Item_Text && self.info_type == .RequirementInfo_Name {
            let lab: UILabel = UILabel.buildLabel(title: "0/10", titleColor: GRAY_COLOR_9CA3AF, labFont: UIFont.systemFont(ofSize: 10))
            lab.frame = CGRect(origin: CGPointZero, size: CGSize(width: 40, height: 20))
            
            self.typeTextFiled.rightView = lab
            self.typeTextFiled.rightViewMode = .always
        }
        
        if self.info_style == .Item_Text_Number {
            self.typeTextFiled.keyboardType = .numberPad
        }
    }
}

@objc private extension RSAPPRequirementInfoItem {
    func textChange(textField: UITextField) {
        guard let text = textField.text, let _right_view = textField.rightView as? UILabel else {
            return
        }
        
        _right_view.text = "\(text.count)/10"
    }
}

extension RSAPPRequirementInfoItem: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _text = textField.text else {
            return true
        }
        
        return _text.count + string.count <= 10
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.infoDelegate?.didBeginEditingText(infoItem: self)
        return self.info_style == .Item_Text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.infoDelegate?.didEndEditingText(value: textField.text, infoItem: self)
    }
}
