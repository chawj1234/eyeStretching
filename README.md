# 👁️ Eysee - 스마트 눈 스트레칭 앱

> **Eye + See = Eysee** - 차세대 눈 건강 관리 솔루션

Eysee는 핸즈프리로 눈 스트레칭을 제공하는 혁신적인 건강 앱입니다. 화면 속 움직이는 포인트를 따라가며 자연스럽고 효과적인 눈 근육 운동을 경험하세요.

![iOS](https://img.shields.io/badge/iOS-15.0+-blue) ![Swift](https://img.shields.io/badge/Swift-5.0+-orange) ![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green) ![License](https://img.shields.io/badge/License-MIT-lightgrey)

## ✨ 주요 기능

### 🎯 **4가지 과학적 스트레칭 패턴**
- **🔄 원형 패턴**: 360도 회전 운동으로 모든 방향 눈근육 강화
- **♾️ 세로 8자 패턴**: Lemniscate 곡선을 따라 복합적 눈 움직임
- **⬆️ 상하 패턴**: 직선 수직 운동으로 상하 근육 집중 스트레칭  
- **💎 마름모 패턴**: 대각선 복합 운동으로 정밀한 근육 조절

### ⚡ **2단계 속도 시스템**
- **보통 속도** (35초): 일상적인 빠른 스트레칭
- **빠른 속도** (18초): 초고속 집중 운동

### 🎨 **직관적 사용자 경험**
- **패턴 전환 애니메이션**: 체크마크와 함께 자연스러운 전환
- **실시간 진행률**: 부드러운 프로그레스 바로 현재 상태 표시
- **햅틱 피드백**: 완료 시 진동으로 즉각적 반응
- **간소화된 UI**: 운동에 집중할 수 있는 미니멀 디자인

### 📊 **스마트 데이터 관리**
- **세션 완료 추적**: 운동 횟수 자동 기록
- **최근 활동 표시**: 오늘 운동 여부 확인
- **영구 데이터 저장**: UserDefaults 기반 안전한 데이터 보관

## 🎮 사용법

### 1️⃣ **앱 시작하기**
1. 앱을 실행하고 메인 화면에서 **"시작하기"** 버튼 터치
2. 3초 카운트다운으로 준비 시간 확보
3. 편안한 자세로 화면을 정면으로 바라보기

### 2️⃣ **스트레칭 패턴 따라가기**
1. **8자형 패턴** (20초) → 세로 무한대 모양 추적
2. **원형 패턴** (20초) → 큰 원을 그리며 회전 운동  
3. **상하형 패턴** (20초) → 위아래 직선 움직임
4. **마름모형 패턴** (20초) → 다이아몬드 경로 추적

### 3️⃣ **실시간 컨트롤**
- **속도 조절**: 우상단 속도 버튼으로 언제든 변경
- **운동 종료**: X 버튼으로 즉시 종료 가능
- **진행 확인**: 하단 프로그레스 바로 실시간 진행률 체크

### 4️⃣ **완료 및 통계**
1. 모든 패턴 완료 시 "수고하셨습니다!" 메시지
2. 완료 세션 자동 카운트 및 저장

## 🏥 기대 효과

### 👁️ **눈 건강 개선**
- **안구건조증 완화**: 규칙적인 눈 운동으로 눈물샘 자극
- **눈의피로 감소**: 장시간 근거리 작업 후 근육 이완
- **시력 보호**: 조절근과 외안근 강화로 시력 유지
- **혈액순환 촉진**: 눈 주변 혈관 순환 개선

### 🧠 **인지 기능 향상**
- **집중력 증진**: 목표 추적을 통한 주의력 훈련
- **시각-운동 협응**: 눈과 뇌의 협응 능력 강화
- **반응속도 개선**: 빠른 시각 정보 처리 능력 향상

## 🛠️ 기술적 특징

### 📱 **개발 환경**
- **플랫폼**: iOS 15.0+ (iPhone, iPad)
- **언어**: Swift 5.0+
- **프레임워크**: SwiftUI 3.0+
- **아키텍처**: MVVM + ObservableObject

### ⚙️ **핵심 구성요소**
```
📁 Eysee/
├── 📁 Views/
│   ├── 🎯 EyeStretchingManager.swift    # 앱 상태 및 데이터 관리
│   ├── 🏠 MenuView.swift                # 메인 화면 및 통계
│   ├── ⏰ CountdownView.swift            # 시작 카운트다운
│   ├── 🏃 StretchingView.swift          # 메인 운동 화면
│   └── 🎉 CompletionView.swift          # 완료 축하 화면
├── 📁 Components/
│   ├── 🎨 AnimationEngine.swift         # 60fps 고성능 애니메이션
│   ├── 🔵 MovingPoint.swift            # 움직이는 포인트 렌더링
│   └── 📐 PatternPath.swift             # 수학적 경로 계산
└── 📁 Assets/
    └── 🎨 AppIcon & Colors              # 앱 아이콘 및 컬러 팔레트
```

### 🔬 **고급 애니메이션 기술**
- **CADisplayLink**: 60fps 네이티브 애니메이션 엔진
- **수학적 경로**: Lemniscate, 타원, 사인파 기반 정밀 계산
- **Seamless 속도 전환**: 현재 위치 보존하며 속도만 변경
- **Spring Animation**: 자연스러운 UI 전환 효과

## 💡 건강 가이드

### 📋 **권장 사용법**
- **빈도**: 하루 3-5회 (2-3시간 간격)
- **타이밍**: 컴퓨터/스마트폰 장기간 사용 시
- **환경**: 충분한 조명, 편안한 자세
- **거리**: 화면에서 30-60cm 거리 유지


Eysee는 이 규칙을 실천할 수 있는 완벽한 도구입니다:
- 20초 운동으로 규칙 준수
- 먼 거리 응시 효과와 유사한 근육 이완

### ⚠️ **주의사항**
- 어지러움이나 불편함 발생 시 즉시 중단
- 눈 질환이 있는 경우 의사와 상담 후 사용
- 과도한 사용보다는 꾸준한 사용이 중요
- 충분한 수면과 영양 섭취 병행

## 🔧 설치 및 실행

### 📋 **시스템 요구사항**
- **iOS**: 15.0 이상
- **기기**: iPhone 7 이상, iPad (6세대) 이상
- **Xcode**: 14.0 이상 (개발 시)
- **Swift**: 5.0 이상

### 🚀 **설치 방법**
```bash
# 1. 저장소 클론
git clone https://github.com/your-repo/Eysee.git
cd Eysee

# 2. Xcode에서 프로젝트 열기
open Eysee/Eysee.xcodeproj

# 3. 타겟 기기 선택 후 빌드 및 실행
⌘ + R
```

### 📱 **지원 기기**
- **iPhone**: 모든 크기 (SE, 12 mini ~ 15 Pro Max)
- **iPad**: 모든 세대 (Air, Pro, mini 포함)
- **방향**: 세로 모드 최적화 (가로 모드 지원)
- **해상도**: 자동 적응형 레이아웃

## 🎯 향후 계획

### 🔮 **단기 계획 (1-3개월)**
- [ ] **Apple Health 연동**: 운동 데이터 헬스앱 동기화
- [ ] **알림 시스템**: 정기적 눈 운동 리마인더
- [ ] **다크 모드**: 야간 사용을 위한 어두운 테마
- [ ] **접근성 강화**: 손쉬운 사용-눈 추적 기능 지원

### 🚀 **중기 계획 (3-6개월)**
- [ ] **개인화 루틴**: 사용자별 맞춤 운동 패턴
- [ ] **통계 대시보드**: 주간/월간 운동 분석
- [ ] **목표 설정**: 일일/주간 운동 목표 및 달성률
- [ ] **소셜 기능**: 가족/친구와 운동 기록 공유

### 🌟 **장기 계획 (6개월+)**
- [ ] **AI 추천 시스템**: 사용 패턴 기반 맞춤 스케줄
- [ ] **전문가 콘텐츠**: 안과 의사 협력 건강 가이드
- [ ] **다국어 지원**: 전 세계 사용자를 위한 현지화
- [ ] **웨어러블 연동**: Apple Watch 진동 알림 지원

## 🤝 기여하기

### 🐛 **버그 리포트**
발견된 문제는 [Issues](https://github.com/your-repo/Eysee/issues)에 등록해 주세요.

### 💡 **기능 제안**
새로운 아이디어나 개선사항을 언제든 제안해 주세요.

### 👨‍💻 **개발 참여**
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이센스

이 프로젝트는 **MIT 라이센스** 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

```
MIT License

Copyright (c) 2024 Eysee Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 🙏 감사인사

- **Go&Finn**: 앱 배포에 많은 아이디어와 도움과 조언

---

<div align="center">

## 👁️ **건강한 눈, 밝은 미래**

**Eysee와 함께 디지털 시대의 눈 건강을 지켜보세요!**

[![Download on the App Store](https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg)](https://apps.apple.com/app/eysee)

*"당신의 눈이 보는 모든 순간을 더욱 선명하게"* ✨

</div>

---

> 📧 **문의사항**: [chawj1234@gmail.com]](mailto:chawj1234@gmail.com)  
> 📱 **LinkedIn**: [차원준](www.linkedin.com/in/wonjuncha

)
