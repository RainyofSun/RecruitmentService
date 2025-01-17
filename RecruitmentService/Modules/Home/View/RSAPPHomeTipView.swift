//
//  RSAPPHomeTipView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeTipView: UIView {

    open var gotoClosure: ((Bool) -> Void)?
    
    private lazy var tipLab: UILabel = UILabel.buildLabel(labFont: UIFont.systemFont(ofSize: 14))
    private lazy var tipBtn: UIButton = UIButton.buildButton(titleColor: .white)
    private var hasLogin: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tipLab.text = RSAPPLanguage.localValue("home_tip_unlogin")
        self.tipBtn.setTitle(RSAPPLanguage.localValue("home_tip_goto_login"), for: UIControl.State.normal)
        self.tipBtn.addTarget(self, action: #selector(clickTipButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.tipLab)
        self.addSubview(self.tipBtn)
        
        self.tipLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(PADDING_UNIT * 4)
        }
        
        self.tipBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tipLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.size.equalTo(CGSize(width: 98, height: 35))
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        Global.shared.addObserver(self, forKeyPath: APP_LOGIN_KEY, options: .new, context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, let change = change, let newValue = change[.newKey] as? Bool {
            if keyPath == APP_LOGIN_KEY {
                self.hasLogin = newValue
                DispatchQueue.main.async {
                    if newValue {
                        self.tipLab.text = RSAPPLanguage.localValue("home_tip_unpublish")
                        self.tipBtn.setTitle(RSAPPLanguage.localValue("home_tip_goto_publish"), for: UIControl.State.normal)
                    } else {
                        self.tipLab.text = RSAPPLanguage.localValue("home_tip_unlogin")
                        self.tipBtn.setTitle(RSAPPLanguage.localValue("home_tip_goto_login"), for: UIControl.State.normal)
                    }
                }
            }
        }
    }
}

@objc private extension RSAPPHomeTipView {
    func clickTipButton(sender: UIButton) {
        self.gotoClosure?(self.hasLogin)
    }
}
