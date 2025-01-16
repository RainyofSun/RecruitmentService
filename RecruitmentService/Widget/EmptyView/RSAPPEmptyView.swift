//
//  RSAPPEmptyView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPEmptyView: UIView {

    open var gotoPublishClosure:(() -> Void)?
    
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "menu_slider"))
    private lazy var titleLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_empty_title"), titleColor: GRAY_COLOR_999999, labFont: UIFont.boldSystemFont(ofSize: 34))
    private lazy var tryBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("notification_empty_try_title"), titleColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tryBtn.addTarget(self, action: #selector(clickGotoPublishBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.emptyImgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.tryBtn)
        
        self.titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        self.emptyImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.titleLab.snp.top).offset(-PADDING_UNIT * 2)
        }
        
        self.tryBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.size.equalTo(CGSize(width: 98, height: 35))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

@objc private extension RSAPPEmptyView {
    func clickGotoPublishBtn(sender: UIButton) {
        self.gotoPublishClosure?()
    }
}
