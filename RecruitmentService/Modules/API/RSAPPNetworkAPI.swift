//
//  RSAPPNetworkAPI.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/14.
//

import UIKit
import Moya

enum RSAPPNetworkAPI {
    /// 更新头像
    case UploadUserHeadImage(image: String)
    /// 查询头像
    case GetUserHeadImage
    /// 上传文件
    case UploadFile(uploadFiles: [String])
    /// 保存数据
    case SaveRequirementParams(paramsJson: [String: Any], key: String)
    /// 保存数据
    case SaveRequirementArrayParams(paramsJson: [[String: Any]], key: String)
    /// 读取数据
    case ReadRequirementParams(key: String)
    /// 查询数据列表
    case queryRequirementList(key: String)
    /// 删除数据
    case deleteRequirementData(keys: [String])
}

extension RSAPPNetworkAPI: TargetType {
    
    var baseURL: URL {
        return URL.init(string: FVNetRequestURL.requestURL())!
    }
    
    var path: String {
        switch self {
        case .UploadUserHeadImage(_):
            return "app/config/changHeadImage"
        case .GetUserHeadImage:
            return "app/config/selectHeadImage"
        case .UploadFile(_):
            return "app/user/habit/upload"
        case .SaveRequirementParams(_, _):
            return "app/persistent/set"
        case .SaveRequirementArrayParams(_, _):
            return "app/persistent/set"
        case .ReadRequirementParams(_):
            return "app/persistent/get"
        case .queryRequirementList(_):
            return "app/persistent/list"
        case .deleteRequirementData(_):
            return "app/persistent/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .UploadUserHeadImage(_):
            return .post
        case .GetUserHeadImage:
            return .get
        case .UploadFile(_):
            return .post
        case .SaveRequirementParams(_, _), .SaveRequirementArrayParams(_, _):
            return .post
        case .ReadRequirementParams(_):
            return .post
        case .queryRequirementList(_):
            return .post
        case .deleteRequirementData(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .UploadUserHeadImage(let image):
            let imageData: MultipartFormData = MultipartFormData(provider: .file(URL(fileURLWithPath: image)), name: "file")
            return .uploadMultipart([imageData])
        case .GetUserHeadImage:
            return .requestPlain
        case .UploadFile(let uploadFiles):
            var dataArray: [MultipartFormData] = []
            uploadFiles.forEach { (item: String) in
                let imageData: MultipartFormData = MultipartFormData(provider: .file(URL(fileURLWithPath: item)), name: "file")
                dataArray.append(imageData)
            }
            return .uploadMultipart(dataArray)
        case .SaveRequirementParams(let paramsJson, let key):
            return .requestParameters(parameters: ["app": Bundle.main.bundleIdentifier ?? "", "key": key, "value": paramsJson], encoding: JSONEncoding.default)
        case .SaveRequirementArrayParams(let arrayJson, let key):
            return .requestParameters(parameters: ["app": Bundle.main.bundleIdentifier ?? "", "key": key, "value": arrayJson], encoding: JSONEncoding.default)
        case .ReadRequirementParams(let key):
            return .requestParameters(parameters: ["app": Bundle.main.bundleIdentifier ?? "", "key": key], encoding: JSONEncoding.default)
        case .queryRequirementList(let key):
            return .requestParameters(parameters: ["app": Bundle.main.bundleIdentifier ?? "", "key": key], encoding: JSONEncoding.default)
        case .deleteRequirementData(let keys):
            return .requestParameters(parameters: ["app": Bundle.main.bundleIdentifier ?? "", "keys": keys], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var params: [String: String] = ["token": Global.shared.userData?.token ?? "",
                                        "system":"ios",
                                        "ver": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
                                        "bundleId": Bundle.main.bundleIdentifier ?? ""]
        switch self {
        case .UploadUserHeadImage(_):
            params["Content-Type"] = "multipart/form-data"
        case .GetUserHeadImage:
            params["Content-Type"] = "application/json"
        case .UploadFile(_):
            params["Content-Type"] = "multipart/form-data"
        case .SaveRequirementParams(_, _):
            params["Content-Type"] = "application/json"
        case .SaveRequirementArrayParams(_, _):
            params["Content-Type"] = "application/json"
        case .ReadRequirementParams(_):
            params["Content-Type"] = "application/json"
        case .queryRequirementList(_):
            params["Content-Type"] = "application/json"
        case .deleteRequirementData(_):
            params["Content-Type"] = "application/json"
        }
        
        return params
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
