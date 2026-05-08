# Implementation Context: Graph Designer AI (Kùzu Local Version)

## 📋 프로젝트 현재 상태
- **상태**: 초기 설계 및 환경 설정 단계
- **최근 작업**: 
  - 개발 규칙(`.agent/rules/`) 이식 완료
  - 문서 구조(`docs/plan`, `docs/impl`, `docs/tr`) 개편 중
- **주요 목표**: Google ADK Agent와 로컬 Kùzu DB를 결합한 그래프 스키마 자동 설계 및 배포 시스템 구축

## ✅ 구현된 기능 (Implemented Features)
- [x] 프로젝트 초기화 및 Git 브랜치(`local-kuzu-with-rules`) 설정
- [x] 프로젝트 공통 무시 설정(`.geminiignores`) 추가
- [x] 표준 개발 규칙(`.agent/rules/core-directives.md`, `rules.md`) 수립

## 🛠 설계 결정 사항 (Design Decisions)
1. **아키텍처**: Main Agent + 3개의 Sub-Agents (Schema Designer, Kuzu Deployer, Visualizer) 하이브리드 구조.
2. **데이터베이스**: 로컬 임베디드 Kùzu DB 활용 (클라우드 종속성 제거).
3. **문서화**: `docs/` 하위의 목적별 디렉토리 분리 및 `context.md` 기반 상태 관리.

## 📌 현재 컨텍스트 (Current Context)
- 거대 단일 계획서를 모듈화된 계획서들로 분할하는 작업 진행 예정.
- 이후 각 Agent별 상세 구현 및 테스트 단계로 진입할 계획임.
