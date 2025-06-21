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
        GeometryReader { geometry in
            let screenSize = DeviceHelper.ScreenSize.current(geometry: geometry)
            let deviceType = DeviceHelper.currentDevice
            
            VStack(spacing: screenSize == .compact ? 40 : 60) {
                Spacer()
                
                // 제목 섹션
                VStack(spacing: screenSize == .compact ? 20 : 32) {
                    Image("eyes")
                        .resizable()
                        .frame(
                            width: screenSize == .compact ? 100 : 140,
                            height: screenSize == .compact ? 100 : 140
                        )
                    
                    Text(NSLocalizedString("menu_title", comment: ""))
                        .font(screenSize == .compact ? .largeTitle : .system(size: 44, weight: .medium))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(NSLocalizedString("menu_subtitle", comment: ""))
                        .font(screenSize == .compact ? .body : .title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenSize == .compact ? 20 : 40)
                }
                
                // 통계 카드
                VStack(spacing: 16) {
                    HStack(spacing: screenSize == .compact ? 16 : 24) {
                        StatCard(
                            title: NSLocalizedString("completed_count", comment: ""),
                            value: "\(manager.completedSessions)",
                            unit: NSLocalizedString("count_unit", comment: ""),
                            color: .mint,
                            screenSize: screenSize
                        )
                        
                        if manager.lastCompletedDate != nil {
                            StatCard(
                                title: NSLocalizedString("recent_exercise", comment: ""),
                                value: NSLocalizedString("today", comment: ""),
                                unit: "",
                                color: .green,
                                screenSize: screenSize
                            )
                        } else {
                            StatCard(
                                title: NSLocalizedString("recommended_count", comment: ""),
                                value: "3-5",
                                unit: NSLocalizedString("times_per_day", comment: ""),
                                color: .orange,
                                screenSize: screenSize
                            )
                        }
                    }
                    .padding(.horizontal, screenSize == .compact ? 20 : 40)
                }
                
                Spacer()
                
                // 시작 버튼
                Button(action: {
                    manager.startStretching()
                }) {
                    Text(NSLocalizedString("start_exercise", comment: ""))
//                        .font(screenSize == .compact ? .title3 : .title2)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
//                        .frame(maxWidth: screenSize == .large ? 400 : .infinity)
                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, screenSize == .compact ? 16 : 20)
                        .padding(.vertical, 16)
                        .background(Color.mint)
//                        .clipShape(RoundedRectangle(cornerRadius: screenSize == .compact ? 12 : 16))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                //                .padding(.horizontal, screenSize == .compact ? 24 : 60)
                .padding(.horizontal, 24)
                // Mac에서만 하단 여백 추가 (Mac Catalyst + Designed for iPad)
                .padding(.bottom, DeviceHelper.isRunningOnMac ? 20 : 0)
            }
            .background(Color(.systemBackground))
            .onAppear {
                // 디바이스 정보 출력 (디버그 모드에서만)
                #if DEBUG
                DeviceHelper.printDeviceInfo()
                #endif
            }
            // Mac에서 키보드 입력 지원
            #if targetEnvironment(macCatalyst)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyCommandNotification)) { notification in
                if let keyCommand = notification.object as? UIKey {
                    if keyCommand.charactersIgnoringModifiers == " " {
                        manager.startStretching()
                    }
                }
            }
            #endif
        }
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let screenSize: DeviceHelper.ScreenSize
    
    var body: some View {
        VStack(spacing: screenSize == .compact ? 8 : 12) {
            Text(title)
                .font(screenSize == .compact ? .caption : .subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(screenSize == .compact ? .title2 : .largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(screenSize == .compact ? .caption : .subheadline)
                        .foregroundColor(.secondary)
                        .offset(y: screenSize == .compact ? -2 : -4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, screenSize == .compact ? 16 : 24)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: screenSize == .compact ? 12 : 16))
    }
}
