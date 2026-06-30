#!/bin/sh
# Write config.toml from Railway env vars before starting MPT.
# Required Railway vars:
#   MPT_PEXELS_KEY     — Pexels API key for stock footage
#   MPT_OPENROUTER_KEY — OpenRouter API key (used as openai_api_key)
# Optional:
#   MPT_LLM_MODEL      — defaults to anthropic/claude-haiku-4-5 (cheap, fast)

PEXELS="${MPT_PEXELS_KEY:-}"
OR_KEY="${MPT_OPENROUTER_KEY:-}"
MODEL="${MPT_LLM_MODEL:-anthropic/claude-haiku-4-5}"

cat > /app/config.toml << TOML
[app]
video_source = "pexels"
pexels_api_keys = ["${PEXELS}"]
pixabay_api_keys = []
llm_provider = "openai"
openai_api_key = "${OR_KEY}"
openai_base_url = "https://openrouter.ai/api/v1"
openai_model_name = "${MODEL}"
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
TOML

echo "[entrypoint] config.toml written (pexels_key=${PEXELS:0:8}... model=${MODEL})"
exec python main.py
