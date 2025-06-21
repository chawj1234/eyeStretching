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
    
    // 현재 속도 설정을 가져오기 위해 추가
    @EnvironmentObject var manager: EyeStretchingManager
    
    private var adjustedProgress: Double {
        // 속도에 따라 progress 조정 (빠르게 모드에서 더 많은 사이클)
        return progress * manager.animationSpeed.multiplier
    }
    
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
        let angle = adjustedProgress * 2 * .pi
        
        // Universal App 지원: 디바이스별 크기 조정
        let deviceScale = DeviceHelper.animationAreaScale(for: DeviceHelper.currentDevice)
        
        // PatternPath와 동일한 프레임 크기 계산
        let frameWidth = (geometry.size.width - 80) * 0.9 * deviceScale
        let frameHeight = (geometry.size.height - 160) * 0.9 * deviceScale
        
        // 타원의 반지름 (프레임의 절반)
        let radiusX = frameWidth / 2
        let radiusY = frameHeight / 2
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let x = centerX + cos(angle) * radiusX
        let y = centerY + sin(angle) * radiusY
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - 8자형 패턴 (세로 방향, 더 큰 움직임)
    private func figure8Position() -> CGPoint {
        let t = adjustedProgress * 2 * .pi
        
        // Universal App 지원: 디바이스별 크기 조정
        let deviceScale = DeviceHelper.animationAreaScale(for: DeviceHelper.currentDevice)
        
        // PatternPath와 동일한 프레임 크기 계산
        let frameWidth = (geometry.size.width - 80) * 1.6 * deviceScale
        let frameHeight = (geometry.size.height - 160) * 0.9 * deviceScale
        
        // PatternPath와 동일한 반경 계산
        let radiusX = frameWidth * 0.8
        let radiusY = frameHeight * 0.45
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        // 세로 8자를 위한 90도 회전된 Lemniscate of Bernoulli 공식
        let sinT = sin(t)
        let cosT = cos(t)
        let denominator = 1 + sinT * sinT
        
        // PatternPath와 정확히 동일한 계산
        let x = centerX + (radiusX * sinT * cosT) / denominator
        let y = centerY + (radiusY * cosT) / denominator
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - 상하 패턴 (큰 수직 움직임)
    private func verticalPosition() -> CGPoint {
        let centerX = geometry.size.width / 2
        let topMargin: CGFloat = 80
        let bottomMargin: CGFloat = 80
        
        // Universal App 지원: 디바이스별 크기 조정
        let deviceScale = DeviceHelper.animationAreaScale(for: DeviceHelper.currentDevice)
        
        // 사인파를 이용한 부드러운 상하 움직임
        let amplitude = (geometry.size.height - topMargin - bottomMargin) / 2 * deviceScale
        let centerY = geometry.size.height / 2
        
        // 0 -> 1 -> 0 -> -1 -> 0 순서로 움직임 (위 -> 중간 -> 아래 -> 중간 -> 위)
        let angle = adjustedProgress * 4 * .pi  // 2번의 완전한 사이클
        let y = centerY - sin(angle) * amplitude
        
        return CGPoint(x: centerX, y: y)
    }
    
    // MARK: - 마름모 패턴 (세로로 긴 다이아몬드)
    private func diamondPosition() -> CGPoint {
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        // Universal App 지원: 디바이스별 크기 조정
        let deviceScale = DeviceHelper.animationAreaScale(for: DeviceHelper.currentDevice)
        
        // PatternPath와 동일한 프레임 크기 계산
        let frameWidth = (geometry.size.width - 80) * 0.9 * deviceScale
        let frameHeight = (geometry.size.height - 160) * 0.9 * deviceScale
        
        // PatternPath와 동일한 반경 계산
        let horizontalRange = frameWidth * 0.45
        let verticalRange = frameHeight * 0.45
        
        // 위쪽 꼭지점에서 시작하여 시계방향으로 마름모 그리기
        // 빠른 속도에서 adjustedProgress가 1.0을 넘어갈 수 있으므로 4로 나눈 나머지 사용
        let rawAngle = adjustedProgress * 4  // 0~8 범위 가능
        let angle = rawAngle.truncatingRemainder(dividingBy: 4.0)  // 0~4 범위로 제한
        
        var x: CGFloat
        var y: CGFloat
        
        if angle <= 1 {
            // 1단계: 위쪽 정점 → 오른쪽 중앙 (0~1)
            let t = angle
            x = centerX + horizontalRange * t
            y = centerY - verticalRange * (1 - t)
        } else if angle <= 2 {
            // 2단계: 오른쪽 중앙 → 아래쪽 정점 (1~2)
            let t = angle - 1
            x = centerX + horizontalRange * (1 - t)
            y = centerY + verticalRange * t
        } else if angle <= 3 {
            // 3단계: 아래쪽 정점 → 왼쪽 중앙 (2~3)
            let t = angle - 2
            x = centerX - horizontalRange * t
            y = centerY + verticalRange * (1 - t)
        } else {
            // 4단계: 왼쪽 중앙 → 위쪽 정점 (3~4)
            let t = angle - 3
            x = centerX - horizontalRange * (1 - t)
            y = centerY - verticalRange * t
        }
        
        return CGPoint(x: x, y: y)
    }
} 