//
//  ContentView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var manager = EyeStretchingManager()
    
    var body: some View {
        Group {
            switch manager.currentView {
            case .menu:
                MenuView(manager: manager)
            case .countdown:
                CountdownView(manager: manager)
            case .stretching:
                StretchingView(manager: manager)
            case .completion:
                CompletionView(manager: manager)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: manager.currentView)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
} 