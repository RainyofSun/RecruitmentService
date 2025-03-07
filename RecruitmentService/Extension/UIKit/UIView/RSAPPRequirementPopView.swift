//
//  RSAPPRequirementPopView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/13.
//

import UIKit
import BRPickerView
import HandyJSON

enum RequirementType: Int, HandyJSONEnum {
    case WeiXiu = 1
    case Baojie
    
    enum WeiXiuRequirementType: Int, HandyJSONEnum {
        case DianShiJi = 1
        case BingXiang
        case KongTiao
        case XiYiJi
        case ReShuiQi
        case DianNao
        case ShouJi
        case PingBanDianNao
        case DengJu
        case ShuiLongTou
        case MaTong
        case MenChuang
        case JiaJu
        case XiaShuiGuanDao
        case ShangShuiGuanDao
        case SuoJu
        case DianDongGongJu
    }
    
    enum BaoJieRequirementType: Int, HandyJSONEnum {
        case JiaJuCaShi = 1
        case DiMianQingJie
        case ZhuangShiPinQingJie
        case ChuangHuQingJie
        case ChuangPuZhengLi
        case JiaJuQingJie
        case ChuGuiBiaoMianQingJie
        case LuZaoQingJie
        case ShuiCaoQingJie
        case DianQiBiaoMianQingJie
        case MaTongQingJie
        case XiShouPengQingJie
        case LinYuJianQingJie
    }
}

extension UIView {
    func showRequirementTypePop(handle: (@escaping (RequirementType, RequirementType.WeiXiuRequirementType?, RequirementType.BaoJieRequirementType?, String) -> Void)) {
        let textPickerView: BRTextPickerView = BRTextPickerView(pickerMode: BRTextPickerMode.componentCascade)
        textPickerView.title = RSAPPLanguage.localValue("pop_task_type_title")
        let pickerStyle: BRPickerStyle = BRPickerStyle()
        pickerStyle.topCornerRadius = 8
        pickerStyle.titleTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.titleTextColor = BLACK_COLOR_333333
        pickerStyle.cancelBtnTitle = RSAPPLanguage.localValue("pop_cancel")
        pickerStyle.cancelTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.cancelTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneBtnTitle = RSAPPLanguage.localValue("pop_confirm")
        pickerStyle.doneTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 14)
        pickerStyle.pickerTextColor = UIColor.hexString("#656C74")
        pickerStyle.selectRowTextColor = BLACK_COLOR_333333
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16)
        textPickerView.pickerStyle = pickerStyle
        
        var array1: [[String: String]] = []
        for index in 1...17 {
            array1.append(["text": RSAPPLanguage.localValue("task_suubtype1_\(index)")])
        }
        
        var array2: [[String: String]] = []
        for index in 1...13 {
            array2.append(["text": RSAPPLanguage.localValue("task_suubtype2_\(index)")])
        }
        
        let dict = [
            ["text": RSAPPLanguage.localValue("task_type1"),
             "children": array1],
            ["text": RSAPPLanguage.localValue("task_type2"),
             "children": array2]
        ]
        
        textPickerView.dataSourceArr = NSArray.br_modelArray(withJson: dict, mapper: nil)
        textPickerView.multiResultBlock = { (models: [BRTextModel]?, indexs: [NSNumber]?) in
            guard let _m_s = models as? NSArray, let _index_array = indexs else {
                return
            }
            
            let _type1: RequirementType = RequirementType(rawValue: _index_array.first?.intValue ?? .zero) ?? .WeiXiu
            var _type2: RequirementType.WeiXiuRequirementType?
            var _type3: RequirementType.BaoJieRequirementType?
            if _type1 == .WeiXiu, let _index = _index_array.last {
                _type2 = RequirementType.WeiXiuRequirementType(rawValue: (_index.intValue + 1))
            }
            
            if _type1 == .Baojie, let _index = _index_array.last {
                _type3 = RequirementType.BaoJieRequirementType(rawValue: (_index.intValue + 1))
            }
            
            handle(_type1, _type2, _type3, _m_s.br_joinText("-"))
        }
        
        textPickerView.show()
    }
    
    func showSingleChoiseView(dataSource: [String], title: String, handle: ( @escaping (String?) -> Void)) {
        let textPickerView: BRTextPickerView = BRTextPickerView(pickerMode: BRTextPickerMode.componentSingle)
        textPickerView.title = RSAPPLanguage.localValue(title)
        let pickerStyle: BRPickerStyle = BRPickerStyle()
        pickerStyle.topCornerRadius = 8
        pickerStyle.titleTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.titleTextColor = BLACK_COLOR_333333
        pickerStyle.cancelBtnTitle = RSAPPLanguage.localValue("pop_cancel")
        pickerStyle.cancelTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.cancelTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneBtnTitle = RSAPPLanguage.localValue("pop_confirm")
        pickerStyle.doneTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 14)
        pickerStyle.pickerTextColor = UIColor.hexString("#656C74")
        pickerStyle.selectRowTextColor = BLACK_COLOR_333333
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16)
        textPickerView.pickerStyle = pickerStyle
        
        textPickerView.dataSourceArr = dataSource
        textPickerView.singleResultBlock = { (selectedModel: BRTextModel?, idx: Int) in
            handle(selectedModel?.text)
        }
        
        textPickerView.show()
    }
    
    func showTimePicker(title: String, handle: ( @escaping (String?) -> Void)) {
        let timePicker: BRDatePickerView = BRDatePickerView.init(pickerMode: BRDatePickerMode.YMD)
        timePicker.title = RSAPPLanguage.localValue(title)
        timePicker.minDate = Date()
        timePicker.maxDate = Date.distantFuture
        let pickerStyle: BRPickerStyle = BRPickerStyle()
        pickerStyle.topCornerRadius = 8
        pickerStyle.titleTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.titleTextColor = BLACK_COLOR_333333
        pickerStyle.cancelBtnTitle = RSAPPLanguage.localValue("pop_cancel")
        pickerStyle.cancelTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.cancelTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneBtnTitle = RSAPPLanguage.localValue("pop_confirm")
        pickerStyle.doneTextFont = UIFont.systemFont(ofSize: 16)
        pickerStyle.doneTextColor = UIColor.hexString("#58AFFC")
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 14)
        pickerStyle.pickerTextColor = UIColor.hexString("#656C74")
        pickerStyle.selectRowTextColor = BLACK_COLOR_333333
        pickerStyle.selectRowTextFont = UIFont.systemFont(ofSize: 16)
        timePicker.pickerStyle = pickerStyle
        
        timePicker.resultBlock = { (sel_date: Date?, sel_time_text: String?) in
            handle(sel_time_text)
        }
        
        timePicker.show()
    }
}
