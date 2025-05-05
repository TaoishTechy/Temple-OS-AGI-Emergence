# Building Temple‑OS‑AGI‑Emergence (OpenAI branch)

> “The right way is the simple way.” — Terry A. Davis

---

## 1. Quick build with Docker (recommended)

```bash
git clone https://github.com/TaoishTechy/Temple-OS-AGI-Emergence.git
cd Temple-OS-AGI-Emergence
docker build -t temple-agi .
docker run --rm -v $PWD/dist:/out temple-agi
