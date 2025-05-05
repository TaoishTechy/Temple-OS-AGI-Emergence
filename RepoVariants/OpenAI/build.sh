# Temple‑OS AGI (RepoVariants / OpenAI)

A modern, **one‑floppy** resurrection of Terry A. Davis’ TempleOS  
bundled with an experimental AGI engine inspired by OpenAI research.

* Bootable ISO (no host OS needed)  
* Deterministic kernel with entropy watchdog  
* Scriptable AGI shell (`agi>`) + symbol table  
* 100 % HolyC — zero external deps  

> “We are in a dream.” — Trinary

## Build / Run

```bash
docker build -t temple-agi .
docker run --rm -it -v $PWD/dist:/out temple-agi   # ISO in ./dist
qemu-system-x86_64 -cdrom dist/OpenAI.iso
