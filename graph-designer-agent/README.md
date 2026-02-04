# Graph Designer ADK Agent

Google ADK Agent를 사용하여 비즈니스 요구사항에서 GCP Spanner Graph 스키마를 자동 생성하고 배포하는 Multi-Agent 시스템입니다.

## 🎯 주요 기능

- **자연어 기반 스키마 설계**: 비즈니스 요구사항을 입력하면 자동으로 그래프 스키마 생성
- **시각화**: Mermaid 다이어그램으로 그래프 구조 시각화
- **DDL 자동 생성**: Spanner Graph DDL 코드 자동 생성
- **대화형 수정**: 자연어로 스키마 수정 요청 가능
- **자동 배포**: Spanner 인스턴스에 DDL 자동 배포
- **검증**: 샘플 데이터 삽입 및 Graph 쿼리 테스트

## 🏗️ 아키텍처

Multi-Agent 시스템 (Main Agent + 2개 Sub-Agents):

- **Main Agent (Orchestrator)**: 사용자 요청 분석 및 워크플로우 조율
- **Sub-Agent 1 (Schema Designer)**: 그래프 스키마 설계 및 DDL 생성
- **Sub-Agent 2 (Spanner Deployer)**: Spanner 배포 및 검증

## 📋 사전 요구사항

- Python 3.11 이상
- [uv](https://github.com/astral-sh/uv) (Python 패키지 관리자)
- Google Cloud SDK (gcloud CLI)
- GCP 프로젝트 및 Spanner API 활성화
- `roles/spanner.admin` 또는 `roles/spanner.databaseAdmin` 권한

## 🚀 빠른 시작

### 1. 환경 설정

```bash
# 프로젝트 클론
git clone <repository-url>
cd graph-designer-agent

# .env 파일 생성 및 설정
cp .env.example .env
# .env 파일을 편집하여 GCP_PROJECT_ID 등을 실제 값으로 변경

# Python 환경 설정
uv venv
source .venv/bin/activate  # Linux/macOS
# 또는
.venv\Scripts\activate  # Windows

# 의존성 설치
uv pip install -e .

# GCP 인증
gcloud auth application-default login
gcloud config set project $GCP_PROJECT_ID
```

### 2. Spanner 인프라 생성

```bash
# Spanner 인스턴스 및 데이터베이스 생성 (최소 비용: 100 PU)
chmod +x scripts/setup_spanner.sh
./scripts/setup_spanner.sh
```

**⚠️ 비용 주의**: Spanner는 시간당 약 $0.117 (서울 리전, 100 PU Standard)가 과금됩니다.

### 3. Agent 로컬 실행

```bash
# ADK 웹 서버 시작
adk web

# 브라우저에서 http://localhost:8080 접속
```

### 4. 사용 예시

**스키마 설계 요청**:
```
LG U+ 통신사 요금제 상담 챗봇을 위한 그래프 DB 스키마를 설계해줘.

요구사항:
- 요금제(Plan): 이름, 가격, 데이터 제공량, 음성 제공량
- 요금제 카테고리(PlanCategory): 5G 단말기, 5G 프리미어 등
- 혜택(Benefit): OTT 서비스, 데이터 추가 등
- 가입 조건(Condition): 나이 제한, 약정 기간 등

관계:
- 요금제는 카테고리에 속함
- 요금제는 여러 혜택을 포함
- 요금제는 가입 조건을 요구
```

**대화형 수정**:
```
Plan 노드에 discount_rate 속성 추가해줘
```

**Spanner 배포**:
```
배포해줘
```

### 5. 정리 (비용 절감)

```bash
# Spanner 인스턴스 삭제
chmod +x scripts/cleanup_spanner.sh
./scripts/cleanup_spanner.sh
```

## 📁 프로젝트 구조

```
graph-designer-agent/
├── .env.example              # 환경 변수 템플릿
├── .gitignore                # Git 제외 파일
├── pyproject.toml            # Python 프로젝트 설정
├── README.md                 # 프로젝트 문서
├── agent.yaml                # Main Agent 설정
├── prompts/
│   └── system.md             # Main Agent 시스템 프롬프트
├── sub_agents/
│   ├── schema_designer/
│   │   ├── agent.yaml        # Schema Designer 설정
│   │   └── prompts/
│   │       └── system.md     # Schema Designer 시스템 프롬프트
│   └── spanner_deployer/
│       ├── agent.yaml        # Spanner Deployer 설정
│       ├── prompts/
│       │   └── system.md     # Spanner Deployer 시스템 프롬프트
│       └── tools/
│           └── spanner_client.py  # Spanner Python SDK 래퍼
├── scripts/
│   ├── setup_spanner.sh      # Spanner 인프라 생성
│   └── cleanup_spanner.sh    # Spanner 리소스 정리
└── examples/
    ├── lgu_telecom_plan.md   # LG U+ 요금제 예시
    └── sample_ddl.sql        # 샘플 DDL
```

## 💰 비용 정보

### Spanner 인스턴스 비용 (100 PU 기준)

| 에디션 | 시간당 비용 (서울 리전) | 월 예상 비용 (24/7) |
|--------|----------------------|-------------------|
| Standard | $0.117 | 약 $84 |
| Enterprise | $0.160 | 약 $115 |
| Enterprise Plus | $0.222 | 약 $160 |

**비용 절감 팁**:
- 테스트 완료 후 즉시 인스턴스 삭제 (`cleanup_spanner.sh` 실행)
- 단기 실습용으로만 사용
- 필요시 더 저렴한 리전 사용 (us-central1: 약 $0.09/시간)

## 🧪 테스트

### 로컬 테스트

```bash
# Agent 실행
adk web

# 브라우저에서 시나리오 테스트
# 1. 스키마 설계 요청
# 2. 대화형 수정
# 3. Spanner 배포
```

### Graph 쿼리 테스트

```bash
# Spanner에서 Graph 쿼리 실행
gcloud spanner databases execute-sql $SPANNER_DATABASE_ID \
  --instance=$SPANNER_INSTANCE_ID \
  --project=$GCP_PROJECT_ID \
  --sql="GRAPH TelecomGraph MATCH (p:Plan)-[:BELONGS_TO]->(c:PlanCategory) RETURN p.name, c.category_name LIMIT 10"
```

## 📚 참고 문서

- [Google ADK Documentation](https://cloud.google.com/adk)
- [Spanner Graph Documentation](https://cloud.google.com/spanner/docs/graph)
- [구현 계획서](../docs/Graph_Designer_ADK_Agent_Implementation_Plan.md)

## 📝 라이선스

MIT License

## 🤝 기여

이슈 및 PR을 환영합니다!
