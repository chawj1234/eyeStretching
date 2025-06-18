//
//  CountdownView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import UIKit

// MARK: - Countdown View
struct CountdownView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var countdown = 3
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            
            Text("준비하세요")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            // 카운트다운 숫자
            ZStack {
                Circle()
                    .fill(Color.mint.opacity(0.1))
                    .frame(width: 160, height: 160)
                
                Text(countdown > 0 ? "\(countdown)" : "시작!")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(.mint)
                    .scaleEffect(scale)
            }
            
            Text("움직이는 점을 눈으로 따라가세요")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onAppear {
            startCountdown()
        }
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                scale = 1.2
            }
            
            // 햅틱 피드백
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    scale = 1.0
                }
            }
            
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    manager.beginStretching()
                }
            }
        }
    }
} 