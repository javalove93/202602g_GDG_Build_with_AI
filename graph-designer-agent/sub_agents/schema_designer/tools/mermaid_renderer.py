import base64
import json
from typing import Optional

def render_mermaid(mermaid_code: str, theme: str = "default") -> str:
    """Mermaid 코드를 이미지 URL로 변환합니다.
    
    Args:
        mermaid_code: Mermaid 다이어그램 코드
        theme: Mermaid 테마 (default, forest, dark, neutral)
        
    Returns:
        렌더링된 이미지 URL
    """
    # Mermaid.ink는 base64로 인코딩된 JSON 또는 코드를 받습니다.
    # 여기서는 가장 간단한 방식인 base64 인코딩을 사용합니다.
    
    # 코드를 바이트로 변환
    code_bytes = mermaid_code.encode("utf-8")
    
    # Base64 인코딩
    base64_bytes = base64.b64encode(code_bytes)
    base64_string = base64_bytes.decode("utf-8")
    
    # URL 생성 (mermaid.ink 사용)
    image_url = f"https://mermaid.ink/img/{base64_string}"
    
    # 테마 적용 (옵션)
    if theme != "default":
        image_url += f"?theme={theme}"
        
    return image_url

if __name__ == "__main__":
    # 테스트
    test_code = "graph TD; A-->B; B-->C; C-->A;"
    print(render_mermaid(test_code))
