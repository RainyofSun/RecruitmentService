//
//  Global.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit
import JWAquites

let APP_LOGIN_KEY: String = "appLogin"

class Global: NSObject {
    
    // 用户信息
    open var userData: JWALoginData? {
        didSet {
            self.appLogin = userData != nil
        }
    }
    
    /// 外界监听登出/登录
    @objc private dynamic var appLogin: Bool = false
    
    public static let shared = Global()
}
