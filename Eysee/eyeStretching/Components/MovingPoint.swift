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
        case .diamond:
            return diamondPosition()
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
    
    // MARK: - 8자형 패턴 (세로 방향, 더 큰 움직임)
    private func figure8Position() -> CGPoint {
        let t = progress * 2 * .pi
        let scaleX = (geometry.size.width - 80) * 1.6   // 수평 스케일 증가 (더 넓은 8자)
        let scaleY = (geometry.size.height - 160) * 0.45  // 수직 스케일 대폭 증가
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        // 세로 8자를 위한 90도 회전된 Lemniscate of Bernoulli 공식
        let sinT = sin(t)
        let cosT = cos(t)
        let denominator = 1 + sinT * sinT
        
        // x와 y를 바꿔서 세로 8자 형태로 만듦
        let x = centerX + (scaleX * sinT * cosT) / denominator
        let y = centerY + (scaleY * cosT) / denominator
        
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
    
    // MARK: - 마름모 패턴 (세로로 긴 다이아몬드)
    private func diamondPosition() -> CGPoint {
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let horizontalRange = (geometry.size.width - 80) * 0.45   // 수평 범위 (더 넓게)
        let verticalRange = (geometry.size.height - 160) * 0.45  // 수직 범위 (크게)
        
        // 0~1 progress를 4단계로 나누어 마름모 형태 구성
        let angle = progress * 4  // 0~4 범위
        
        var x: CGFloat
        var y: CGFloat
        
        if angle <= 1 {
            // 1단계: 중앙 → 위쪽 정점 (0~1)
            let t = angle
            x = centerX
            y = centerY - verticalRange * t
        } else if angle <= 2 {
            // 2단계: 위쪽 정점 → 오른쪽 중앙 (1~2)
            let t = angle - 1
            x = centerX + horizontalRange * t
            y = centerY - verticalRange * (1 - t)
        } else if angle <= 3 {
            // 3단계: 오른쪽 중앙 → 아래쪽 정점 (2~3)
            let t = angle - 2
            x = centerX + horizontalRange * (1 - t)
            y = centerY + verticalRange * t
        } else {
            // 4단계: 아래쪽 정점 → 중앙 (3~4)
            let t = angle - 3
            x = centerX - horizontalRange * t
            y = centerY + verticalRange * (1 - t)
        }
        
        return CGPoint(x: x, y: y)
    }
} 