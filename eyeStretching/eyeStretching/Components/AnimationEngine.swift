//
//  AnimationEngine.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI
import Combine

// MARK: - High Performance Animation Engine
class AnimationEngine: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var isRunning: Bool = false
    
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    private var duration: Double = 0
    private var completion: (() -> Void)?
    
    func startAnimation(duration: Double, completion: @escaping () -> Void) {
        // 메인 스레드에서 실행 보장
        if Thread.isMainThread {
            performStartAnimation(duration: duration, completion: completion)
        } else {
            DispatchQueue.main.async {
                self.performStartAnimation(duration: duration, completion: completion)
            }
        }
    }
    
    func resumeAnimation(from currentProgress: Double, duration: Double, completion: @escaping () -> Void) {
        // 메인 스레드에서 실행 보장
        if Thread.isMainThread {
            performResumeAnimation(from: currentProgress, duration: duration, completion: completion)
        } else {
            DispatchQueue.main.async {
                self.performResumeAnimation(from: currentProgress, duration: duration, completion: completion)
            }
        }
    }
    
    private func performStartAnimation(duration: Double, completion: @escaping () -> Void) {
        stopAnimation()
        
        self.duration = duration
        self.completion = completion
        self.startTime = CACurrentMediaTime()
        self.progress = 0.0
        self.isRunning = true
        
        // CADisplayLink for 60fps animation
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func performResumeAnimation(from currentProgress: Double, duration: Double, completion: @escaping () -> Void) {
        stopAnimation()
        
        self.duration = duration
        self.completion = completion
        self.startTime = CACurrentMediaTime() - (currentProgress * duration) // 현재 진행률 반영
        self.progress = currentProgress
        self.isRunning = true
        
        // CADisplayLink for 60fps animation
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimation() {
        displayLink?.invalidate()
        displayLink = nil
        isRunning = false
    }
    
    @objc private func updateAnimation() {
        let elapsed = CACurrentMediaTime() - startTime
        let newProgress = min(elapsed / duration, 1.0)
        
        progress = newProgress
        
        if newProgress >= 1.0 {
            stopAnimation()
            completion?()
        }
    }
    
    deinit {
        stopAnimation()
    }
} 