//
//  ResponsePluginType.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit
import Moya
import SwiftyJSON
import Alamofire

private let responseDataKey = "pyrazine"
private let responseCodeKey = "polycyclic"
private let responseMsgKey  = "antiaromatic"
private let successCode: Int = 0
private var responseExtensionKey: String = "MsgInfoKey"

class ResponsePluginType: PluginType {
    // 准备发起请求,可以在这里对请求进行修改，比如再增加一些额外的参数。
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let _originalUrl = request.url?.absoluteString else {
            return request
        }
        var newRequest: URLRequest = request
        let url: String = FVCommonArgus.splicingCommonParameters(_originalUrl)
        newRequest.url = URL(string: url)
        return newRequest
    }
    
    // 开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    // 收到请求响应
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case .success(_): break
        case .failure(let failure):
            errorHandler(error: ErrorResponse(code: failure.errorCode, message: failure.localizedDescription))
        }
    }
    
    // 处理请求结果。我们可以在 completion 前对结果进行进一步处理。
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
#if DEBUG
            let mapping = try? response.mapJSON()
            CocoaLog.debug(mapping ?? [:])
#endif
            let response = getResponse(response: response)
            if response.statusCode == successCode {
                return .success(response)
            } else {
                let errorMsg: String = response.responseMsg ?? ""
                let nsError: NSError = NSError(domain: "net.error", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg, NSLocalizedFailureReasonErrorKey: errorMsg])
                return .failure(MoyaError.underlying(nsError, response))
            }
        case .failure(_):
            break
        }
        return result
    }
    
    // 非标准rest返回需要加工一下
    func getResponse(response: Response) -> Response {
        let json = JSON(response.data)
        let msgInfo = json[responseMsgKey].stringValue
        do {
            let data = try json[responseDataKey].rawData()
            let res = Response(statusCode: json[responseCodeKey].intValue, data: data, request: response.request, response: response.response)
            res.responseMsg = msgInfo
            return res
        } catch {
            let res = Response(statusCode: json[responseCodeKey].intValue, data: Data(), request: response.request, response: response.response)
            return res
        }
    }
}

extension Response {
    var responseMsg: String? {
        get {
            return objc_getAssociatedObject(self, responseExtensionKey) as? String
        }
        set {
            objc_setAssociatedObject(self, responseExtensionKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
