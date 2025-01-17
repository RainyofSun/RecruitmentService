//
//  RSAPPMineViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPMineViewController: APBaseViewController, HideNavigationBarProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBrown
        Global.shared.addObserver(self, forKeyPath: APP_LOGIN_KEY, options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, let change = change, let newValue = change[.newKey] as? Bool {
            if keyPath == APP_LOGIN_KEY && !newValue {
                CocoaLog.debug("------- 用户登出了 ---------")
            }
        }
    }
}
