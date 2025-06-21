//
//  eyeStretchingApp.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI

@main
struct EyeStretchingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear {
                    // 눈 추적 권한 및 설정 안내
                    setupAccessibilityFeatures()
                    // 다국어 설정 확인 (디버그 모드에서만)
                    #if DEBUG
                    LocalizationHelper.printCurrentLanguageSettings()
                    DeviceHelper.printDeviceInfo()
                    #endif
                }
        }
        // Mac Catalyst에서 윈도우 크기 제한 설정
        #if targetEnvironment(macCatalyst)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #endif
    }
    
    private func setupAccessibilityFeatures() {
        // 눈 추적 기능 사용 가능 여부 확인
        #if targetEnvironment(simulator)
        print("시뮬레이터에서는 눈 추적 기능을 사용할 수 없습니다. 실제 기기에서 테스트해주세요.")
        #else
        print("눈 추적 기능을 사용하려면 설정 > 손쉬운 사용 > 눈 추적을 활성화해주세요.")
        #endif
        
        // 접근성 알림 등록
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.guidedAccessStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            print("접근성 설정이 변경되었습니다.")
        }
    }
}
