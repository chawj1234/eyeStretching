//
//  MovingPoint.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import Foundation

// MARK: - Moving Point Component
struct MovingPoint: View {
    let pattern: EyeStretchingManager.StretchingPattern
    let progress: Double
    let geometry: GeometryProxy
    
    private var position: CGPoint {
        calculatePosition()
    }
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [.mint, .mint.opacity(0.7)],
                    center: .center,
                    startRadius: 5,
                    endRadius: 15
                )
            )
            .frame(width: 24, height: 24)
            .shadow(color: .mint.opacity(0.3), radius: 6, x: 0, y: 1)
            .position(position)
    }
    
    private func calculatePosition() -> CGPoint {
        switch pattern {
        case .circle:
            return circlePosition()
        case .figure8:
            return figure8Position()
        case .vertical:
            return verticalPosition()
        case .horizontal:
            return horizontalPosition()
        }
    }
    
    // MARK: - 원형 패턴 (화면 전체 활용)
    private func circlePosition() -> CGPoint {
        let angle = progress * 2 * .pi
        // 화면을 최대한 활용하되 안전 여백 확보
        let radiusX = (geometry.size.width - 80) * 0.45  // 좌우 여백 40씩
        let radiusY = (geometry.size.height - 160) * 0.45  // 상하 여백 80씩
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let x = centerX + cos(angle) * radiusX
        let y = centerY + sin(angle) * radiusY
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - 8자형 패턴 (더 큰 움직임)
    private func figure8Position() -> CGPoint {
        let t = progress * 2 * .pi
        let scaleX = (geometry.size.width - 80) * 0.4   // 수평 스케일 증가
        let scaleY = (geometry.size.height - 160) * 0.3  // 수직 스케일 증가
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        // Lemniscate of Bernoulli 공식 개선
        let sinT = sin(t)
        let cosT = cos(t)
        let denominator = 1 + sinT * sinT
        
        let x = centerX + (scaleX * cosT) / denominator
        let y = centerY + (scaleY * sinT * cosT) / denominator
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - 상하 패턴 (큰 수직 움직임)
    private func verticalPosition() -> CGPoint {
        let centerX = geometry.size.width / 2
        let topMargin: CGFloat = 80
        let bottomMargin: CGFloat = 80
        
        // 사인파를 이용한 부드러운 상하 움직임
        let amplitude = (geometry.size.height - topMargin - bottomMargin) / 2
        let centerY = geometry.size.height / 2
        
        // 0 -> 1 -> 0 -> -1 -> 0 순서로 움직임 (위 -> 중간 -> 아래 -> 중간 -> 위)
        let angle = progress * 4 * .pi  // 2번의 완전한 사이클
        let y = centerY - sin(angle) * amplitude
        
        return CGPoint(x: centerX, y: y)
    }
    
    // MARK: - 좌우 패턴 (큰 수평 움직임)
    private func horizontalPosition() -> CGPoint {
        let centerY = geometry.size.height / 2
        let leftMargin: CGFloat = 40
        let rightMargin: CGFloat = 40
        
        // 코사인파를 이용한 부드러운 좌우 움직임
        let amplitude = (geometry.size.width - leftMargin - rightMargin) / 2
        let centerX = geometry.size.width / 2
        
        // 0 -> 1 -> 0 -> -1 -> 0 순서로 움직임 (오른쪽 -> 중간 -> 왼쪽 -> 중간 -> 오른쪽)
        let angle = progress * 4 * .pi  // 2번의 완전한 사이클
        let x = centerX + cos(angle) * amplitude
        
        return CGPoint(x: x, y: centerY)
    }
} 