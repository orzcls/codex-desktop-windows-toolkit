# Image Generation Record

## Prompt Compiler

The README hero used the `gpt-image-2-style-library` `infographic-engine` direction and guizang Swiss-style constraints:

- technical infographic, not photography
- white paper background, thin grid
- one IKB blue accent plus small safety-orange status markers
- straight lines, right angles, no shadows, no gradients
- modules for Computer Use, Browser Runtime, and Goal Mode

## GPTGod Attempt

Command family:

```powershell
python C:\Users\admin\.codex\skills\gptgod-draw\scripts\gptgod_draw.py --model gpt-image-2-vip --size 1536x1024 --quality high
```

Result:

- Model listing succeeded.
- Generation failed with `RemoteDisconnected: Remote end closed connection without response`.

## Fallback

A deterministic local PNG was generated at `assets/readme/codex-windows-toolkit-hero-v2.png` using the same visual direction. This keeps the README publishable without committing API responses, credentials, or remote artifacts.
