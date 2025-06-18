//
//  StretchingView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import UIKit

// MARK: - Stretching View
struct StretchingView: View {
    @ObservedObject var manager: EyeStretchingManager
    @StateObject private var animationEngine = AnimationEngine()
    
    @State private var currentPattern: EyeStretchingManager.StretchingPattern = .circle
    @State private var currentCycle = 0
    
    private let totalCycles = 4 // 2회 원형, 2회 8자
    private let cycleDuration: Double = 15.0 // 각 패턴 15초
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 밝은 배경
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                // 패턴 가이드라인
                PatternPath(
                    pattern: currentPattern,
                    geometry: geometry
                )
                
                // 움직이는 포인트
                MovingPoint(
                    pattern: currentPattern,
                    progress: animationEngine.progress,
                    geometry: geometry
                )
                
                // 상단 진행 상황
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(currentCycle + 1)/\(totalCycles)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text(getPatternName())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 종료 버튼
                        Button(action: {
                            Task { @MainActor in
                                animationEngine.stopAnimation()
                                manager.returnToMenu()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // 하단 진행률
                VStack {
                    Spacer()
                    
                    ProgressView(value: Double(currentCycle) + animationEngine.progress, total: Double(totalCycles))
                        .progressViewStyle(LinearProgressViewStyle(tint: .mint))
                        .scaleEffect(x: 1, y: 2)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            startStretching()
        }
        .onDisappear {
            animationEngine.stopAnimation()
        }
    }
    
    private func startStretching() {
        currentCycle = 0
        currentPattern = .circle
        animatePattern()
    }
    
    private func animatePattern() {
        // 고성능 60fps 애니메이션 엔진 사용
        animationEngine.startAnimation(duration: cycleDuration) {
            completeCurrentPattern()
        }
    }
    
    private func completeCurrentPattern() {
        currentCycle += 1
        
        if currentCycle >= totalCycles {
            // 모든 패턴 완료
            animationEngine.stopAnimation()
            manager.completeStretching()
        } else {
            // 다음 패턴으로 전환
            currentPattern = (currentCycle % 2 == 0) ? .circle : .figure8
            
            // 햅틱 피드백
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // 0.5초 후 다음 패턴 시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animatePattern()
            }
        }
    }
    
    private func getPatternName() -> String {
        switch currentPattern {
        case .circle:
            return "원형 패턴"
        case .figure8:
            return "8자 패턴"
        }
    }
} 