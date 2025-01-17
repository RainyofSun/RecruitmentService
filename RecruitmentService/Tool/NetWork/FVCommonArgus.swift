//
//  FVCommonArgus.swift
//  FastVay
//
//  Created by Yu Chen  on 2024/11/21.
//

import UIKit
import AdSupport

class FVCommonArgus: NSObject {
    
    public static func splicingCommonParameters(_ url: String) -> String {
        // APP Version
        let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        // 设备名称
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier: String = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        // IDFV
        let idfv: String = UIDevice.current.keychainIdfv
        // 设备版本
        let sysVersion: String = UIDevice.current.systemVersion
        // 登录态
        let loginStatus: String = Global.shared.userData?.token ?? ""
        // IDFA
//        let idfa: String = FVDeviceAuthorizationTool.ATTTrackingStatus() == .authorized ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
        
        var components = URLComponents(string: url)

        components?.queryItems = [
            URLQueryItem(name: "society", value: appVersion),
            URLQueryItem(name: "american", value: identifier),
            URLQueryItem(name: "ultramicroelectrode", value: idfv),
            URLQueryItem(name: "ren", value: sysVersion),
            URLQueryItem(name: "fan", value: loginStatus),
//            URLQueryItem(name: "yang", value: idfa)
//            URLQueryItem(name: "exploration", value: "\(Global.shared.countryCode)")
        ]

        if url.contains("?") {
            let params = FVCommonArgus.separationURLParameter(url: url)
            if !params.isEmpty {
                params.forEach { (tupe: (String, String)) in
                    components?.queryItems?.append(URLQueryItem(name: tupe.0, value: tupe.1))
                }
            }
        }
        return components?.url?.absoluteString ?? url
    }
}

private extension FVCommonArgus {
    static func separationURLParameter(url: String) -> [(String, String)] {
        let paraStr = url.components(separatedBy: "?").last
        var tupeArray: [(String, String)] = []
        if let paraStr1 = paraStr?.components(separatedBy: "&") {
            paraStr1.forEach({ (item: String) in
                let params = item.components(separatedBy: "=")
                if let _key = params.first, let _value = params.last {
                    tupeArray.append((_key, _value))
                }
            })
        }
        
        return tupeArray
    }
}
