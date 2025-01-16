//
//  RSAPPAuthAlertView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPAuthAlertView: UIView {
    
    open var confirmClosure: (() -> Void)?
    
    private lazy var bgView: UIView = {
        var view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLab: UILabel = {
        var view = UILabel.buildLabel(labFont: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium))
        return view
    }()
    
    private lazy var contentLab: UILabel = {
        var view = UILabel.buildLabel(titleColor: UIColor.hexString("#999999"), labFont: UIFont.systemFont(ofSize: 12))
        return view
    }()
    
    private lazy var hLineView: UIView = {
        var view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexString("#EBEBEB")
        return view
    }()
    
    private lazy var vLineView: UIView = {
        var view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexString("#EBEBEB")
        return view
    }()
    
    private lazy var okBtn: UIButton = {
        var btn = UIButton.buildButton(title: RSAPPLanguage.localValue("alert_btn_ok"), titleColor: BLUE_COLOR_1874FF, backgroudColor: .white)
        return btn
    }()
    
    private lazy var cancelBtn: UIButton = {
        var view = UIButton.buildButton(title: RSAPPLanguage.localValue("alert_btn_cancel"), backgroudColor: .white)
        return view
    }()
    
    private weak var _super_view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.okBtn.addTarget(self, action: #selector(clickOKBtn(sender: )), for: UIControl.Event.touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(clickCancelBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.contentLab)
        self.bgView.addSubview(self.hLineView)
        self.bgView.addSubview(self.cancelBtn)
        self.bgView.addSubview(self.okBtn)
        self.bgView.addSubview(self.vLineView)
        
        
        self.bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 12)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.top.equalTo(self.bgView).offset(PADDING_UNIT * 4)
            make.centerX.equalToSuperview()
        }
        
        self.contentLab.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
        }
        
        self.hLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.contentLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.height.equalTo(1)
        }
        
        self.cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.hLineView.snp.bottom)
            make.height.equalTo(52)
            make.bottom.equalTo(self.bgView)
        }
        
        self.vLineView.snp.makeConstraints { make in
            make.left.equalTo(self.cancelBtn.snp.right)
            make.top.height.equalTo(self.cancelBtn)
            make.width.equalTo(1)
        }
        
        self.okBtn.snp.makeConstraints { make in
            make.left.equalTo(self.vLineView.snp.right)
            make.right.equalToSuperview()
            make.top.size.equalTo(self.cancelBtn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    @discardableResult
    public class func showAlertView(title: String, content: String, superView: UIView, confirm:@escaping (() -> Void)) -> RSAPPAuthAlertView {
        let alertView = RSAPPAuthAlertView(frame: superView.bounds)
        alertView.setAlertTitle(title, alertContent: content, superView: superView)
        alertView.confirmClosure = confirm
        superView.addSubview(alertView)
        alertView.pop()
        return alertView
    }
    
    public func setAlertTitle(_ title: String, alertContent: String, superView: UIView) {
        self._super_view = superView
        self.titleLab.text = title
        self.contentLab.text = alertContent
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

@objc private extension RSAPPAuthAlertView {
    func clickOKBtn(sender: UIButton) {
        self.confirmClosure?()
        self.dismiss()
    }
    
    func clickCancelBtn(sender: UIButton) {
        self.dismiss()
    }
}
