#!/bin/bash

# Spanner 리소스 정리 스크립트 (비용 절감)

set -e

# 환경 변수 로드
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

PROJECT_ID=${GCP_PROJECT_ID:-"your-gcp-project-id"}
INSTANCE_ID=${SPANNER_INSTANCE_ID:-"graph-designer-instance"}

echo "⚠️  경고: Spanner 인스턴스를 삭제하려고 합니다."
echo "인스턴스: $INSTANCE_ID"
echo "프로젝트: $PROJECT_ID"
read -p "계속하시겠습니까? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    echo "\nSpanner 인스턴스 삭제 중..."
    gcloud spanner instances delete $INSTANCE_ID --project=$PROJECT_ID --quiet
    echo "✅ 인스턴스 '$INSTANCE_ID' 삭제 완료"
else
    echo "취소되었습니다."
fi
