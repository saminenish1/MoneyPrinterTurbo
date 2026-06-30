#!/bin/bash
# Write config.toml from Railway env vars, then start MPT.
# Required env var: MPT_PEXELS_KEY

python3 - << 'PYEOF'
import os, pathlib, sys

pexels = os.environ.get("MPT_PEXELS_KEY", "")
if not pexels:
    print("[entrypoint] WARNING: MPT_PEXELS_KEY not set — stock footage will fail")

# Find config.toml location (same dir as this script or cwd)
script_dir = pathlib.Path(__file__).parent.resolve()
config_path = script_dir / "config.toml"

config = f"""[app]
video_source = "pexels"
pexels_api_keys = ["{pexels}"]
pixabay_api_keys = []
llm_provider = "openai"
openai_api_key = "unused"
openai_base_url = "https://openrouter.ai/api/v1"
openai_model_name = "anthropic/claude-haiku-4-5"
subtitle_provider = "edge"
max_concurrent_tasks = 3
max_queued_tasks = 20
video_codec = "libx264"
tls_verify = true

[whisper]
model_size = "large-v3"
device = "CPU"
compute_type = "int8"

[proxy]

[azure]
speech_key = ""
speech_region = ""

[ui]
language = "en"
tts_server = "edge"
voice_name = "en-US-GuyNeural-Male"
font_name = "MicrosoftYaHeiBold.ttc"
subtitle_position = "bottom"
text_fore_color = "#FFFFFF"
font_size = 60
subtitle_background_enabled = true
subtitle_background_color = "#000000"
"""

config_path.write_text(config)
print(f"[entrypoint] config.toml written to {config_path} (pexels={pexels[:8]}...)")
PYEOF

exec python3 main.py
