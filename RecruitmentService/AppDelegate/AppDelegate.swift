//
//  AppDelegate.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/14.
//

import UIKit
import IQKeyboardManagerSwift
import JWAquites

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true // 当点击键盘外部时，键盘是否应该关闭
        IQKeyboardManager.shared.keyboardDistance = 10
        
        WebPro.initWithConfiguration { (config: JWAConfigInfo) in
            config.host = BASE_URL
            config.bundleID = Bundle.main.bundleIdentifier ?? ""
            config.delegate = self
#if DEBUG
            config.isDev = true
#endif
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: WebProDelegate {
    func appWillEnterLoginPage(_ showGuestLogin: Bool) {
        let loginVC = RSAPPLoginViewController()
        loginVC.hideVistorLogin = !showGuestLogin
        WebPro.enterLoginPage(APBaseNavigationController(rootViewController: loginVC))
    }
    
    func appWillEnterMainPage(_ data: JWALoginData!) {
        CocoaLog.debug("用户信息:\n 登录状态 = \(data.isLogin) 用户ID = \(data.userId) 用户手机号 = \(data.phone) 登录标识符 = \(data.token) --- \n")
        Global.shared.userData = data
        
        WebPro.enterMainPage(APBaseTabBarController())
    }
}
