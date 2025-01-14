//
//  UIFontExtension.swift
//  Living
//
//  Created by Eric on 2023/10/26.
//

import UIKit

extension UIFont{
    
    /// 半粗体字体
    /// - Parameter size: 大小
    class public func semiBoldFont(size:CGFloat) -> UIFont{
        return UIFont.PopBold(size: size)
    }
    
    /// 粗体
    /// - Parameter size: 大小
    class public func boldFont(size:CGFloat) -> UIFont{
        return UIFont.PopBold(size: size)
    }
    
    /// 超粗体
    /// - Parameter size: 大小
    class public func blackFont(size:CGFloat) -> UIFont{
        return UIFont.PopBold(size: size)
    }
    
    /// Roboto 常规 字体
    /// - Parameter size: 大小
    class public func robotoRegular(size:CGFloat) -> UIFont{
        return UIFont.PopRegular(size: size)
    }
    
    class public func PopBold(size:CGFloat) -> UIFont{
        return UIFont(name: "Poppins", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class public func PopRegular(size:CGFloat) -> UIFont{
        return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: Weight.regular)
    }
    
    /// 常规字体
    /// - Parameter size: 大小
    class public func fontRegular(size:CGFloat) -> UIFont{
        return UIFont.PopRegular(size: size)
    }
    
}
