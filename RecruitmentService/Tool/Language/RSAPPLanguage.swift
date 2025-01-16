//
//  RSAPPLanguage.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

enum LanguageType: Int {
    case english
    case vietnamese
    case Auto
}

// MARK: 单例 -- 管理多语言
class RSAPPLanguage: NSObject {
    
    //单例
    static let shared = RSAPPLanguage()
    
    private override init() {}
    private var bundle:Bundle = Bundle.main
    
    /// 加载多语言
    static func localValue(_ str:String) -> String {
        RSAPPLanguage.shared.localValue(str: str)
    }
    
    /// 设置语言类别
    static func setLanguage(_ type:LanguageType){
        RSAPPLanguage.shared.setLanguage(type)
    }
    
    private func localValue(str:String) -> String{
        //table参数值传nil也是可以的，传nil系统就会默认为Localizable
        bundle.localizedString(forKey: str, value: nil, table: "Localizable")
    }

    private func setLanguage(_ type:LanguageType){
        var typeStr = ""
        switch type {
        case .vietnamese:
            // 越南语
            typeStr = "vi"
        case .english:
            typeStr = "en"
        case .Auto:
            typeStr = Locale.current.languageCode ?? "vi"
            if let _script_code = Locale.current.scriptCode {
                typeStr += "-\(_script_code)"
            }
        }
        
        //返回项目中 en.lproj 文件的路径
        var path = Bundle.main.path(forResource: typeStr, ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }
        
        //用这个路径生成新的bundle
        bundle = Bundle(path: path!)!
    }
}
