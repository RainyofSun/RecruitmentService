//
//  RSAPPCustomTextFiled.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/17.
//

import UIKit

class RSAPPCustomTextFiled: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 5
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 5
        return rect
    }
    
    // UITextField 文字与输入框的距离
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }
    
    // 控制文本的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false;
        }
        return super.canPerformAction(action, withSender: sender);
    }
    
    deinit {
        deallocPrint()
    }
}
