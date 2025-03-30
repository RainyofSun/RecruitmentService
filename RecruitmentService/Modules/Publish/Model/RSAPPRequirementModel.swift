//
//  RSAPPRequirementModel.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/13.
//

import UIKit

enum RequirementStatus: Int, HandyJSONEnum {
    /// 已发布
    case Published = 1
    /// 保存信息待发布
    case ToBePublished
    /// 招聘结束
    case RecruitmentEnded
}

class RSAPPRequirementModel: HandyJSON {
    /// 招工信息Key 前缀 + 时间戳的形式 ==> 优化： 应该是用户的ID + 时间戳的形式
    var requirementKey: String?
    /// 招工时间Key
    var requirementTimeKey: String?
    /// 需求类型
    var requirementType: RequirementType?
    /// 需求子类型
    var requirementSubType1: RequirementType.WeiXiuRequirementType?
    var requirementSubType2: RequirementType.BaoJieRequirementType?
    /// 需求名字
    var requirementName: String?
    /// 需求介绍
    var requirementIntro: String?
    /// 年龄
    var age: String?
    /// 性别
    var sex: String?
    /// 学历
    var education: String?
    /// 经验
    var experience: String?
    /// 截止时间
    var stopTime: String?
    /// 联系电话
    var contactPhone: String?
    /// 备用电话
    var backupPhone: String?
    /// 服务地点
    var address: String?
    /// 详细位置
    var detailAddress: String?
    /// 招工状态
    var status: RequirementStatus = .ToBePublished
    
    required init() {
        
    }
}
