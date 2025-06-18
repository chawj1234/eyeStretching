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
                    Color.mint.opacity(0.2),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .frame(
                    width: min(geometry.size.width, geometry.size.height) * 0.5,
                    height: min(geometry.size.width, geometry.size.height) * 0.5
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            
        case .figure8:
            Figure8Path()
                .stroke(
                    Color.mint.opacity(0.2),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .frame(
                    width: min(geometry.size.width, geometry.size.height) * 0.5,
                    height: min(geometry.size.width, geometry.size.height) * 0.3
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
            let radius = min(rect.width, rect.height) * 0.4
            
            var isFirst = true
            
            for i in 0...200 {
                let t = Double(i) / 100.0 * Double.pi * 2
                let denominator = 1 + pow(sin(t), 2)
                
                let x = center.x + CGFloat((Double(radius) * cos(t)) / denominator)
                let y = center.y + CGFloat((Double(radius) * sin(t) * cos(t)) / denominator)
                
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