//
//  RSAPPWebViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/3/6.
//

import UIKit
import WebKit

class RSAPPWebViewController: APBaseViewController, HideNavigationBarProtocol {

    private lazy var navView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        let originalImage = UIImage(systemName: "chevron.backward")
        let tintedImage = originalImage?.withTintColor(BLACK_COLOR_333333, renderingMode: .alwaysOriginal)
        btn.setImage(tintedImage, for: UIControl.State.normal)
        btn.setImage(tintedImage, for: UIControl.State.highlighted)
        return btn
    }()
    
    private lazy var webView: WKWebView = WKWebView(frame: CGRectZero)
    
    private var link_url: String?
    
    init(link_url: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.link_url = link_url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backBtn.addTarget(self, action: #selector(clickBackBtn(sender: )), for: UIControl.Event.touchUpInside)
        self.view.addSubview(self.navView)
        self.navView.addSubview(self.backBtn)
        self.view.addSubview(self.webView)
        
        self.navView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(UIDevice.xp_navigationFullHeight())
        }
        
        self.backBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(UIDevice.xp_navigationBarHeight())
        }
        
        self.webView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(self.navView.snp.bottom)
        }
        
        if let _url = self.link_url {
            self.webView.load(NSURLRequest(url: NSURL(string: _url)! as URL) as URLRequest)
        }
    }
}

@objc private extension RSAPPWebViewController {
    func clickBackBtn(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
