# How to Build the Windows Executable

The Windows binary (`opencode.exe`) is produced by `packages/opencode/script/build-win.ts` using **Bun's native compile** feature. It cross-compiles to `bun-windows-x64` and embeds everything into a single self-contained `.exe`.

> **Important:** the output binary is large (~150 MB) and is excluded from git via `.gitignore`. Never commit it.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Bun](https://bun.sh) ≥ 1.1 | Must support `bun-windows-x64` compile target |
| Node / npm | Only needed by some native deps (`node-gyp` is external, not bundled) |
| Internet access | `generate.ts` fetches the models snapshot from `https://models.dev/api.json` |

### Installing with Chocolatey (Windows)

If you don't have Chocolatey installed yet, open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Then install Bun and Node in the same elevated shell:

```powershell
choco install bun -y
choco install nodejs -y
```

Restart your terminal after installation so the new PATH entries take effect, then verify:

```bash
bun --version
node --version
```

---

## Install repo dependencies

Run this once from the **repo root** before building:

```bash
bun install
```

---

## Build steps

### 1. Run the build script

From the **repo root**:

```bash
bun run --cwd packages/opencode script/build-win.ts
```

Or from inside `packages/opencode`:

```bash
cd packages/opencode
bun run script/build-win.ts
```

### 2. What the script does

1. **`generate.ts`** — fetches `https://models.dev/api.json` and writes `src/provider/models-snapshot.js` (auto-generated, never edit by hand).
2. **`Bun.build()`** — compiles the app with `compile.target = "bun-windows-x64"`, bundles all entrypoints, and embeds migrations and version info.
3. Outputs the binary to:

```
packages/opencode/dist/opencode-windows-x64/bin/opencode.exe
```

---

## Output location

```
packages/opencode/
└── dist/
    └── opencode-windows-x64/
        └── bin/
            └── opencode.exe   ← final binary
```

---

## Using a local models snapshot (offline build)

If you don't have internet access, point `generate.ts` at a local copy of `api.json`:

```bash
MODELS_DEV_API_JSON=/path/to/api.json bun run script/build-win.ts
```

Or set a custom models URL:

```bash
OPENCODE_MODELS_URL=https://your-mirror.example.com bun run script/build-win.ts
```

---

## Changing the version or channel

The script reads `version` from `packages/opencode/package.json` and hardcodes `channel: "dev"` and `release: false`.

To change the version, update `package.json`:

```json
{
  "version": "1.4.3"
}
```

To change the channel or mark it as a release, edit `build-win.ts`:

```ts
const Script = {
  version: pkg.version,
  channel: "stable",   // ← change here
  release: true,        // ← change here
}
```

---

## Embedded data

The following values are baked into the binary at build time via `define`:

| Define key | Value |
|------------|-------|
| `OPENCODE_VERSION` | `package.json` → `version` |
| `OPENCODE_CHANNEL` | `"dev"` (or what you set) |
| `OPENCODE_MIGRATIONS` | All SQL migration files under `migration/` |
| `OPENCODE_WORKER_PATH` | TUI parser worker path |

---

## Troubleshooting

**Build fails with "Build failed"**
- Check the logs printed to stdout — Bun will show which module failed.
- Make sure `bun install` was run from the repo root so all workspace deps are available.

**`parser.worker.js` not found**
- The script looks for it in `node_modules/@opentui/core/` — either local to `packages/opencode` or at the repo root. Run `bun install` again.

**`generate.ts` fetch fails**
- Use the `MODELS_DEV_API_JSON` env var to supply a local file (see above).

**`choco` is not recognized**
- Make sure you ran the Chocolatey install in an **elevated** PowerShell session and restarted the terminal.

**Binary is too large / want to inspect contents**
- The `.exe` is a Bun standalone binary. You cannot easily unpack it, but you can inspect the source at `packages/opencode/src/index.ts` and trace entrypoints from there.
