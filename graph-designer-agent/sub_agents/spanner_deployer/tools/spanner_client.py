"""Spanner Python SDK 래퍼 모듈"""

import os
from typing import List, Dict, Any
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types


class SpannerGraphClient:
    """Spanner Graph 작업을 위한 클라이언트 래퍼"""
    
    def __init__(
        self,
        project_id: str = None,
        instance_id: str = None,
        database_id: str = None
    ):
        """초기화
        
        Args:
            project_id: GCP 프로젝트 ID (기본값: 환경 변수)
            instance_id: Spanner 인스턴스 ID (기본값: 환경 변수)
            database_id: 데이터베이스 ID (기본값: 환경 변수)
        """
        self.project_id = project_id or os.getenv("GCP_PROJECT_ID")
        self.instance_id = instance_id or os.getenv("SPANNER_INSTANCE_ID")
        self.database_id = database_id or os.getenv("SPANNER_DATABASE_ID")
        
        if not all([self.project_id, self.instance_id, self.database_id]):
            raise ValueError(
                "프로젝트 ID, 인스턴스 ID, 데이터베이스 ID가 필요합니다. "
                "환경 변수 또는 인자로 제공하세요."
            )
        
        self.client = spanner.Client(project=self.project_id)
        self.instance = self.client.instance(self.instance_id)
        self.database = self.instance.database(self.database_id)
    
    def deploy_ddl(self, ddl_statements: List[str], timeout: int = 300) -> bool:
        """DDL을 Spanner에 배포
        
        Args:
            ddl_statements: DDL 문장 리스트
            timeout: 타임아웃 (초)
            
        Returns:
            성공 여부
        """
        try:
            print(f"DDL 배포 시작: {len(ddl_statements)}개 문장")
            operation = self.database.update_ddl(ddl_statements)
            operation.result(timeout=timeout)
            print("✅ DDL 배포 완료")
            return True
        except Exception as e:
            print(f"❌ DDL 배포 실패: {e}")
            return False
    
    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        """SQL 쿼리 실행
        
        Args:
            query: SQL 쿼리 문자열
            
        Returns:
            쿼리 결과 (딕셔너리 리스트)
        """
        with self.database.snapshot() as snapshot:
            results = snapshot.execute_sql(query)
            return [dict(row) for row in results]
    
    def execute_graph_query(self, graph_query: str) -> List[Dict[str, Any]]:
        """Graph 쿼리 실행
        
        Args:
            graph_query: Graph 쿼리 문자열 (GRAPH ... MATCH ... RETURN ...)
            
        Returns:
            쿼리 결과
        """
        return self.execute_query(graph_query)
    
    def insert_data(self, table: str, columns: List[str], values: List[List[Any]]) -> bool:
        """데이터 삽입
        
        Args:
            table: 테이블 이름
            columns: 컬럼 리스트
            values: 값 리스트 (각 행은 리스트)
            
        Returns:
            성공 여부
        """
        try:
            with self.database.batch() as batch:
                batch.insert(
                    table=table,
                    columns=columns,
                    values=values
                )
            print(f"✅ {table}에 {len(values)}개 행 삽입 완료")
            return True
        except Exception as e:
            print(f"❌ 데이터 삽입 실패: {e}")
            return False
    
    def get_ddl(self) -> List[str]:
        """현재 데이터베이스의 DDL 조회
        
        Returns:
            DDL 문장 리스트
        """
        return self.database.ddl_statements
    
    def table_exists(self, table_name: str) -> bool:
        """테이블 존재 여부 확인
        
        Args:
            table_name: 테이블 이름
            
        Returns:
            존재 여부
        """
        query = f"""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name = '{table_name}'
        """
        results = self.execute_query(query)
        return len(results) > 0


# 사용 예시
if __name__ == "__main__":
    # 환경 변수에서 설정 로드
    client = SpannerGraphClient()
    
    # DDL 배포
    ddl = [
        """
        CREATE TABLE Plan (
          id STRING(36) NOT NULL,
          name STRING(100),
          price INT64,
        ) PRIMARY KEY (id)
        """,
        """
        CREATE PROPERTY GRAPH TelecomGraph
        NODE TABLES (Plan)
        """
    ]
    client.deploy_ddl(ddl)
    
    # 데이터 삽입
    client.insert_data(
        table="Plan",
        columns=["id", "name", "price"],
        values=[
            ["plan-001", "5G 시그니처", 130000],
            ["plan-002", "5G 프리미어", 95000],
        ]
    )
    
    # 쿼리 실행
    results = client.execute_query("SELECT * FROM Plan")
    print(results)
