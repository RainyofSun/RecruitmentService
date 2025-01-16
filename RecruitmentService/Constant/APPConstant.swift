//
//  APPConstant.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit

// MARK: URL
let BASE_URL: String = "https://api.github.com/"

// MARK: Frame
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height
let PADDING_UNIT: CGFloat = 4

let APP_ACCOUNT_KEY = "APP_ACCOUNT_KEY"

// MARK: Color
let BLUE_COLOR_1874FF: UIColor = UIColor.hexString("#1874FF")
let BLACK_COLOR_333333: UIColor = UIColor.hexString("#333333")
let GRAY_COLOR_999999: UIColor = UIColor.hexString("#999999")

// MARK: 通知
// 网络状态通知
public let APPNetStateNotification = Notification.Name("com.rs.notification.name.net.appNetState")
