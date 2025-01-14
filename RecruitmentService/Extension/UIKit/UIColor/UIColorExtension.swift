//
//  UIColorExtension.swift
//  Living
//
//  Created by Eric on 2023/10/26.
//

import UIKit

extension UIColor{
    /// 背景颜色
    public class var darkColor: UIColor {
        return UIColor.hexString("#13131E")
    }
    
    public class var darkGray: UIColor {
        return UIColor.hexString("#393942")
    }
    
    public class var imageBgColor: UIColor {
        return UIColor.hexString("#f6f6f6")
    }
}

extension UIColor {
    
    public convenience init(r: UInt32, g: UInt32, b: UInt32, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    public convenience init(rgb: UInt32) {
        self.init(rgba: rgb << 8 | 0xFF)
    }
    
    public convenience init(rgba: UInt32) {
        self.init(r: rgba >> 24, g: rgba >> 16 & 0xFF, b: rgba >> 8 & 0xFF, a: CGFloat(rgba & 0xFF) / 255)
    }
    
    class func hexString(_ hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(UIColor.hexStringToInt(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    class func hexStringToInt(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

public func RGB(r:Float,g:Float,b:Float) -> UIColor {
    return UIColor(red: CGFloat(r/255.0), green:CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1))
}

public func RGBA(r:Float,g:Float,b:Float,a:Float) -> UIColor {
    return UIColor(red: CGFloat(r/255.0), green:CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a))
}
