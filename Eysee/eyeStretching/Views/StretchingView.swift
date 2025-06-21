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
    @State private var showCompletionCheck = false
    @State private var isTransitioning = false
    
    private let totalCycles = 4 // 8자 → 원형 → 상하 → 마름모
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
                if !isTransitioning {
                    MovingPoint(
                        pattern: currentPattern,
                        progress: animationEngine.progress,
                        geometry: geometry
                    )
                }
                
                // 패턴 완료 체크 애니메이션
                if showCompletionCheck {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.mint.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .scaleEffect(showCompletionCheck ? 1.2 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showCompletionCheck)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.mint)
                                .scaleEffect(showCompletionCheck ? 1.0 : 0.3)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: showCompletionCheck)
                        }
                        
                        Text(NSLocalizedString("pattern_complete", comment: ""))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.mint)
                            .opacity(showCompletionCheck ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.3).delay(0.2), value: showCompletionCheck)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                // 상단 진행 상황 및 컨트롤
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(currentCycle + 1)/\(totalCycles)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text("\(getPatternName()) • \(manager.animationSpeed.localizedName)")
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
                                Text(manager.animationSpeed.localizedName)
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
                    
                    ProgressView(value: getDisplayProgress(), total: Double(totalCycles))
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
        // 전환 상태로 설정
        isTransitioning = true
        
        // 완료 체크 애니메이션 시작
        withAnimation {
            showCompletionCheck = true
        }
        
        // 성공 햅틱 피드백
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        // 1.5초 후 다음 단계 진행
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCompletionCheck = false
            }
            
            let nextCycle = currentCycle + 1
            
            if nextCycle >= totalCycles {
                // 모든 패턴 완료
                currentCycle = nextCycle
                isTransitioning = false
                animationEngine.stopAnimation()
                manager.completeStretching()
            } else {
                // 다음 패턴으로 순서대로 전환: 8자 → 원형 → 상하 → 마름모
                switch nextCycle {
                case 1:
                    currentPattern = .circle
                case 2:
                    currentPattern = .vertical
                case 3:
                    currentPattern = .diamond
                default:
                    currentPattern = .figure8
                }
                
                // 0.5초 후 다음 패턴 시작
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    currentCycle = nextCycle  // 애니메이션 시작 직전에 사이클 증가
                    isTransitioning = false
                    animatePattern()
                }
            }
        }
    }
    
    private func getPatternName() -> String {
        return currentPattern.localizedName
    }
    
    private func getDisplayProgress() -> Double {
        if isTransitioning {
            // 전환 중일 때는 현재 패턴이 완료된 상태로 표시
            return Double(currentCycle + 1)
        } else {
            // 일반 애니메이션 중일 때는 실시간 진행률 표시
            return Double(currentCycle) + animationEngine.progress
        }
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