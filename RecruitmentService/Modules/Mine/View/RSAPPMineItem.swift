//
//  RSAPPMineItem.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

enum APPMineItemType: String {
    case Mine_AboutUs = "mine_about_us"
    case Mine_UserPrivacy = "mine_user_privacy"
    case Mine_Privacy = "mine_privacy"
    case Mine_Cancel = "mine_cancel"
}

class RSAPPMineItem: UIControl {

    private lazy var titleLab: UILabel = UILabel.buildLabel()
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "home_arrow"))

    private(set) var item_type: APPMineItemType = .Mine_AboutUs
    
    init(frame: CGRect, itemType type: APPMineItemType) {
        super.init(frame: frame)
        self.item_type = type
        
        switch type {
        case .Mine_AboutUs:
            self.titleLab.attributedText = NSAttributedString.attachmentImage("mine_about_us", attributeString: RSAPPLanguage.localValue(type.rawValue), textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        case .Mine_UserPrivacy:
            self.titleLab.attributedText = NSAttributedString.attachmentImage("mine_user_privacy", attributeString: RSAPPLanguage.localValue(type.rawValue), textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        case .Mine_Privacy:
            self.titleLab.attributedText = NSAttributedString.attachmentImage("mine_privacy", attributeString: RSAPPLanguage.localValue(type.rawValue), textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        case .Mine_Cancel:
            self.titleLab.attributedText = NSAttributedString.attachmentImage("mine_cancel", attributeString: RSAPPLanguage.localValue(type.rawValue), textColor: BLACK_COLOR_4B5563, textFont: UIFont.systemFont(ofSize: 14))
        }
        
        self.arrowImgView.transform = CGAffineTransformMakeRotation(-Double.pi * 0.5)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.arrowImgView)
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}
