# Codebase Overview & How to Change the Command Name

---

## Monorepo structure

This is a **Bun workspace monorepo**. All packages live under `packages/`.

```
blueberrycode/
├── packages/
│   ├── opencode/          ← Main CLI + TUI (the core of everything)
│   ├── app/               ← Web SPA (Solid.js + Vite)
│   ├── ui/                ← Shared UI component library
│   ├── util/              ← Shared utility helpers
│   ├── sdk/js/            ← TypeScript SDK (client + server bindings)
│   ├── plugin/            ← Plugin system / base plugin interface
│   ├── script/            ← Build/dev script utilities
│   ├── web/               ← Marketing website (Astro)
│   ├── desktop/           ← Desktop app (Tauri)
│   ├── desktop-electron/  ← Desktop app (Electron alternative)
│   ├── storybook/         ← UI component showcase
│   ├── slack/             ← Slack bot integration
│   ├── enterprise/        ← Enterprise backend (Hono)
│   ├── function/          ← Cloudflare Workers serverless functions
│   └── console/
│       ├── app/           ← Admin console UI (Solid Start)
│       ├── core/          ← Console backend + database
│       ├── function/      ← Console serverless functions
│       ├── mail/          ← Email service
│       └── resource/      ← Resource management
├── docs/                  ← Project documentation (this folder)
├── .opencode/             ← Custom branding overrides
└── bun.lock               ← Lockfile
```

---

## Package responsibilities

| Package | What it does |
|---------|-------------|
| `packages/opencode` | CLI binary, TUI, server, all AI provider integrations |
| `packages/app` | Browser-based interface to the opencode server |
| `packages/ui` | Solid.js components, themes, icons shared by app + console |
| `packages/util` | Error types, small helpers used across all packages |
| `packages/sdk/js` | TypeScript client/server SDK, v2 API bindings |
| `packages/plugin` | Plugin base interface, TUI plugin support |
| `packages/script` | Shared build utilities (version, channel, release flags) |
| `packages/web` | opencode.ai website and docs (Astro) |
| `packages/desktop` | Tauri desktop wrapper around the web app |
| `packages/desktop-electron` | Electron desktop wrapper (Windows/Linux/macOS) |
| `packages/slack` | Slack Bolt integration |
| `packages/enterprise` | Enterprise API server |
| `packages/function` | Edge/serverless functions (Cloudflare Workers) |
| `packages/console/*` | SaaS management console (UI + backend + functions) |

---

## How the CLI works (`packages/opencode`)

### Entry chain

```
bin/opencode  (or  bin/blueberrycode)
  └── Node.js wrapper that finds the platform binary
        └── dist/opencode-windows-x64/bin/opencode.exe
              └── src/index.ts  (yargs CLI setup)
                    └── TuiThreadCommand  (default: $0 [project])
                          └── spawns a Worker thread  (worker.ts)
                                └── worker starts an HTTP server
                                      └── tui()  (app.tsx)
                                            └── @opentui/solid renderer
                                                  └── Solid.js component tree
```

### `src/index.ts` — CLI registration

This is where yargs is configured. It sets the script name, version, global flags, and registers every command:

```
opencode                → TuiThreadCommand   (default, starts TUI)
opencode attach <url>   → AttachCommand      (connect to remote server)
opencode serve          → ServeCommand       (start server only)
opencode run            → RunCommand
opencode generate       → GenerateCommand
opencode models         → ModelsCommand
opencode providers      → ProvidersCommand
opencode agent          → AgentCommand
opencode session        → SessionCommand
opencode plugin         → PluginCommand
opencode mcp            → McpCommand
opencode acp            → AcpCommand
opencode console        → ConsoleCommand
opencode github         → GithubCommand
opencode pr             → PrCommand
opencode stats          → StatsCommand
opencode export         → ExportCommand
opencode import         → ImportCommand
opencode debug          → DebugCommand
opencode db             → DbCommand
opencode web            → WebCommand
opencode upgrade        → UpgradeCommand
opencode uninstall      → UninstallCommand
```

### `src/cli/cmd/tui/app.tsx` — TUI rendering

The TUI is a Solid.js component tree rendered into the terminal via `@opentui/solid`. Key providers (outside-in):

```
ErrorBoundary → ArgsProvider → ExitProvider → KVProvider → ToastProvider
  → RouteProvider → TuiConfigProvider → SDKProvider → SyncProvider
    → ThemeProvider → LocalProvider → KeybindProvider → PromptStashProvider
      → DialogProvider → CommandProvider → FrecencyProvider
        → PromptHistoryProvider → PromptRefProvider → <App />
```

`<App />` manages the two main views: **home** (session list) and **session** (active chat).

---

## How to change the command name

Every place that needs to change when renaming the command (e.g. `opencode` → `blueberrycode`):

### 1. `packages/opencode/package.json` — bin registration

```json
"bin": {
  "opencode": "./bin/opencode",
  "blueberrycode": "./bin/blueberrycode"
}
```

Add or rename the entry. This is what `npm install -g` / `bun link` uses to create the command on PATH.

### 2. `packages/opencode/bin/` — the bin wrapper script

`bin/blueberrycode` is the Node.js wrapper that resolves and runs the compiled exe.
`bin/opencode` is the original upstream wrapper (looks for platform-specific binaries in `node_modules`).

Both support an env var override:
- `OPENCODE_BIN_PATH` — override for the `opencode` wrapper
- `BLUEBERRYCODE_BIN_PATH` — override for the `blueberrycode` wrapper

### 3. `packages/opencode/src/index.ts` line 67 — yargs script name

```ts
.scriptName("opencode")   // ← change to "blueberrycode"
```

This controls what name appears in `--help` output and error messages.

### 4. `packages/opencode/src/index.ts` line 57 — help output guard

```ts
if (!text.startsWith("opencode ")) {   // ← change to "blueberrycode "
```

This condition controls when the ASCII logo is shown vs suppressed in help text.

### 5. `packages/opencode/script/install-global.ps1` — Windows global install

Run this after every build to update the exe in your PATH:

```powershell
powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1
```

It copies `dist/opencode-windows-x64/bin/opencode.exe` → `%LOCALAPPDATA%\blueberrycode\bin\blueberrycode.exe`.

---

## Full checklist to rename the command

| # | File | What to change |
|---|------|----------------|
| 1 | `packages/opencode/package.json` | Add/rename entry in `"bin"` field |
| 2 | `packages/opencode/bin/<name>` | Create or copy bin wrapper script, update `BLUEBERRYCODE_BIN_PATH` env var name if desired |
| 3 | `packages/opencode/src/index.ts:67` | `.scriptName("your-command")` |
| 4 | `packages/opencode/src/index.ts:57` | `text.startsWith("your-command ")` |
| 5 | Rebuild exe | `bun run --cwd packages/opencode script/build-win.ts` |
| 6 | Reinstall globally | `powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1` |
| 7 | Restart terminal | PATH changes only take effect in new terminal sessions |

---

## Development commands

```bash
# Install all dependencies (run from repo root)
bun install

# Run the CLI in dev mode (no build needed)
bun run --cwd packages/opencode dev

# Build the Windows exe
bun run --cwd packages/opencode script/build-win.ts

# Install blueberrycode.exe globally on Windows
powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1

# Type check
bun run --cwd packages/opencode typecheck

# Run tests
bun run --cwd packages/opencode test

# Run web app
bun run --cwd packages/app dev

# Run console app
bun run --cwd packages/console/app dev
```

---

## Key environment variables

| Variable | Package | Purpose |
|----------|---------|---------|
| `OPENCODE_BIN_PATH` | bin/opencode | Override which binary the opencode wrapper runs |
| `BLUEBERRYCODE_BIN_PATH` | bin/blueberrycode | Override which binary blueberrycode runs |
| `OPENCODE_MODELS_URL` | script/generate.ts | Custom URL for models snapshot fetch |
| `MODELS_DEV_API_JSON` | script/generate.ts | Path to local models JSON (offline build) |
| `OPENCODE_DISABLE_MOUSE` | app.tsx | Disable mouse support in TUI |
| `OPENCODE_SERVER_PASSWORD` | cmd/tui/attach.ts | Auth password for `attach` command |
