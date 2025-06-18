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
                    
                    if manager.lastCompletedDate != nil {
                        StatCard(
                            title: "최근 운동",
                            value: "오늘",
                            unit: "",
                            color: .orange
                        )
                    }
                }
            }
            
            Spacer()
            
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
            
            // 간단한 안내
            Text("원형과 8자 패턴을 2분간 따라가세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
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