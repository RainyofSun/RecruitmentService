//
//  RSAPPBaseAlertView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPBaseAlertView: UIView {
    
    open var confirmClosure: (() -> Void)?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            make.bottom.equalToSuperview().offset(PADDING_UNIT * 6)
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.leftBtn.snp.right).offset(PADDING_UNIT * 2.5)
            make.centerY.height.equalTo(self.leftBtn)
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
    public class func showAlertView(title: String, content: String, rightButtonTitle: String, rightButtonBgColor: UIColor? = BLUE_COLOR_1874FF, superView: UIView, confirm:@escaping (() -> Void)) -> Self {
        let alertView = RSAPPBaseAlertView(frame: superView.bounds)
        alertView.setAlertTitle(alertContent: title, rightButtonTitle: rightButtonTitle, rightButtonBgColor: rightButtonBgColor, superView: superView)
        alertView.confirmClosure = confirm
        superView.addSubview(alertView)
        alertView.pop()
        return alertView as! Self
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
