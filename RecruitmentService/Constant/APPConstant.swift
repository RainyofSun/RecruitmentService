//
//  APPConstant.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit

// MARK: URL
//let BASE_URL: String = "http://api.ddongl.com/"
let BASE_URL: String = "http://api.fiksgo.com/"
/// 仅在测试阶段使用
let Boundle_ID: String = "com.abcd.test"

// MARK: Frame
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height
let PADDING_UNIT: CGFloat = 4

let APP_ACCOUNT_KEY = "APP_ACCOUNT_KEY"

// MARK: Color
let BLUE_COLOR_1874FF: UIColor = UIColor.hexString("#1874FF")
let BLACK_COLOR_333333: UIColor = UIColor.hexString("#333333")
let BLACK_COLOR_374151: UIColor = UIColor.hexString("#374151")
let BLACK_COLOR_4B5563: UIColor = UIColor.hexString("#4B5563")
let BLACK_COLOR_666666: UIColor = UIColor.hexString("#666666")
let GRAY_COLOR_999999: UIColor = UIColor.hexString("#999999")
let GRAY_COLOR_9CA3AF: UIColor = UIColor.hexString("#9CA3AF")

// MARK: 通知
// 网络状态通知
public let APPNetStateNotification = Notification.Name("com.rs.notification.name.net.appNetState")
// 发布切换通知
public let APPGoToPublishTabNotification = Notification.Name("com.rs.notification.name.tab.gotoPublish")

// MARK: 协议
let USER_PRIVACY: String = "https://www.fiksgo.com/user-agreement"
let PRIVACY_POLICY: String = "https://www.fiksgo.com/privacy-policy"
