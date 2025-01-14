//
//  AuthApi.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit
import Moya

enum AuthApi {
    case refreshToken
}

extension AuthApi: TargetType {
    var baseURL: URL {
        return URL.init(string: BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "auth"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
