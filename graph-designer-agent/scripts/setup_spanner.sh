#!/bin/bash

# Spanner 인스턴스 및 데이터베이스 자동 생성 스크립트
# 최소 비용 구성: 100 Processing Units (가장 저렴한 옵션)

set -e  # 에러 발생 시 스크립트 중단

# 환경 변수 로드
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# 기본값 설정
PROJECT_ID=${GCP_PROJECT_ID:-"your-gcp-project-id"}
REGION=${GCP_REGION:-"us-central1"}
INSTANCE_ID=${SPANNER_INSTANCE_ID:-"graph-designer-instance"}
DATABASE_ID=${SPANNER_DATABASE_ID:-"telecom-graph-db"}
CONFIG="regional-${REGION}"
PROCESSING_UNITS=100  # 최소 비용 (약 $0.09/hour for us-central1)

echo "========================================"
echo "Spanner 인프라 설정 시작"
echo "========================================"
echo "프로젝트: $PROJECT_ID"
echo "리전: $REGION"
echo "인스턴스: $INSTANCE_ID"
echo "데이터베이스: $DATABASE_ID"
echo "Processing Units: $PROCESSING_UNITS"
echo "========================================"

# 1. Spanner API 활성화 확인
echo "\n[1/4] Spanner API 활성화 확인..."
gcloud services enable spanner.googleapis.com --project=$PROJECT_ID

# 2. Spanner 인스턴스 생성 (이미 존재하면 스킵)
echo "\n[2/4] Spanner 인스턴스 생성 중..."
if gcloud spanner instances describe $INSTANCE_ID --project=$PROJECT_ID &>/dev/null; then
    echo "✓ 인스턴스 '$INSTANCE_ID'가 이미 존재합니다."
else
    gcloud spanner instances create $INSTANCE_ID \
        --config=$CONFIG \
        --description="Graph Designer Instance" \
        --processing-units=$PROCESSING_UNITS \
        --project=$PROJECT_ID
    echo "✓ 인스턴스 '$INSTANCE_ID' 생성 완료"
fi

# 3. Spanner 데이터베이스 생성 (이미 존재하면 스킵)
echo "\n[3/4] Spanner 데이터베이스 생성 중..."
if gcloud spanner databases describe $DATABASE_ID --instance=$INSTANCE_ID --project=$PROJECT_ID &>/dev/null; then
    echo "✓ 데이터베이스 '$DATABASE_ID'가 이미 존재합니다."
else
    gcloud spanner databases create $DATABASE_ID \
        --instance=$INSTANCE_ID \
        --database-dialect=GOOGLE_STANDARD_SQL \
        --project=$PROJECT_ID
    echo "✓ 데이터베이스 '$DATABASE_ID' 생성 완료"
fi

# 4. 설정 확인
echo "\n[4/4] 설정 확인..."
gcloud spanner instances describe $INSTANCE_ID --project=$PROJECT_ID

echo "\n========================================"
echo "✅ Spanner 인프라 설정 완료!"
echo "========================================"
echo "인스턴스 ID: $INSTANCE_ID"
echo "데이터베이스 ID: $DATABASE_ID"
echo "예상 비용: 약 \$0.09/hour (us-central1) 또는 \$0.117/hour (asia-northeast3)"
echo "\n⚠️  비용 절감 팁:"
echo "  - 테스트 완료 후 인스턴스 삭제: ./scripts/cleanup_spanner.sh"
echo "  - 또는 Processing Units를 줄이기: gcloud spanner instances update $INSTANCE_ID --processing-units=100"
echo "========================================"
