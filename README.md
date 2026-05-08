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
├── README.md                                    # 프로젝트 개요 및 가이드
├── context.md                                   # 프로젝트 전반의 컨텍스트 정보
├── .agent/                                      # Agent 관련 규칙 및 지침
│   └── rules/
│       ├── core-directives.md                   # 핵심 지시사항
│       └── rules.md                             # 상세 작업 규칙
├── conductor/                                   # 프로젝트 오케스트레이션 및 관리
│   └── plan_docs_and_rules.md                   # 전체적인 실행 계획 및 규칙
├── docs/                                        # 상세 문서 및 설계 자료
│   ├── Build_with_AI_Vibe_prototyping.md       # Vibe Prototyping 개념 및 배경
│   ├── Graph Designer ADK Agent - Antigravity Chat.md # Agent 대화 기록 및 히스토리
│   ├── plan/                                    # 단계별 상세 구현 계획
│   │   ├── 00_overview_and_architecture.md      # 아키텍처 개요 및 핵심 구현 계획 ⭐
│   │   ├── 01_main_agent_orchestrator.md        # 메인 에이전트 설계
│   │   ├── 02_schema_designer_agent.md          # 스키마 설계 에이전트
│   │   ├── 03_kuzu_deployer_agent.md            # Kùzu 배포 에이전트
│   │   ├── 04_visualizer_agent.md               # 시각화 에이전트
│   │   └── 05_environment_and_execution.md      # 환경 구성 및 실행 방법
│   ├── impl/                                    # 구현 세부 정보
│   │   └── impl_context.md                      # 구현 컨텍스트 및 히스토리
│   └── tr/                                      # 문제 해결 가이드
│       └── troubleshooting.md                   # 트러블슈팅 문서
└── examples/                                    # 테스트 데이터 및 가이드
    ├── 테스트_시나리오_가이드.md                 # Agent 테스트 시나리오 및 방법
    ├── kt_plans_data.md                         # KT 요금제 예시 데이터
    ├── lgu_5g_plans_data.md                     # LGU+ 요금제 예시 데이터
    └── skt_plans_data.md                        # SKT 요금제 예시 데이터
```

---

## 🚀 빠른 시작

### 1️⃣ 필수 문서 확인

**반드시 이 순서대로 읽으세요:**

1. **[docs/plan/00_overview_and_architecture.md](docs/plan/00_overview_and_architecture.md)** ⭐
   - **전체 구현 계획 및 아키텍처 가이드**
   - 이 문서를 시작으로 `docs/plan/` 폴더 내의 상세 계획들을 파악할 수 있습니다.
   - 포함 내용:
     - Multi-Agent 아키텍처 (Main + Sub-Agents)
     - 환경 설정 및 구현 제약사항
     - 단계별 상세 구현 로드맵 가이드

2. **[examples/테스트_시나리오_가이드.md](examples/테스트_시나리오_가이드.md)** ⭐
   - **Agent 테스트 가이드**
   - 4가지 입력 방법 및 검증 포인트 안내
   - 실제 테스트 시에는 동봉된 통신 3사 데이터(`lgu_5g_plans_data.md`, `skt_plans_data.md`, `kt_plans_data.md`) 중 하나를 첨부하여 진행하세요.

### 2️⃣ 구현 및 실행 가이드 (AI Agent 기반 자동 개발)

이 프로젝트는 개발자가 직접 코딩하는 대신, **Gemini CLI, Antigravity, Gemini Code Assist 등의 AI 에이전트가 `docs/plan/` 폴더 내의 계획서들을 읽고 스스로 구현하도록 지시하는 것**이 핵심입니다.

```bash
# 1. 저장소 클론 및 브랜치 전환
git clone https://github.com/javalove93/202602g_GDG_Build_with_AI
cd 202602g_GDG_Build_with_AI
git checkout local-kuzu-with-rules

# 2. Worktree 구성
# ⚠️ 권장: git worktree를 사용하여 개발 전용 독립 환경(impl)을 구성하세요
git worktree add -b impl ../impl origin/local-kuzu-with-rules
cd ../impl

# 3. AI Agent에게 구현 지시 (Gemini CLI 예시)
# 에이전트에게 계획서를 읽고 프로젝트 루트 하위에 graph-designer-agent 폴더를 생성하여 구현을 시작하도록 명령합니다.
gemini -y "@docs/plan/00_overview_and_architecture.md 및 docs/plan/ 폴더의 계획서들을 숙지하고, 반드시 프로젝트 루트에 'graph-designer-agent'라는 폴더를 먼저 생성한 후 그 안에 모든 코드와 설정을 구현해줘. uv 환경을 사용하여 필요한 의존성(pyproject.toml)도 함께 구성해줘."

# 4. 환경 변수 설정
# 에이전트 구현이 완료되면 .env.example을 복사하여 .env를 생성하고 GEMINI_API_KEY를 설정하세요.
cp .env.example .env

# 5. ADK Agent 실행
# 환경 변수 설정 후 에이전트 웹 UI를 시작합니다.
uv run adk web graph-designer-agent
```

### 💡 ADK Web 실행 후 테스트 방법 (프롬프트 예시)

에이전트 구현이 완료되고 `adk web` 화면이 열리면, 하단의 **클립(첨부) 아이콘 📎**을 클릭하여 `examples/` 폴더에 있는 데이터 파일을 업로드합니다.

#### [기본] 단일 통신사 분석
원하는 통신사 파일 1개를 업로드하고 아래 프롬프트를 입력하세요.

```text
첨부한 통신사 요금제 정보를 바탕으로 상담 챗봇을 위한 그래프 DB 스키마를 설계해줘.

요구사항:
- 요금제(Plan): 이름, 가격, 데이터 제공량, 음성 제공량
- 요금제 카테고리(PlanCategory): 주력 요금제, 실속형, 청년 특화 등
- 혜택(Benefit): OTT 서비스, 데이터 추가, 스마트기기 회선 등
- 가입 조건(Condition): 나이 제한, 약정 기간, 가족 결합 등

관계:
- 요금제는 카테고리에 속함
- 요금제는 여러 혜택을 포함
- 요금제는 가입 조건을 요구
```

#### [심화] 통신 3사 통합 비교 분석 (Multi-Carrier)
`lgu_5g_plans_data.md`, `skt_plans_data.md`, `kt_plans_data.md` 3개의 파일을 **모두 한 번에 첨부**하고 아래 프롬프트를 입력하세요.

```text
첨부한 통신 3사(SKT, KT, LGU+)의 요금제 정보들을 하나의 단일 지식 그래프(Knowledge Graph)로 통합하여 비교할 수 있도록 설계해줘. 

추가 요구사항:
- 반드시 `Carrier(통신사)`라는 최상위 엔티티 노드를 생성할 것.
- 각 통신사의 요금제(Plan) 노드들이 해당 Carrier 노드에 `BELONGS_TO_CARRIER` 관계로 연결되도록 설계할 것.
- 서로 다른 통신사라도 혜택(예: 넷플릭스)이나 조건(예: 20대 청년)이 같다면, 동일한 Benefit/Condition 노드를 공유하여 크로스 비교가 가능하도록 할 것.
```

---

### 🔍 지식 그래프(KG) 활용 질의 예시 (Chatbot Use Cases)

에이전트가 구축한 지식 그래프는 단순 검색(Vector RAG)으로는 답변하기 어려운 **관계 중심의 복합 질문**에 대해 정확한 데이터를 추출할 수 있는 기반이 됩니다.

| 질문 유형 | 자연어 질문 (상담 챗봇 환경) | Cypher 쿼리 (내부 작동 원리) |
| :--- | :--- | :--- |
| **기초: 복합 필터링** | "월 8만원 이하 요금제 중 OTT 혜택이 있는 건 뭐야?" | `MATCH (p:Plan)-[:PROVIDES]->(b:Benefit) WHERE p.monthly_fee <= 80000 AND b.benefit_type = 'OTT' RETURN p.name, b.description` |
| **기초: 자격 확인** | "20대 청년들만 가입할 수 있는 요금제들만 골라줘." | `MATCH (p:Plan)-[:REQUIRES]->(c:Condition) WHERE c.description CONTAINS '청년' OR c.description CONTAINS '20대' RETURN p.name` |
| **심화: 다중 홉(Multi-hop)** | "내가 20대 청년인데, 넷플릭스를 볼 수 있고 데이터가 무제한인 가장 저렴한 요금제는 뭐야?" | `MATCH (c:Condition)<-[:REQUIRES]-(p:Plan)-[:INCLUDES]->(b:Benefit)`<br>`WHERE c.condition_type = 'Age' AND c.value = '20대'`<br>`AND b.description CONTAINS '넷플릭스' AND p.data_limit = -1`<br>`RETURN p.name, p.price ORDER BY p.price ASC LIMIT 1` |
| **심화: Upsell 추천** | "현재 '5G 스탠다드'를 쓰는데, 2만원만 더 내면 OTT가 추가되는 상위 요금제는?" | `MATCH (curr:Plan {name: '5G 스탠다드'}), (up:Plan)-[:INCLUDES]->(b:Benefit)`<br>`WHERE up.price > curr.price AND up.price <= curr.price + 20000 AND b.benefit_type = 'OTT'`<br>`RETURN up.name, up.price - curr.price AS cost_diff, b.description` |
| **고급: 교집합 패턴** | "가족 결합 할인이 되면서 스마트기기 2회선이 무료인 요금제들을 카테고리별로 묶어줘." | `MATCH (cat:PlanCategory)<-[:BELONGS_TO]-(p:Plan)`<br>`MATCH (p)-[:REQUIRES]->(c:Condition), (p)-[:INCLUDES]->(b:Benefit)`<br>`WHERE c.condition_type = 'Family' AND b.description CONTAINS '스마트기기 2회선'`<br>`RETURN cat.category_name, collect(p.name) AS eligible_plans` |
| **최고급: 3사 통합 비교 (Cross-Carrier)**<br>*(통합 KG의 진가)* | "통신 3사 통틀어서, 데이터 무제한이면서 넷플릭스 혜택을 주는 요금제를 통신사별로 묶어서 보여줘." | `MATCH (c:Carrier)<-[:BELONGS_TO_CARRIER]-(p:Plan)-[:INCLUDES]->(b:Benefit)`<br>`WHERE p.data_limit = -1 AND b.description CONTAINS '넷플릭스'`<br>`RETURN c.name AS carrier, collect(p.name) AS plans` |

---

## 📚 문서 간 관계

### 핵심 문서 (필수)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| **docs/plan/00_overview_and_architecture.md** | 전체 구현 가이드 시작점 | 구현 아키텍처 파악 시 |
| **docs/plan/** | 단계별 상세 구현 계획 폴더 | 각 에이전트 상세 구현 시 |
| **examples/테스트_시나리오_가이드.md** | 테스트 데이터 및 시나리오 | Agent 실행 후 프롬프트 테스트 |
| **docs/impl/impl_context.md** | 구현 상태 기록 | 프로젝트 히스토리 파악 시 |
| **docs/tr/troubleshooting.md** | 트러블슈팅 가이드 | 에러 발생 시 |

### 참고 문서 (선택)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| docs/Build_with_AI_Vibe_prototyping.md | Vibe Prototyping 개념 설명 | 배경 이해 필요 시 |
| docs/Build with AI - Vibe prototyping using GraphDB 14.jpg | 이미지 자료 | 시각적 참고 필요 시 |

---

## ✅ Self-Sufficiency 체크리스트

이 저장소만으로 Agent를 완전히 구동할 수 있는지 확인:

### 필수 구성 요소

- [x] **환경 설정 가이드**: uv, Python 3.11, 의존성 패키지(kuzu)
- [x] **Agent 계획**: docs/plan/ 내의 상세 설계 문서들
- [x] **시스템 프롬프트**: 각 상세 계획서 내의 프롬프트 지침
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

1. ✅ **지금**: `docs/plan/00_overview_and_architecture.md` 읽기 시작
2. ✅ **환경 설정**: uv 설치 및 가상환경 초기화
3. ✅ **Agent 구현**: 계획서에 따라 `graph-designer-agent` 폴더 구조 및 파일 생성
4. ✅ **테스트**: ADK 웹 UI 하단의 **클립 아이콘(첨부)**을 클릭하여 `examples/lgu_5g_plans_data.md` 파일을 업로드한 후, 프롬프트를 입력하여 스키마 자동 생성 검증

**시작하세요! 모든 것이 준비되어 있습니다.** 🚀
