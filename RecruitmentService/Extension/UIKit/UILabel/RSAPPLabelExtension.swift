//
//  RSAPPLabelExtension.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

extension UILabel {
    class func buildLabel(title: String? = nil, titleColor: UIColor? = BLACK_COLOR_333333, labFont: UIFont? = UIFont.systemFont(ofSize: 12)) -> UILabel {
        let lab = UILabel(frame: CGRectZero)
        lab.textColor = titleColor
        lab.font = labFont
        lab.numberOfLines = .zero
        lab.text = title
        lab.textAlignment = .center
        return lab
    }
}

extension UIButton {
    class func buildButton(title: String? = nil, titleColor: UIColor? = UIColor.hexString("#656C74"), titleFont:UIFont? = UIFont .systemFont(ofSize: 14), backgroudColor: UIColor? = BLUE_COLOR_1874FF, cornerRadius: CGFloat = 4) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(titleColor, for: UIControl.State.normal)
        btn.titleLabel?.font = titleFont
        btn.backgroundColor = backgroudColor
        btn.layer.cornerRadius = cornerRadius
        btn.clipsToBounds = true
        
        return btn
    }
}
