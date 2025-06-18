//
//  MenuView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI

// MARK: - Menu View
struct MenuView: View {
    @ObservedObject var manager: EyeStretchingManager
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // 제목 섹션
            VStack(spacing: 20) {
                Image(systemName: "eye")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.mint)
                
                Text("눈 스트레칭")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("움직이는 점을 따라 자연스럽게 눈 운동하기")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // 통계 카드
            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    StatCard(
                        title: "완료 횟수",
                        value: "\(manager.completedSessions)",
                        unit: "회",
                        color: .mint
                    )
                    
                    StatCard(
                        title: "운동 속도",
                        value: manager.animationSpeed.rawValue,
                        unit: "",
                        color: manager.animationSpeed == .fast ? .orange : .blue
                    )
                }
                
                if manager.lastCompletedDate != nil {
                    HStack {
                        StatCard(
                            title: "최근 운동",
                            value: "오늘",
                            unit: "",
                            color: .green
                        )
                    }
                }
            }
            
            Spacer()
            
            // 속도 설정 버튼
            HStack(spacing: 12) {
                ForEach(EyeStretchingManager.AnimationSpeed.allCases, id: \.self) { speed in
                    Button(action: {
                        manager.animationSpeed = speed
                        manager.saveData()
                        
                        // 햅틱 피드백
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: speed.icon)
                                .font(.caption)
                            Text(speed.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(manager.animationSpeed == speed ? .white : .mint)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(manager.animationSpeed == speed ? Color.mint : Color.mint.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 24)
            
            // 시작 버튼
            Button(action: {
                manager.startStretching()
            }) {
                Text("운동 시작")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            
            // 패턴 안내
            VStack(spacing: 12) {
                Text("🎯 운동 패턴")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 6) {
                    HStack {
                        Text("∞")
                            .font(.title2)
                            .foregroundColor(.mint)
                        Text("8자형")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("○")
                            .font(.title2)
                            .foregroundColor(.mint)
                        Text("원형")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("↕")
                            .font(.title2)
                            .foregroundColor(.mint)
                        Text("상하형")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("↔")
                            .font(.title2)
                            .foregroundColor(.mint)
                        Text("좌우형")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Text(getExerciseTimeDescription())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
    
    private func getExerciseTimeDescription() -> String {
        let baseTime = 80.0 // 기본 80초 (20초 × 4패턴)
        let adjustedTime = Int(baseTime / manager.animationSpeed.multiplier)
        return "총 4가지 패턴으로 \(adjustedTime)초간 큰 눈 운동을 해보세요!"
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .offset(y: -2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 