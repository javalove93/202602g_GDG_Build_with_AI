#!/bin/bash

# .env 파일 위치 설정 (스크립트 위치 기준)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [ -f "$ENV_FILE" ]; then
    # .env 파일 로드 (주석과 빈 줄 제외)
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ ]] && continue
        [[ -z "$key" ]] && continue
        export "$key=$value"
    done < "$ENV_FILE"

    echo "========================================"
    echo "   Google Cloud Spanner 정보"
    echo "========================================"
    echo "Project ID  : $GCP_PROJECT_ID"
    echo "Instance ID : $SPANNER_INSTANCE_ID"
    echo "Database ID : $SPANNER_DATABASE_ID"
    echo "Region      : $GCP_REGION"
    echo "========================================"
    echo "에이전트에게 위 정보를 그대로 복사해서 전달하세요."
else
    echo "오류: $ENV_FILE 파일을 찾을 수 없습니다."
    exit 1
fi
