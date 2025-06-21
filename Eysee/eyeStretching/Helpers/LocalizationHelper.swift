//
//  LocalizationHelper.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import Foundation
import UIKit

// MARK: - Localization Helper
class LocalizationHelper {
    
    // 현재 시스템 언어 가져오기
    static var currentLanguage: String {
        return Locale.current.languageCode ?? "ko"
    }
    
    // 지원하는 언어 목록
    static let supportedLanguages = ["ko", "en", "es", "ja", "de", "fr"]
    
    // 현재 언어가 지원되는지 확인
    static var isCurrentLanguageSupported: Bool {
        return supportedLanguages.contains(currentLanguage)
    }
    
    // 지원되는 언어로 fallback
    static var preferredLanguage: String {
        let preferredLanguages = Locale.preferredLanguages
        
        for language in preferredLanguages {
            let languageCode = String(language.prefix(2))
            if supportedLanguages.contains(languageCode) {
                return languageCode
            }
        }
        
        // 기본값으로 한국어 반환
        return "ko"
    }
    
    // 언어별 표시 이름
    static func displayName(for languageCode: String) -> String {
        switch languageCode {
        case "ko":
            return "한국어"
        case "en":
            return "English"
        case "es":
            return "Español"
        case "ja":
            return "日本語"
        case "de":
            return "Deutsch"
        case "fr":
            return "Français"
        default:
            return "한국어"
        }
    }
    
    // 디버그용: 현재 언어 설정 출력
    static func printCurrentLanguageSettings() {
        print("🌐 Current Language: \(currentLanguage)")
        print("🌐 Preferred Language: \(preferredLanguage)")
        print("🌐 Is Supported: \(isCurrentLanguageSupported)")
        print("🌐 Preferred Languages: \(Locale.preferredLanguages)")
    }
} 