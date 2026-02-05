import base64
import requests

def render_mermaid(mermaid_code: str) -> str:
    """
    Renders mermaid code into an image URL using mermaid.ink.
    
    Args:
        mermaid_code: The mermaid diagram code.
        
    Returns:
        The URL of the rendered image.
    """
    try:
        # Remove any leading/trailing whitespace
        mermaid_code = mermaid_code.strip()
        
        # UTF-8 encoding is required for Korean characters
        mermaid_code_bytes = mermaid_code.encode("utf-8")
        base64_bytes = base64.b64encode(mermaid_code_bytes)
        base64_string = base64_bytes.decode("utf-8")
        
        # mermaid.ink URL format: https://mermaid.ink/img/BASE64_CODE
        image_url = f"https://mermaid.ink/img/{base64_string}"
        
        return image_url
    except Exception as e:
        return f"Error rendering mermaid: {str(e)}"

if __name__ == "__main__":
    # Test
    code = """
    graph TD
        A[Christmas] -->|Get money| B(Go shopping)
        B --> C{Let me think}
        C -->|One| D[Laptop]
        C -->|Two| E[iPhone]
        C -->|Three| F[fa:fa-car Car]
    """
    print(render_mermaid(code))
