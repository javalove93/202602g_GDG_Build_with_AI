# 개발 규칙 이식 및 문서 구조 개편 계획서

## 1. Objective (목적)
기존 `gemini-cli-wrapper` 프로젝트의 우수한 에이전트 개발 규칙(Rules)을 현재 프로젝트(`Graph Designer ADK Agent`)에 엄격하게 이식합니다. 또한, 방대해진 단일 구현 계획서(`docs/Graph_Designer_ADK_Agent_Implementation_Plan.md`)를 `docs/plan/`, `docs/impl/`, `docs/tr/` 구조로 분할하여 가독성과 유지보수성을 극대화합니다.

## 2. Key Files & Context (핵심 파일 및 컨텍스트)
*   **신규 생성 대상**:
    *   `.agent/rules/core-directives.md`: 최우선 행동 강령
    *   `.agent/rules/rules.md`: 에이전트 동작 및 문서화 규칙
    *   `context.md`: 프로젝트 루트 레벨의 상태 및 작업 동기화 파일
    *   `docs/plan/*`: 분할된 계획서 파일들
    *   `docs/impl/impl_context.md`: 구현 상태 및 컨텍스트 저장소
    *   `docs/tr/troubleshooting.md`: 문제 해결 이력 저장소
*   **분할 대상**: `docs/Graph_Designer_ADK_Agent_Implementation_Plan.md` (작업 후 삭제)

## 3. Implementation Steps (구현 단계)

### Phase 1: 에이전트 규칙(Rules) 이식
기존 프로젝트의 엄격한 통제 규칙을 원형 그대로 가져오되, 경로 및 프로젝트 명칭만 현재 워크스페이스에 맞게 조정하여 파일을 생성합니다.
1.  **`.agent/rules/core-directives.md` 생성**: No Silent Mutations, No Guessing, Bottom-up 디버깅 등 핵심 강령 유지.
2.  **`.agent/rules/rules.md` 생성**: `#PLAN`, `#IMPL`, `#TR` 등의 태그 기반 작업 방식과 문서화 규칙 명시. (기존 `chat_history/` 방식 대신 `docs/` 하위 분리 방식을 명시)

### Phase 2: 디렉토리 구조 셋업 및 컨텍스트 초기화
1.  **디렉토리 생성**: `docs/plan`, `docs/impl`, `docs/tr` 생성.
2.  **초기 파일 세팅**:
    *   `docs/impl/impl_context.md`: 현재까지의 구현 상태 요약 (초기 뼈대 구축).
    *   `docs/tr/troubleshooting.md`: 향후 버그 및 해결책을 기록할 템플릿 파일 생성.
    *   `context.md` (루트): MW/SW 역할에 따른 현재 To-Do 및 상태 관리 파일 생성.

### Phase 3: 거대 계획서 분할 (Monolithic → Modular)
현재 `Graph_Designer_ADK_Agent_Implementation_Plan.md`의 내용을 논리적인 단위로 쪼개어 `docs/plan/` 하위에 배치합니다.
1.  `docs/plan/00_overview_and_architecture.md`: 프로젝트 개요, 분석, 제안 아키텍처 (Multi-Agent).
2.  `docs/plan/01_main_agent_orchestrator.md`: Main Agent 역할, System Prompt, 설정.
3.  `docs/plan/02_schema_designer_agent.md`: Sub-Agent 1 (Schema Designer)의 스키마 생성 및 대화형 로직.
4.  `docs/plan/03_kuzu_deployer_agent.md`: Sub-Agent 2 (Kuzu Deployer)의 검증 및 배포 전략.
5.  `docs/plan/04_visualizer_agent.md`: Sub-Agent 3 (Visualizer)의 시각화 전략 및 Mermaid 렌더링.
6.  `docs/plan/05_environment_and_execution.md`: 환경 설정, 입력 데이터 형식, E2E 실행 가이드.

### Phase 4: 원본 파일 정리
분할 및 이관이 완벽히 검증되면 원본 `Graph_Designer_ADK_Agent_Implementation_Plan.md` 파일을 삭제합니다.

## 4. Verification & Testing (검증)
1.  새로 생성된 `.agent/rules` 파일들이 에이전트의 지시사항으로 정상 작동하는지 프롬프트 로드 테스트 (에이전트에게 규칙 요약 요청).
2.  `docs/plan/` 내의 파일들이 원본의 내용을 누락 없이 모두 포함하고 있는지 확인.
3.  `context.md`와 `impl_context.md`가 서로 참조하며 프로젝트의 진실의 공급원(SoT) 역할을 수행할 수 있는지 검토.