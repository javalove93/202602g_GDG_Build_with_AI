# ADK Configuration Troubleshooting Context

## 1. 개요
현재 `graph-designer-agent` 프로젝트에서 Google ADK(Agent Development Kit)를 사용하여 메인 Agent와 Sub-Agent를 구성하는 중, 기본적인 도구 로드 과정에서 `AttributeError`가 발생하고 있습니다.

## 2. 참조 문서
- **기반 계획서**: [`docs/Graph_Designer_ADK_Agent_Implementation_Plan.md`](file:///home/jerryj/git/202602g_GDG_Build_with_AI/docs/Graph_Designer_ADK_Agent_Implementation_Plan.md)
- **현재 구조**:
  ```
  graph-designer-agent/
  ├── main_agent/
  │   └── root_agent.yaml (오케스트레이터)
  ├── sub_agents/
  │   ├── schema_designer/
  │   │   └── root_agent.yaml
  │   └── spanner_deployer/
  │       └── root_agent.yaml
  └── .venv/ (google-adk 설치됨)
  ```

## 3. 주요 문제 (Error Details)
`adk web main_agent` 실행 및 브라우저에서 요청 시 발생:
```
AttributeError: Fail to load '.../main_agent/root_agent.yaml' config. 
module 'google.adk.tools' has no attribute 'built_in_code_execution' (또는 code_execution)
```
- **특이사항**: YAML 파일에서 `tools` 섹션을 완전히 제거했음에도 불구하고, ADK가 이전 설정을 계속 참조하는 듯한 현상이 발생함.

## 4. 지금까지 진행한 조치 (Current Status)
1. **YAML 표준화**: `agent.yaml`을 `root_agent.yaml`로 변경하고, `agent_class: LlmAgent` 등 공식 규격을 준수하도록 수정함.
2. **도구 제거**: `generate_image`, `code_execution`, `built_in_code_execution` 등 ADK 내장 도구가 아닌 것들을 YAML에서 삭제함.
3. **경로 수정**: `sub_agents` 호출 시 `config_path: ../sub_agents/.../root_agent.yaml` 형식을 사용하도록 수정함.
4. **환경 정리**: `.adk` 캐시 디렉토리를 수차례 삭제하고 재실행했으나 동일 증상 반복됨.
5. **모듈 확인**: `.venv`의 `google.adk.tools`를 확인한 결과 `built_in_code_execution` 속성이 실제로 없음.

## 5. 최종 해결 방법 (Resolution) - 2026-02-05

### 5.1 Invalid Agent Name (Pydantic ValidationError)
- **증상**: `Valiation error: Found invalid agent name: schema-designer`.
- **원인**: ADK Agent 이름(ID)에 하이픈(`-`)이 포함되어 Python 식별자 규칙을 위반함.
- **해결**: 모든 `root_agent.yaml`의 `name` 필드와 시스템 프롬프트 내 참조를 언더스코어(`_`) 형식으로 변경함.
  - `schema-designer` → `schema_designer`
  - `spanner-deployer` → `spanner_deployer`
  - `graph-designer-main` → `graph_designer_main`

### 5.2 AttributeError (built_in_code_execution)
- **증상**: `module 'google.adk.tools' has no attribute 'built_in_code_execution'`.
- **해결**: YAML 설정에서 해당 도구를 제거했음에도 에러가 지속되는 경우, ADK 캐시가 원인임을 식별함.
  - `rm -rf .adk` 명령어로 캐시 디렉토리를 삭제하여 설정을 강제 재로드함.

### 5.3 Model Inconsistency
- **증상**: 계획서(`gemini-3-flash-preview`)와 개별 Agent 설정(`gemini-2.0-flash-exp`) 간의 모델 미스매치.
- **해결**: 모든 `root_agent.yaml`의 `model` 필드를 `.env`에 정의된 `gemini-3-flash-preview`로 통합함.

## 6. 도구 및 환경 설정 가이드
- **내장 도구**: 현재 SDK 버전 기준, 공식 문서에 명시되지 않은 내장 도구(예: `built_in_code_execution`)는 사용을 지양하고 캐시 삭제를 병행할 것.
- **실행 명령어**:
  ```bash
  # 캐시 삭제 후 실행 권장
  rm -rf .adk && adk web main_agent
  ```
