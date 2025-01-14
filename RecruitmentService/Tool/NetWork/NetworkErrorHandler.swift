//
//  NetworkErrorHandler.swift
//  Living
//
//  Created by Eric on 2023/10/26.
//

import UIKit
import Toast_Swift

// MARK: 错误代码
/// TOEKN 失效
let TOKEN_EXPIRED: Int = -2
/// 服务器错误
let SERVICE_ERROR: Int = 500
/// JSON 解析失败
let JSON_SERIALIZATION_ERROR: Int = 1000000
/// 无网络
let NETWORK_ERROR: Int = 9999

/// 错误处理
/// - Parameters:
///   - code: code码
///   - message: 错误消息
///   - needShowFailAlert: 是否显示网络请求失败的弹框
///   - failure: 网络请求失败的回调
func errorHandler(error: ErrorResponse, needShowFailAlert: Bool = false, failure: ((ErrorResponse) -> Void)? = nil) {
    let errorMessage: String = error.message
    if error.code == TOKEN_EXPIRED {
//        let loginNav: APBaseNavigationController = APBaseNavigationController(rootViewController: FVLoginViewController())
//        loginNav.modalPresentationStyle = .fullScreen
//        UIDevice.appKeyWindow().rootViewController?.present(loginNav, animated: true)
    } else if error.code == SERVICE_ERROR {
        //errorMessage = "服务器开小差儿了...."
    } else if error.code == JSON_SERIALIZATION_ERROR {
        //errorMessage = "JSON serialization fail"
    } else if error.code == NETWORK_ERROR {
        //errorMessage = "netowrk lost...."
    }
    
    if needShowFailAlert {
        // 展示弹窗
        UIDevice.appKeyWindow().makeToast(errorMessage, position: ToastPosition.center)
    }
    
    CocoaLog.error("Net Request Error: code = \(error.code) message = \(errorMessage)")
    failure?(error)
}
