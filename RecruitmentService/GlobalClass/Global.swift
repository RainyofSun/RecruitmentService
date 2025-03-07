//
//  Global.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit

let APP_LOGIN_KEY: String = "userData"

class Global: NSObject {
    
    // 用户信息 外界监听登出/登录
    open dynamic var userData: JWALoginData?
    
    open var appLogin: Bool {
        return userData?.isLogin ?? false
    }
    
    public static let shared = Global()
    
    public func saveRequirementMessageToServer() {
        if let path = Bundle.main.path(forResource: "task", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonArray = jsonObject as? [[String:Any]] {
//                    NetworkRequest(RSAPPNetworkAPI.deleteRequirementData(keys: [REQUIREMENT_INFO_KEY]), modelType: RSAPPBaseResponseModel.self) { _, _ in
//                        CocoaLog.debug("--------- 删除招工信息成功 ------------")
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            NetworkRequest(RSAPPNetworkAPI.SaveRequirementArrayParams(paramsJson: jsonArray, key: REQUIREMENT_INFO_KEY), modelType: RSAPPBaseResponseModel.self) { _, _ in
                                CocoaLog.debug("--------- 保存招工信息成功 ------------")
                            } failureCallback: { _ in
                                CocoaLog.error("--------- 保存招工信息失败 ------------")
                            }
//                        })
//                    } failureCallback: { _ in
//                        CocoaLog.error("--------- 删除招工信息失败 ------------")
//                    }
                }
            } catch {
                
            }
        }
    }
}
