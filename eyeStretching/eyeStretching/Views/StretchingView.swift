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
    
    @State private var currentPattern: EyeStretchingManager.StretchingPattern = .figure8
    @State private var currentCycle = 0
    
    private let totalCycles = 4 // 8자 → 원형 → 상하 → 좌우
    private let cycleDuration: Double = 20.0 // 각 패턴 20초 (더 긴 시간으로 충분한 운동)
    
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
                
                // 상단 진행 상황 및 컨트롤
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(currentCycle + 1)/\(totalCycles)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text("\(getPatternName()) • \(manager.animationSpeed.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 속도 조절 버튼
                        Button(action: {
                            toggleSpeed()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: manager.animationSpeed.icon)
                                    .font(.caption)
                                Text(manager.animationSpeed.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.mint)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.mint.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        
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
        currentPattern = .figure8  // 8자부터 시작
        animatePattern()
    }
    
    private func animatePattern() {
        // 속도에 따른 지속시간 조절
        let adjustedDuration = cycleDuration / manager.animationSpeed.multiplier
        
        // 고성능 60fps 애니메이션 엔진 사용
        animationEngine.startAnimation(duration: adjustedDuration) {
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
            // 다음 패턴으로 순서대로 전환: 8자 → 원형 → 상하 → 좌우
            switch currentCycle {
            case 1:
                currentPattern = .circle
            case 2:
                currentPattern = .vertical
            case 3:
                currentPattern = .horizontal
            default:
                currentPattern = .figure8
            }
            
            // 햅틱 피드백
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // 1초 후 다음 패턴 시작 (패턴 간 휴식시간 증가)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animatePattern()
            }
        }
    }
    
    private func getPatternName() -> String {
        return currentPattern.rawValue
    }
    
    private func toggleSpeed() {
        // 현재 애니메이션 진행률 저장
        let currentProgress = animationEngine.progress
        
        // 속도 변경
        manager.animationSpeed = (manager.animationSpeed == .normal) ? .fast : .normal
        manager.saveData() // 설정 저장
        
        // 햅틱 피드백
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        // 현재 애니메이션이 실행 중이라면 현재 위치에서 새로운 속도로 계속 진행
        if animationEngine.isRunning {
            // 전체 사이클 시간 (새로운 속도 적용)
            let totalDuration = cycleDuration / manager.animationSpeed.multiplier
            
            // 현재 위치에서 새로운 속도로 애니메이션 재개
            animationEngine.resumeAnimation(from: currentProgress, duration: totalDuration) {
                completeCurrentPattern()
            }
        }
    }
} 