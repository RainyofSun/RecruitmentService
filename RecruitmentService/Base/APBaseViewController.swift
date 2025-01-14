//
//  APBaseViewController.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit
import FDFullscreenPopGesture
import SnapKit

class APBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = self.hideNavBar()
        
        self.view.backgroundColor = .orange
    }
    
    deinit {
        deallocPrint()
    }
    
    public func hideNavBar() -> Bool {
        return false
    }
}
