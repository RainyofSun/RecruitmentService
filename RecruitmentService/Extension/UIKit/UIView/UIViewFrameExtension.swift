//
//  UIViewFrameExtension.swift
//  Living
//
//  Created by Eric on 2023/10/24.
//

import UIKit

public extension UIView {    
    /// x 的位置
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }

    /// y 的位置
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }

    /// height: 视图的高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }

    /// width: 视图的宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }

    /// size: 视图的zize
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size = newValue
            self.frame = tempFrame
        }
    }

    /// centerX: 视图的X中间位置
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }

    /// centerY: 视图Y的中间位置
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.y = newValue
            self.center = tempCenter;
        }
    }

    /// centerY: 视图Y的中间位置
    var centerPoint: CGPoint {
        get {
            return self.center
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter = newValue
            self.center = tempCenter;
        }
    }

    /// top 上端横坐标(y)
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }

    /// left 左端横坐标(x)
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }

    /// bottom 底端纵坐标 (y + height)
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    /// right 底端纵坐标 (x + width)
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
}
