//
//  RSAPPHomeQuestionHeaderView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/3/16.
//

import UIKit

class RSAPPHomeQuestionHeaderView: UITableViewHeaderFooterView {

    open var clickHeaderClousre: (() -> Void)?
    
    private lazy var contentControl: UIControl = UIControl(frame: CGRectZero)
    
    private lazy var titleLab: UILabel = {
        let view = UILabel.buildLabel(labFont: UIFont.systemFont(ofSize: 14))
        view.textAlignment = .left
        return view
    }()
    
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "home_arrow"))
    private var _expand: Bool = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentControl.addTarget(self, action: #selector(clickHeader(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.contentControl)
        self.contentControl.addSubview(self.titleLab)
        self.contentControl.addSubview(self.arrowImgView)
        
        self.contentControl.snp.makeConstraints { make in
            make.left.width.verticalEdges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadHeaderTitle(_ title: String, isExpand: Bool = false) {
        self.titleLab.text = String(format: RSAPPLanguage.localValue(title), UIDevice.appName())
        self._expand = isExpand
        if self._expand {
            UIView.animate(withDuration: 0.3) {
                self.arrowImgView.transform = CGAffineTransformMakeRotation(-Double.pi * 0.5)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.arrowImgView.transform = CGAffineTransform.identity
            }
        }
    }
}

@objc private extension RSAPPHomeQuestionHeaderView {
    func clickHeader(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.clickHeaderClousre?()
    }
}
