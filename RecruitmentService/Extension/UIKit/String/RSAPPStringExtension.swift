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

extension NSAttributedString {
    /// 附加图片和文字
    class func attachmentImage(_ imageName: String, afterText after: Bool = false, imageYPosition y: CGFloat = -3, attributeString str: String, textColor color: UIColor, textFont font: UIFont) -> NSMutableAttributedString? {
        guard let _img = UIImage(named: imageName) else {
            return nil
        }
            
        let _attachment: NSTextAttachment = NSTextAttachment.init()
        _attachment.image = _img
        _attachment.bounds = CGRect(origin: CGPoint(x: .zero, y: y), size: _img.size)
        
        let string: String = after ? str + " " : " " + str
        
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [.font: font, .foregroundColor: color])
        if after {
            attributeStr.append(NSAttributedString(attachment: _attachment))
        } else {
            attributeStr.insert(NSAttributedString(attachment: _attachment), at: .zero)
        }
        return attributeStr
    }
}
