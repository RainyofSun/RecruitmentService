//
//  Global.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit
// TODO 考虑是否要定义全局传值
class Global: NSObject {
    
    // token
    open var token: String?
    // refreshToken
    open var refreshToken: String?
    
    public static let shared = Global()
}
