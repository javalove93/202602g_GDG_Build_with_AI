#!/bin/bash

# 가상환경 활성화 시도
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/../.venv"

if [ -d "$VENV_DIR" ]; then
    source "$VENV_DIR/bin/activate"
fi

# Python 스크립트 실행
python3 "$SCRIPT_DIR/query_spanner.py" "$@"
