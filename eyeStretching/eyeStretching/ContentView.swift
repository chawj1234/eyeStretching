//
//  ContentView.swift
//  eyeStretching
//
//  Created by 차원준 on 6/18/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var eyeStretchingManager = EyeStretchingManager()
    
    var body: some View {
        NavigationView {
            switch eyeStretchingManager.currentState {
            case .menu:
                MainMenuView(manager: eyeStretchingManager)
            case .preparing:
                PreparationView(manager: eyeStretchingManager)
            case .stretching:
                StretchingView(manager: eyeStretchingManager)
            case .completed:
                CompletionView(manager: eyeStretchingManager)
            case .calibration:
                CalibrationView(manager: eyeStretchingManager)
            }
        }
        .preferredColorScheme(.light)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Eye Stretching Manager
class EyeStretchingManager: ObservableObject {
    @Published var currentState: AppState = .menu
    @Published var currentStep: Int = 0
    @Published var isEyeTrackingEnabled: Bool = false
    @Published var stretchingProgress: Double = 0.0
    @Published var totalSteps: Int = 8
    @Published var completedSessions: Int = UserDefaults.standard.integer(forKey: "completedSessions")
    @Published var showCalibrationHelper: Bool = false
    @Published var calibrationMode: Bool = false
    @Published var eyeTrackingAccuracy: Double = 1.0 // 1.0 = 완벽, 0.0 = 매우 부정확
    
    let stretchingSteps: [StretchingStep] = [
        StretchingStep(title: "위쪽 시선", description: "원을 따라 위를 바라보세요", position: .top),
        StretchingStep(title: "오른쪽 위", description: "원을 따라 오른쪽 위를 바라보세요", position: .topTrailing),
        StretchingStep(title: "오른쪽", description: "원을 따라 오른쪽을 바라보세요", position: .trailing),
        StretchingStep(title: "오른쪽 아래", description: "원을 따라 오른쪽 아래를 바라보세요", position: .bottomTrailing),
        StretchingStep(title: "아래쪽", description: "원을 따라 아래를 바라보세요", position: .bottom),
        StretchingStep(title: "왼쪽 아래", description: "원을 따라 왼쪽 아래를 바라보세요", position: .bottomLeading),
        StretchingStep(title: "왼쪽", description: "원을 따라 왼쪽을 바라보세요", position: .leading),
        StretchingStep(title: "왼쪽 위", description: "원을 따라 왼쪽 위를 바라보세요", position: .topLeading)
    ]
    
    func startStretching() {
        currentState = .preparing
        currentStep = 0
        stretchingProgress = 0.0
    }
    
    func beginStretching() {
        currentState = .stretching
    }
    
    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
            stretchingProgress = Double(currentStep) / Double(totalSteps)
        } else {
            completeStretching()
        }
    }
    
    func completeStretching() {
        currentState = .completed
        completedSessions += 1
        UserDefaults.standard.set(completedSessions, forKey: "completedSessions")
    }
    
    func returnToMenu() {
        currentState = .menu
        currentStep = 0
        stretchingProgress = 0.0
        calibrationMode = false
        showCalibrationHelper = false
    }
    
    func startCalibration() {
        calibrationMode = true
        showCalibrationHelper = true
    }
    
    func completeCalibration() {
        calibrationMode = false
        showCalibrationHelper = false
        eyeTrackingAccuracy = 1.0
        
        // 햅틱 피드백
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    func checkEyeTrackingAccuracy() {
        // 눈 추적 정확도 체크 (시뮬레이션)
        // 실제로는 사용자 상호작용 패턴을 분석할 수 있음
        eyeTrackingAccuracy = Double.random(in: 0.6...1.0)
    }
}

// MARK: - App States
enum AppState {
    case menu
    case preparing
    case stretching
    case completed
    case calibration
}

// MARK: - Stretching Step Model
struct StretchingStep {
    let title: String
    let description: String
    let position: Alignment
}

// MARK: - Main Menu View
struct MainMenuView: View {
    @ObservedObject var manager: EyeStretchingManager
    
    private var accuracyColor: Color {
        if manager.eyeTrackingAccuracy >= 0.9 {
            return .green
        } else if manager.eyeTrackingAccuracy >= 0.7 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var accuracyText: String {
        if manager.eyeTrackingAccuracy >= 0.9 {
            return "우수"
        } else if manager.eyeTrackingAccuracy >= 0.7 {
            return "보통"
        } else {
            return "재보정 필요"
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            // 앱 헤더
            VStack(spacing: 16) {
                Image(systemName: "eye.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .accessibilityHidden(true)
                
                Text("눈 스트레칭")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                
                Text("눈 추적으로 건강한 시력 관리")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // 통계 및 상태 카드
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("완료한 세션")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(manager.completedSessions)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("권장 횟수")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("하루 3-5회")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                .padding(20)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                
                // 눈 추적 정확도 상태
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "eye.circle")
                                .foregroundColor(accuracyColor)
                            Text("눈 추적 정확도")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(Int(manager.eyeTrackingAccuracy * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(accuracyColor)
                            
                            Text(accuracyText)
                                .font(.caption)
                                .foregroundColor(accuracyColor)
                        }
                    }
                    
                    Spacer()
                    
                    // 재보정 버튼
                    Button(action: {
                        manager.currentState = .calibration
                    }) {
                        HStack {
                            Image(systemName: "target")
                                .font(.caption)
                            Text("재보정")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .accessibilityLabel("눈 추적 재보정")
                    .accessibilityHint("눈 추적 포인터의 정확도를 다시 조정합니다")
                }
                .padding(20)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
            }
            
            // 시작 버튼
            Button(action: {
                manager.startStretching()
            }) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    Text("스트레칭 시작")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .accessibilityLabel("눈 스트레칭 시작하기")
            .accessibilityHint("눈 추적을 사용한 스트레칭 세션을 시작합니다")
            
            // 설정 안내
            VStack(spacing: 12) {
                Text("눈 추적 사용법")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.blue)
                        Text("설정 > 손쉬운 사용 > 눈 추적 활성화")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.blue)
                        Text("기기를 1.5피트 거리에 고정하여 배치")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.blue)
                        Text("움직이는 원을 눈으로 따라가기")
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(20)
        .navigationBarHidden(true)
        .onAppear {
            // 정확도 체크
            manager.checkEyeTrackingAccuracy()
        }
    }
}

// MARK: - Preparation View
struct PreparationView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var countdown = 3
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "eye.trianglebadge.exclamationmark")
                .font(.system(size: 80))
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            
            Text("준비하세요")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Text("눈 추적이 활성화되었는지 확인하고\n편안한 자세를 취하세요")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            // 카운트다운
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(4 - countdown) / 3)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: countdown)
                
                Text("\(countdown)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("시작까지 \(countdown)초")
            
            Spacer()
        }
        .padding(20)
        .navigationBarHidden(true)
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer?.invalidate()
                manager.beginStretching()
            }
        }
    }
}

// MARK: - Stretching View
struct StretchingView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var circleScale: CGFloat = 1.0
    @State private var dwellProgress: Double = 0.0
    @State private var dwellTimer: Timer?
    @State private var isCircleSelected = false
    @State private var isHovering = false
    @State private var showCheckmark = false
    @State private var circlePosition: CGPoint = .zero
    @State private var animationPaused = false
    
    private let dwellDuration: Double = 2.0 // 2초 응시 시간
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // 핫코너 (좌상단) - 재보정 트리거
                    HotCornerView(manager: manager)
                    
                    // 상단 진행률 표시
                    VStack(spacing: 12) {
                        HStack {
                            Text("단계 \(manager.currentStep + 1)/\(manager.totalSteps)")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(Int(manager.stretchingProgress * 100))%")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        
                        ProgressView(value: manager.stretchingProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // 현재 스트레칭 지시사항
                    VStack(spacing: 16) {
                        Text(manager.stretchingSteps[manager.currentStep].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .accessibilityAddTraits(.isHeader)
                        
                        Text(manager.stretchingSteps[manager.currentStep].description)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                                         // 스트레칭 영역
                    GeometryReader { stretchGeometry in
                        ZStack {
                            // 이전 단계들의 흐릿한 위치 표시 (가이드)
                            ForEach(0..<manager.currentStep, id: \.self) { stepIndex in
                                GuideCircle(
                                    position: manager.stretchingSteps[stepIndex].position,
                                    geometry: stretchGeometry,
                                    completed: true
                                )
                            }
                            
                            // 현재 활성 원
                            AdvancedStretchingCircle(
                                dwellProgress: dwellProgress,
                                scale: circleScale,
                                isSelected: isCircleSelected,
                                isHovering: isHovering,
                                showCheckmark: showCheckmark,
                                animationPaused: animationPaused,
                                position: manager.stretchingSteps[manager.currentStep].position,
                                geometry: stretchGeometry,
                                onHoverStart: {
                                    startHovering()
                                },
                                onHoverEnd: {
                                    endHovering()
                                },
                                onDwellStart: {
                                    startDwelling()
                                }
                            )
                            
                            // 다음 단계들의 미리보기 (가이드)
                            ForEach((manager.currentStep + 1)..<manager.totalSteps, id: \.self) { stepIndex in
                                GuideCircle(
                                    position: manager.stretchingSteps[stepIndex].position,
                                    geometry: stretchGeometry,
                                    completed: false
                                )
                            }
                        }
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startCircleAnimation()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(manager.stretchingSteps[manager.currentStep].title). \(manager.stretchingSteps[manager.currentStep].description)")
        .accessibilityHint("원을 2초간 응시하여 다음 단계로 진행하세요")
    }
    
    private func startCircleAnimation() {
        guard !animationPaused else { return }
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            circleScale = isHovering ? 1.1 : 1.2
        }
    }
    
    private func startHovering() {
        guard !isCircleSelected else { return }
        
        isHovering = true
        animationPaused = true
        
        // 애니메이션 일시 정지 및 호버 효과
        withAnimation(.easeInOut(duration: 0.3)) {
            circleScale = 1.15
        }
        
        // 햅틱 피드백 (호버 시작)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func endHovering() {
        guard !isCircleSelected else { return }
        
        isHovering = false
        animationPaused = false
        dwellProgress = 0.0
        dwellTimer?.invalidate()
        
        // 애니메이션 재시작
        startCircleAnimation()
    }
    
    private func startDwelling() {
        guard !isCircleSelected && isHovering else { return }
        
        isCircleSelected = true
        dwellProgress = 0
        
        dwellTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            dwellProgress += 0.05 / dwellDuration
            
            if dwellProgress >= 1.0 {
                timer.invalidate()
                completeStep()
            }
        }
    }
    
    private func completeStep() {
        dwellTimer?.invalidate()
        
        // 체크마크 표시
        showCheckmark = true
        
        // 성공 햅틱 피드백
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            circleScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // 다음 단계로 전환
            withAnimation(.easeInOut(duration: 0.5)) {
                showCheckmark = false
                dwellProgress = 0
                isCircleSelected = false
                isHovering = false
                animationPaused = false
                circleScale = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                manager.nextStep()
            }
        }
    }
}

// MARK: - Advanced Stretching Circle Component
struct AdvancedStretchingCircle: View {
    let dwellProgress: Double
    let scale: CGFloat
    let isSelected: Bool
    let isHovering: Bool
    let showCheckmark: Bool
    let animationPaused: Bool
    let position: Alignment
    let geometry: GeometryProxy
    let onHoverStart: () -> Void
    let onHoverEnd: () -> Void
    let onDwellStart: () -> Void
    
    @State private var hoverTimer: Timer?
    @State private var eyeTrackingDetected = false
    
    var circlePosition: (x: CGFloat, y: CGFloat) {
        let width = geometry.size.width
        let height = geometry.size.height
        let padding: CGFloat = 60
        
        switch position {
        case .top:
            return (width / 2, padding)
        case .topTrailing:
            return (width - padding, padding)
        case .trailing:
            return (width - padding, height / 2)
        case .bottomTrailing:
            return (width - padding, height - padding)
        case .bottom:
            return (width / 2, height - padding)
        case .bottomLeading:
            return (padding, height - padding)
        case .leading:
            return (padding, height / 2)
        case .topLeading:
            return (padding, padding)
        default:
            return (width / 2, height / 2)
        }
    }
    
    var body: some View {
        ZStack {
            // 외부 진행률 링 (더 큰 타겟 영역)
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: dwellProgress)
                .stroke(
                    LinearGradient(
                        colors: [.blue, .green],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.05), value: dwellProgress)
            
            // 메인 원
            Circle()
                .fill(
                    RadialGradient(
                        colors: circleColors,
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 50
                    )
                )
                .frame(width: 70, height: 70)
                .scaleEffect(scale)
                .shadow(
                    color: shadowColor,
                    radius: isHovering ? 15 : 8,
                    x: 0,
                    y: isHovering ? 8 : 5
                )
                .overlay(
                    // 호버 링 효과
                    Circle()
                        .stroke(
                            Color.white.opacity(isHovering ? 0.6 : 0),
                            lineWidth: 3
                        )
                        .scaleEffect(isHovering ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isHovering)
                )
            
            // 중앙 아이콘 또는 체크마크
            if showCheckmark {
                Image(systemName: "checkmark")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(1.2)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: isSelected ? "eye.circle" : "eye.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .scaleEffect(scale * 0.8)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            
            // 눈 추적 포인터 감지 영역 (투명한 큰 영역)
            Circle()
                .fill(Color.clear)
                .frame(width: 120, height: 120)
                .contentShape(Circle())
                .onTapGesture {
                    // 터치 지원 (눈 추적이 없을 때)
                    if !isSelected && !showCheckmark {
                        onHoverStart()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onDwellStart()
                        }
                    }
                }
                .onHover { hovering in
                    // 눈 추적 호버 감지
                    if hovering && !isSelected && !showCheckmark {
                        onHoverStart()
                        
                        // 자동으로 Dwell 시작 (눈 추적 시)
                        hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                            if isHovering && !isSelected {
                                onDwellStart()
                            }
                        }
                    } else if !hovering {
                        hoverTimer?.invalidate()
                        if !isSelected {
                            onHoverEnd()
                        }
                    }
                }
        }
        .position(x: circlePosition.x, y: circlePosition.y)
        .accessibilityElement()
        .accessibilityLabel("스트레칭 원")
        .accessibilityValue("진행률 \(Int(dwellProgress * 100))퍼센트")
        .accessibilityAddTraits(isHovering ? .isSelected : [])
    }
    
    private var circleColors: [Color] {
        if showCheckmark {
            return [.green, .blue]
        } else if isSelected {
            return [.blue, .purple]
        } else if isHovering {
            return [.cyan, .blue]
        } else {
            return [.blue, .purple]
        }
    }
    
    private var shadowColor: Color {
        if showCheckmark {
            return .green.opacity(0.4)
        } else if isHovering {
            return .cyan.opacity(0.4)
        } else {
            return .blue.opacity(0.3)
        }
    }
}

// MARK: - Guide Circle Component
struct GuideCircle: View {
    let position: Alignment
    let geometry: GeometryProxy
    let completed: Bool
    
    var circlePosition: (x: CGFloat, y: CGFloat) {
        let width = geometry.size.width
        let height = geometry.size.height
        let padding: CGFloat = 60
        
        switch position {
        case .top:
            return (width / 2, padding)
        case .topTrailing:
            return (width - padding, padding)
        case .trailing:
            return (width - padding, height / 2)
        case .bottomTrailing:
            return (width - padding, height - padding)
        case .bottom:
            return (width / 2, height - padding)
        case .bottomLeading:
            return (padding, height - padding)
        case .leading:
            return (padding, height / 2)
        case .topLeading:
            return (padding, padding)
        default:
            return (width / 2, height / 2)
        }
    }
    
    var body: some View {
        Circle()
            .fill(
                completed ? 
                Color.green.opacity(0.3) : 
                Color.gray.opacity(0.2)
            )
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(
                        completed ? 
                        Color.green.opacity(0.6) : 
                        Color.gray.opacity(0.4), 
                        lineWidth: 2
                    )
            )
            .overlay(
                // 완료된 단계에 체크마크
                completed ? 
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.green)
                : nil
            )
            .position(x: circlePosition.x, y: circlePosition.y)
            .animation(.easeInOut(duration: 0.5), value: completed)
    }
}

// MARK: - Hot Corner View
struct HotCornerView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var isHovering = false
    @State private var hoverProgress: Double = 0.0
    @State private var hoverTimer: Timer?
    
    private let hoverDuration: Double = 3.0 // 3초 응시로 재보정 트리거
    
    var body: some View {
        HStack {
            // 좌상단 핫코너
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: isHovering ? [.blue.opacity(0.3), .purple.opacity(0.3)] : [.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color.blue.opacity(isHovering ? 0.6 : 0.2),
                                lineWidth: 2
                            )
                    )
                
                // 진행률 표시
                if isHovering {
                    Circle()
                        .trim(from: 0, to: hoverProgress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: hoverProgress)
                }
                
                Image(systemName: "target")
                    .font(.system(size: 16))
                    .foregroundColor(isHovering ? .blue : .gray.opacity(0.6))
                    .scaleEffect(isHovering ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
            }
            .onHover { hovering in
                if hovering && !manager.calibrationMode {
                    startHotCornerHover()
                } else {
                    endHotCornerHover()
                }
            }
            .onTapGesture {
                // 터치 지원
                if !manager.calibrationMode {
                    triggerCalibration()
                }
            }
            
            Spacer()
        }
        .accessibilityElement()
        .accessibilityLabel("재보정 핫코너")
        .accessibilityHint("3초간 응시하면 눈 추적 재보정이 시작됩니다")
    }
    
    private func startHotCornerHover() {
        isHovering = true
        hoverProgress = 0
        
        // 햅틱 피드백
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            hoverProgress += 0.1 / hoverDuration
            
            if hoverProgress >= 1.0 {
                timer.invalidate()
                triggerCalibration()
            }
        }
    }
    
    private func endHotCornerHover() {
        isHovering = false
        hoverProgress = 0
        hoverTimer?.invalidate()
    }
    
    private func triggerCalibration() {
        hoverTimer?.invalidate()
        endHotCornerHover()
        
        // 재보정 모드로 전환
        withAnimation(.easeInOut(duration: 0.5)) {
            manager.currentState = .calibration
        }
    }
}

// MARK: - Calibration View
struct CalibrationView: View {
    @ObservedObject var manager: EyeStretchingManager
    @State private var currentStep: Int = 0
    @State private var calibrationProgress: Double = 0.0
    @State private var isCompleted = false
    
    private let calibrationPoints: [(x: CGFloat, y: CGFloat, name: String)] = [
        (0.1, 0.1, "좌상단"),
        (0.9, 0.1, "우상단"),
        (0.9, 0.9, "우하단"),
        (0.1, 0.9, "좌하단"),
        (0.5, 0.5, "중앙")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // 헤더
                    VStack(spacing: 16) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                            .accessibilityHidden(true)
                        
                        Text("눈 추적 재보정")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .accessibilityAddTraits(.isHeader)
                        
                        if !isCompleted {
                            Text("화면의 \(calibrationPoints[currentStep].name) 원을 2초간 응시하세요")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        } else {
                            Text("재보정이 완료되었습니다!")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.green)
                        }
                    }
                    
                    // 진행률 표시
                    if !isCompleted {
                        VStack(spacing: 12) {
                            HStack {
                                Text("단계 \(currentStep + 1)/\(calibrationPoints.count)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(Int(calibrationProgress * 100))%")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                            }
                            
                            ProgressView(value: calibrationProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                                .scaleEffect(y: 2)
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
                
                // 재보정 포인트들
                if !isCompleted {
                    ForEach(0..<calibrationPoints.count, id: \.self) { index in
                        let point = calibrationPoints[index]
                        let isCurrentPoint = index == currentStep
                        
                        CalibrationPoint(
                            isActive: isCurrentPoint,
                            isCompleted: index < currentStep,
                            geometry: geometry,
                            position: (point.x, point.y),
                            onComplete: {
                                completeCurrentStep()
                            }
                        )
                    }
                } else {
                    // 완료 화면
                    VStack(spacing: 30) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                        }
                        
                        Text("재보정 완료!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Button(action: {
                            manager.completeCalibration()
                            manager.returnToMenu()
                        }) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.title2)
                                Text("완료")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        .accessibilityLabel("재보정 완료하고 메뉴로 돌아가기")
                        
                        Spacer()
                    }
                }
                
                // 취소 버튼
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            manager.returnToMenu()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                        .accessibilityLabel("재보정 취소")
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            currentStep = 0
            calibrationProgress = 0.0
            isCompleted = false
        }
    }
    
    private func completeCurrentStep() {
        if currentStep < calibrationPoints.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep += 1
                calibrationProgress = Double(currentStep) / Double(calibrationPoints.count)
            }
        } else {
            // 모든 단계 완료
            withAnimation(.easeInOut(duration: 0.5)) {
                calibrationProgress = 1.0
                isCompleted = true
            }
        }
    }
}

// MARK: - Calibration Point Component
struct CalibrationPoint: View {
    let isActive: Bool
    let isCompleted: Bool
    let geometry: GeometryProxy
    let position: (x: CGFloat, y: CGFloat)
    let onComplete: () -> Void
    
    @State private var dwellProgress: Double = 0.0
    @State private var dwellTimer: Timer?
    @State private var isHovering = false
    
    private let dwellDuration: Double = 2.0
    
    var body: some View {
        ZStack {
            // 외부 링
            Circle()
                .stroke(
                    isCompleted ? Color.green.opacity(0.6) : 
                    isActive ? Color.purple.opacity(0.3) : Color.gray.opacity(0.2),
                    lineWidth: isActive ? 6 : 3
                )
                .frame(width: isActive ? 80 : 40, height: isActive ? 80 : 40)
            
            // 진행률 링 (활성 상태일 때만)
            if isActive {
                Circle()
                    .trim(from: 0, to: dwellProgress)
                    .stroke(Color.purple, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: dwellProgress)
            }
            
            // 중앙 원
            Circle()
                .fill(
                    isCompleted ? Color.green :
                    isActive ? (isHovering ? Color.purple : Color.purple.opacity(0.7)) : Color.gray.opacity(0.4)
                )
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .scaleEffect(isHovering && isActive ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovering)
            
            // 아이콘
            Image(systemName: isCompleted ? "checkmark" : (isActive ? "eye" : "circle"))
                .font(.system(size: isActive ? 20 : 12))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .position(
            x: geometry.size.width * position.x,
            y: geometry.size.height * position.y
        )
        .onHover { hovering in
            if isActive && hovering {
                startDwelling()
            } else if !hovering {
                endDwelling()
            }
        }
        .onTapGesture {
            if isActive {
                startDwelling()
            }
        }
        .accessibilityElement()
        .accessibilityLabel(isCompleted ? "완료된 포인트" : (isActive ? "현재 활성 포인트" : "비활성 포인트"))
        .accessibilityValue(isActive ? "진행률 \(Int(dwellProgress * 100))퍼센트" : "")
    }
    
    private func startDwelling() {
        guard isActive && dwellTimer == nil else { return }
        
        isHovering = true
        dwellProgress = 0
        
        // 햅틱 피드백
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        dwellTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            dwellProgress += 0.05 / dwellDuration
            
            if dwellProgress >= 1.0 {
                timer.invalidate()
                completePoint()
            }
        }
    }
    
    private func endDwelling() {
        isHovering = false
        dwellProgress = 0
        dwellTimer?.invalidate()
        dwellTimer = nil
    }
    
    private func completePoint() {
        dwellTimer?.invalidate()
        dwellTimer = nil
        
        // 성공 햅틱 피드백
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        
        onComplete()
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @ObservedObject var manager: EyeStretchingManager
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // 완료 애니메이션
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            .scaleEffect(1.0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    // 완료 애니메이션
                }
            }
            
            VStack(spacing: 16) {
                Text("수고하셨습니다!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                
                Text("눈 스트레칭이 완료되었습니다")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("총 \(manager.completedSessions)회 완료")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            // 건강 팁
            VStack(spacing: 12) {
                Text("💡 건강한 눈을 위한 팁")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• 20-20-20 규칙: 20분마다 20피트 거리를 20초간 바라보기")
                    Text("• 충분한 조명에서 작업하기")
                    Text("• 규칙적인 눈 깜빡임으로 촉촉함 유지")
                    Text("• 하루 3-5회 눈 스트레칭 실시")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding(20)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // 완료 버튼
            Button(action: {
                manager.returnToMenu()
            }) {
                HStack {
                    Image(systemName: "house.fill")
                        .font(.title2)
                    Text("홈으로 돌아가기")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .accessibilityLabel("메인 메뉴로 돌아가기")
            
            Spacer()
        }
        .padding(20)
        .navigationBarHidden(true)
        .onAppear {
            // 완료 시 햅틱 피드백
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
    }
}

#Preview {
    ContentView()
}

