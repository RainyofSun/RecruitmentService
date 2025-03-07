//
//  RSAPPProcessItemView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/11.
//

import UIKit

enum ProcessStep: String {
    case Step_One = "publish_process_step_one"
    case Step_Two = "publish_process_step_two"
    case Step_Three = "publish_process_step_three"
    
    func selectedImage() -> String {
        switch self {
        case .Step_One:
            return "stop_one_sel"
        case .Step_Two:
            return "stop_two_sel"
        case .Step_Three:
            return "stop_three_sel"
        }
    }
    
    func normalImage() -> String {
        switch self {
        case .Step_One:
            return "stop_one_nor"
        case .Step_Two:
            return "stop_two_nor"
        case .Step_Three:
            return "stop_three_nor"
        }
    }
    
    func title() -> String {
        switch self {
        case .Step_One:
            return "publish_process_step_one"
        case .Step_Two:
            return "publish_process_step_two"
        case .Step_Three:
            return "publish_process_step_three"
        }
    }
}

class RSAPPProcessItemView: UIControl {

    private(set) lazy var topImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildLabel()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.topImgView.image = UIImage(named: self._process_step.selectedImage())
                self.titleLab.textColor = BLUE_COLOR_1874FF
            } else {
                self.topImgView.image = UIImage(named: self._process_step.normalImage())
                self.titleLab.textColor = GRAY_COLOR_9CA3AF
            }
        }
    }
    
    private(set) var _process_step: ProcessStep = .Step_One
    
    init(frame: CGRect, processStep step: ProcessStep) {
        super.init(frame: frame)
        self._process_step = step
        
        self.isSelected = step == .Step_One
        self.titleLab.text = RSAPPLanguage.localValue(step.rawValue)
        
        self.addSubview(self.topImgView)
        self.addSubview(self.titleLab)
        
        self.topImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT)
            make.centerX.equalToSuperview()
            make.size.equalTo(28)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.top.equalTo(self.topImgView.snp.bottom).offset(PADDING_UNIT)
            make.width.equalTo(80)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}
