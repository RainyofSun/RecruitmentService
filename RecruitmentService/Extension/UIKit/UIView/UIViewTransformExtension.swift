//
//  UIViewTransformExtension.swift
//  Living
//
//  Created by Eric on 2023/10/24.
//

import UIKit

// MARK:- 四、继承于 UIView 视图的 平面、3D 旋转 以及 缩放
/**
 从m11到m44定义的含义如下：
 m11：x轴方向进行缩放
 m12：和m21一起决定z轴的旋转
 m13:和m31一起决定y轴的旋转
 m14:
 m21:和m12一起决定z轴的旋转
 m22:y轴方向进行缩放
 m23:和m32一起决定x轴的旋转
 m24:
 m31:和m13一起决定y轴的旋转
 m32:和m23一起决定x轴的旋转
 m33:z轴方向进行缩放
 m34:透视效果m34= -1/D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
 m41:x轴方向进行平移
 m42:y轴方向进行平移
 m43:z轴方向进行平移
 m44:初始为1
 */
extension UIView {

    // MARK: 4.1、平面旋转
    /// 平面旋转
    /// - Parameters:
    ///   - angle: 旋转多少度
    ///   - isInverted: 顺时针还是逆时针，默认是顺时针
    public func setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        self.transform = isInverted ? CGAffineTransform(rotationAngle: angle).inverted() : CGAffineTransform(rotationAngle: angle)
    }

    // MARK: 4.2、沿X轴方向旋转多少度(3D旋转)
    /// 沿X轴方向旋转多少度(3D旋转)
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationX(_ angle: CGFloat) {
        // 初始化3D变换,获取默认值
        //var transform = CATransform3DIdentity
        // 透视 1/ -D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
        // 当我们有垂直于z轴的旋转分量时，设置m34的值可以增加透视效果，也可以理解为景深效果
        // transform.m34 = 1.0 / -1000.0
        // 空间旋转，x，y，z决定了旋转围绕的中轴，取值为 (-1,1) 之间
        //transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        //self.self.layer.transform = transform
        self.layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }

    // MARK: 4.3、沿 Y 轴方向旋转多少度(3D旋转)
    /// 沿 Y 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }

    // MARK: 4.4、沿 Z 轴方向旋转多少度(3D旋转)
    /// 沿 Z 轴方向旋转多少度
    /// - Parameter angle: 旋转角度，angle参数是旋转的角度，为弧度制 0-2π
    public func set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    // MARK: 4.5、沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// 沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// - Parameters:
    ///   - xAngle: x 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - yAngle: y 轴的角度，旋转的角度，为弧度制 0-2π
    ///   - zAngle: z 轴的角度，旋转的角度，为弧度制 0-2π
    public func setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    // MARK: 4.6、设置 x,y 缩放
    /// 设置 x,y 缩放
    /// - Parameters:
    ///   - x: x 放大的倍数
    ///   - y: y 放大的倍数
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}
