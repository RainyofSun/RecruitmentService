//
//  IntExtension.swift
//  Living
//
//  Created by Eric on 2023/10/24.
//

import UIKit

enum NumberFormat {
    /// 精确显示
    case Accurate
    /// 简略
    case Simple
    /// 极简版 会显示 K
    case Minimalist
}

extension Int {
    /// 数字格式化 保留一位小数
    /// 1B = 1Billion = 1,000,000,000 = 10亿  1M = 1Million = 1,000,000 = 1百万 1K = 1Kilo = 1,000 = 1千
    func numberFormat(_ format: NumberFormat) -> String {
        guard self > .zero else {
            return "0"
        }
        
        // 精确版
        if format == .Accurate {
            return String(self)
        }
        
        // 转化亿
        if self >= 1_000_000_000 {
            return String(format: "%.1fB", Float(self)/1_000_000_000)
        }
        
        // 转化百万
        if self >= 1_000_000 {
            return String(format: "%.1fM", Float(self)/1_000_000)
        }
        
        // 转化千
        if self >= 1_000 {
            // 极简版
            if format == .Minimalist {
                return String(format: "%.1fK", Float(self)/1_000)
            }
            
            return String(self)
        }
        
        return String(self)
    }
}
