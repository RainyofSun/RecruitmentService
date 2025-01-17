//
//  RSAPPHomeQuestionView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeQuestionView: UIControl {

    private lazy var titleLab: UILabel = {
        let view = UILabel.buildLabel(labFont: UIFont.systemFont(ofSize: 14))
        view.textAlignment = .left
        return view
    }()
    
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "home_arrow"))
    
    private lazy var contentLab: UILabel = {
        let view = UILabel.buildLabel()
        view.textAlignment = .left
        view.alpha = .zero
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            var textHeight: CGFloat = 0.001
            if isSelected {
                textHeight = self.contentLab.text?.calculateTextHeight(font: UIFont.systemFont(ofSize: 12), width: ScreenWidth - PADDING_UNIT * 7) ?? 0.001
                UIView.animate(withDuration: 0.3) {
                    self.contentLab.snp.updateConstraints { make in
                        make.height.equalTo(textHeight)
                    }
                    self.arrowImgView.transform = CGAffineTransformMakeRotation(-Double.pi * 0.5)
                    self.contentLab.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.contentLab.snp.updateConstraints { make in
                        make.height.equalTo(textHeight)
                    }
                    self.arrowImgView.transform = CGAffineTransform.identity
                    self.contentLab.alpha = .zero
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.contentLab)
        
        self.titleLab.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-PADDING_UNIT * 2)
        }
        
        self.contentLab.snp.remakeConstraints { make in
            make.left.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.height.equalTo(0.001)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 5)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
            make.centerY.equalTo(self.titleLab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setQuestionTitle(title: String, content: String) {
        let appName = UIDevice.appName()
        self.titleLab.text = String(format: RSAPPLanguage.localValue(title), appName)
        self.contentLab.text = String(format: RSAPPLanguage.localValue(content), appName)
    }
}
