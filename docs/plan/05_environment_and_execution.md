# 05. 환경 설정 및 실행 가이드 (Env & Execution Guide)

## 🛠 Python 환경 구성 (uv 사용)
### 1. 프로젝트 초기화
```bash
mkdir -p graph-designer-agent
cd graph-designer-agent

# 💡 빌드 시스템(hatchling 등) 없이 순수 의존성 관리용으로만 초기화
uv init --app --no-workspace
```

> [!CAUTION]
> **[build-system] 섹션 생성 금지**: `pyproject.toml`에 `requires = ["hatchling"]`과 같은 빌드 시스템 설정이 포함되지 않도록 주의하십시오. 만약 생성되었다면 해당 섹션을 삭제하여 순수한 의존성 관리 파일로 유지해야 합니다.

### 2. 의존성 패키지 설치
`pyproject.toml`에 다음 의존성을 추가하고 `uv sync`를 실행합니다.
...

- `kuzu>=0.8.0`
- `google-adk`
- `google-genai>=0.2.0`

---

## 🚀 에이전트 로컬 실행

```bash
# ADK 웹 서버 시작
uv run adk web
```
브라우저에서 `http://localhost:8080` 접속 후 대화 시작.

---

## 📥 입력 데이터 형식 예시

에이전트는 다음과 같은 마크다운 형식의 비즈니스 데이터를 이해할 수 있습니다. (`examples/` 폴더 참조)

### 요금제 데이터 예시 (`lgu_5g_plans_data.md`)
```markdown
# 5G 시그니처 요금제
- 월 이용료: 130,000원
- 데이터: 무제한
- 혜택: OTT 팩 2개 선택 가능, 로밍 50% 할인
```

---

## 🧪 E2E 실행 시나리오

1.  **설계 요청**: "첨부한 요금제 파일을 바탕으로 그래프 스키마 설계해줘"
2.  **DDL 생성**: Schema Designer가 DDL 및 Mermaid 다이어그램 생성
3.  **배포 요청**: "로컬 DB에 배포해줘"
4.  **배포 실행**: Kuzu Deployer가 사용자 승인 후 `./kuzu_db`에 스키마 생성
5.  **시각화**: "배포된 구조 보여줘" 요청 시 Visualizer가 최종 스키마 출력

---

## ⚖️ 원본 vs Agent 버전 비교

| 기능 | 원본 (React+FastAPI) | Agent 버전 |
|------|----------------------|------------|
| 개발 속도 | 주 단위 | 즉시 사용 가능 |
| 인프라 비용 | Cloud Run 등 발생 | 로컬 실행 (비용 0) |
| 인터랙티브 | 드래그 앤 드롭 편집 | 대화형 텍스트 수정 |
| 데이터 저장 | 외부 DB 필수 | 로컬 Kùzu 파일 |
