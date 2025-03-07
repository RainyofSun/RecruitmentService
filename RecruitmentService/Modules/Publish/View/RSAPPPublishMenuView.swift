//
//  RSAPPPublishMenuView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/19.
//

import UIKit

protocol APPPublishMenuProtocol: AnyObject {
    func didSelectedMenuItem(idx: NSInteger)
}

class RSAPPPublishMenuView: UIView {

    weak open var menuDelegate: APPPublishMenuProtocol?
    
    private var titlesArray: [String] = [RSAPPLanguage.localValue("publish_top_menu_item1"), RSAPPLanguage.localValue("publish_top_menu_item2"),
                                         RSAPPLanguage.localValue("publish_top_menu_item3"), RSAPPLanguage.localValue("publish_top_menu_item4")]
    private lazy var lineView: UIImageView = UIImageView(image: UIImage(named: "menu_slider"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var temp_left_item: UIButton?
        self.addSubview(self.lineView)
        
        for (index, obj) in titlesArray.enumerated() {
            let btn: UIButton = UIButton(type: UIButton.ButtonType.custom)
            btn.setTitle(obj, for: UIControl.State.normal)
            btn.setTitle(obj, for: UIControl.State.selected)
            btn.setTitleColor(BLACK_COLOR_666666, for: UIControl.State.normal)
            btn.setTitleColor(BLUE_COLOR_1874FF, for: UIControl.State.selected)
            btn.titleLabel?.font = index == .zero ? UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium) : UIFont.systemFont(ofSize: 14)
            btn.isSelected = index == 0
            btn.tag = 1000 + index
            btn.addTarget(self, action: #selector(clickMenuItem(sender: )), for: UIControl.Event.touchUpInside)
            self.addSubview(btn)
            
            if let _left = temp_left_item {
                if index == titlesArray.count - 1 {
                    btn.snp.makeConstraints { make in
                        make.top.size.equalTo(_left)
                        make.left.equalTo(_left.snp.right)
                        make.right.equalToSuperview().offset(-PADDING_UNIT * 3)
                    }
                } else {
                    btn.snp.makeConstraints { make in
                        make.top.size.equalTo(_left)
                        make.left.equalTo(_left.snp.right)
                    }
                }
            } else {
                btn.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(PADDING_UNIT * 3)
                    make.top.equalToSuperview().offset(PADDING_UNIT)
                    make.height.equalTo(30)
                }
            }
            
            temp_left_item = btn
            
            if index == 0 {
                self.lineView.snp.makeConstraints { make in
                    make.centerX.equalTo(btn)
                    make.top.equalTo(btn.snp.bottom)
                    make.bottom.equalToSuperview().offset(-PADDING_UNIT)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func switchMenuItem(index: Int) {
        guard let _view = self.viewWithTag(1000 + index) as? UIButton else {
            return
        }
        
        self.clickMenuItem(sender: _view)
    }
}

private extension RSAPPPublishMenuView {
    func resetButtonStatus() {
        for item in self.subviews {
            if let _btn = item as? UIButton, _btn.isSelected {
                _btn.isSelected = false
                _btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                break
            }
        }
    }
}

@objc private extension RSAPPPublishMenuView {
    func clickMenuItem(sender: UIButton) {
        self.resetButtonStatus()
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.3) {
            self.lineView.centerX = sender.centerX
        }
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        self.menuDelegate?.didSelectedMenuItem(idx: sender.tag - 1000)
    }
}
