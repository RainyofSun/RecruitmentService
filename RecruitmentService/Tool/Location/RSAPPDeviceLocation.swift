//
//  RSAPPDeviceLocation.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/14.
//

import UIKit
import Foundation
import CoreLocation
import NetworkExtension
import Toast_Swift

/// App 定位类
class RSAPPDeviceLocation : NSObject {
    
    static let shareInstance = RSAPPDeviceLocation.init()
    
    /// 获取最新定位信息
    open var placemark: CLPlacemark?
    open var location: CLLocation?
    /// 定位结束回调
    open var locationEndClosure: ((String) -> Void)?
    
    //初始化
    override init() {
        super.init()
        self.locationInit()
    }
    
    deinit {
        self.llocationManager?.stopUpdatingLocation()
        self.llocationManager?.delegate = nil
        self.llocationManager = nil
    }
    
    //MARK: - lazy load
    /// 定位对象
    private lazy var llocationManager:CLLocationManager? = nil
}
 
extension RSAPPDeviceLocation {
    /// 开启定位
    public func startLoaction() {
        //已开启定位服务
        if RSAPPDeviceAuthorizationTool.instance.phoneOpenLocal {
            //是否有授权本App获取定位
            var _auth:CLAuthorizationStatus?
            if #available(iOS 14.0, *) {
                _auth = self.llocationManager?.authorizationStatus
            } else {
                // Fallback on earlier versions
                _auth = CLLocationManager.authorizationStatus()
            }
            
            if let _a = _auth, (_a != .authorizedAlways && _a != .authorizedWhenInUse) {
                self.llocationManager?.requestWhenInUseAuthorization()
                return
            }
            //可以定位
            self.llocationManager?.startUpdatingLocation()
        } else{
            self.locationPermissionsCheck()
        }
    }
    
    /// 获取位置
    public func requestLocation() {
        self.llocationManager?.startUpdatingLocation()
    }
}
 
//MARK: -
private extension RSAPPDeviceLocation {
    
    /// 定位初始化
    func locationInit(){
        //定位对象
        self.llocationManager = CLLocationManager.init()
        weak var weakSelf = self
        self.llocationManager?.delegate = weakSelf
        
        /**
         设置精度
         kCLLocationAccuracyBest             精确度最佳
         kCLLocationAccuracyNearestTenMeters 精确度10m以内
         kCLLocationAccuracyHundredMeters    精确度100m以内
         kCLLocationAccuracyKilometer        精确度1000m以内
         kCLLocationAccuracyThreeKilometers  精确度3000m以内
         */
        self.llocationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //设置间隔距离(单位：m) 内更新定位信息
        //定位要求的精度越高，distanceFilter属性的值越小，应用程序的耗电量就越大。
//        self.llocationManager?.distanceFilter = 200.0
    }
    
    /// 权限检测
    func locationPermissionsCheck(){
        // 手机定位是否开启
        if CLLocationManager.locationServicesEnabled() == false {
            return
        }
        
        // 请求用户授权
        if RSAPPDeviceAuthorizationTool.locationAuthorizationStatus() == .notDetermined {
            self.llocationManager?.requestWhenInUseAuthorization()
        }
    }
    
    /// 反编码获取地址信息
    func getGeocoderInfoFor(Location location:CLLocation){
        
        // 如果断网或者定位失败
        if !UIDevice.isNetworkConnect {
            UIDevice.appKeyWindow().makeToast("Network lost", position: ToastPosition.center)
            return
        }
        
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) {[weak self] (_placemarks:[CLPlacemark]?, _error:Error?) in
            guard let self = self else { return }
            guard let placemarks = _placemarks,placemarks.count > 0 else {
                return
            }
            
            /*
             * region:                               //地理区域
             * addressDictionary:[AnyHashable : Any] //可以使用ABCreateStringWithAddressDictionary格式化为一个地址
             * thoroughfare: String?                 //街道名
             * name:String?                          //地址
             * subThoroughfare: String?              //大道
             * locality: String?                     //城市
             * subLocality: String?                  // 社区,通用名称
             * administrativeArea: String?           // state, eg. CA
             * subAdministrativeArea: String?        // 国家, eg. Santa Clara
             * postalCode: String?                   // zip code, eg. 95014
             * isoCountryCode: String?               // eg. US
             * country: String?                      // eg. United States
             * inlandWater: String?                  // 湖泊
             * ocean: String?                        // 洋
             * areasOfInterest: [String]?            // 感兴趣的地方
             */
            self.placemark = placemarks[0]
            self.location = location
            var city: String = ""
            if let _c = self.placemark?.locality {
                city = _c
            }
            if let _c = self.placemark?.administrativeArea {
                city += _c
            }
            
            self.locationEndClosure?(city)
        }
    }
}
 
 
//MARK: - CLLocationManagerDelegate
extension RSAPPDeviceLocation : CLLocationManagerDelegate {
    
    /// 定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败：\(error.localizedDescription)")
    }
    
    /// 定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /**
         * CLLocation 定位信息
         *
         * 经度：currLocation.coordinate.longitude
         * 纬度：currLocation.coordinate.latitude
         * 海拔：currLocation.altitude
         * 方向：currLocation.course
         * 速度：currLocation.speed
         *  ……
         */
        if let _location = locations.last {
            CocoaLog.debug("------- 埋点定位 - \(_location.coordinate.latitude) - \(_location.coordinate.longitude)")
            self.getGeocoderInfoFor(Location: _location)
            self.llocationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.requestLocation()
        }
    }
}
