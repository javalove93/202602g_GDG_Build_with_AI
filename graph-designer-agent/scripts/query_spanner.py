import os
import sys
from google.cloud import spanner
from dotenv import load_dotenv

# .env 파일 로드
load_dotenv(os.path.join(os.path.dirname(__file__), '../.env'))

def query_spanner(query=None):
    project_id = os.getenv('GCP_PROJECT_ID')
    instance_id = os.getenv('SPANNER_INSTANCE_ID')
    database_id = os.getenv('SPANNER_DATABASE_ID')

    if not all([project_id, instance_id, database_id]):
        print("오류: .env 파일에 GCP_PROJECT_ID, SPANNER_INSTANCE_ID, SPANNER_DATABASE_ID가 설정되어 있어야 합니다.")
        return

    client = spanner.Client(project=project_id)
    instance = client.instance(instance_id)
    database = instance.database(database_id)

    if not query:
        # 기본 정보 조회: 테이블 목록 및 행 수
        print(f"--- Database: {database_id} ---")
        # 테이블 목록 조회를 위해 별도의 스냅샷 또는 개별 실행을 사용하거나
        # 여러 쿼리를 위해 multi-use snapshot을 사용합니다.
        with database.snapshot(multi_use=True) as snapshot:
            results = snapshot.execute_sql(tables_query)
            tables = [row[0] for row in results]
            
            if not tables:
                print("생성된 테이블이 없습니다.")
                return

            for table in tables:
                count_query = f"SELECT COUNT(*) FROM {table}"
                count_res = snapshot.execute_sql(count_query)
                count = list(count_res)[0][0]
                print(f"Table: {table:<20} | Rows: {count}")
    else:
        # 사용자 정의 쿼리 실행
        try:
            with database.snapshot() as snapshot:
                results = snapshot.execute_sql(query)
                
                # 결과 출력
                first_row = True
                for row in results:
                    if first_row:
                        # 컬럼명 출력 (results.fields가 존재할 경우)
                        if hasattr(results, 'fields'):
                            cols = [field.name for field in results.fields]
                            print(" | ".join(cols))
                            print("-" * (len(" | ".join(cols)) + 4))
                        first_row = False
                    print(" | ".join(map(str, row)))
                
                if first_row:
                    print("결과가 없습니다.")
        except Exception as e:
            print(f"쿼리 실행 오류: {e}")

if __name__ == "__main__":
    user_query = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else None
    query_spanner(user_query)
