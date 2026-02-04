# Build with AI: Vibe Prototyping using GraphDB

> **Note:** 이 문서는 "Build with AI - Vibe prototyping using GraphDB.pdf" 파일의 내용을 기반으로 재구성되었습니다. 이미지는 `[Image: Page X]` 형식으로 표시되어 있습니다.

[Image: Page 1]
**발표자:** Sean Jung (Customer Engineer, Google Cloud)
**주제:** Vibe Prototyping using GraphDB

---

## 1. 개요: Vibe Prototyping이란?

[Image: Page 2]

**핵심 메시지:** 아이디어에서 구현까지 핵심 메시지, 장점, 그리고 프로세스 요약

### 핵심 메시지 및 장점 (Core Message & Benefits)
[Image: Page 3]

**What is Vibe Prototyping?**
*   LLM을 활용해 복잡한 코딩 지식 없이 자연어(Natural Language)로 기능적인 프로토타입을 만드는 방법입니다.
*   **Target:** PM, UX 디자이너 등 비개발 직군이 주요 대상입니다.

**3가지 핵심 가치**
1.  **접근성 (Accessibility):** '바이브 코딩(Vibe Coding)' - 완벽한 코드 문법 대신 '좋은 바이브(Good Vibes)'와 명확한 프롬프트만 있으면 누구나 앱을 만들 수 있습니다.
2.  **속도 (Speed):** 아이디어를 문서로 정리하는 시간 안에 실제 작동하는 애플리케이션을 생성할 수 있습니다.
3.  **커뮤니케이션 (Communication):** '백문이 불여일견(Show, don't tell)' - 정적인 문서(PRD)나 정지된 목업 대신, 인터랙티브한 결과물로 아이디어를 검증하고 소통할 수 있습니다.

### 프로세스 및 도구 (The Process & Tools)
[Image: Page 4]

**3단계 프로세스 (The 3-Step Process)**
1.  **기획 (Plan):** 무엇을 만들지 자연어로 서술합니다. Google Docs에 아이디어를 적는 것만으로 충분합니다.
2.  **시작 (Initiate):** AI에게 기획안을 입력하여 초기 코드를 생성합니다. (Gemini Canvas 활용)
3.  **반복 (Iterate):** 결과물을 직접 사용해보며 기능을 추가하거나 버그를 수정하여 완성도를 높입니다.

**도구 선택 가이드 (Tool Selection Guide)**
*   **Gemini Canvas (초급):** 빠르고 간편한 인터랙티브 앱 제작.
*   **AI Studio / Firebase (중급 - Prototyping Sweet Spot):** 정교한 제어, 버전 관리, 모바일 앱 지원.
*   **Gemini CLI (고급):** 로컬 환경, 프레임워크 자유 사용.

### 업무 방식의 변화 (Paradigm Shift)
[Image: Page 5]

*   **과거 (Traditional):** PRD 작성 -> 끝없는 리뷰 및 승인 -> 개발 착수
*   **현재 (Vibe Prototyping):** 프로토타입 제작 -> 테스트 및 개선 -> 제품화
*   **Key Takeaway:** PRD가 완전히 사라지는 것은 아니지만, 기획 단계에서부터 실행 가능한 결과물을 만들어 'Building-first culture'로 나아갑니다.

---

## 2. RAG and GraphDB

[Image: Page 6]

### Vector RAG의 한계와 GraphDB의 필요성
[Image: Page 7]

**Vector RAG의 현주소**
*   작동 원리: 질문과 문서 간의 유사도(Similarity) 기반 검색.
*   강점: 답이 명시된 문장을 찾는 데 탁월.

**주요 한계 (The Gap)**
1.  **관계의 부재 (Neglecting Relationships):** 문서 간의 인과관계나 숨겨진 연결고리를 놓침.
2.  **전체 맥락 파악 불가 (Lack of Global Sensemaking):** 거시적 질문(테마 요약)에 대해 단편적 정보만 제공.
3.  **환각 (Hallucination):** 파편화된 정보를 억지로 연결하려다 거짓 정보 생성.

### GraphDB의 기본 원리
[Image: Page 8]

데이터를 '점'이 아닌 '선'으로 연결: 'A는 B와 연결되어 있다'는 사실 자체가 데이터로 저장됨. (Node A -> Edge -> Node B)

| 구분 | Vector DB (기존 RAG) | Graph DB (차세대 RAG 기반) |
| :--- | :--- | :--- |
| **데이터 구조** | 고차원 벡터 공간의 점 (유사성) | 노드와 엣지의 네트워크 (관계성) |
| **장점** | 비정형 텍스트 처리에 강력, 구축 용이 | **복잡한 추론**, 인과관계 파악, 설명 가능성(XAI) |
| **단점** | **논리적 추론 및 정확한 사실 관계 취약** | 스키마 설계 및 구축 난이도 높음 |
| **적합 분야** | 단순 질문 답변, 문서 요약 | **복잡한 정책 검색**, 사기 탐지, 인과 분석 |

### GraphRAG: LLM의 창의성과 그래프의 구조적 사고의 결합
[Image: Page 9]

1.  **구조화 (Indexing):** 텍스트 내의 엔티티(Entity)와 관계(Relationship)를 추출하여 그래프로 변환.
2.  **계층적 요약 (Community Summaries):** 그래프 내 밀접한 그룹(Community)별로 요약 정보를 미리 생성하여 거시적 질문에 대응.
3.  **단일 단계 다중 추론 (Retrieval):** 한 번의 검색으로 연관된 여러 단계의 정보를 동시에 추론 (경로 찾기).
    *   **도입 효과:** 기존 RAG 대비 포괄성(Comprehensiveness) 및 답변 다양성 대폭 향상.

---

## 3. 실습: 통신사 요금제 상담 봇 설계 (Agent 개발 참조용)

[Image: Page 10]
함께 만들어 봅시다.

### 실습 시나리오
[Image: Page 11]

*   **배경 (Context):** LG U+의 요금제 데이터는 단순하지 않습니다. 요금제(Plan), 부가서비스(Benefit), 가족 결합(Family), 할인 조건이 복잡하게 얽혀 있습니다.
*   **도전 과제 (The Challenge):** "나에게 딱 맞는 결합 할인 조합은?" 단순한 RAG(검색)로는 요금제 간의 '관계'와 '조건'을 완벽하게 추론하기 어렵습니다.
*   **우리의 목표 (Goal):** AI Studio를 활용해 이 관계를 정의하는 GraphDB 스키마를 프로토타이핑합니다.

### Business Requirement
[Image: Page 12]
*   요금제 관련 정확한 답변을 하는 상담 챗봇 만들기
*   참고 URL: `https://www.lguplus.com/mobile/plan/mplan/plan-all`

---

## 4. Tech Spec & Prompt Engineering (Agent 개발 핵심)

**이 섹션은 Agent Wrapping 시 가장 중요한 부분입니다.**

### [상세 기술 스펙 및 화면 구성 명세서]
[Image: Page 14]

#### 1. 프로젝트 개요
*   **서비스명:** AI Graph Designer (Powered by Gemini 3 Flash)
*   **목적:** 비즈니스 요구사항(텍스트/문서)을 분석하여 GCP Spanner Graph 전용 스키마 및 시각화 모델을 자동 생성하는 도구.
*   **핵심 가치:** 복잡한 통신사 요금제와 같은 관계 중심 데이터를 전문가 도움 없이 그래프 모델로 신속하게 자산화.

#### 2. 상세 기술 스택 (Tech Stack)
*   **LLM 모델:** Gemini 3 Flash Preview (**초저지연(Low-latency)**과 고성능 추론 능력을 갖춘 최신 모델)
*   **Frontend:** React 18+ / Next.js (App Router)
*   **Backend:** Python 3.11+ / FastAPI (Gemini API 및 Spanner SDK 연동 비동기 서버)
*   **Graph Engine:** React Flow (노드 기반 UI 편집 및 시각화 라이브러리)
*   **Cloud DB:** Google Cloud Spanner Graph (하이브리드(SQL+Graph) 쿼리를 지원하는 타겟 DB)
*   **Infrastructure:** Google Cloud Run / Vertex AI
*   **API Protocol:** Server-Sent Events (SSE) (Gemini의 실시간 응답 스트리밍 구현)

#### 3. Gemini 3 Flash Preview 최적화 전략 (System Prompt 설계 요소)

**A. 멀티모달 프롬프트 (System Prompt 예시)**

```markdown
"너는 Google Cloud Spanner Graph 아키텍트야.
사용자가 입력한 비즈니스 명세를 분석하여
1. Nodes (ID, Label, Properties)
2. Edges (Source, Destination, Label)
3. Spanner CREATE PROPERTY GRAPH DDL
위 3가지를 JSON 구조로 정밀하게 반환해줘.
특히 Gemini 3 Flash의 빠른 속도를 활용해 실시간으로 구조를 제안해."
```

**B. 처리 프로세스**
1.  **Context Injection:** 사용자의 텍스트와 파일 데이터를 Gemini 3 Flash Preview에 입력.
2.  **Fast Reasoning:** 모델이 비즈니스 엔티티 간의 관계를 추론하여 그래프 스키마 생성.
3.  **Visual Mapping:** 백엔드에서 받은 JSON을 Frontend의 React Flow 데이터 규격으로 변환하여 렌더링.

#### 4. 화면 구성 명세 (UI/UX Detail)
*   **[A. 좌측: Input Panel - 비즈니스 명세서]**
    *   업무 설명 영역 (Prompt Editor): Rich Text Editor. (예: "5G 요금제와 OTT 혜택의 관계를 입력")
    *   파일 첨부 버튼 (Multimodal Input): 요금제 PDF, 엑셀 시트 등 업로드.
    *   그래프 생성 버튼 (Trigger): 액션 입력된 컨텍스트를 Gemini에게 전달하여 노드/엣지 데이터 요청.
*   **[B. 우측: Output Panel - 그래프 DB 설계안]**
    *   그래프 시각화 영역 (Interactive Canvas): React Flow 기반 캔버스.
    *   설명 영역 (AI Summary): 생성된 그래프 모델에 대한 Gemini의 해석 제공.

---

### [Spec to Prototype Prompt] - 실제 사용된 프롬프트
[Image: Page 16]

아래 프롬프트는 상세 제품 계획을 바탕으로 인터랙티브 웹 프로토타입을 생성하기 위해 사용된 것입니다. Agent가 코드를 생성할 때 이 페르소나와 지침을 사용할 수 있습니다.

```text
1. 당신은 제품 사양을 바탕으로 고품질의 인터랙티브 웹 프로토타입을 신속하게 구축하는 데 능숙한 시니어 프로토타입 엔지니어입니다. 당신의 임무는 전문적인 판단력을 발휘하여 제품 계획을 현실로 구현하는 데 가장 적합한 기술과 형식을 선택하는 것입니다.

2. 핵심 과제는 아래의 상세 제품 계획을 바탕으로 완벽하게 작동하는 인터랙티브 프로토타입을 제작하는 것입니다. 계획에 명시된 모든 사용자 여정, 버튼 클릭, 양식을 구현하여 사용자 테스트에 바로 사용할 수 있는 매끄러운 사용자 흐름을 만들어야 합니다.

3. 중요한 것은 이것이 개념 증명(Proof-of-Concept)이라는 점입니다. 계획에 없는 기능을 추가하거나 프로덕션 수준의 고려 사항(확장성, 보안, 성능 등)을 반영하여 구축해서는 안 됩니다.

4. 이 프로토타입은 회사의 성공을 위한 마지막 기회입니다. 팀의 미래는 완벽하고 직관적이며 인상적인 사용자 경험을 제공하는 당신의 능력에 달려 있습니다. 우리는 당신이 이 계획을 완벽하게 실행할 수 있을 것이라고 확신합니다.

5. 자, 이제 아래 제품 계획을 바탕으로 프로토타입을 제작해 보세요.
```

---

## 5. 결과물 예시 및 활용

[Image: Page 20]
**그래프 DB 설계안 예시 데이터 구조**
*   **Nodes:** Plan (요금제), PlanCategory, Condition
*   **Edges:** BELONGS_TO, REQUIRES
*   **AI 설계 의도:** 요금제 라인업, 혜택, 가입 조건을 분리된 노드로 설계하여 고객 속성에 따른 요금제 추천 로직을 그래프 탐색으로 구현.

[Image: Page 22]
**AI Studio 활용**
1.  **Plan:** 만들고자 하는 비즈니스 로직 정의 (프롬프트 설계)
2.  **Initiate:** 데이터 주입 및 페르소나 부여
3.  **Iterate:** 대화를 통한 수정 및 정교화 (Vibe Coding)
4.  **Result:** 실행 가능한 코드 (Cypher DDL) 생성

