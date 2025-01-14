//
//  APBaseTabBarController.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit

class APBaseTabBarController: UITabBarController {

    private var customBar: APCustomTabbar?
    private var vc_array: [UIViewController.Type] = [UIViewController.self, UIViewController.self, UIViewController.self, UIViewController.self, UIViewController.self]
    private var title_array: [String] = []
    private var image_array: [String] = ["tab_home_n", "tab_moment_n", "tab_creat", "tab_msg_n", "tab_me_n"]
    private var select_image_array: [String] = ["tab_home_h", "tab_moment_h", "tab_creat", "tab_msg_h_livo", "tab_me_h"]
    private let CENTER_INDEX: Int = 2
    
    override var selectedIndex: Int {
        didSet {
            self.customBar?.selectedTabbarItem(selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
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
        tabbar.setCenterBarItem(CGSize(width: 58, height: 58), index: CENTER_INDEX)
        tabbar.setTabbarTitles(barItemImages: image_array, barItemSelectedImages: select_image_array)
        tabbar.setBadgeView(3)
        tabbar.barDelegate = self
        self.addMyVC()
        self.customBar = tabbar
        self.selectedIndex = .zero
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
        if index == CENTER_INDEX {
            let vc = APBaseNavigationController(rootViewController: UIViewController())
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        } else {
            self.selectedIndex = index
        }
    }
}
