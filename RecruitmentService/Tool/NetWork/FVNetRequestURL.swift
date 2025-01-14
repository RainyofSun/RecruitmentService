//
//  FVNetRequestURL.swift
//  FastVay
//
//  Created by Yu Chen  on 2024/11/21.
//

import UIKit

class FVNetRequestURL: NSObject {
    public static let shared = FVNetRequestURL()
    private(set) var domain_url: String?
    private var used_domain_urls: [String] = []
    
    public func setNewDomainURL(_ url: String) -> Bool {
        if self.used_domain_urls.contains(url) {
            return false
        }
        
        self.domain_url = url
        self.used_domain_urls.append(url)
        CocoaLog.debug("------- 设置新的域名 = \(url) success --------")
        return true
    }
    
    public static func requestURL() -> String {
        if let _u = FVNetRequestURL.shared.domain_url {
            return _u
        }
        
        return BASE_URL
    }
}
