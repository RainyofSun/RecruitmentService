//
//  ResponseModel.swift
//  Living
//
//  Created by Eric on 2023/10/24.
//

import UIKit
import SwiftyJSON

struct SuccessResponse {
    /// 非数组模型
    var dataJSON: [String: Any]?
    /// 数组模型
    var arrayJSON: [Any]?
    /// 分页的游标
    var cursor: Int?
    /// 分页总页数
    var totalPages: Int?
    /// 请求消息
    var responseMsg: String?
}

struct ErrorResponse {
    var code: Int = -999
    var message: String = ""
}
