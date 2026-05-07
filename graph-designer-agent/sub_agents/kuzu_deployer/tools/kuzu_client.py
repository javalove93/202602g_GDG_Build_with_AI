"""Kùzu Embedded Graph DB 래퍼 모듈"""

import os
from typing import List, Dict, Any, Optional
import kuzu

class KuzuGraphClient:
    """Kùzu Graph 작업을 위한 클라이언트 래퍼"""
    
    def __init__(self, db_path: str = "./kuzu_db"):
        """초기화
        
        Args:
            db_path: Kuzu 데이터베이스 파일이 저장될 로컬 디렉토리 경로
        """
        self.db_path = db_path
        
        # 디렉토리가 없으면 생성
        if not os.path.exists(self.db_path):
            os.makedirs(self.db_path)
            
        self.db = kuzu.Database(self.db_path)
        self.conn = kuzu.Connection(self.db)
    
    def deploy_ddl(self, ddl_statements: List[str]) -> bool:
        """DDL을 Kuzu에 배포 (Node/Rel Table 생성)
        
        Args:
            ddl_statements: Kuzu Cypher DDL 문장 리스트 (CREATE NODE TABLE, CREATE REL TABLE 등)
            
        Returns:
            성공 여부
        """
        try:
            print(f"DDL 배포 시작: {len(ddl_statements)}개 문장")
            for statement in ddl_statements:
                stmt = statement.strip()
                if stmt:
                    self.conn.execute(stmt)
            print("✅ DDL 배포 완료")
            return True
        except Exception as e:
            print(f"❌ DDL 배포 실패: {e}")
            return False
    
    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        """Cypher 쿼리 실행 (조회, 데이터 삽입 등)
        
        Args:
            query: Cypher 쿼리 문자열
            
        Returns:
            쿼리 결과 (딕셔너리 리스트)
        """
        try:
            results = self.conn.execute(query)
            
            # 결과가 없는 경우 처리 (예: INSERT, CREATE 쿼리)
            if not results.has_next():
                return [{"status": "success", "message": "Query executed successfully, but no return values."}]

            output = []
            while results.has_next():
                row = results.get_next()
                # 컬럼 이름 추출
                cols = results.get_column_names()
                row_dict = dict(zip(cols, row))
                output.append(row_dict)
            return output
        except Exception as e:
            print(f"❌ 쿼리 실행 실패: {e}")
            return [{"error": str(e)}]

def deploy_kuzu_ddl(ddl: str) -> str:
    """Kuzu Graph DDL(CREATE NODE TABLE 등)을 배포합니다.
    
    Args:
        ddl: 실행할 DDL 문장 (세미콜론으로 구분된 여러 문장 가능)
    """
    client = KuzuGraphClient()
    statements = [s.strip() for s in ddl.split(";") if s.strip()]
    if client.deploy_ddl(statements):
        return "✅ DDL 배포 성공"
    else:
        return "❌ DDL 배포 실패"

def execute_kuzu_query(query: str) -> str:
    """Kuzu 쿼리(Cypher)를 실행합니다.
    
    Args:
        query: 실행할 Cypher 쿼리 문자열
    """
    client = KuzuGraphClient()
    results = client.execute_query(query)
    if not results:
        return "결과가 없거나 오류가 발생했습니다."
    return str(results)
