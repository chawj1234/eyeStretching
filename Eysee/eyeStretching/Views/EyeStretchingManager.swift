//
//  EyeStretchingManager.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import Foundation

// MARK: - Eye Tracking Manager
class EyeStretchingManager: ObservableObject {
    @Published var currentView: AppView = .menu
    @Published var completedSessions: Int = 0
    @Published var lastCompletedDate: Date?
    @Published var animationSpeed: AnimationSpeed = .normal
    
    private let userDefaults = UserDefaults.standard
    
    enum AppView {
        case menu
        case countdown
        case stretching
        case completion
    }
    
    enum StretchingPattern: String, CaseIterable {
        case figure8 = "pattern_figure8"
        case circle = "pattern_circle"
        case vertical = "pattern_vertical"
        case diamond = "pattern_diamond"
        
        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        var description: String {
            switch self {
            case .figure8:
                return NSLocalizedString("pattern_figure8_desc", comment: "")
            case .circle:
                return NSLocalizedString("pattern_circle_desc", comment: "")
            case .vertical:
                return NSLocalizedString("pattern_vertical_desc", comment: "")
            case .diamond:
                return NSLocalizedString("pattern_diamond_desc", comment: "")
            }
        }
        
        var icon: String {
            switch self {
            case .figure8:
                return "infinity"
            case .circle:
                return "circle"
            case .vertical:
                return "arrow.up.arrow.down"
            case .diamond:
                return "diamond"
            }
        }
    }
    
    enum AnimationSpeed: String, CaseIterable {
        case normal = "normal_speed"
        case fast = "fast_speed"
        
        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        var multiplier: Double {
            switch self {
            case .normal:
                return 1.0  // 기본 속도 (1회 사이클)
            case .fast:
                return 2.0  // 2배 빠른 속도 (2회 사이클)
            }
        }
        
        var icon: String {
            switch self {
            case .normal:
                return "1.circle"
            case .fast:
                return "2.circle.fill"
            }
        }
        
        var description: String {
            switch self {
            case .normal:
                return NSLocalizedString("normal_speed_desc", comment: "")
            case .fast:
                return NSLocalizedString("fast_speed_desc", comment: "")
            }
        }
    }
    
    init() {
        loadData()
    }
    
    func startStretching() {
        currentView = .countdown
    }
    
    func beginStretching() {
        currentView = .stretching
    }
    
    func completeStretching() {
        completedSessions += 1
        lastCompletedDate = Date()
        saveData()
        currentView = .completion
    }
    
    func returnToMenu() {
        currentView = .menu
    }
    
    func saveData() {
        userDefaults.set(completedSessions, forKey: "completedSessions")
        userDefaults.set(animationSpeed.rawValue, forKey: "animationSpeed")
        if let date = lastCompletedDate {
            userDefaults.set(date, forKey: "lastCompletedDate")
        }
    }
    
    private func loadData() {
        completedSessions = userDefaults.integer(forKey: "completedSessions")
        lastCompletedDate = userDefaults.object(forKey: "lastCompletedDate") as? Date
        
        if let speedString = userDefaults.object(forKey: "animationSpeed") as? String,
           let speed = AnimationSpeed(rawValue: speedString) {
            animationSpeed = speed
        } else {
            animationSpeed = .normal
        }
    }
} 