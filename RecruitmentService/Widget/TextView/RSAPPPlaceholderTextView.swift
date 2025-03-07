//
//  RSAPPPlaceholderTextView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/12.
//

import UIKit

class RSAPPPlaceholderTextView: UITextView {

    open var endEditingClosure: ((String?) -> Void)?
    
    /// 最大字数
    open var maxTextLength: Int = 200
    
    /// 占位文字
    open var placeholder: String? {
        didSet {
            self.placeholderLab.text = placeholder
        }
    }
    
    /// 占位文字颜色
    open var placeholderColor: UIColor? {
        didSet {
            if let _color = placeholderColor {
                self.placeholderLab.textColor = _color
            }
        }
    }
    
    /// 占位文字字体,默认和文本框同一字体
    open var placeholderFont: UIFont? {
        didSet {
            self.placeholderLab.font = placeholderFont
        }
    }
    
    override var font: UIFont? {
        didSet {
            if let _ = placeholderFont {
                return
            }
            placeholderFont = font
            self.placeholderLab.font = placeholderFont
        }
    }
    
    override var text: String! {
        didSet {
            self.placeholderLab.isHidden = !text.isEmpty
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            self.placeholderLab.isHidden = attributedText.length != 0
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    private lazy var placeholderLab: UILabel = {
        return UILabel.init()
    }()
    
    private lazy var numberLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textColor = GRAY_COLOR_9CA3AF
        view.font = UIFont.systemFont(ofSize: 10)
        view.text = "0/\(self.maxTextLength)"
        view.textAlignment = .right
        return view
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderLab.numberOfLines = 0
        if #available(iOS 14.0, *) {
            placeholderLab.lineBreakStrategy = []
        } else {
            // Fallback on earlier versions
        }
        self.delegate = self
        
        self.addSubview(placeholderLab)
        self.addSubview(self.numberLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateConstraintsForPlaceholderLabel()
    }
    
    deinit {
        deallocPrint()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        if self.bounds.height == .zero || self.bounds.width == .zero {
            return
        }
        
        self.placeholderLab.snp.removeConstraints()
        let _scale = (self.textContainerInset.left + self.textContainerInset.right + 5)/self.bounds.width
        self.placeholderLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(textContainerInset.left)
            make.width.equalToSuperview().multipliedBy((1 - _scale))
            make.top.equalToSuperview().offset(textContainerInset.top)
            make.bottom.equalToSuperview().offset(-textContainerInset.bottom)
        }
        
        self.numberLab.frame = CGRect(x: self.width - 55, y: self.height - 20, width: 50, height: 20)
    }

    /// 重新设置占位文字
    private func resetPlaceHolderText() {
        if self.hasText {
            CocoaLog.debug("还有输入的文字 -------- 不设置占位文字 ------")
            return
        }
        
        self.placeholderLab.text = self.placeholder
        self.placeholderColor = GRAY_COLOR_9CA3AF
        self.numberLab.text = "0/\(self.maxTextLength)"
    }
}

// MARK: UITextViewDelegate
extension RSAPPPlaceholderTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        
        return textView.text.count < self.maxTextLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let _textV = textView as? Self else {
            return
        }
        
        if _textV.hasText {
            _textV.placeholderLab.text = nil
            _textV.numberLab.text = "\(_textV.text.count)/\(self.maxTextLength)"
        } else {
            resetPlaceHolderText()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.endEditingClosure?(textView.text)
    }
}
