# Graph Designer ADK Agent 프로젝트

Google ADK를 사용하여 비즈니스 요구사항으로부터 Kùzu Graph 스키마를 자동 생성하는 Multi-Agent 시스템

---

## 📋 프로젝트 개요

이 프로젝트는 **통신사 요금제**와 같은 복잡한 비즈니스 규칙을 입력받아, **Kùzu Embedded Graph 스키마**를 자동으로 설계하고 배포하는 ADK Agent 시스템입니다. 클라우드 인프라(Spanner) 대신 로컬 임베디드 그래프 DB(Kùzu)를 사용하여 비용 없이 빠르게 프로토타이핑할 수 있습니다.

### 핵심 기능
- ✅ 자연어 비즈니스 요구사항 → Graph 스키마 자동 생성
- ✅ Kùzu Cypher DDL 자동 생성 및 검증
- ✅ 로컬 Kùzu DB 자동 배포 및 테스트 데이터 삽입
- ✅ 그래프 시각화 (Mermaid 다이어그램)
- ✅ Multi-Agent 아키텍처 (Main + Schema Designer + Kuzu Deployer)

---

## 🗂️ 프로젝트 구조

```
202602g_GDG_Build_with_AI/
├── README.md                                    # 이 파일
├── docs/
│   ├── Graph_Designer_ADK_Agent_Implementation_Plan.md  # ⭐ 핵심 구현 계획서 (Kùzu 버전)
│   └── Build_with_AI_Vibe_prototyping.md       # 참고: Vibe Prototyping 개념
└── examples/
    ├── 테스트_시나리오_가이드.md                 # Agent 테스트 가이드 및 방법론
    ├── lgu_5g_plans_data.md                      # LGU+ 요금제 원시 데이터
    ├── skt_plans_data.md                         # SKT 요금제 원시 데이터
    └── kt_plans_data.md                          # KT 요금제 원시 데이터
```

---

## 🚀 빠른 시작

### 1️⃣ 필수 문서 확인

**반드시 이 순서대로 읽으세요:**

1. **[docs/Graph_Designer_ADK_Agent_Implementation_Plan.md](docs/Graph_Designer_ADK_Agent_Implementation_Plan.md)** ⭐
   - **전체 구현 계획서 (Kùzu 기반)**
   - 이 문서 하나로 Agent 전체를 파악할 수 있습니다
   - 포함 내용:
     - 환경 설정 (uv)
     - Agent 설정 파일 (agent.yaml, 프롬프트)
     - Python Kùzu 래퍼 코드
     - End-to-End 실행 가이드

2. **[examples/테스트_시나리오_가이드.md](examples/테스트_시나리오_가이드.md)** ⭐
   - **Agent 테스트 가이드**
   - 4가지 입력 방법 및 검증 포인트 안내
   - 실제 테스트 시에는 동봉된 통신 3사 데이터(`lgu_5g_plans_data.md`, `skt_plans_data.md`, `kt_plans_data.md`) 중 하나를 첨부하여 진행하세요.

### 2️⃣ 구현 및 실행 가이드 (AI Agent 기반 자동 개발)

이 프로젝트는 개발자가 직접 코딩하는 대신, **Gemini CLI, Antigravity, Gemini Code Assist 등의 AI 에이전트가 `docs/Graph_Designer_ADK_Agent_Implementation_Plan.md`를 읽고 스스로 구현하도록 지시하는 것**이 핵심입니다.

```bash
# 1. 저장소 클론 및 브랜치 전환
git clone https://github.com/javalove93/202602g_GDG_Build_with_AI
cd 202602g_GDG_Build_with_AI
git checkout local-kuzu

# 2. Worktree 구성
# ⚠️ 권장: git worktree를 사용하여 개발 전용 독립 환경(impl)을 구성하세요
git worktree add -b impl ../impl origin/local-kuzu
cd ../impl

# 3. AI Agent에게 구현 지시 (Gemini CLI 예시)
# 에이전트에게 계획서를 읽고 구현(폴더 구조, 코드 스캐폴딩, 의존성 설치 등)을 시작하도록 명령합니다.
gemini "docs/Graph_Designer_ADK_Agent_Implementation_Plan.md 파일의 '다음 단계'를 참조하여 graph-designer-agent 폴더 구조와 초기 코드 스캐폴딩을 시작해줘"

# 4. 환경 변수 설정
# 에이전트 구현이 완료되면 .env.example을 복사하여 .env를 생성하고 GEMINI_API_KEY를 설정하세요.
cp .env.example .env

# 5. ADK Agent 실행
# 환경 변수 설정 후 에이전트 웹 UI를 시작합니다.
uv run adk web graph-designer-agent/main_agent/root_agent.yaml
```

---

## 📚 문서 간 관계

### 핵심 문서 (필수)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| **Graph_Designer_ADK_Agent_Implementation_Plan.md** | 전체 구현 가이드 | 구현 아키텍처 파악 시 |
| **입력_예시.md** | 테스트 데이터 | Agent 실행 후 프롬프트 테스트 |
| **impl_context.md** | 구현 상태 기록 | 프로젝트 히스토리 파악 시 |
| **troubleshooting.md** | 트러블슈팅 가이드 | 에러 발생 시 |

### 참고 문서 (선택)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| Build_with_AI_Vibe_prototyping.md | Vibe Prototyping 개념 설명 | 배경 이해 필요 시 |
| Build with AI - Vibe prototyping using GraphDB.pdf | 원본 발표 자료 | 상세 배경 이해 필요 시 |

---

## ✅ Self-Sufficiency 체크리스트

이 저장소만으로 Agent를 완전히 구동할 수 있는지 확인:

### 필수 구성 요소

- [x] **환경 설정 가이드**: uv, Python 3.11, 의존성 패키지(kuzu)
- [x] **Agent 설정 파일**: root_agent.yaml (Main + Sub-Agents)
- [x] **시스템 프롬프트**: 전체 Kùzu Cypher 프롬프트 내용 포함
- [x] **Python 코드**: Kùzu 로컬 DB 래퍼 클래스
- [x] **테스트 데이터**: 통신사 요금제 실제 예시

### 외부 의존성

**필요한 것:**
- ✅ 인터넷 연결 (초기 패키지 설치 및 Gemini API 호출)

**필요 없는 것:**
- ❌ GCP 계정 및 비용 (Spanner 제거)
- ❌ 외부 DB 인프라 구축

---

## 💡 주요 특징

### 1. 비용 완전 제로
- 클라우드 DB(Spanner) 대신 로컬 Embedded DB(Kùzu)를 사용하여, 인프라 비용 없이 무제한 프로토타이핑 가능.

### 2. 실제 비즈니스 케이스
- 통신사 5G 요금제 실제 데이터
- 4가지 입력 방법 예시
- 예상 출력 포함

### 3. Multi-Agent 아키텍처
- Main Agent: 오케스트레이터
- Schema Designer: Kùzu 스키마 설계 전문
- Kuzu Deployer: 로컬 배포 및 검증 전문

---

## 🔧 기술 스택

| 구성 요소 | 기술 |
|----------|------|
| **언어** | Python 3.11+ |
| **패키지 관리** | uv |
| **LLM** | Gemini 2.0 Flash |
| **Database** | Kùzu (Embedded Graph DB) |
| **Agent Framework** | Google ADK |
| **시각화** | Mermaid 다이어그램 |

---

## 📞 문의 및 기여

이 프로젝트는 **"Build with AI - Vibe Prototyping using GraphDB"** 발표를 기반으로 하며, 비용 최적화를 위해 로컬 버전으로 개량되었습니다.

### 참고 자료
- 발표 자료: `docs/Build with AI - Vibe prototyping using GraphDB.pdf`
- 통신사 공식 홈페이지: https://www.lguplus.com/mobile/plan/mplan/plan-all

---

## 📝 라이선스

이 프로젝트는 교육 및 학습 목적으로 제공됩니다.

---

## 🎓 다음 단계

1. ✅ **지금**: `docs/Graph_Designer_ADK_Agent_Implementation_Plan.md` 읽기 시작
2. ✅ **환경 설정**: uv 설치 및 가상환경 초기화
3. ✅ **Agent 구현**: 계획서에 따라 `graph-designer-agent` 폴더 구조 및 파일 생성
4. ✅ **테스트**: ADK 웹 UI 하단의 **클립 아이콘(첨부)**을 클릭하여 `examples/lgu_5g_plans_data.md` 파일을 업로드한 후, 프롬프트를 입력하여 스키마 자동 생성 검증

**시작하세요! 모든 것이 준비되어 있습니다.** 🚀
