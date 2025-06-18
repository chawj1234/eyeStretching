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
    
    private let userDefaults = UserDefaults.standard
    
    enum AppView {
        case menu
        case countdown
        case stretching
        case completion
    }
    
    enum StretchingPattern {
        case circle
        case figure8
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
    
    private func saveData() {
        userDefaults.set(completedSessions, forKey: "completedSessions")
        if let date = lastCompletedDate {
            userDefaults.set(date, forKey: "lastCompletedDate")
        }
    }
    
    private func loadData() {
        completedSessions = userDefaults.integer(forKey: "completedSessions")
        lastCompletedDate = userDefaults.object(forKey: "lastCompletedDate") as? Date
    }
} 