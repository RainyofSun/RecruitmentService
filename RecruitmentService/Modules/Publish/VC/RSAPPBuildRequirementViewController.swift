//
//  RSAPPBuildRequirementViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/11.
//

import UIKit
import TZImagePickerController
import JKSwiftExtension
import Toast_Swift

class RSAPPBuildRequirementViewController: APBaseViewController {

    private lazy var processView: RSAPPNewRequirementProcessView = RSAPPNewRequirementProcessView(frame: CGRectZero)
    private lazy var typeView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Enum, requirementType: RequirementInfoType.RequirementInfo_Type)
    private lazy var nameView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text, requirementType: RequirementInfoType.RequirementInfo_Name)
    private lazy var introView: RSAPPRequirementInfoItem = RSAPPRequirementInfoItem(frame: CGRectZero, itemStyle: InfoItemStyle.Item_Text_Multable, requirementType: RequirementInfoType.RequirementInfo_Intro)
    
    private lazy var imgContentView: UIView = UIView(frame: CGRectZero)
    private lazy var numLab: UILabel = {
        let lab = UILabel(frame: CGRectZero)
        lab.text = "0/3"
        lab.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        lab.textColor = GRAY_COLOR_9CA3AF
        return lab
    }()
    
    private lazy var nextBtn: RSAPPLoadingButton = RSAPPLoadingButton.buildLoadingButton(RSAPPLanguage.localValue("publish_requirement_next"), cornerRadius: 4)
    private lazy var imgFilePathArray: [String] = []
    
    // 缩略图资源
    private var _thumbnailImages: [UIImage] = [UIImage]()
    private var requirementModel: RSAPPRequirementModel = RSAPPRequirementModel()
    
    override func buildViewUI() {
        super.buildViewUI()
        // 记录招工的时间戳信息, 后续作为Key的一部分使用
        self.requirementModel.requirementTimeKey = Date().jk.dateToTimeStamp()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("publish_new_task_nav_title")
        
        self.typeView.setInfoItemPlaceHolder("publish_requirement_type_place", titleTip: "publish_requirement_type")
        self.nameView.setInfoItemPlaceHolder("publish_requirement_name_place", titleTip: "publish_requirement_name")
        self.introView.setInfoItemPlaceHolder("publish_requirement_intro_place", titleTip: "publish_requirement_intro")
        
        self.typeView.infoDelegate = self
        self.nameView.infoDelegate = self
        self.introView.infoDelegate = self
        
        self.nextBtn.addTarget(self, action: #selector(clickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.processView.setProcessSteo(step: ProcessStep.Step_One)
        self.contentView.addSubview(self.processView)
        self.contentView.addSubview(self.typeView)
        self.contentView.addSubview(self.nameView)
        self.contentView.addSubview(self.introView)
        self.contentView.addSubview(self.imgContentView)
        self.imgContentView.addSubview(self.numLab)
        self.view.addSubview(self.nextBtn)
        self.buildEmptyImageControl()
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.xp_navigationFullHeight())
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-PADDING_UNIT)
        }
        
        self.processView.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
        }
        
        self.typeView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.processView)
            make.top.equalTo(self.processView.snp.bottom).offset(PADDING_UNIT * 7)
        }
        
        self.nameView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.typeView)
            make.top.equalTo(self.typeView.snp.bottom).offset(PADDING_UNIT * 2)
        }
        
        self.introView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.nameView)
            make.top.equalTo(self.nameView.snp.bottom).offset(PADDING_UNIT * 2)
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
        
        self.nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
            make.height.equalTo(47)
        }
    }

}

private extension RSAPPBuildRequirementViewController {
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
        self.imgFilePathArray.append(filePath)
        CocoaLog.debug("-------- 选择的图片地址 +++++ == \n \(self.imgFilePathArray) \n ----")
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
            self.present(_vc, animated: true)
        }
    }
    
    func takePhotoWithCamera() {
        RSAPPDeviceAuthorizationTool.requsetCameraAuthorization {[weak self] (auth: Bool) in
            guard auth else {
                self?.showSystemStyleSettingAlert(content: RSAPPLanguage.localValue("alert_camera"))
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
                    self?.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: ImageControlProtocol
extension RSAPPBuildRequirementViewController: ImageControlProtocol {
    func clean_deleteImage(imageControl: RSAPPRequirementImageControl) {
        let _removeIndex: Int = imageControl.tag - 2000
        // 重新排列
        _thumbnailImages.remove(at: _removeIndex)
        self.imgFilePathArray.removeAll { (item: String) in
            if let _tag = imageControl.imageTag {
                return item.hasSuffix(_tag + ".png")
            }
            
            return false
        }
        CocoaLog.debug("-------- 选择的图片地址 == \n \(self.imgFilePathArray) \n ----")
        // 更新图片数字
        numLab.text = String(format: "%d/3", _thumbnailImages.count)
        resetAllImages()
    }
}

// MARK: APPRequirementInfoItemProtocol
extension RSAPPBuildRequirementViewController: APPRequirementInfoItemProtocol {
    func didBeginEditingText(infoItem: RSAPPRequirementInfoItem) {
        if infoItem.info_style == .Item_Enum {
            self.view.showRequirementTypePop { (type1: RequirementType, type2: RequirementType.WeiXiuRequirementType?, type3: RequirementType.BaoJieRequirementType?, text: String) in
                infoItem.reloadTextFiledText(text)
                self.requirementModel.requirementType = type1
                self.requirementModel.requirementSubType1 = type2
                self.requirementModel.requirementSubType2 = type3
            }
        }
    }
    
    func didEndEditingText(value: String?, infoItem: RSAPPRequirementInfoItem) {
        if infoItem.info_type == .RequirementInfo_Name {
            self.requirementModel.requirementName = value
        }
        
        if infoItem.info_type == .RequirementInfo_Intro {
            self.requirementModel.requirementIntro = value
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RSAPPBuildRequirementViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension RSAPPBuildRequirementViewController: TZImagePickerControllerDelegate {
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

// MARK: Target
@objc private extension RSAPPBuildRequirementViewController {
    func clickAddImage(sender: RSAPPRequirementImageControl) {
        if !sender.isEmpty {
            return
        }
        
        RSAPPRequirementPhotoPopView.convenienceShow(self.view).popDidDismissClosure = {[weak self] (popView: RSAPPBasePopView) in
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
    
    func clickNextButton(sender: RSAPPLoadingButton) {
        guard let _ = self.requirementModel.requirementName, let _ = self.requirementModel.requirementType, let _ = self.requirementModel.requirementIntro else {
            self.view.makeToast(RSAPPLanguage.localValue("pop_complete_requirement"), position: ToastPosition.center)
            return
        }
        
        self.navigationController?.pushViewController(RSAPPRequirementConditionVC(requirementModel: self.requirementModel, imageArray: self.imgFilePathArray), animated: true)
    }
}
