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
                Image("eyes")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text(NSLocalizedString("menu_title", comment: ""))
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(NSLocalizedString("menu_subtitle", comment: ""))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // 통계 카드
            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    StatCard(
                        title: NSLocalizedString("completed_count", comment: ""),
                        value: "\(manager.completedSessions)",
                        unit: NSLocalizedString("count_unit", comment: ""),
                        color: .mint
                    )
                    
                    if manager.lastCompletedDate != nil {
                        StatCard(
                            title: NSLocalizedString("recent_exercise", comment: ""),
                            value: NSLocalizedString("today", comment: ""),
                            unit: "",
                            color: .green
                        )
                    } else {
                        StatCard(
                            title: NSLocalizedString("recommended_count", comment: ""),
                            value: "3-5",
                            unit: NSLocalizedString("times_per_day", comment: ""),
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // 시작 버튼
            Button(action: {
                manager.startStretching()
            }) {
                Text(NSLocalizedString("start_exercise", comment: ""))
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
//            Text("다양한 패턴으로 큰 눈 운동을 해보세요!")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//            
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
