//
//  NetworkManager.swift
//  Living
//
//  Created by Eric on 2023/10/24.
//

import UIKit
import Alamofire
import Moya
import HandyJSON
import SwiftyJSON

/// 超时时长
private var requestTimeOut: Double = 30
/// 单个模型的成功回调
typealias RequestModelSuccessCallback<HandyJSON> = ((HandyJSON, SuccessResponse) -> Void)
/// 数组模型的成功回调
typealias RequestModelsSuccessCallback<HandyJSON> = (([HandyJSON?], SuccessResponse) -> Void)
/// 文件下载成功的回调
typealias RequestDownloadSuccessCallback = ((String, SuccessResponse) -> Void)
/// 网络请求的回调
typealias RequestCallback = ((ErrorResponse) -> Void)

private let responseListKey = "list"
private let responsePageKey = "page"
private let responseTotalPageKey = "total_pages"

/// 网络请求的基本设置
private let RequestEndpointClosure = {(target: TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    requestTimeOut = 30
    return endpoint
}

/// 网络请求的配置
private let RequestClosure = { (endPoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endPoint.urlRequest()
        // 请求时长
        request.timeoutInterval = requestTimeOut
        // 打印参数
        if let requestData = request.httpBody {
            CocoaLog.debug("请求的url：\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            CocoaLog.debug("请求的url：\(request.url!) " + "\(String(describing: request.httpMethod))")
        }

        if let header = request.allHTTPHeaderFields {
            CocoaLog.debug("请求头内容\(header)")
        }
        
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/// 网络请求发送的核心初始化方法，创建网络请求对象
fileprivate var AuthProvider: MoyaProvider<MultiTarget> {
    get {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        let customSession = Session(configuration: configuration, startRequestsImmediately: true, interceptor: NetRequestInterceptor())
        
        return MoyaProvider<MultiTarget>(endpointClosure: RequestEndpointClosure, requestClosure: RequestClosure, callbackQueue: .main, session: customSession, plugins: [networkPlugin, ResponsePluginType()], trackInflights: false)
    }
}

/// NetworkActivityPlugin插件用来监听网络请求,界面上做相应的展示
private let networkPlugin = NetworkActivityPlugin.init { change, target in
    DispatchQueue.main.async {
        switch change {
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

/// 网络请求，当模型为dict类型
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - modelType: 模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetworkRequest<T: HandyJSON>(_ target: TargetType, needShowFailAlert: Bool = false, modelType: T.Type, successCallback: @escaping RequestModelSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert) { (respModel: SuccessResponse) in
        if let _model = T.deserialize(from: respModel.dataJSON) {
            successCallback(_model, respModel)
        }
    } failureCallback: { (respModel: ErrorResponse) in
        failureCallback?(respModel)
    }
}

/// 网络请求，当模型为数组类型
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - modelType: 模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetworkRequest<T: HandyJSON>(_ target: TargetType, needShowFailAlert: Bool = false, modelType: [T].Type, successCallback:@escaping RequestModelsSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert) { (respModel: SuccessResponse) in
        if let models = [T].deserialize(from: respModel.arrayJSON) {
            successCallback(models, respModel)
        }
    } failureCallback: { (respModel: ErrorResponse) in
        failureCallback?(respModel)
    }
}

/// 网络请求，下载文件
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetworkDownloadRequest<T: HandyJSON>(_ target: TargetType, needShowFailAlert: Bool = false, modelType: [T].Type, successCallback:@escaping RequestModelsSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert, downloadFile: true) { (respModel: SuccessResponse) in
        if let models = [T].deserialize(from: respModel.arrayJSON) {
            successCallback(models, respModel)
        }
    } failureCallback: { (respModel: ErrorResponse) in
        failureCallback?(respModel)
    }
}

/// 网络请求的基础方法
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
private func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, downloadFile: Bool = false, successCallback:@escaping ((SuccessResponse) -> Void), failureCallback: RequestCallback? = nil) -> Cancellable? {
    // 判断网络状态
    guard UIDevice.isNetworkConnect else {
        errorHandler(error: ErrorResponse(code: NETWORK_ERROR, message: "The network is lost"), needShowFailAlert: false, failure: failureCallback)
        return nil
    }
    
    return AuthProvider.request(MultiTarget(target)) { result in
        switch result {
        case let .success(response):
            var respModel = SuccessResponse()
            do {
                respModel.responseMsg = response.responseMsg
                
                let jsonData = try JSON(data: response.data)
                // 针对字典模型解析
                if let _obj = jsonData.dictionaryObject {
                    if let _objs = _obj[responseListKey] as? [Any] {
                        respModel.arrayJSON = _objs
                    }
                    if let _page = _obj[responsePageKey] as? Int {
                        respModel.cursor = _page
                    }
                    if let _total_page = _obj[responseTotalPageKey] as? Int {
                        respModel.totalPages = _total_page
                    }
                    respModel.dataJSON = _obj
                }
                // 针对字典数组模型
                if let _objs = jsonData.arrayObject {
                    respModel.arrayJSON = _objs
                }
                
                successCallback(respModel)
            } catch {
                if downloadFile {
                    do {
                        if let suggestedFilename = response.response?.suggestedFilename {
                            let pathExtension = (suggestedFilename as NSString).pathExtension
                            if pathExtension.isEmpty {
                                CocoaLog.error("++++++++++++ ❌❌❌ file path extension is empty ❌❌❌ +++++++++++++")
                            }
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL: URL = documentsURL.appendingPathComponent(suggestedFilename)
                            let jsonData = try JSON(data: Data(contentsOf: fileURL))
                            if let _objs = jsonData.arrayObject {
                                respModel.arrayJSON = _objs
                            }
                            successCallback(respModel)
                        }
                    } catch {
                        errorHandler(error: ErrorResponse(code: JSON_SERIALIZATION_ERROR, message: "JSON SERIALIZATION ERROR"), needShowFailAlert: false, failure: failureCallback)
                    }
                } else {
                    if let string = String(data: response.data, encoding: String.Encoding.utf8) {
                        respModel.dataJSON = ["stringJson": string]
                        successCallback(respModel)
                    } else {
                        errorHandler(error: ErrorResponse(code: JSON_SERIALIZATION_ERROR, message: "JSON SERIALIZATION ERROR"), needShowFailAlert: false, failure: failureCallback)
                    }
                }
            }
        case let .failure(error):
            if let _error = error.errorUserInfo[NSUnderlyingErrorKey] as? NSError {
                errorHandler(error: ErrorResponse(code: _error.code, message: _error.localizedDescription), needShowFailAlert: needShowFailAlert, failure: failureCallback)
            } else {
                errorHandler(error: ErrorResponse(code: error.errorCode, message: error.localizedDescription), needShowFailAlert: needShowFailAlert, failure: failureCallback)
            }
        }
    }
}
