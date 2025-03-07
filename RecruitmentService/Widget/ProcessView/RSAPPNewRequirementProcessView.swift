//
//  RSAPPNewRequirementProcessView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/11.
//

import UIKit

class RSAPPNewRequirementProcessView: UIView {

    private lazy var stepOneControl: RSAPPProcessItemView = RSAPPProcessItemView(frame: CGRectZero, processStep: ProcessStep.Step_One)
    private lazy var stepTwoControl: RSAPPProcessItemView = RSAPPProcessItemView(frame: CGRectZero, processStep: ProcessStep.Step_Two)
    private lazy var stepThreeControl: RSAPPProcessItemView = RSAPPProcessItemView(frame: CGRectZero, processStep: ProcessStep.Step_Three)
    private lazy var lineView1: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexString("#D1D5DB")
        return view
    }()
    
    private lazy var lineView2: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexString("#D1D5DB")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.stepOneControl)
        self.addSubview(self.lineView1)
        self.addSubview(self.stepTwoControl)
        self.addSubview(self.lineView2)
        self.addSubview(self.stepThreeControl)
        
        self.stepTwoControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.lineView1.snp.makeConstraints { make in
            make.top.equalTo(self.stepTwoControl).offset(PADDING_UNIT * 5)
            make.size.equalTo(CGSize(width: ScreenWidth * 0.15, height: 1))
            make.right.equalTo(self.stepTwoControl.snp.left).offset(-PADDING_UNIT)
        }
        
        self.stepOneControl.snp.makeConstraints { make in
            make.top.equalTo(self.stepTwoControl)
            make.right.equalTo(self.lineView1.snp.left).offset(-PADDING_UNIT)
        }
        
        self.lineView2.snp.makeConstraints { make in
            make.top.size.equalTo(self.lineView1)
            make.left.equalTo(self.stepTwoControl.snp.right).offset(PADDING_UNIT)
        }
        
        self.stepThreeControl.snp.makeConstraints { make in
            make.top.equalTo(self.stepTwoControl)
            make.right.equalTo(self.lineView2.left).offset(-PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setProcessSteo(step: ProcessStep) {
        if step == self.stepOneControl._process_step {
            self.stepOneControl.isSelected = true
        }
        
        if step == self.stepTwoControl._process_step {
            self.stepOneControl.isSelected = true
            self.stepTwoControl.isSelected = true
        }
        
        if step == self.stepThreeControl._process_step {
            self.stepOneControl.isSelected = true
            self.stepTwoControl.isSelected = true
            self.stepThreeControl.isSelected = true
        }
    }
}
