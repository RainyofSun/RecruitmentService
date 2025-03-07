//
//  RSAPPDeviceAuthorizationTool.swift
//  FastVay
//
//  Created by Yu Chen  on 2024/11/21.
//

import UIKit
import CoreLocation
import Photos
import Contacts
import AppTrackingTransparency

public enum MZAuthorizationStatus: Int {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
    case limited = 4
    case disable = 5
}

public enum KPhotoAccessLevel: Int {
    case addOnly = 1
    case readWrite = 2
}

public enum KLocationAuthLevel: Int {
    case whenInUse = 1
    case always = 2
}

class RSAPPDeviceAuthorizationTool: NSObject, CLLocationManagerDelegate {
    
    static let instance: RSAPPDeviceAuthorizationTool = RSAPPDeviceAuthorizationTool()
    private var locationCompletionHandler: ((Bool) -> Void)?
    private var bluetoothCompletionHandler: ((Bool) -> Void)?
    private(set) var phoneOpenLocal: Bool = true
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    override init() {
        super.init()
        self.deviceOpenLocal()
    }
    
    //MARK: - 获取权限状态
    /// 获取相册权限状态
    /// - Parameter level: 权限等级
    /// - Returns: 权限状态
    public static func photoAuthorizationStatus(level: KPhotoAccessLevel = .readWrite) -> MZAuthorizationStatus {
        var status: PHAuthorizationStatus!
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: level == .addOnly ? .addOnly : .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取相机权限状态
    /// - Returns: 权限状态
    public static func cameraAuthorizationStatus() -> MZAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取麦克风权限状态
    /// - Returns: 权限状态
    public static func micAuthorizationStatus() -> MZAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取通讯录权限状态
    /// - Returns: 权限状态
    public static func contactAuthorizationStatus() -> MZAuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取定位权限状态
    /// - Returns: 权限状态
    public static func locationAuthorizationStatus() -> MZAuthorizationStatus {
        if !RSAPPDeviceAuthorizationTool.instance.phoneOpenLocal {
            return .disable
        }
        
        var status: CLAuthorizationStatus = .denied
        if #available(iOS 14.0, *) {
            let locationManager =  CLLocationManager()
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        status = CLLocationManager.authorizationStatus()
        return MZAuthorizationStatus.init(rawValue: Int(status.rawValue)) ?? .denied
    }
    
    /// 获取IDFA状态
    public static func ATTTrackingStatus() -> ATTrackingManager.AuthorizationStatus {
        return ATTrackingManager.trackingAuthorizationStatus
    }
    
    //MARK: - 获取权限授权
    
    /// 检查是否开启定位
    private func deviceOpenLocal() {
        DispatchQueue.global(qos: .userInitiated).async {
            // 在这里执行耗时的任务
            let areLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
            DispatchQueue.main.async {
                // 回到主线程更新UI
                self.phoneOpenLocal = areLocationServicesEnabled
            }
        }
    }
    
    /// 获取相册授权
    /// - Parameters:
    ///   - level: 权限等级
    ///   - completionHandler: 授权回调
    public static func requestPhotoAuthorization(level: KPhotoAccessLevel = .readWrite, completionHandler: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: level == .addOnly ? .addOnly : .readWrite) { status in
                completionHandler(status == .authorized)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                completionHandler(status == .authorized)
            }
        }
    }
    
    /// 获取相机授权
    /// - Parameter completionHandler: 授权回调
    public static func requsetCameraAuthorization(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completionHandler)
    }
    
    /// 获取麦克风授权
    /// - Parameter completionHandler: 授权回调
    public static func requestMicAuthorization(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: completionHandler)
    }
    
    /// 获取通讯录授权
    /// - Parameter completionHandler: 授权回调
    public static func requestContactAuthorization(completionHandler: @escaping (Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            if error == nil {
                completionHandler(granted)
            } else {
                completionHandler(false)
            }
        }
    }
    
    /// 获取定位授权
    /// - Parameters:
    ///   - level: 授权等级
    ///   - completionHandler: 授权回调
    public static func requestLocationAuthorization(level: KLocationAuthLevel, completionHandler: @escaping (Bool) -> Void) {
        RSAPPDeviceAuthorizationTool.instance.locationCompletionHandler = completionHandler
        if level == .whenInUse {
            instance.locationManager.requestWhenInUseAuthorization()
        } else {
            instance.locationManager.allowsBackgroundLocationUpdates = true
            instance.locationManager.requestAlwaysAuthorization()
        }
    }
    
    /// 获取IDFA权限
    public static func requestIDFAAuthorization(completionHandler: @escaping (Bool) -> Void) {
        ATTrackingManager.requestTrackingAuthorization { (status: ATTrackingManager.AuthorizationStatus) in
            completionHandler(status == .authorized)
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    @nonobjc public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = RSAPPDeviceAuthorizationTool.locationAuthorizationStatus()
        if status == .authorized || status == .limited {
            self.locationCompletionHandler?(true)
            self.locationCompletionHandler = nil
        } else {
            self.locationCompletionHandler?(false)
            self.locationCompletionHandler = nil
        }
    }
    
    @nonobjc public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationCompletionHandler?(true)
            self.locationCompletionHandler = nil
        } else {
            self.locationCompletionHandler?(false)
            self.locationCompletionHandler = nil
        }
    }
}
