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
        case figure8 = "8자형"
        case circle = "원형" 
        case vertical = "상하형"
        case diamond = "마름모형"
        
        var description: String {
            switch self {
            case .figure8:
                return "세로 8자를 그리며 눈을 크게 움직여보세요"
            case .circle:
                return "큰 원을 그리며 눈을 움직여보세요"
            case .vertical:
                return "위아래로 눈을 크게 움직여보세요"
            case .diamond:
                return "세로 마름모를 그리며 눈을 움직여보세요"
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
        case normal = "보통"
        case fast = "빠르게"
        
        var multiplier: Double {
            switch self {
            case .normal:
                return 1.0
            case .fast:
                return 2.5
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
                return "편안한 속도로 운동"
            case .fast:
                return "빠른 속도로 운동"
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