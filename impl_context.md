# Graph Designer Agent Implementation Context

## 1. 프로젝트 현재 상태
- **기초 아키텍처 수립**: 하이브리드 Main + Sub-Agents 구조 완료
- **Agent 설정 완료**: `main_agent`, `schema_designer`, `spanner_deployer`의 `root_agent.yaml` 구성 완료
- **실행 환경**: `google-adk` 설치 및 `.venv` 구성 완료. `adk web` 명령어로 웹 인터페이스 접속 가능 확인.

## 2. 구현 과정에서의 주요 결정 시항 (Plan 대비 변경점)
- **Agent 명명 규칙**: Pydantic 검증 오류 방지를 위해 하이픈(`-`) 대신 언더스코어(`_`) 사용.
  - 예: `schema-designer` → `schema_designer`
- **시스템 지침 통합**: 별도의 `prompts/system.md` 파일을 참조하는 대신, YAML의 `instruction` 필드에 시스템 프롬프트를 직접 작성하여 관리 모델 단순화.
- **모델명 통일**: 모든 Agent의 모델 사양을 `gemini-3-flash-preview`로 통일하여 최신 성능 활용.
- **도구(Tools) 최적화**: 
  - 대신 **Mermaid 문법**과 **mermaid_renderer** 도구를 활용하여 실시간 이미지 렌더링 시각화 제공.
  - 도구 등록 시 정규화된 Python 이름(FQN) 사용 및 패키지 구조(`__init__.py`) 준수.
- **디렉토리 구조**: `main_agent`를 별도 디렉토리로 분리하여 ADK의 Agent Discovery 메커니즘에 최적화.

## 3. 핵심 파일 요약
- [`docs/Graph_Designer_ADK_Agent_Implementation_Plan.md`](file:///home/jerryj/git/202602g_GDG_Build_with_AI/docs/Graph_Designer_ADK_Agent_Implementation_Plan.md): 모든 변경 사항이 반영된 최신 설계도.
- `graph-designer-agent/main_agent/root_agent.yaml`: 오케스트레이터 설정.
- `graph-designer-agent/sub_agents/schema_designer/root_agent.yaml`: 스키마 설계 로직 포함.
- `graph-designer-agent/sub_agents/spanner_deployer/root_agent.yaml`: 배포 프로세스 포함.

## 4. 향후 작업 방향
- **프롬프트 고도화**: Spanner Graph의 복잡한 DDL 문법(특히 Edge의 키 참조)을 더 정확히 생성하도록 지침 강화.
- **배포 자동화 연동**: `scripts/setup_spanner.sh`를 Agent가 사용자에게 적절히 가이드하도록 프롬프트 보완.
- **데이터 예시 추가**: `examples/lgu_telecom_plan.md` 외에 더 다양한 비즈니스 케이스 추가.
- **시각화 고도화 (Phase 2 완료)**: `mermaid_renderer` 도구를 통해 텍스트 기반 Mermaid 다이어그램을 실제 이미지 URL(mermaid.ink)로 변환하여 마크다운 이미지 태그로 제공.
