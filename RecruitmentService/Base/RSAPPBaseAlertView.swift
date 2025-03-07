//
//  RSAPPBaseAlertView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPBaseAlertView: UIView {
    
    open var confirmClosure: ((Bool) -> Void)?
    open var codeConfirmClosure: ((Bool, String) -> Void)?
    open var closeClosure: (() -> Void)?
    
    private(set) lazy var bgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var titleLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("alert_title"), labFont: UIFont.boldSystemFont(ofSize: 18))
    private lazy var contentLab: UILabel = UILabel.buildLabel(titleColor: GRAY_COLOR_999999)
    private lazy var leftBtn: UIButton = {
        let view = UIButton.buildButton(title: RSAPPLanguage.localValue("alert_left_title"), titleColor: UIColor.hexString("#344054"), titleFont: UIFont.systemFont(ofSize: 16), backgroudColor: .white)
        view.layer.borderColor = UIColor.hexString("#D0D5DD").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var rightBtn: UIButton = UIButton.buildButton(titleColor: .white, titleFont: UIFont.systemFont(ofSize: 16))
    private lazy var closeBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setImage(UIImage(named: "pop_alert_close"), for: UIControl.State.normal)
        
        return view
    }()
    
    private(set) lazy var codeTextFiled: RSAPPCustomTextFiled = {
        let view = RSAPPCustomTextFiled(frame: CGRectZero)
        view.attributedPlaceholder = NSAttributedString(string: RSAPPLanguage.localValue("notification_pop_code"), attributes: [.foregroundColor: GRAY_COLOR_999999, .font: UIFont.systemFont(ofSize: 16)])
        view.textColor = BLACK_COLOR_333333
        view.font = UIFont.systemFont(ofSize: 16)
        view.keyboardType = .numberPad
        view.borderStyle = .none
        view.layer.borderColor = UIColor.hexString("#D0D5DD").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        
        self.leftBtn.addTarget(self, action: #selector(clickCancelButton(sender: )), for: UIControl.Event.touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(clickConfirmButton(sender: )), for: UIControl.Event.touchUpInside)
        self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.contentLab)
        self.bgView.addSubview(self.leftBtn)
        self.bgView.addSubview(self.rightBtn)
        self.addSubview(self.closeBtn)
        
        self.bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
        }
        
        self.closeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bgView.snp.bottom).offset(PADDING_UNIT * 6)
            make.size.equalTo(36)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.bgView).offset(PADDING_UNIT * 5)
        }
        
        self.contentLab.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
        }
        
        self.leftBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalTo(self.contentLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 6)
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.leftBtn.snp.right).offset(PADDING_UNIT * 2.5)
            make.centerY.size.equalTo(self.leftBtn)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    @discardableResult
    public class func showAlertView(title: String? = nil, content: String, rightButtonTitle: String, rightButtonBgColor: UIColor? = BLUE_COLOR_1874FF, superView: UIView, confirm:@escaping ((Bool) -> Void)) -> Self {
        let alertView = RSAPPBaseAlertView(frame: superView.bounds)
        alertView.setAlertTitle(title, alertContent: content, rightButtonTitle: rightButtonTitle, rightButtonBgColor: rightButtonBgColor, superView: superView)
        alertView.confirmClosure = confirm
        superView.addSubview(alertView)
        alertView.pop()
        return alertView as! Self
    }
    
    public class func showAlertView(title: String? = nil, content: String, rightButtonTitle: String, rightButtonBgColor: UIColor? = BLUE_COLOR_1874FF, superView: UIView) -> Self {
        let alertView = RSAPPBaseAlertView(frame: superView.bounds)
        alertView.setAlertTitle(title, alertContent: content, rightButtonTitle: rightButtonTitle, rightButtonBgColor: rightButtonBgColor, superView: superView)
        superView.addSubview(alertView)
        alertView.pop()
        return alertView as! Self
    }
    
    @discardableResult
    public func authAlertLayout() -> Self {
        self.closeBtn.isHidden = true
        self.rightBtn.setTitleColor(BLUE_COLOR_1874FF, for: UIControl.State.normal)
        self.rightBtn.backgroundColor = .white
        self.leftBtn.layer.borderColor = nil
        self.leftBtn.layer.borderWidth = 0
        
        let view1: UIView = UIView(frame: CGRectZero)
        view1.backgroundColor = UIColor.hexString("#EBEBEB")
        self.bgView.addSubview(view1)

        let view2: UIView = UIView(frame: CGRectZero)
        view2.backgroundColor = UIColor.hexString("#EBEBEB")
        self.bgView.addSubview(view2)
        
        view2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 1, height: 44))
        }
        
        self.leftBtn.snp.removeConstraints()
        self.leftBtn.snp.remakeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(view2.snp.left)
            make.height.equalTo(view2)
        }
        
        self.rightBtn.snp.removeConstraints()
        self.rightBtn.snp.remakeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(self.leftBtn)
            make.left.equalTo(view2.snp.right)
        }
        
        view1.snp.makeConstraints { make in
            make.top.equalTo(self.contentLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.bottom.equalTo(self.leftBtn.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return self
    }
    
    @discardableResult
    public func protocolLayout() -> Self {
        self.closeBtn.isHidden = true
        self.leftBtn.isHidden = true
        
        self.leftBtn.snp.removeConstraints()
        self.rightBtn.snp.removeConstraints()
        self.rightBtn.snp.remakeConstraints { make in
            make.top.equalTo(self.contentLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
            make.height.equalTo(44)
        }
        
        return self
    }
    
    @discardableResult
    public func notificationCodeLayout() -> Self {
        
        self.bgView.addSubview(self.codeTextFiled)
        
        self.codeTextFiled.snp.makeConstraints { make in
            make.top.equalTo(self.contentLab.snp.bottom).offset(PADDING_UNIT * 8)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 4)
            make.height.equalTo(44)
        }
        
        self.leftBtn.snp.removeConstraints()
        self.leftBtn.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 4)
            make.top.equalTo(self.codeTextFiled.snp.bottom).offset(PADDING_UNIT * 4)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 6)
        }
        
        return self
    }
    
    public func evaluteLayout() -> Self {
        self.leftBtn.isHidden = true
        self.rightBtn.isHidden = true
        
        return self
    }
    
    public func setAlertTitle(_ title: String? = nil, alertContent: String, rightButtonTitle: String, rightButtonBgColor: UIColor? = BLUE_COLOR_1874FF, superView: UIView) {
        if let _t = title {
            self.titleLab.text = _t
        }
        
        self.contentLab.text = alertContent
        self.rightBtn .setTitle(rightButtonTitle, for: UIControl.State.normal)
        self.rightBtn.backgroundColor = rightButtonBgColor
    }
    
    public func pop() {
        self.bgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        UIView.animate(withDuration: 0.25, delay: 0.01, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    public func dismiss() {
        UIView.transition(with: self, duration: 0.25, options: UIView.AnimationOptions.curveEaseInOut) {
            self.alpha = .zero
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

@objc private extension RSAPPBaseAlertView {
    func clickCancelButton(sender: UIButton) {
        self.dismiss()
        if self.codeTextFiled.superview != nil {
            if let _code = self.codeTextFiled.text {
                self.codeConfirmClosure?(false, _code)
            }
        } else {
            self.confirmClosure?(false)
        }
    }
    
    func clickCloseButton(sender: UIButton) {
        self.dismiss()
        self.closeClosure?()
    }
    
    func clickConfirmButton(sender: UIButton) {
        self.dismiss()
        if self.codeTextFiled.superview != nil {
            if let _code = self.codeTextFiled.text {
                self.codeConfirmClosure?(true, _code)
            }
        } else {
            self.confirmClosure?(true)
        }
    }
}
