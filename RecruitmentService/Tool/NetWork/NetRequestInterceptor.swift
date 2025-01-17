//
//  NetRequestInterceptor.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//
/*
 https://juejin.cn/post/7062611278371487751
 https://juejin.cn/post/7035816989444538399
 https://juejin.cn/post/7041831520155205640
 */
import UIKit
import Alamofire
import Moya

class NetRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = Global.shared.userData?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        // 确保只重试一次，否则就无限重试下去了
        guard request.retryCount == 0 else {
            return completion(.doNotRetry)
        }
        
        if Global.shared.userData?.token != nil {
            MoyaProvider<AuthApi>(plugins: [NetworkLoggerPlugin()]).request(.refreshToken) { result in
                switch result {
                case .success(let response):
                    CocoaLog.debug("response = \(response.statusCode)")
                    //                guard let dic = dataToDictionary(data: response.data) else{
                    //                    completion(.failure(YHError.other(code: -999, msg: "解析错误")))
                    //                    return
                    //                }
                    //                guard let model = ResponseBaseModel<RefreshToken>(JSON: dic) else {
                    //                    completion(.failure(YHError.other(code: -999, msg: "解析错误")))
                    //                    return
                    //                }
                    //                guard model.code == 0 else {
                    //                    let hud = HUD.show(message: "请重新登录")
                    //                    hud?.pinned = true
                    //                    Global.logout()
                    //                    completion(.failure(YHError.other(code: -999, msg: "请重新登录")))
                    //                    return
                    //                }
                    //                Global.shared.refreshToken = model.data?.refresh_token ?? ""
                    //                Global.shared.token = model.data?.token ?? ""
                    //
                    //                completion(.success(OAuthCredential(accessToken: model.data?.token ?? "",
                    //                                                    refreshToken: model.data?.refresh_token ?? "",
                    //                                                    userID: Global.shared.userInfo._id,
                    //                                                    expiration: Date(timeIntervalSinceNow: OAuthAuthenticator.expirationDuration))))
                    completion(.retry)
                case .failure(let error ):
                    CocoaLog.debug("error = \(error)")
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
