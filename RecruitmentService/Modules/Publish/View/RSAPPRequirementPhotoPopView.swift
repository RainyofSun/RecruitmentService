//
//  RSAPPRequirementPhotoPopView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/13.
//

import UIKit

class RSAPPRequirementPhotoPopView: RSAPPBasePopView {
    
    private lazy var cameraBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("pop_camera"), titleColor: BLACK_COLOR_333333, titleFont: UIFont.systemFont(ofSize: 17), backgroudColor: .white)
    private lazy var thumbBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("pop_thumb"), titleColor: BLACK_COLOR_333333, titleFont: UIFont.systemFont(ofSize: 17), backgroudColor: .white)
    private lazy var cancelBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("pop_cancel"), titleColor: BLACK_COLOR_333333, titleFont: UIFont.systemFont(ofSize: 17), backgroudColor: .white)
    
    private(set) var isCamera: Bool = false
    
    override var stableHeight: CGFloat {
        return 210
    }
    
    override var canTouchDismiss: Bool {
        return false
    }
    
    override func loadPopViews() {
        super.loadPopViews()
        self.contentView.backgroundColor = UIColor.hexString("#F2F2F2")
        
        self.thumbBtn.addTarget(self, action: #selector(clickThumbButton(sender: )), for: UIControl.Event.touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(clickCameraButton(sender: )), for: UIControl.Event.touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(clickCancelButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.thumbBtn)
        self.contentView.addSubview(self.cameraBtn)
        self.contentView.addSubview(self.cancelBtn)
    }

    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.thumbBtn.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }
        
        self.cameraBtn.snp.makeConstraints { make in
            make.top.equalTo(self.thumbBtn.snp.bottom)
            make.horizontalEdges.size.equalTo(self.thumbBtn)
        }
        
        self.cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.cameraBtn.snp.bottom).offset(PADDING_UNIT * 2)
            make.horizontalEdges.size.equalTo(self.cameraBtn)
        }
    }
    
    @discardableResult
    override class func convenienceShow(_ superView: UIView) -> Self {
        let view = RSAPPRequirementPhotoPopView(frame: CGRect(origin: CGPoint(x: .zero, y: ScreenHeight), size: UIScreen.main.bounds.size))
        superView.addSubview(view)
        view.showPop()
        
        return view as! Self
    }
}

@objc private extension RSAPPRequirementPhotoPopView {
    func clickCameraButton(sender: UIButton) {
        self.isCamera = true
        self.dismiss()
        self.popDidDismissClosure?(self)
    }
    
    func clickThumbButton(sender: UIButton) {
        self.isCamera = false
        self.dismiss()
        self.popDidDismissClosure?(self)
    }
    
    func clickCancelButton(sender: UIButton) {
        self.dismiss()
    }
}
