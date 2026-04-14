# How to Rename the Command (Simple Guide)

This guide shows you how to rename the CLI command from `opencode` to a custom name (e.g., `pestanacode`).

---

## Quick Steps

### 1. Create the new bin wrapper

Create `packages/opencode/bin/pestanacode` with this content:

```javascript
#!/usr/bin/env node

const childProcess = require("child_process")
const fs = require("fs")
const path = require("path")

function run(target) {
  const result = childProcess.spawnSync(target, process.argv.slice(2), {
    stdio: "inherit",
  })
  if (result.error) {
    console.error(result.error.message)
    process.exit(1)
  }
  const code = typeof result.status === "number" ? result.status : 0
  process.exit(code)
}

// Allow override via env var
const envPath = process.env.PESTANACODE_BIN_PATH
if (envPath) {
  run(envPath)
}

const scriptPath = fs.realpathSync(__filename)
const scriptDir = path.dirname(scriptPath)
const pkgDir = path.resolve(scriptDir, "..")

// Point to the compiled exe
const compiled = path.join(pkgDir, "dist", "opencode-windows-x64", "bin", "opencode.exe")

if (!fs.existsSync(compiled)) {
  console.error(
    "pestanacode: compiled binary not found at " + compiled + "\n" +
    "Run the build first:\n" +
    "  bun run --cwd packages/opencode script/build-win.ts",
  )
  process.exit(1)
}

run(compiled)
```

### 2. Update package.json

In `packages/opencode/package.json`, add your command to the `bin` section:

```json
"bin": {
  "opencode": "./bin/opencode",
  "pestanacode": "./bin/pestanacode"
}
```

### 3. Update src/index.ts

Change two things in `packages/opencode/src/index.ts`:

**Line ~57** - Change the help guard:
```typescript
if (!text.startsWith("pestanacode ")) {
```

**Line ~67** - Change the script name:
```typescript
.scriptName("pestanacode")
```

### 4. Update the ASCII logo

Edit `packages/opencode/src/cli/logo.ts`:

```typescript
export const logo = {
  left: [
    "                                            ",
    "█▀▀▄ █▀▀█ █▀▀▀ █▀▀█ ▀█▀ █▀▀█ █▀▀█ █▀▀█",
    "█▀▀▀ █^^^ ▀▀▀█ █  █  █  █▀▀█ █  █ █▀▀█",
    "▀    ▀▀▀▀ ▀▀▀▀ ▀  ▀  ▀  ▀  ▀ ▀  ▀ ▀  ▀",
  ],
  right: ["                    ", "█▀▀▀ █▀▀█ █▀▀█ █▀▀█", "█___ █__█ █__█ █^^^", "▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀"],
}
```

### 5. Update terminal titles

In `packages/opencode/src/cli/cmd/tui/app.tsx`, change:

```typescript
renderer.setTerminalTitle("PestanaCode")
```

And change the abbreviation:
```typescript
renderer.setTerminalTitle(`PC | ${title}`)
```

### 6. Update install script

Edit `packages/opencode/script/install-global.ps1`:

Change the install paths:
```powershell
$installDir = "$env:LOCALAPPDATA\pestanacode\bin"
$dest       = "$installDir\pestanacode.exe"
```

Update the messages:
```powershell
Write-Host "Done! pestanacode installed to:"
Write-Host "  pestanacode /init"
```

### 7. Update desktop app title (optional)

In `packages/desktop-electron/src/main/windows.ts`:

```typescript
title: "PestanaCode",
```

---

## Build and Install

### Step 1: Install dependencies (if needed)
```bash
cd C:\WorkDir\blueberrycode
bun install
```

### Step 2: Build the executable
```bash
bun run --cwd packages/opencode script/build-win.ts
```

### Step 3: Install globally
```powershell
powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1
```

### Step 4: Restart your terminal
Close and reopen your terminal for PATH changes to take effect.

---

## Usage

Now you can use your custom command:

```bash
# Initialize a project
pestanacode .

# Start in current directory
pestanacode

# Check version
pestanacode --version

# Get help
pestanacode --help
```

---

## Quick Reference

| What to Change | File | What to Update |
|----------------|------|----------------|
| Command name | `packages/opencode/package.json` | Add to `"bin"` section |
| Binary wrapper | `packages/opencode/bin/[name]` | Create new file |
| CLI script name | `packages/opencode/src/index.ts` | `.scriptName()` and help guard |
| ASCII logo | `packages/opencode/src/cli/logo.ts` | Change text art |
| Terminal title | `packages/opencode/src/cli/cmd/tui/app.tsx` | `setTerminalTitle()` calls |
| Install script | `packages/opencode/script/install-global.ps1` | Install paths and messages |
| Desktop title | `packages/desktop-electron/src/main/windows.ts` | Window `title` property |

---

## Troubleshooting

**"pestanacode: compiled binary not found"**
- Run the build command first: `bun run --cwd packages/opencode script/build-win.ts`

**"Could not resolve" errors during build**
- Install dependencies: `bun install`

**Command not found after install**
- Restart your terminal
- Check PATH includes `%LOCALAPPDATA%\pestanacode\bin`

**Still seeing old logo**
- Make sure you rebuilt after changing `logo.ts`
- Restart the application if running in dev mode
