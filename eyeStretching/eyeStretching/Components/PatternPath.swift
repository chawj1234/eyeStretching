//
//  PatternPath.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import Foundation

// MARK: - Pattern Path Component
struct PatternPath: View {
    let pattern: EyeStretchingManager.StretchingPattern
    let geometry: GeometryProxy
    
    var body: some View {
        switch pattern {
        case .circle:
            CirclePath()
                .stroke(
                    Color.mint.opacity(0.25),
                    style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                )
                .frame(
                    width: (geometry.size.width - 80) * 0.9,  // 더 큰 원형
                    height: (geometry.size.height - 160) * 0.9
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            
        case .figure8:
            Figure8Path()
                .stroke(
                    Color.mint.opacity(0.25),
                    style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                )
                .frame(
                    width: (geometry.size.width - 80) * 0.8,  // 더 큰 8자
                    height: (geometry.size.height - 160) * 0.6
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                
        case .vertical:
            VerticalPath()
                .stroke(
                    Color.mint.opacity(0.25),
                    style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                )
                .frame(
                    width: 40,  // 선의 두께
                    height: geometry.size.height - 160  // 전체 높이 활용
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                
        case .horizontal:
            HorizontalPath()
                .stroke(
                    Color.mint.opacity(0.25),
                    style: StrokeStyle(lineWidth: 3, dash: [10, 5])
                )
                .frame(
                    width: geometry.size.width - 80,  // 전체 너비 활용
                    height: 40  // 선의 두께
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
    }
}

// MARK: - Circle Path Shape
struct CirclePath: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addEllipse(in: rect)
        }
    }
}

// MARK: - Figure 8 Path Shape
struct Figure8Path: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radiusX = rect.width * 0.4  // 더 큰 수평 반경
            let radiusY = rect.height * 0.4  // 더 큰 수직 반경
            
            var isFirst = true
            
            for i in 0...300 {  // 더 부드러운 곡선
                let t = Double(i) / 150.0 * Double.pi * 2
                let denominator = 1 + pow(sin(t), 2)
                
                let x = center.x + CGFloat((Double(radiusX) * cos(t)) / denominator)
                let y = center.y + CGFloat((Double(radiusY) * sin(t) * cos(t)) / denominator)
                
                let point = CGPoint(x: x, y: y)
                
                if isFirst {
                    path.move(to: point)
                    isFirst = false
                } else {
                    path.addLine(to: point)
                }
            }
            
            path.closeSubpath()
        }
    }
}

// MARK: - Vertical Path Shape (상하 패턴)
struct VerticalPath: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let centerX = rect.midX
            let topY = rect.minY + 20
            let bottomY = rect.maxY - 20
            
            // 부드러운 상하 곡선 (사인파)
            var isFirst = true
            
            for i in 0...100 {
                let progress = Double(i) / 100.0
                let angle = progress * 4 * Double.pi  // 2번의 완전한 사이클
                let amplitude = (bottomY - topY) / 2
                let centerY = (topY + bottomY) / 2
                
                let y = centerY - sin(angle) * amplitude
                let point = CGPoint(x: centerX, y: y)
                
                if isFirst {
                    path.move(to: point)
                    isFirst = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
    }
}

// MARK: - Horizontal Path Shape (좌우 패턴)
struct HorizontalPath: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let centerY = rect.midY
            let leftX = rect.minX + 20
            let rightX = rect.maxX - 20
            
            // 부드러운 좌우 곡선 (코사인파)
            var isFirst = true
            
            for i in 0...100 {
                let progress = Double(i) / 100.0
                let angle = progress * 4 * Double.pi  // 2번의 완전한 사이클
                let amplitude = (rightX - leftX) / 2
                let centerX = (leftX + rightX) / 2
                
                let x = centerX + cos(angle) * amplitude
                let point = CGPoint(x: x, y: centerY)
                
                if isFirst {
                    path.move(to: point)
                    isFirst = false
                } else {
                    path.addLine(to: point)
                }
            }
        }
    }
} 