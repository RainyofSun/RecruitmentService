//
//  RSAPPWebViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/3/6.
//

import UIKit
import WebKit

class RSAPPWebViewController: APBaseViewController {

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

        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let _url = self.link_url {
            self.webView.load(NSURLRequest(url: NSURL(string: _url)! as URL) as URLRequest)
        }
    }

}
