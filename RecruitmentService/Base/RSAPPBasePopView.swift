//
//  RSAPPBasePopView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPBasePopView: UIView {
    /// 设置 contentView 高度比, 最低高度为270
    open var heightRadio: CGFloat {
        return 0.65
    }
    
    /// 设置固定高度 默认为 0 ---> 如果设置数值后,优先级大于 heightRadio
    open var stableHeight: CGFloat {
        return .zero
    }
    
    /// 是否允许点击空白消失
    open var canTouchDismiss: Bool {
        return true
    }

    /// 消失之后是否主动移除 默认主动移除
    open var autoRemove: Bool {
        return true
    }
    
    /// 是否需要父类设置圆角
    open var setCorner: Bool {
        return true
    }
    
    /// 是否需要延长布局 ---> 延迟布局需要子类自己调用布局
    open var delayLayout: Bool {
        return false
    }
    
    /// 页面消失回调
    open var popDidDismissClosure: ((RSAPPBasePopView) -> Void)?
    
    private(set) lazy var contentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "certification_alert_close"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "certification_alert_close"), for: UIControl.State.highlighted)
        return btn
    }()
    
    private(set) lazy var titleLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return view
    }()
    
    // 最低高度
    private var MIN_HEIGHT: CGFloat = 270
    private var MIN_Radio: CGFloat {
        return MIN_HEIGHT/UIScreen.main.bounds.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadPopViews()
        if !self.delayLayout {
            self.layoutPopViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.setCorner {
            return
        }
        
        self.contentView.addCorner(conrners: [.topLeft, .topRight], radius: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
        guard let point = touches.first?.location(in: self), canTouchDismiss else {
            return
        }
        
        if self.contentView.frame.contains(point) {
            return
        }
        
        self.dismiss()
    }
    
    deinit {
        deallocPrint()
    }
    
    // MARK: 子类覆写
    public func loadPopViews() {
        self.alpha = .zero
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.contentView)
        self.closeBtn.isHidden = self.canTouchDismiss
        self.contentView.addSubview(self.closeBtn)
        self.contentView.addSubview(self.titleLab)
    }
    
    public func layoutPopViews() {
        self.contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            if self.stableHeight != .zero {
                make.height.equalTo(self.stableHeight)
            } else {
                make.height.equalToSuperview().multipliedBy(max(self.heightRadio, self.MIN_Radio))
            }
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        self.closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(24)
        }
    }
    
    @discardableResult
    public class func convenienceShow(_ superView: UIView) -> Self {
        return RSAPPBasePopView(frame: CGRectZero) as! Self
    }
}

// MARK: Public Methods
extension RSAPPBasePopView {
    public func showPop() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: UIView.AnimationOptions.curveEaseInOut) {
            self.alpha = 1
            self.y = .zero
        }
    }
    
    public func showPopFromRight() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: UIView.AnimationOptions.curveEaseInOut) {
            self.alpha = 1
            self.x = .zero
        }
    }
    
    public func dismiss(time: CGFloat = 0.3) {
        UIView.animate(withDuration: time, delay: .zero, options: UIView.AnimationOptions.curveEaseOut) {
            self.y = ScreenHeight
        } completion: { _ in
            self.autoRemove ? self.removeFromSuperview() : self.popDidDismissClosure?(self)
        }
    }
    
    public func dismissFromRight() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: UIView.AnimationOptions.curveEaseOut) {
            self.x = ScreenWidth
        } completion: { _ in
            self.autoRemove ? self.removeFromSuperview() : self.popDidDismissClosure?(self)
        }
    }
}

@objc private extension RSAPPBasePopView {
    func clickCloseButton(sender: UIButton) {
        self.dismiss()
    }
}
