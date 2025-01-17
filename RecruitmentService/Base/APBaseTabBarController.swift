//
//  APBaseTabBarController.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit

class APBaseTabBarController: UITabBarController {

    private var customBar: APCustomTabbar?
    private var vc_array: [UIViewController.Type] = [RSAPPHomeViewController.self, RSAPPPublishViewController.self, RSAPPNotificationViewController.self, RSAPPMineViewController.self]
    private var title_array: [String] = []
    private var image_array: [String] = ["tabbar_home_normal", "tabbar_publish_normal", "tabbar_notification_normal", "tabbar_mine_normal"]
    private var select_image_array: [String] = ["tabbar_home_sel", "tabbar_publish_sel", "tabbar_notification_sel", "tabbar_mine_sel"]
    
    override var selectedIndex: Int {
        didSet {
            self.customBar?.selectedTabbarItem(selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, let change = change, let newValue = change[.newKey] as? Bool {
            if keyPath == APP_LOGIN_KEY && !newValue {
                self.selectedIndex = .zero
            }
        }
    }
    
    deinit {
        deallocPrint()
    }
}

// MARK: Private Methods
private extension APBaseTabBarController {
    func setupUI() {
        let tabbar: APCustomTabbar = APCustomTabbar(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: UIDevice.xp_tabBarFullHeight())))
        self.setValue(tabbar, forKey: "tabBar")
        tabbar.tabbarItemImageInset = self.view.safeAreaInsets.bottom == .zero ? UIEdgeInsets(top: 5, left: .zero, bottom: .zero, right: .zero) : .zero
        tabbar.setTabbarTitles([RSAPPLanguage.localValue("tabbar_home"), RSAPPLanguage.localValue("tabbar_publish"), RSAPPLanguage.localValue("tabbar_notification"), RSAPPLanguage.localValue("tabbar_mine")], barItemImages: image_array, barItemSelectedImages: select_image_array)
        tabbar.setBadgeView(3)
        tabbar.barDelegate = self
        self.addMyVC()
        self.customBar = tabbar
        self.selectedIndex = .zero
        
        Global.shared.addObserver(self, forKeyPath: APP_LOGIN_KEY, options: .new, context: nil)
    }
    
    func addMyVC() {
        var listVCS:[UIViewController] = []
        vc_array.forEach { (vcType: UIViewController.Type) in
            listVCS.append(APBaseNavigationController(rootViewController: vcType.init()))
        }
        self.viewControllers = listVCS;
    }
}

// MARK: APCustomTabbarProtocol
extension APBaseTabBarController: APCustomTabbarProtocol {
    func ap_canSelected() -> Bool {
        return true
    }
    
    func ap_didSelctedItem(_ tabbar: APCustomTabbar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}
