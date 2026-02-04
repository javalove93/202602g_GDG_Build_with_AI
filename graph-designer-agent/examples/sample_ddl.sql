-- LG U+ 통신사 요금제 그래프 DB 스키마
-- Spanner Graph DDL 예시

-- ========================================
-- Node Tables (노드 테이블)
-- ========================================

-- 요금제 테이블
CREATE TABLE Plan (
  id STRING(36) NOT NULL,
  name STRING(100),
  price INT64,
  data_limit INT64,  -- GB 단위, 무제한은 999999
  voice_limit INT64,  -- 분 단위, 무제한은 999999
  sharing_data INT64,  -- 공유 데이터 GB
) PRIMARY KEY (id);

-- 요금제 카테고리 테이블
CREATE TABLE PlanCategory (
  id STRING(36) NOT NULL,
  category_name STRING(100),
  description STRING(MAX),
) PRIMARY KEY (id);

-- 혜택 테이블
CREATE TABLE Benefit (
  id STRING(36) NOT NULL,
  benefit_type STRING(50),  -- OTT, 스마트기기, 로밍 등
  description STRING(MAX),
  value STRING(100),  -- 혜택 값 (예: "2개 선택", "50% 할인")
) PRIMARY KEY (id);

-- 가입 조건 테이블
CREATE TABLE Condition (
  id STRING(36) NOT NULL,
  condition_type STRING(50),  -- 나이, 신용등급, 약정기간 등
  value STRING(100),
  description STRING(MAX),
) PRIMARY KEY (id);

-- 할인 테이블
CREATE TABLE Discount (
  id STRING(36) NOT NULL,
  discount_type STRING(50),  -- 선택약정, 나이할인, 가족결합 등
  discount_rate FLOAT64,  -- 할인율 (0.25 = 25%)
  description STRING(MAX),
) PRIMARY KEY (id);

-- ========================================
-- Edge Tables (엣지 테이블)
-- ========================================

-- 요금제 → 카테고리
CREATE TABLE PlanBelongsTo (
  plan_id STRING(36) NOT NULL,
  category_id STRING(36) NOT NULL,
  FOREIGN KEY (plan_id) REFERENCES Plan(id),
  FOREIGN KEY (category_id) REFERENCES PlanCategory(id),
) PRIMARY KEY (plan_id, category_id);

-- 요금제 → 혜택
CREATE TABLE PlanIncludesBenefit (
  plan_id STRING(36) NOT NULL,
  benefit_id STRING(36) NOT NULL,
  FOREIGN KEY (plan_id) REFERENCES Plan(id),
  FOREIGN KEY (benefit_id) REFERENCES Benefit(id),
) PRIMARY KEY (plan_id, benefit_id);

-- 요금제 → 가입 조건
CREATE TABLE PlanRequiresCondition (
  plan_id STRING(36) NOT NULL,
  condition_id STRING(36) NOT NULL,
  FOREIGN KEY (plan_id) REFERENCES Plan(id),
  FOREIGN KEY (condition_id) REFERENCES Condition(id),
) PRIMARY KEY (plan_id, condition_id);

-- 요금제 → 할인
CREATE TABLE PlanOffersDiscount (
  plan_id STRING(36) NOT NULL,
  discount_id STRING(36) NOT NULL,
  FOREIGN KEY (plan_id) REFERENCES Plan(id),
  FOREIGN KEY (discount_id) REFERENCES Discount(id),
) PRIMARY KEY (plan_id, discount_id);

-- 조건 → 할인 (특정 조건을 만족하면 받을 수 있는 할인)
CREATE TABLE ConditionEligibleForDiscount (
  condition_id STRING(36) NOT NULL,
  discount_id STRING(36) NOT NULL,
  FOREIGN KEY (condition_id) REFERENCES Condition(id),
  FOREIGN KEY (discount_id) REFERENCES Discount(id),
) PRIMARY KEY (condition_id, discount_id);

-- ========================================
-- Property Graph 정의
-- ========================================

CREATE PROPERTY GRAPH TelecomGraph
NODE TABLES (
  Plan,
  PlanCategory,
  Benefit,
  Condition,
  Discount
)
EDGE TABLES (
  PlanBelongsTo
    SOURCE KEY(plan_id) REFERENCES Plan(id)
    DESTINATION KEY(category_id) REFERENCES PlanCategory(id)
    LABEL BELONGS_TO,
  PlanIncludesBenefit
    SOURCE KEY(plan_id) REFERENCES Plan(id)
    DESTINATION KEY(benefit_id) REFERENCES Benefit(id)
    LABEL INCLUDES,
  PlanRequiresCondition
    SOURCE KEY(plan_id) REFERENCES Plan(id)
    DESTINATION KEY(condition_id) REFERENCES Condition(id)
    LABEL REQUIRES,
  PlanOffersDiscount
    SOURCE KEY(plan_id) REFERENCES Plan(id)
    DESTINATION KEY(discount_id) REFERENCES Discount(id)
    LABEL OFFERS,
  ConditionEligibleForDiscount
    SOURCE KEY(condition_id) REFERENCES Condition(id)
    DESTINATION KEY(discount_id) REFERENCES Discount(id)
    LABEL ELIGIBLE_FOR
);

-- ========================================
-- 샘플 데이터 삽입
-- ========================================

-- 요금제 데이터
INSERT INTO Plan (id, name, price, data_limit, voice_limit, sharing_data)
VALUES 
  ('plan-001', '5G 시그니처', 130000, 999999, 999999, 120),
  ('plan-002', '5G 프리미어 슈퍼', 115000, 999999, 999999, 100),
  ('plan-003', '5G 프리미어 에센셜', 95000, 40, 999999, 10);

-- 요금제 카테고리 데이터
INSERT INTO PlanCategory (id, category_name, description)
VALUES
  ('cat-001', '5G 시그니처', '최고급 5G 요금제'),
  ('cat-002', '5G 프리미어', '프리미엄 5G 요금제');

-- 혜택 데이터
INSERT INTO Benefit (id, benefit_type, description, value)
VALUES
  ('ben-001', 'OTT', 'OTT 서비스 선택', '2개 선택'),
  ('ben-002', '스마트기기', '웨어러블/태블릿 무료', '2회선'),
  ('ben-003', '로밍', '해외 데이터 로밍 할인', '50%'),
  ('ben-004', 'OTT', 'OTT 서비스 선택', '1개 선택'),
  ('ben-005', '스마트기기', '웨어러블/태블릿 무료', '1회선');

-- 가입 조건 데이터
INSERT INTO Condition (id, condition_type, value, description)
VALUES
  ('cond-001', '나이', '만 19세 이상', '성인만 가입 가능'),
  ('cond-002', '신용등급', '6등급 이상', '신용 등급 제한'),
  ('cond-003', '약정기간', '24개월', '2년 약정'),
  ('cond-004', '나이', '만 34세 이하', '청년 할인 대상');

-- 할인 데이터
INSERT INTO Discount (id, discount_type, discount_rate, description)
VALUES
  ('disc-001', '선택약정', 0.25, '월정액의 25% 할인'),
  ('disc-002', '청년할인', 0.10, '만 34세 이하 10% 추가 할인'),
  ('disc-003', '가족결합', 0.15, '가족 2인 이상 15% 할인');

-- 요금제 → 카테고리 관계
INSERT INTO PlanBelongsTo (plan_id, category_id)
VALUES
  ('plan-001', 'cat-001'),
  ('plan-002', 'cat-002'),
  ('plan-003', 'cat-002');

-- 요금제 → 혜택 관계
INSERT INTO PlanIncludesBenefit (plan_id, benefit_id)
VALUES
  ('plan-001', 'ben-001'),  -- 5G 시그니처 → OTT 2개
  ('plan-001', 'ben-002'),  -- 5G 시그니처 → 스마트기기 2회선
  ('plan-001', 'ben-003'),  -- 5G 시그니처 → 로밍 50%
  ('plan-002', 'ben-004'),  -- 5G 프리미어 슈퍼 → OTT 1개
  ('plan-002', 'ben-005');  -- 5G 프리미어 슈퍼 → 스마트기기 1회선

-- 요금제 → 가입 조건 관계
INSERT INTO PlanRequiresCondition (plan_id, condition_id)
VALUES
  ('plan-001', 'cond-001'),  -- 만 19세 이상
  ('plan-001', 'cond-002'),  -- 신용등급 6등급 이상
  ('plan-001', 'cond-003'),  -- 24개월 약정
  ('plan-002', 'cond-001'),
  ('plan-002', 'cond-002'),
  ('plan-002', 'cond-003'),
  ('plan-003', 'cond-001'),
  ('plan-003', 'cond-002'),
  ('plan-003', 'cond-003');

-- 요금제 → 할인 관계
INSERT INTO PlanOffersDiscount (plan_id, discount_id)
VALUES
  ('plan-001', 'disc-001'),  -- 선택약정 할인
  ('plan-002', 'disc-001'),
  ('plan-003', 'disc-001');

-- 조건 → 할인 관계 (만 34세 이하 → 청년 할인)
INSERT INTO ConditionEligibleForDiscount (condition_id, discount_id)
VALUES
  ('cond-004', 'disc-002');

-- ========================================
-- 검증 쿼리 예시
-- ========================================

-- 1. 요금제별 카테고리 조회
-- GRAPH TelecomGraph
-- MATCH (p:Plan)-[:BELONGS_TO]->(c:PlanCategory)
-- RETURN p.name, c.category_name;

-- 2. 요금제별 혜택 조회
-- GRAPH TelecomGraph
-- MATCH (p:Plan)-[:INCLUDES]->(b:Benefit)
-- RETURN p.name, b.benefit_type, b.description, b.value;

-- 3. 요금제별 가입 조건 조회
-- GRAPH TelecomGraph
-- MATCH (p:Plan)-[:REQUIRES]->(c:Condition)
-- RETURN p.name, c.condition_type, c.value;

-- 4. 요금제별 할인 조회
-- GRAPH TelecomGraph
-- MATCH (p:Plan)-[:OFFERS]->(d:Discount)
-- RETURN p.name, d.discount_type, d.discount_rate;

-- 5. 특정 조건을 만족하면 받을 수 있는 할인 조회
-- GRAPH TelecomGraph
-- MATCH (c:Condition)-[:ELIGIBLE_FOR]->(d:Discount)
-- RETURN c.condition_type, c.value, d.discount_type, d.discount_rate;
