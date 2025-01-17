//
//  RSAPPStringExtension.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/17.
//

import UIKit

extension String {
    func calculateTextHeight(font: UIFont? = UIFont.preferredFont(forTextStyle: .body), width: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
     
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
     
        let textRect = NSString(string: self).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes as [NSAttributedString.Key : Any],
            context: nil
        )
     
        return textRect.height
    }
}
