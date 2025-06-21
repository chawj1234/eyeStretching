//
//  CompletionView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import UIKit

// MARK: - Completion View
struct CompletionView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var showCheckmark = false
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // 성공 아이콘
            ZStack {
                Circle()
                    .fill(Color.mint.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.mint)
                    .scaleEffect(scale)
                    .opacity(showCheckmark ? 1 : 0)
            }
            
            // 완료 메시지
            VStack(spacing: 16) {
                Text(NSLocalizedString("exercise_complete", comment: ""))
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(NSLocalizedString("exercise_success_message", comment: ""))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // 통계
            VStack(spacing: 12) {
                Text(NSLocalizedString("total_completed", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(manager.completedSessions)\(NSLocalizedString("count_unit", comment: ""))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.mint)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 40)
            
            Spacer()
            
            // 완료 버튼
            Button(action: {
                manager.returnToMenu()
            }) {
                Text(NSLocalizedString("complete_button", comment: ""))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            
        }
        .background(Color(.systemBackground))
        .onAppear {
            // 성공 햅틱 피드백
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            
            // 체크마크 애니메이션
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showCheckmark = true
                scale = 1.0
            }
        }
    }
} 
