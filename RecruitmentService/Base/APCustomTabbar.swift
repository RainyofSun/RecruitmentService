//
//  APCustomTabbar.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit

protocol APCustomTabbarProtocol: UITabBarController {
    /// 是否可以选中当前 Item
    func ap_canSelected() -> Bool
    /// 选中当前 Item
    func ap_didSelctedItem(_ tabbar: APCustomTabbar, item: UIButton, index: Int)
}

class APCustomTabbar: UITabBar {

    weak open var barDelegate: APCustomTabbarProtocol?
    open var tabbarItemImageInset: UIEdgeInsets = .zero
    open var tabbarCenterImageInset: UIEdgeInsets = .zero
    
    private lazy var path: UIBezierPath = UIBezierPath()
    private lazy var alienLayer: CALayer = CALayer()
    private lazy var alienShapeLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        maskLayer.shadowOffset = CGSize(width: 2, height: 4)
        maskLayer.shadowRadius = 8
        maskLayer.shadowOpacity = 0.2
        maskLayer.fillColor = UIColor.white.cgColor
        return maskLayer
    }()
    
    private var original_size: CGSize?
    private var center_size: CGSize = .zero
    private var center_index: Int?
    private let _top_y: CGFloat = 15
    
    private lazy var badgeView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.init(red: 1.0, green: 0, blue: 152/255.0, alpha: 1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    private lazy var badgeLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 10)
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.original_size = frame.size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let _size = self.original_size {
            return _size
        }
        
        return super.sizeThatFits(size)
    }
    
    override func draw(_ rect: CGRect) {
        let radius: CGFloat = 30
        self.alienLayer.frame = CGRect(x: .zero, y: -_top_y, width: rect.width, height: rect.height + _top_y)
        path.move(to: CGPoint(x: .zero, y: _top_y))
        path.addLine(to: CGPoint(x: rect.midX - radius * 0.9, y: _top_y))
        path.addQuadCurve(to: CGPoint(x: rect.midX + radius * 0.9, y: _top_y), controlPoint: CGPoint(x: rect.midX, y: -radius * 0.4))
        path.addLine(to: CGPoint(x: rect.width, y: _top_y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height + _top_y))
        path.addLine(to: CGPoint(x: .zero, y: rect.height + _top_y))
        path.close()
        path.lineWidth = 2
        self.alienShapeLayer.path = path.cgPath
        self.alienLayer.addSublayer(self.alienShapeLayer)
        self.layer.insertSublayer(self.alienLayer, at: .zero)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.alienLayer.frame.contains(point)
    }
}

// MARK: Public Methods
extension APCustomTabbar {
    /// 设置角标
    public func setBadgeView(_ index: Int) {
        guard let _widget = self.viewWithTag((100 + index)) as? UIButton, let _imageView = _widget.imageView else {
            return
        }
        
        self.badgeView.addSubview(self.badgeLab)
        _widget.addSubview(self.badgeView)
        
        self.badgeView.snp.makeConstraints { make in
            make.left.equalTo(_imageView.snp.right).offset(-8)
            make.top.equalTo(_imageView).offset(-5)
        }
        
        self.badgeLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(3)
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(20)
            make.width.greaterThanOrEqualTo(15)
        }
    }
    
    public func updateBadge(_ badge: Int) {
        self.badgeView.isHidden = badge == .zero
        self.badgeLab.text = badge > 99 ? "99+" : String(badge)
    }
    
    public func setCenterBarItem(_ size: CGSize, index: Int?) {
        self.center_size = size
        self.center_index = index
    }
    
    public func setTabbarTitles(_ titles: [String]? = nil, barItemImages images:[String], barItemSelectedImages selectImages: [String]) {
        let _count = self.center_size == .zero ? images.count : images.count - 1
        let item_width: CGFloat = (UIScreen.main.bounds.width - self.center_size.width)/CGFloat(_count)
        let item_height: CGFloat = 49
        images.enumerated().forEach { (index: Int, image: String) in
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setTitle(titles?[index], for: UIControl.State.normal)
            button.setTitle(titles?[index], for: UIControl.State.highlighted)
            button.setTitleColor(UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1), for: UIControl.State.normal)
            button.setTitleColor(UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1), for: UIControl.State.highlighted)
            button.setImage(UIImage(named: image), for: UIControl.State.normal)
            button.setImage(UIImage(named: selectImages[index]), for: UIControl.State.selected)
            button.imageEdgeInsets = index != self.center_index ? self.tabbarItemImageInset : self.tabbarCenterImageInset
            if let _c_index = self.center_index {
                if index < _c_index {
                    button.frame = CGRect(x: item_width * CGFloat(index), y: .zero, width: item_width, height: item_height)
                }
                if index == _c_index {
                    button.frame = CGRect(origin: CGPoint(x: item_width * CGFloat(index), y: -_top_y + 2), size: self.center_size)
                }
                if index > _c_index {
                    button.frame = CGRect(x: item_width * CGFloat(index - 1) + self.center_size.width, y: .zero, width: item_width, height: item_height)
                }
            } else {
                button.frame = CGRect(x: item_width * CGFloat(index), y: .zero, width: item_width, height: item_height)
            }
            button.tag = 100 + index
            button.addTarget(self, action: #selector(clickTabbarItem(sender: )), for: UIControl.Event.touchUpInside)
            self.addSubview(button)
        }
    }
    
    /// 设置选中界面
    public func selectedTabbarItem(_ index: Int) {
        guard let _item = self.viewWithTag((100 + index)) as? UIButton else {
            return
        }
        self.reseButtonState()
        _item.isSelected = !_item.isSelected
    }
}

// MARK: Private Methods
private extension APCustomTabbar {
    func reseButtonState() {
        for item in self.subviews {
            if let _btn = item as? UIButton, _btn.tag >= 100 {
                if _btn.isSelected {
                    _btn.isSelected = false
                    break
                }
            }
        }
    }
}

// MARK: Target
@objc private extension APCustomTabbar {
    func clickTabbarItem(sender: UIButton) {
        if !(self.barDelegate?.ap_canSelected() ?? true) {
            return
        }
        self.reseButtonState()
        sender.isSelected = !sender.isSelected
        self.barDelegate?.ap_didSelctedItem(self, item: sender, index: sender.tag - 100)
    }
}
