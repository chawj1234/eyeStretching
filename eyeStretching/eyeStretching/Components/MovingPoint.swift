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
        let center = CGPoint(
            x: geometry.size.width / 2,
            y: geometry.size.height / 2
        )
        
        let radius = min(geometry.size.width, geometry.size.height) * 0.25
        let angle = progress * 2 * .pi
        
        switch pattern {
        case .circle:
            return CGPoint(
                x: center.x + radius * CGFloat(cos(Double(angle))),
                y: center.y + radius * CGFloat(sin(Double(angle)))
            )
            
        case .figure8:
            // Lemniscate (8자) 곡선 공식
            let t = Double(angle)
            let a = Double(radius * 0.8)
            let denominator = 1 + pow(sin(t), 2)
            
            return CGPoint(
                x: center.x + CGFloat((a * cos(t)) / denominator),
                y: center.y + CGFloat((a * sin(t) * cos(t)) / denominator)
            )
        }
    }
} 