# Current Status & Setup Summary

## Completed Changes

### 1. Command Renamed: `blueberrycode` → `pestanacode`

**Files Modified:**
- ✅ `packages/opencode/bin/pestanacode` - Created new bin wrapper
- ✅ `packages/opencode/package.json` - Updated bin entry
- ✅ `packages/opencode/src/index.ts` - Changed scriptName and help guard
- ✅ `packages/opencode/src/cli/logo.ts` - Updated ASCII logo to "pestana code"
- ✅ `packages/opencode/src/cli/cmd/tui/app.tsx` - Terminal titles changed to "PestanaCode", abbreviation "PC"
- ✅ `packages/opencode/script/install-global.ps1` - Install paths updated
- ✅ `packages/desktop-electron/src/main/windows.ts` - Window title changed to "PestanaCode"

### 2. Azure OpenAI Bug Fixes

**Fixed Issues:**
- ✅ `packages/opencode/src/provider/provider.ts` - Changed from `sdk.responses()` to `sdk.chat()` (responses API doesn't exist for Azure)
- ✅ `packages/opencode/src/provider/transform.ts` - Excluded GPT-4 models from `reasoning.effort` parameter (unsupported)

### 3. Documentation Created/Updated

**New Docs:**
- ✅ `docs/how-to-rename-command.md` - Simple step-by-step renaming guide
- ✅ `docs/quick-start.md` - Updated with corrected Azure auth flow, added Anthropic and GitHub Copilot setup

**Removed Docs:**
- ✅ Removed verbose `docs/codebase-overview.md`
- ✅ Removed outdated `docs/how-to-run-and-auth.md`

---

## Current Configuration

### Active Providers

**GitHub Copilot** ✅
- Authenticated via OAuth
- No environment variables needed
- Credentials stored in `~\.local\share\opencode\auth.json`

**Azure OpenAI** (Currently disabled)
- Can be re-enabled by setting `AZURE_RESOURCE_NAME` environment variable
- Last used resource: `ai-pvc-f`
- Last used model: `azure/gpt-4.1`

### Build Status

**Needs Rebuild:**
- ⚠️ Changes made to source code require rebuild
- Run: `bun run --cwd packages/opencode script/build-win.ts`
- Then: `powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1`

---

## Quick Reference Commands

### Building & Installing

```bash
# Build the executable
bun run --cwd packages/opencode script/build-win.ts

# Install globally
powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1

# Restart terminal, then run
pestanacode
```

### Provider Management

```bash
# List configured providers
pestanacode providers list

# Add a provider
pestanacode auth login

# Remove a provider
pestanacode auth logout

# List available models
pestanacode models
```

### Azure OpenAI Setup

```powershell
# Set resource name
setx AZURE_RESOURCE_NAME "your-resource-name"

# Authenticate
pestanacode auth login  # Select Azure

# Remove Azure
[System.Environment]::SetEnvironmentVariable("AZURE_RESOURCE_NAME", $null, [System.EnvironmentVariableTarget]::User)
pestanacode auth logout
```

### Anthropic (Claude) Setup

```bash
pestanacode auth login  # Select Anthropic
# Enter API key from https://console.anthropic.com/
```

### GitHub Copilot Setup

```bash
pestanacode auth login  # Select GitHub Copilot (not GitHub Models)
# Follows OAuth flow in browser
```

---

## Known Working Configurations

### Azure OpenAI (Tested)
- Resource: `phg-ai-f` → `ai-pvc-f`
- Model: `azure/gpt-4.1`
- Status: ✅ Working after bug fixes

### GitHub Copilot (Active)
- Authentication: OAuth
- Status: ✅ Configured

### Anthropic Claude (Available)
- Authentication: API Key
- Status: 📋 Ready to configure

---

## Next Steps

1. **Rebuild the application** with bug fixes:
   ```bash
   bun run --cwd packages/opencode script/build-win.ts
   powershell -ExecutionPolicy Bypass -File packages\opencode\script\install-global.ps1
   ```

2. **Choose your AI provider:**
   - Keep GitHub Copilot (current)
   - Or add Anthropic for Claude models
   - Or re-enable Azure OpenAI

3. **Test the application:**
   ```bash
   pestanacode
   ```

---

## Troubleshooting

**"sdk.responses is not a function"**
- Fixed in code, requires rebuild

**"Unsupported parameter: 'reasoning.effort'"**
- Fixed for GPT-4 models, requires rebuild

**Azure models not appearing**
- Check `AZURE_RESOURCE_NAME` is set
- Verify Azure authentication with `pestanacode providers list`
- Ensure deployment exists in Azure Portal

**Command not found**
- Restart terminal after installation
- Check PATH includes `%LOCALAPPDATA%\pestanacode\bin`

---

## File Locations

**Executable:** `packages/opencode/dist/opencode-windows-x64/bin/opencode.exe`  
**Installed:** `%LOCALAPPDATA%\pestanacode\bin\pestanacode.exe`  
**Auth Storage:** `~\.local\share\opencode\auth.json`  
**Config:** `~\.config\opencode\config.json` (optional)  
**Documentation:** `docs/`

---

*Last Updated: After Azure bug fixes and GitHub Copilot setup*
