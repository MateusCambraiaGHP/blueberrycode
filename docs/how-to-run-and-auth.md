# How to Run OpenCode and Configure Auth

---

## 1. Install OpenCode

Open **PowerShell as Administrator** and run:

```powershell
choco install opencode -y
```

If you don't have Chocolatey yet, install it first:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

## 2. Install a compatible terminal

OpenCode requires a modern terminal with full Unicode and true-color support. Two recommended options:

**WezTerm** (recommended)
```powershell
choco install wezterm -y
```

**Ghostty** (alternative)
```powershell
choco install ghostty -y
```

> Do **not** use the default Windows Terminal or `cmd.exe` — the TUI will not render correctly.

---

## 3. Authenticate

Open WezTerm (or Ghostty) and log in with your AI provider.

**OpenAI:**
```bash
opencode auth login
```

Follow the prompts — it will open a browser tab to complete OAuth or ask you to paste an API key depending on the provider.

To check which accounts are currently authenticated:
```bash
opencode auth list
```

To remove an account:
```bash
opencode auth logout
```

---

## 4. Navigate to your project and start

```bash
cd C:\path\to\your\fork
opencode /init
```

`/init` creates an `opencode.json` config file at the project root and starts the TUI session.

For subsequent sessions you only need:
```bash
cd C:\path\to\your\fork
opencode
```

---

## 5. Config file location

Global user config is stored at:

```
C:\Users\mateu\.config\opencode
```

| File | Purpose |
|------|---------|
| `C:\Users\mateu\.config\opencode\config.json` | Global settings (model, theme, keybindings, providers) |
| `<project-root>\opencode.json` | Per-project overrides |

> `opencode.json` at the project root is gitignored by default — keep secrets out of it.

### Example `config.json`

```json
{
  "model": "gpt-4o",
  "theme": "opencode",
  "keybindings": "default"
}
```

---

## 6. Using the `blueberrycode` command (custom build)

If you built your own exe from source (see [how-to-build-exe.md](./how-to-build-exe.md)), you can run it directly using the `blueberrycode` command instead of `opencode`.

### Step 1 — Build the exe

```bash
bun run --cwd packages/opencode script/build-win.ts
```

This produces:
```
packages/opencode/dist/opencode-windows-x64/bin/opencode.exe
```

### Step 2 — Install globally

Run the install script in **PowerShell** (no admin required):

```powershell
powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1
```

What it does:
- Copies `opencode.exe` to `%LOCALAPPDATA%\blueberrycode\bin\blueberrycode.exe`
- Adds that folder to your **user PATH** automatically

**Restart your terminal** after running it, then verify:

```bash
blueberrycode --version
```

### Step 3 — Use `blueberrycode` instead of `opencode`

```bash
cd C:\path\to\your\project
blueberrycode /init
```

For subsequent sessions:
```bash
blueberrycode
```

Auth commands work the same way:
```bash
blueberrycode auth login
blueberrycode auth list
blueberrycode auth logout
```

### How it resolves the binary

`blueberrycode` always runs your locally compiled exe at:
```
packages/opencode/dist/opencode-windows-x64/bin/opencode.exe
```

You can override this at any time with the env var:
```bash
BLUEBERRYCODE_BIN_PATH=C:\path\to\custom.exe blueberrycode
```

If the exe is not found (e.g. you haven't built yet), you will see:
```
blueberrycode: compiled binary not found at ...
Run the build first:
  bun run --cwd packages/opencode script/build-win.ts
```

---

## Quick reference

| Task | Command |
|------|---------|
| Install OpenCode | `choco install opencode -y` |
| Install WezTerm | `choco install wezterm -y` |
| Install Ghostty | `choco install ghostty -y` |
| Log in | `opencode auth login` |
| Check auth | `opencode auth list` |
| Log out | `opencode auth logout` |
| Init project | `opencode /init` |
| Start session | `opencode` |
| Global config | `C:\Users\<you>\.config\opencode\` |
| Build custom exe | `bun run --cwd packages/opencode script/build-win.ts` |
| Install `blueberrycode` globally | `powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1` |
| Init with custom build | `blueberrycode /init` |
| Start with custom build | `blueberrycode` |
