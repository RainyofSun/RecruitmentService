//
//  UIDeviceExtension.swift
//  Living
//
//  Created by Eric on 2023/10/25.
//

import UIKit
import Alamofire
import SAMKeychain
import CoreTelephony
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import Mach_Swift

extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true
    }
}

extension UIDevice {
    static func appKeyWindow() -> UIWindow {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        return window!
    }
}

public extension UIDevice {
    /// 从钥匙串读取idfv
    var keychainIdfv: String {
        let idfv = identifierForVendor?.uuidString
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        // 说明以前存过
        let lastKeyChianIdfv = SAMKeychain.password(forService: bundleID, account: APP_ACCOUNT_KEY)
        if lastKeyChianIdfv?.count ?? 0 > 0 {
            return lastKeyChianIdfv ?? ""
        }else {
            // 存到钥匙串里
            SAMKeychain.setPassword(idfv ?? "", forService: bundleID, account: APP_ACCOUNT_KEY)
        }
        return idfv ?? ""
    }
}

extension UIDevice {
    /// 顶部安全区高度
    static func xp_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    /// 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    /// 顶部状态栏高度（包括安全区）
    static  func xp_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    /// 导航栏高度
    static func xp_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    /// 状态栏+导航栏的高度
    static func xp_navigationFullHeight() -> CGFloat {
        return UIDevice.xp_statusBarHeight() + UIDevice.xp_navigationBarHeight()
    }
    
    /// 底部导航栏高度
    static func xp_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    /// 底部导航栏高度（包括安全区）
    static func xp_tabBarFullHeight() -> CGFloat {
        return UIDevice.xp_tabBarHeight() + UIDevice.xp_safeDistanceBottom()
    }
    
    /// 限制 iOS15.0 以上
    static func iOSUpVersion(_ version: Int = 15) -> Bool {
        /*majorVersion：主版本号；minorVersion:次版本号;patchVersion:最后一位小版本号*/
        let systemVersion = OperatingSystemVersion(majorVersion: version, minorVersion: 0, patchVersion: 0)
        return ProcessInfo.processInfo.isOperatingSystemAtLeast(systemVersion)
    }
}

extension UIDevice {
    
    /// 获取网络类型
    static func getNetworkType() -> String {
        var zeroAddress = sockaddr_storage()
        bzero(&zeroAddress, MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_len = __uint8_t(MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                SCNetworkReachabilityCreateWithAddress(nil, address)
            }
        }
        guard let defaultRouteReachability = defaultRouteReachability else {
            return "notReachable"
        }
        var flags = SCNetworkReachabilityFlags()
        let didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        
        guard didRetrieveFlags == true,
              (flags.contains(.reachable) && !flags.contains(.connectionRequired)) == true
        else {
            return "notReachable"
        }
        if flags.contains(.connectionRequired) {
            return "notReachable"
        } else if flags.contains(.isWWAN) {
            return self.cellularType()
        } else {
            return "WiFi"
        }
    }
    
    /// 获取蜂窝数据类型
    private static func cellularType() -> String {
        let info = CTTelephonyNetworkInfo()
        var status: String
        
        if #available(iOS 12.0, *) {
            guard let dict = info.serviceCurrentRadioAccessTechnology,
                  let firstKey = dict.keys.first,
                  let statusTemp = dict[firstKey] else {
                return "notReachable"
            }
            status = statusTemp
        } else {
            guard let statusTemp = info.currentRadioAccessTechnology else {
                return "notReachable"
            }
            status = statusTemp
        }
        
        if #available(iOS 14.1, *) {
            if status == CTRadioAccessTechnologyNR || status == CTRadioAccessTechnologyNRNSA {
                return "5G"
            }
        }
        
        switch status {
        case CTRadioAccessTechnologyGPRS,
            CTRadioAccessTechnologyEdge,
        CTRadioAccessTechnologyCDMA1x:
            return "2G"
        case CTRadioAccessTechnologyWCDMA,
            CTRadioAccessTechnologyHSDPA,
            CTRadioAccessTechnologyHSUPA,
            CTRadioAccessTechnologyeHRPD,
            CTRadioAccessTechnologyCDMAEVDORev0,
            CTRadioAccessTechnologyCDMAEVDORevA,
        CTRadioAccessTechnologyCDMAEVDORevB:
            return "3G"
        case CTRadioAccessTechnologyLTE:
            return "4G"
        default:
            return "notReachable"
        }
    }
    
    static func getMAC() -> (String?, String?){
        var ssid: String?
        var mac: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    mac = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                }
            }
        }
        
        return (mac, ssid)
    }
    
    static func getWiFI() -> (ssid: String, bssid: String) {
        NEHotspotNetwork.fetchCurrent(completionHandler: { (item: NEHotspotNetwork?) in
            CocoaLog.debug("ssss")
        })
        
        return ("", "")
    }
    
    static func getNetworkInfo(compleationHandler: @escaping ([String: Any])->Void){
        
        var currentWirelessInfo: [String: Any] = [:]
        
        if #available(iOS 14.0, *) {
            
            NEHotspotNetwork.fetchCurrent { network in
                
                guard let network = network else {
                    compleationHandler([:])
                    return
                }
                
                let bssid = network.bssid
                let ssid = network.ssid
                currentWirelessInfo = ["BSSID ": bssid, "SSID": ssid, "SSIDDATA": "<54656e64 615f3443 38354430>"]
                compleationHandler(currentWirelessInfo)
            }
        }
        else {
#if !TARGET_IPHONE_SIMULATOR
            guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
                compleationHandler([:])
                return
            }
            
            guard let name = interfaceNames.first, let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: Any] else {
                compleationHandler([:])
                return
            }
            
            currentWirelessInfo = info
            
#else
            currentWirelessInfo = ["BSSID ": "c8:3a:35:4c:85:d0", "SSID": "Tenda_4C85D0", "SSIDDATA": "<54656e64 615f3443 38354430>"]
#endif
            compleationHandler(currentWirelessInfo)
        }
    }
    
    /// 获取内存使用情况
    /// - Returns:
    ///     - used: 已使用
    ///     - total: 总内存
    public static func memoryUsage() -> (used: UInt64, total: UInt64) {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        let total = ProcessInfo.processInfo.physicalMemory
        let vm = Mach.Host.Statistics.vmInfo()
//            print("- freeSize: \(vm.freeSize)")  // byte size of free
//            print("- activeSize: \(vm.activeSize)")  // byte size of active
//            print("- inactiveSize: \(vm.inactiveSize)")  // byte size of inactive
//            print("- wireSize: \(vm.wireSize)")  // byte size of wire
        return (vm.inactiveSize, total)
    }
    
    public static func isJailBreak() -> Bool {
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Applications/blackra1n.app")
            || FileManager.default.fileExists(atPath: "/Applications/FakeCarrier.app")
            || FileManager.default.fileExists(atPath: "/Applications/Icy.app")
            || FileManager.default.fileExists(atPath: "/Applications/IntelliScreenx.app")
            || FileManager.default.fileExists(atPath: "/Applications/MxTube.app")
            || FileManager.default.fileExists(atPath: "/Applications/RockApp.app")
            || FileManager.default.fileExists(atPath: "/Applications/SBSettings.app")
            || FileManager.default.fileExists(atPath: "/Applications/WinterBoard.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Veency.plist")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || FileManager.default.fileExists(atPath: "/private/var/lib/cydia")
            || FileManager.default.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes")
            || FileManager.default.fileExists(atPath: "/private/var/stash")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
            return true
        }
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: String.Encoding.utf8)
            // Device is jailbroken
            return true
        } catch {
            return false
        }
    }
    
    public static func getAppBattery() -> (level: Float, status: Int) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        let status = UIDevice.current.batteryState
        return (level * 100, status == .charging || status == .full ? 1 : 0)
    }
    
    class func getAppMemory() -> String {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        let usedMb = Float(taskInfo.phys_footprint) / 1048576.0
        let totalMb = Float(ProcessInfo.processInfo.physicalMemory) / 1048576.0
        //        result != KERN_SUCCESS ? print("Memory used: ? of \(totalMb)") : print("Memory used: \(usedMb) of \(totalMb)")
        if result == KERN_SUCCESS {
            let percent = usedMb / totalMb * 100
            //            print("percent:\(String(format: "%.1f", percent))%")
            return String(format: "%.1f", percent)
        }
        return  ""
    }
    
    class func getAppDiskSize(needFormate: Bool = false) -> (availableCapacity: String, usedCapacity: String, totalCapacity: String) {
        let fileURL = URL(fileURLWithPath:"/")
        do {
            let values = try fileURL.resourceValues(forKeys: [
                .volumeAvailableCapacityKey,
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeAvailableCapacityForOpportunisticUsageKey,
                .volumeTotalCapacityKey
            ])
            //            let formatter = ByteCountFormatter()
            //            if let volumeAvailableCapacityForImportantUsage = values.volumeAvailableCapacityForImportantUsage,
            //               let volumeTotalCapacity = values.volumeTotalCapacity {
            //                let availableCapacity = formatter.string(fromByteCount: Int64(volumeAvailableCapacityForImportantUsage))
            //                print("availableCapacity:\(availableCapacity)")
            //                var totalCapacity = formatter.string(fromByteCount: Int64(volumeTotalCapacity))
            //                totalCapacity = totalCapacity.replacingOccurrences(of: "GB", with: "")
            //                if totalCapacity.hasSuffix(" ") {
            //                    totalCapacity = totalCapacity.replacingOccurrences(of: " ", with: "")
            //                }
            //                totalCapacity = String(format: "%.0f", ceilf(Float(totalCapacity) ?? 0))
            //                print("totalCapacity:\(totalCapacity)")
            //                let usedCapacityNumber = (totalCapacity as NSString).doubleValue - (availableCapacity as NSString).doubleValue
            //                let usedCapacity = String(format: "%.2f", usedCapacityNumber)
            //                print("usedCapacity:\(usedCapacity)")
            //                let availableNumber = (availableCapacity.replacingOccurrences(of: "GB", with: "") as NSString).doubleValue
            //                return (String(format: "%.f", availableNumber), usedCapacity, totalCapacity)
            //            }
            if let volumeAvailableCapacityForImportantUsage = values.volumeAvailableCapacityForImportantUsage,
               let volumeTotalCapacity = values.volumeTotalCapacity {
                let formatter = ByteCountFormatter()
                let totalCapacityString = formatter.string(fromByteCount: Int64(volumeTotalCapacity))
                let totalCapacityInGB = extractCapacityInGB(from: totalCapacityString)
                print("totalCapacityInGB: \(totalCapacityInGB)")
                
                let availableCapacity = formatter.string(fromByteCount: Int64(volumeAvailableCapacityForImportantUsage))
                let availableCapacityInGB = extractCapacityInGB(from: availableCapacity)
                print("availableCapacityInGB: \(availableCapacityInGB)")
                
                let usedCapacityNumber = Double(totalCapacityInGB)! - Double(availableCapacityInGB)!
                let usedCapacityString = String(format: "%.2f", usedCapacityNumber)
                print("usedCapacityInGB: \(usedCapacityString)")
                
                if needFormate {
                    return (String(format: "%.f", Double(availableCapacityInGB)!),
                            usedCapacityString,
                            totalCapacityInGB)
                } else {
                    return ("\(volumeAvailableCapacityForImportantUsage)", "\(usedCapacityNumber)", "\(volumeTotalCapacity)")
                }
            }
            
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
        return ("","","")
    }
    // MARK: 根据不同的地区获取总的手机容量
    private class func extractCapacityInGB(from sizeString: String) -> String {
        if let dotIndex = sizeString.firstIndex(of: ".") {
            if sizeString.contains(" "), let whiteSpace = sizeString.firstIndex(of: " ") {
                return String(sizeString[..<whiteSpace])
            }
            return String(sizeString[..<dotIndex])
        }
        // Return "0" if the capacity cannot be extracted.
        return "0"
    }
    
    /// 获取当前设备IP
    class func getOperatorsIP() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    // 获取设备的原始型号
    public static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    // APP名字
    public static func appName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
}
