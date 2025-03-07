//
//  RSAPPRequirementImageControl.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/12.
//

import UIKit

protocol ImageControlProtocol: AnyObject {
    /// 删除当前的图片
    func clean_deleteImage(imageControl: RSAPPRequirementImageControl)
}

class RSAPPRequirementImageControl: UIControl {

    weak open var controlDelegate: ImageControlProtocol?
    /// 是否处于空白态
    open var isEmpty: Bool {
        get {
            return self.closeBtn.isHidden
        }
    }
    
    open var imageTag: String?
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var addImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "setting_icon_add"))
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "setting_icon_close"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "setting_icon_close"), for: UIControl.State.highlighted)
        btn.isHidden = true
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadControlView()
        layoutControlViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    // MARK: Public Methods
    /// 隐藏添加态
    public func HideAdditions(thumbnailImage: UIImage) {
        self.backgroundColor = .clear
        self.thumbnailImageView.image = thumbnailImage
        self.closeBtn.isHidden = false
        self.addImageView.isHidden = !self.closeBtn.isHidden
    }
    
    // 恢复至添加态
    public func revertToAdditiveState() {
        self.thumbnailImageView.image = nil
        self.addImageView.isHidden = false
        self.closeBtn.isHidden = !self.addImageView.isHidden
    }
}

// MARK: Private Methods
private extension RSAPPRequirementImageControl {
    func loadControlView() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        
        closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(thumbnailImageView)
        self.addSubview(addImageView)
        self.addSubview(closeBtn)
    }
    
    func layoutControlViews() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        addImageView.snp.makeConstraints { make in
            make.center.equalTo(thumbnailImageView)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}

// MARK: Target
@objc private extension RSAPPRequirementImageControl {
    func clickCloseButton(sender: UIButton) {
        self.controlDelegate?.clean_deleteImage(imageControl: self)
    }
}
