//
//  RSAPPHomeQuestionModel.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/3/16.
//

import UIKit

class RSAPPHomeQuestionModel: NSObject {
    var content: String?
}

class RSAPPHomeQuestionGroupModel: NSObject {
    var groupTitle: String?
    var isExpand: Bool = false
    var question: [RSAPPHomeQuestionModel]?
}
