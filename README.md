# Graph Designer ADK Agent 프로젝트

Google ADK를 사용하여 비즈니스 요구사항으로부터 GCP Spanner Graph 스키마를 자동 생성하는 Multi-Agent 시스템

---

## 📋 프로젝트 개요

이 프로젝트는 **LG U+ 요금제**와 같은 복잡한 비즈니스 규칙을 입력받아, **Spanner Graph 스키마**를 자동으로 설계하고 배포하는 ADK Agent 시스템입니다.

### 핵심 기능
- ✅ 자연어 비즈니스 요구사항 → Graph 스키마 자동 생성
- ✅ Spanner DDL 자동 생성 및 검증
- ✅ Spanner 인스턴스 자동 배포
- ✅ 그래프 시각화 (Mermaid 다이어그램)
- ✅ Multi-Agent 아키텍처 (Main + Schema Designer + Spanner Deployer)

---

## 🗂️ 프로젝트 구조

```
202602g_GDG_Build_with_AI/
├── README.md                                    # 이 파일
├── docs/
│   ├── Graph_Designer_ADK_Agent_Implementation_Plan.md  # ⭐ 핵심 구현 계획서
│   ├── Build_with_AI_Vibe_prototyping.md       # 참고: Vibe Prototyping 개념
│   └── Build with AI - Vibe prototyping using GraphDB.pdf  # 원본 발표 자료
└── examples/
    └── 입력_예시.md                              # ⭐ Agent 테스트용 LG U+ 요금제 예시
```

---

## 🚀 빠른 시작

### 1️⃣ 필수 문서 확인

**반드시 이 순서대로 읽으세요:**

1. **[docs/Graph_Designer_ADK_Agent_Implementation_Plan.md](docs/Graph_Designer_ADK_Agent_Implementation_Plan.md)** ⭐
   - **전체 구현 계획서** (2,200+ 줄)
   - 이 문서 하나로 Agent 전체를 구현할 수 있습니다
   - 포함 내용:
     - 환경 설정 (uv, .env 파일)
     - Spanner 인프라 자동화 스크립트
     - Agent 설정 파일 (agent.yaml, 프롬프트)
     - Python SDK 코드
     - End-to-End 실행 가이드

2. **[examples/입력_예시.md](examples/입력_예시.md)** ⭐
   - **Agent 테스트용 입력 데이터**
   - LG U+ 5G 요금제 실제 정보 포함
   - 4가지 입력 방법 예시

### 2️⃣ 구현 시작

```bash
# 1. 저장소 클론 및 브랜치 생성
git clone https://github.com/javalove93/202602g_GDG_Build_with_AI
cd 202602g_GDG_Build_with_AI

# ⚠️ 권장: 개발 전용 브랜치(impl)를 만들어 작업을 시작하세요
git checkout -b impl

# 2. 구현 계획서 열기
# 계획서의 "환경 설정 및 의존성" 섹션부터 순서대로 따라하기
cat docs/Graph_Designer_ADK_Agent_Implementation_Plan.md
```

---

## 📚 문서 간 관계

### 핵심 문서 (필수)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| **Graph_Designer_ADK_Agent_Implementation_Plan.md** | 전체 구현 가이드 | 구현 시작부터 끝까지 |
| **입력_예시.md** | 테스트 데이터 | Agent 구현 완료 후 테스트 |

### 참고 문서 (선택)

| 문서 | 역할 | 사용 시점 |
|------|------|----------|
| Build_with_AI_Vibe_prototyping.md | Vibe Prototyping 개념 설명 | 배경 이해 필요 시 |
| Build with AI - Vibe prototyping using GraphDB.pdf | 원본 발표 자료 | 상세 배경 이해 필요 시 |

---

### Step 1: 개발 환경 준비 (Session Management)

성공적인 에이전트 개발을 위해 다음 두 파일을 먼저 생성하고 에이전트에게 읽히는 것을 권장합니다:

- **`impl_context.md`**: 현재 구현 상태와 설계 결정을 기록
- **`troubleshooting.md`**: 발생한 에러와 해결법 기록

이 파일들은 에이전트가 중단된 지점부터 다시 시작하거나, 과거의 실수를 반복하지 않도록 하는 강력한 컨텍스트가 됩니다.

### Step 2: 환경 설정 및 인프라 구축
```bash
# uv 설치
curl -LsSf https://astral.sh/uv/install.sh | sh

# 프로젝트 디렉토리 생성
mkdir -p graph-designer-agent
cd graph-designer-agent

# .env 파일 생성 및 설정 (계획서 참조)
# Spanner Enterprise 에디션 인스턴스 생성
./scripts/setup_spanner.sh
```

### Step 3: Agent 구현
```bash
# 계획서의 "완전한 프로젝트 구조" 섹션을 따라
# agent.yaml, 프롬프트, 스크립트 파일 생성
```

### Step 4: 테스트
```bash
# examples/입력_예시.md의 내용을 복사하여
# Agent에 입력하고 결과 확인
```

---

## ✅ Self-Sufficiency 체크리스트

이 저장소만으로 Agent를 완전히 구현할 수 있는지 확인:

### 필수 구성 요소

- [x] **환경 설정 가이드**: uv, Python 3.11, 의존성 패키지
- [x] **GCP 설정 가이드**: .env 파일, gcloud 인증, API 활성화
- [x] **Spanner 인프라 스크립트**: setup_spanner.sh, cleanup_spanner.sh
- [x] **Agent 설정 파일**: agent.yaml (Main + Sub-Agents)
- [x] **시스템 프롬프트**: 전체 프롬프트 내용 포함
- [x] **Python 코드**: Spanner SDK 래퍼 클래스
- [x] **테스트 데이터**: LG U+ 요금제 실제 예시
- [x] **실행 가이드**: 처음부터 끝까지 단계별 가이드

### 외부 의존성

**필요한 것:**
- ✅ GCP 계정 (Spanner 사용)
- ✅ 인터넷 연결 (패키지 설치)

**필요 없는 것:**
- ❌ 별도의 코드 저장소
- ❌ 추가 문서
- ❌ 외부 설정 파일

---

## 💡 주요 특징

### 1. 완전한 구현 계획서
- 모든 파일의 전체 코드 포함
- 복사-붙여넣기로 즉시 사용 가능
- 외부 참조 불필요

### 2. 실제 비즈니스 케이스
- LG U+ 5G 요금제 실제 데이터
- 4가지 입력 방법 예시
- 예상 출력 포함

### 3. 비용 최적화
- Spanner 최소 비용 구성 (100 PU)
- 시간당 $0.117 (서울 리전 기준)
- 자동 정리 스크립트 제공

### 4. Multi-Agent 아키텍처
- Main Agent: 오케스트레이터
- Schema Designer: 스키마 설계 전문
- Spanner Deployer: 배포 및 검증 전문

---

## 🔧 기술 스택

| 구성 요소 | 기술 |
|----------|------|
| **언어** | Python 3.11+ |
| **패키지 관리** | uv |
| **LLM** | Gemini 3 Flash Preview |
| **Database** | Google Cloud Spanner (Graph) |
| **Agent Framework** | Google ADK |
| **시각화** | Mermaid 다이어그램 |

---

## 📞 문의 및 기여

이 프로젝트는 **"Build with AI - Vibe Prototyping using GraphDB"** 발표를 기반으로 합니다.

### 참고 자료
- 발표 자료: `docs/Build with AI - Vibe prototyping using GraphDB.pdf`
- LG U+ 공식 홈페이지: https://www.lguplus.com/mobile/plan/mplan/plan-all

---

## 📝 라이선스

이 프로젝트는 교육 및 학습 목적으로 제공됩니다.

---

## 🎓 다음 단계

1. ✅ **지금**: `docs/Graph_Designer_ADK_Agent_Implementation_Plan.md` 읽기 시작
2. ✅ **환경 설정**: uv 설치 및 .env 파일 생성
3. ✅ **Spanner 생성**: setup_spanner.sh 실행
4. ✅ **Agent 구현**: 계획서 따라 파일 생성
5. ✅ **테스트**: examples/입력_예시.md로 검증
6. ✅ **배포**: Cloud Run에 배포 (선택)

**시작하세요! 모든 것이 준비되어 있습니다.** 🚀
