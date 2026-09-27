# AGENTS.md

Tiny Mojo playground managed with pixi. No tests, lint, CI, or build config.

## Env

- Toolchain comes from pixi (`pixi.toml`: `mojo >=1.0.0,<2`, `linux-64` only). `mojo` is NOT on PATH — always run via `pixi run`.
- No `[tasks]` defined; invoke tools directly: `pixi run -- <cmd>`.

## Commands

- Run a file: `pixi run -- mojo <file>.mojo` (e.g. `pixi run -- mojo main.mojo`)
- Check version: `pixi run -- mojo --version`
- `gpu_add.mojo` requires a GPU (`has_accelerator()` guard prints "No compatible GPU found" otherwise).

## Layout

- `main.mojo`, `vector_add.mojo`, `gpu_add.mojo` — standalone scripts, each with its own `main()`. No shared modules or package structure.
- `gpu_add.mojo` is the only non-trivial example (DeviceContext vector-add kernel).

## Skills

- `.agents/skills/` holds Modular Mojo/MAX skills (untracked in git, see `skills-lock.json`). Load `mojo-syntax` before writing Mojo; add `mojo-gpu-fundamentals` for GPU code, `mojo-python-interop` for Python interop.
