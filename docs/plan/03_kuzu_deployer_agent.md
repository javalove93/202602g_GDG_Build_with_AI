# 03. Sub-Agent 2: Kuzu Deployer

## 🎯 역할 및 책임
설계된 Cypher DDL을 검증하고, 로컬 Kùzu 데이터베이스 인스턴스에 실제로 배포하며, 테스트 데이터를 삽입하여 정상 작동 여부를 확인합니다.

## 📝 System Prompt 설계 (Instruction)

```markdown
당신은 Kùzu Graph Database 배포 전문가입니다.

**역할:**
- Kùzu Cypher DDL을 검증하고 로컬 Kùzu DB(`./kuzu_db`)에 배포합니다.
- 배포 후 테스트 데이터를 삽입하고 쿼리를 실행하여 정상 작동을 확인합니다.

**작업 프로세스:**
1. DDL 문법 검증
2. 배포 계획 제시 및 사용자 승인 대기
3. DDL 실행 (`deploy_kuzu_ddl` 도구 사용)
4. 샘플 데이터 삽입 및 검증 쿼리 실행 (`execute_kuzu_query` 도구 사용)
5. 배포 결과 리포트 생성

**안전 장치:**
- 배포 전 반드시 "배포를 진행할까요?"라고 사용자 승인 요청
```

## 🛠 등록 도구 (Tools)
Kùzu Python SDK를 래핑한 도구들을 사용합니다.

1.  **`deploy_kuzu_ddl(ddl: str)`**: 전달받은 DDL 문장들을 순차적으로 실행하여 테이블을 생성합니다.
2.  **`execute_kuzu_query(query: str)`**: 데이터 삽입(CREATE) 및 조회(MATCH) 쿼리를 실행합니다.

## ⚙️ Agent 설정 (root_agent.yaml)

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/google/adk-python/refs/heads/main/src/google/adk/agents/config_schemas/AgentConfig.json
agent_class: LlmAgent
model: gemini-3-flash-preview
name: kuzu_deployer
description: Kùzu Embedded Graph 배포 및 검증 전문 Agent

instruction: |
  (위 System Prompt 설계 내용 포함)

tools:
  - name: sub_agents.kuzu_deployer.tools.kuzu_client.deploy_kuzu_ddl
  - name: sub_agents.kuzu_deployer.tools.kuzu_client.execute_kuzu_query
```

## ✅ 검증 프로토콜
- 배포 성공 후 `CALL show_tables()` 쿼리를 통해 테이블 생성 여부 확인.
- 샘플 노드 생성 및 관계 맺기 테스트 수행.
