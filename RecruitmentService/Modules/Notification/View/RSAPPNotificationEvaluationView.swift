//
//  RSAPPNotificationEvaluationView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationEvaluationView: UIView {

    weak open var superController: UIViewController?
    open var evaluateText: String?
    
    private lazy var tipLab1: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_evalute_tip1"), titleColor: BLACK_COLOR_374151, labFont: UIFont.systemFont(ofSize: 14))
    private lazy var tipLab2: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_evalute_tip2"), titleColor: BLACK_COLOR_374151, labFont: UIFont.systemFont(ofSize: 12))
    private lazy var rateView2: LRStarRateView = {
        let view = LRStarRateView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 150, height: 30)), bottomStar: "review_icon_startGray", topStar: "review_icon_startYellow")
        view.userPanEnabled = true
        view.currentStarCount = 5.0
        return view
    }()
    private lazy var tipLab3: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_evalute_tip3"), titleColor: BLACK_COLOR_374151, labFont: UIFont.systemFont(ofSize: 12))
    private lazy var rateView3: LRStarRateView = {
        let view = LRStarRateView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 150, height: 30)), bottomStar: "review_icon_startGray", topStar: "review_icon_startYellow")
        view.userPanEnabled = true
        view.currentStarCount = 5.0
        return view
    }()
    private lazy var tipLab4: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_evalute_tip4"), titleColor: BLACK_COLOR_374151, labFont: UIFont.systemFont(ofSize: 12))
    private lazy var rateView4: LRStarRateView = {
        let view = LRStarRateView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 150, height: 30)), bottomStar: "review_icon_startGray", topStar: "review_icon_startYellow")
        view.userPanEnabled = true
        view.currentStarCount = 5.0
        return view
    }()
    
    private lazy var introView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text_Multable, requirementType: RequirementInfoType.RequirementInfo_Intro)
    private lazy var imgContentView: UIView = UIView(frame: CGRectZero)
    private lazy var numLab: UILabel = {
        let lab = UILabel(frame: CGRectZero)
        lab.text = "0/3"
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        lab.textColor = GRAY_COLOR_9CA3AF
        return lab
    }()
    
    // 缩略图资源
    private var _thumbnailImages: [UIImage] = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.introView.setInfoItemPlaceHolder("notification_evalute_tip5", titleTip: "notification_evalute_tip6")
        self.introView.infoDelegate = self
        
        self.addSubview(self.tipLab1)
        self.addSubview(self.tipLab2)
        self.addSubview(self.rateView2)
        self.addSubview(self.tipLab3)
        self.addSubview(self.rateView3)
        self.addSubview(self.tipLab4)
        self.addSubview(self.rateView4)
        self.addSubview(self.introView)
        self.addSubview(self.imgContentView)
        self.imgContentView.addSubview(self.numLab)
        
        self.tipLab1.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(PADDING_UNIT * 3.5)
        }
        
        self.tipLab2.snp.makeConstraints { make in
            make.left.equalTo(self.tipLab1)
            make.top.equalTo(self.tipLab1.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.rateView2.snp.makeConstraints { make in
            make.centerY.equalTo(self.tipLab2)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
            make.size.equalTo(CGSize(width: 150, height: 30))
        }
        
        self.tipLab3.snp.makeConstraints { make in
            make.left.equalTo(self.tipLab2)
            make.top.equalTo(self.tipLab2.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.rateView3.snp.makeConstraints { make in
            make.centerY.equalTo(self.tipLab3)
            make.right.size.equalTo(self.rateView2)
        }
        
        self.tipLab4.snp.makeConstraints { make in
            make.left.equalTo(self.tipLab3)
            make.top.equalTo(self.tipLab3.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.rateView4.snp.makeConstraints { make in
            make.centerY.equalTo(self.tipLab4)
            make.right.size.equalTo(self.rateView3)
        }
        
        self.introView.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab4.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.left.width.equalToSuperview()
        }
        
        self.imgContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.introView)
            make.height.equalTo((ScreenWidth - PADDING_UNIT * 10) * 0.3)
            make.top.equalTo(self.introView.snp.bottom).offset(PADDING_UNIT * 5)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT)
        }
        
        self.numLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
            make.bottom.equalToSuperview()
        }
        
        self.buildEmptyImageControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

extension RSAPPNotificationEvaluationView: APPRequirementInfoItemProtocol {
    func didBeginEditingText(infoItem: RSAPPRequirementInfoItem) {
        
    }
    
    func didEndEditingText(value: String?, infoItem: RSAPPRequirementInfoItem) {
        self.evaluateText = value
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RSAPPNotificationEvaluationView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 当图片选取完成时调用
        if let chosenImage = info[.originalImage] as? UIImage, let _img_compress_data = chosenImage.compressImageToTargetSize(maxLength: 1024 * 1024), let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first, let _compree_img = UIImage(data: _img_compress_data) {
            // 存储到临时路径下
            let _file_name = Date.jk.secondStamp
            let filePath: String = document + "/\(_file_name).png"
            do {
                try? _img_compress_data.write(to: URL(fileURLWithPath: filePath))
            }
            
            self.updateSelectedImages(image: _compree_img, filePath: filePath, fileName: _file_name)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 当用户取消选择图片时调用
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: TZImagePickerControllerDelegate
extension RSAPPNotificationEvaluationView: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        guard let image = photos.first else {
            return
        }

        if let _img_compress_data = image.compressImageToTargetSize(maxLength: 1024 * 1024), let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first, let _compree_img = UIImage(data: _img_compress_data) {
            // 存储到临时路径下
            let _file_name = Date.jk.secondStamp
            let filePath: String = document + "/\(_file_name).png"
            do {
                try? _img_compress_data.write(to: URL(fileURLWithPath: filePath))
            }
            
            self.updateSelectedImages(image: _compree_img, filePath: filePath, fileName: _file_name)
        }
    }
}

private extension RSAPPNotificationEvaluationView {
    func buildEmptyImageControl() {
        let _count: Int = 3
        var _lastControl: RSAPPRequirementImageControl?
        for index in 0..<_count {
            let imageControl = RSAPPRequirementImageControl(frame: CGRectZero)
            imageControl.isHidden = (index != .zero)
            imageControl.controlDelegate = self
            imageControl.tag = index + 2000
            imageControl.addTarget(self, action: #selector(clickAddImage(sender: )), for: UIControl.Event.touchUpInside)
            self.imgContentView.addSubview(imageControl)
            if index == .zero {
                imageControl.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
                    make.top.height.equalToSuperview()
                }
            } else {
                if let _l = _lastControl {
                    if index == (_count - 1) {
                        imageControl.snp.makeConstraints { make in
                            make.left.equalTo(_l.snp.right).offset(PADDING_UNIT)
                            make.centerY.size.equalTo(_l)
                            make.right.equalTo(self.numLab.snp.left).offset(-PADDING_UNIT * 2)
                        }
                    } else {
                        imageControl.snp.makeConstraints { make in
                            make.left.equalTo(_l.snp.right).offset(PADDING_UNIT)
                            make.centerY.size.equalTo(_l)
                        }
                    }
                }
            }
            
            _lastControl = imageControl
        }
    }
    
    // 重置所有的图片的排列
    func resetAllImages() {
        self.imgContentView.subviews.forEach { (item: UIView) in
            if let _imageItem = item as? RSAPPRequirementImageControl {
                _imageItem.revertToAdditiveState()
                _imageItem.isHidden = true
            }
        }
        
        _thumbnailImages.enumerated().forEach { (index: Int, tempImage: UIImage) in
            if let _control = self.imgContentView.viewWithTag((index + 2000)) as? RSAPPRequirementImageControl {
                _control.HideAdditions(thumbnailImage: tempImage)
                _control.isHidden = false
            }
        }
        
        // 展示添加
        if let _addItem = self.imgContentView.viewWithTag((_thumbnailImages.count + 2000)) as? RSAPPRequirementImageControl {
            _addItem.revertToAdditiveState()
            _addItem.isHidden = false
        }
    }
    
    /// 更新选择的图片
    @discardableResult
    func updateSelectedImages(image: UIImage, filePath: String, fileName: String) -> Bool {
        if _thumbnailImages.count >= 3 {
            CocoaLog.debug("超出了最大限制 ------------")
            return false
        }

        _thumbnailImages.append(image)
        var _lastIndex: Int = .zero
        for item in self.imgContentView.subviews {
            if let _imageItem = item as? RSAPPRequirementImageControl, _imageItem.isEmpty {
                _imageItem.HideAdditions(thumbnailImage: image)
                _imageItem.imageTag = fileName
                _lastIndex = _imageItem.tag
                break
            }
        }
        numLab.text = String(format: "%d/3", _thumbnailImages.count)
        
        _lastIndex += 1
        // 展示添加
        if _lastIndex - 2000 < 4, let _control = self.imgContentView.viewWithTag(_lastIndex) as? RSAPPRequirementImageControl {
            _control.revertToAdditiveState()
            _control.isHidden = false
        }
        return true
    }
    
    func showTZImagePicker() {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc?.allowPickingImage = true
        imagePickerVc?.allowTakePicture = false
        imagePickerVc?.allowTakeVideo = false
        imagePickerVc?.allowPickingGif = false
        imagePickerVc?.allowPickingVideo = false
        imagePickerVc?.allowCrop = true
        imagePickerVc?.cropRect = CGRect(x: 0, y: (ScreenHeight - ScreenWidth) * 0.5, width: ScreenWidth, height: ScreenWidth)
        imagePickerVc?.statusBarStyle = .lightContent
        imagePickerVc?.modalPresentationStyle = .fullScreen
        if let _vc = imagePickerVc {
            self.superController?.present(_vc, animated: true)
        }
    }
    
    func takePhotoWithCamera() {
        RSAPPDeviceAuthorizationTool.requsetCameraAuthorization {[weak self] (auth: Bool) in
            guard auth else {
                self?.superController?.showSystemStyleSettingAlert(content: RSAPPLanguage.localValue("alert_camera"))
                return
            }
            DispatchQueue.main.async {
                // 检查相机是否可用
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera  // 设置图片来源为相机
                    imagePicker.allowsEditing = false  // 不允许编辑
                    imagePicker.cameraDevice = .rear
                    self?.superController?.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: ImageControlProtocol
extension RSAPPNotificationEvaluationView: ImageControlProtocol {
    func clean_deleteImage(imageControl: RSAPPRequirementImageControl) {
        let _removeIndex: Int = imageControl.tag - 2000
        // 重新排列
        _thumbnailImages.remove(at: _removeIndex)
        // 更新图片数字
        numLab.text = String(format: "%d/3", _thumbnailImages.count)
        resetAllImages()
    }
}

// MARK: Target
@objc private extension RSAPPNotificationEvaluationView {
    func clickAddImage(sender: RSAPPRequirementImageControl) {
        guard let _super_vc = self.superController else {
            return
        }
        
        if !sender.isEmpty {
            return
        }
        
        RSAPPRequirementPhotoPopView.convenienceShow(_super_vc.view).popDidDismissClosure = {[weak self] (popView: RSAPPBasePopView) in
            guard let _p_view = popView as? RSAPPRequirementPhotoPopView, let _self = self else {
                return
            }
            
            if _p_view.isCamera {
                _self.takePhotoWithCamera()
            } else {
                _self.showTZImagePicker()
            }
        }
    }
}
