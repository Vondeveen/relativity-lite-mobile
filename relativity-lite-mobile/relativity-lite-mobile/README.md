# Relativity‑lite Mobile (Offline)

A free Android app (Flutter) for basic eDiscovery-style workflows:
- Import TXT/PDF files
- Extract text (embedded PDF text only — no OCR)
- Keyword search with highlights
- Tagging: Responsiveness, Privilege, Issues (multi-select)
- Export a JSON of your coded set

Everything is offline, on-device. No cost, no server.

## Build online (no installs)
1. Create a GitHub repo, upload this ZIP (extract contents preserving folders).
2. Ensure the included GitHub Actions workflow is present at `.github/workflows/android-apk.yml`.
3. Push/commit → download `app-debug.apk` from the **Actions** artifact.
   - If uploading via the GitHub UI, drag the entire folder structure; or use Git to push.
   - After the first run, open **Actions** → latest run → **Artifacts** → `app-debug.apk`.

## Supported formats
- **TXT** (plain text)
- **PDF** with **embedded text** (image-only PDFs will import but text will be empty; OCR is out-of-scope to stay free/offline)

## Roadmap (still free)
- CSV export
- Hit highlighting in the viewer
- Basic biometric lock
- Simple stopwords/proximity search
