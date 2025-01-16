//
//  RSAPPHomeViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeViewController: APBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        RSAPPAuthAlertView.showAlertView(title: "xXXXX", content: "nisdadsadjad", superView: self.view) {
            CocoaLog.debug("----------")
        }
    }
}
