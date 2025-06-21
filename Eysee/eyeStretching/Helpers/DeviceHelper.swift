//
//  DeviceHelper.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import UIKit

// MARK: - Device Type Helper
struct DeviceHelper {
    
    // 현재 디바이스 타입
    enum DeviceType {
        case iPhone
        case iPad
        case mac
        
        var displayName: String {
            switch self {
            case .iPhone:
                return "iPhone"
            case .iPad:
                return "iPad"
            case .mac:
                return "Mac"
            }
        }
    }
    
    // 현재 디바이스 감지
    static var currentDevice: DeviceType {
        #if targetEnvironment(macCatalyst)
        return .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
        #endif
    }
    
    // Mac에서 실행 중인지 감지 (Mac Catalyst + Designed for iPad 포함)
    static var isRunningOnMac: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        // "Designed for iPad" 앱이 Mac에서 실행되는 경우 감지
        if ProcessInfo.processInfo.isiOSAppOnMac {
            return true
        }
        return false
        #endif
    }
    
    // 화면 크기 카테고리
    enum ScreenSize {
        case compact    // iPhone, 작은 iPad
        case regular    // 큰 iPad
        case large      // Mac, 매우 큰 화면
        
        static func current(geometry: GeometryProxy) -> ScreenSize {
            let width = geometry.size.width
            let height = geometry.size.height
            let minDimension = min(width, height)
            
            if minDimension < 500 {
                return .compact
            } else if minDimension < 800 {
                return .regular
            } else {
                return .large
            }
        }
    }
    
    // 디바이스별 여백 설정
    static func margins(for deviceType: DeviceType) -> (horizontal: CGFloat, vertical: CGFloat) {
        switch deviceType {
        case .iPhone:
            return (horizontal: 24, vertical: 40)
        case .iPad:
            return (horizontal: 60, vertical: 80)
        case .mac:
            return (horizontal: 80, vertical: 100)
        }
    }
    
    // 디바이스별 폰트 크기 배율
    static func fontScale(for deviceType: DeviceType) -> CGFloat {
        switch deviceType {
        case .iPhone:
            return 1.0
        case .iPad:
            return 1.3
        case .mac:
            return 1.2
        }
    }
    
    // 디바이스별 애니메이션 영역 크기 조정
    static func animationAreaScale(for deviceType: DeviceType) -> CGFloat {
        switch deviceType {
        case .iPhone:
            return 1.0
        case .iPad:
            return 0.8  // iPad에서는 조금 더 작게
        case .mac:
            return 0.7  // Mac에서는 더 작게 (마우스 움직임 고려)
        }
    }
    
    // 입력 방식 감지
    static var supportsTouch: Bool {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        return true
        #endif
    }
    
    // 디버깅용 정보 출력
    static func printDeviceInfo() {
        print("📱 Current Device: \(currentDevice.displayName)")
        print("📱 Supports Touch: \(supportsTouch)")
        print("📱 Is Running On Mac: \(isRunningOnMac)")
        print("📱 iOS App On Mac: \(ProcessInfo.processInfo.isiOSAppOnMac)")
        print("📱 User Interface Idiom: \(UIDevice.current.userInterfaceIdiom.rawValue)")
        #if targetEnvironment(macCatalyst)
        print("📱 Running on Mac Catalyst")
        #else
        print("📱 Not Mac Catalyst")
        #endif
    }
}

// MARK: - SwiftUI Extensions for Universal App
extension View {
    // 디바이스별 여백 적용
    func universalPadding() -> some View {
        let margins = DeviceHelper.margins(for: DeviceHelper.currentDevice)
        return self.padding(.horizontal, margins.horizontal)
                  .padding(.vertical, margins.vertical)
    }
    
    // 디바이스별 폰트 크기 조정
    func universalFont(_ font: Font) -> some View {
        let scale = DeviceHelper.fontScale(for: DeviceHelper.currentDevice)
        return self.font(font).scaleEffect(scale)
    }
} 