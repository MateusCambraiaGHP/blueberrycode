# Quick Start Guide

Simple guide to run and authenticate your custom CLI.

---

## Running the App

After building and installing, navigate to your project:

```bash
cd C:\path\to\your\project
pestanacode
```

First time? Initialize:

```bash
pestanacode .
```

The database migration will run automatically on first launch.

---

## Authentication

### Quick Auth (OpenAI, Anthropic, Google, etc.)

```bash
pestanacode auth login
```

Follow the prompts to add your provider.

### Anthropic (Claude)

```bash
pestanacode auth login
```

Select "Anthropic" and enter your API key from https://console.anthropic.com/

Available models: `claude-3-5-sonnet`, `claude-3-opus`, `claude-3-haiku`

### GitHub Copilot

```bash
pestanacode auth login
```

Select "GitHub Copilot" (not GitHub Models). It will open your browser for OAuth authentication.

Requires: GitHub Copilot Individual, Business, or Enterprise subscription

### Azure OpenAI Setup

Azure OpenAI requires both API key AND resource name.

**Step 1: Set Resource Name**

```powershell
setx AZURE_RESOURCE_NAME "your-resource-name"
```

Find your resource name in Azure Portal → Your Azure OpenAI Resource → Overview → "Name" field.

**Step 2: Authenticate**

```bash
pestanacode auth login
```

Select "Azure" from the list and enter your API key when prompted.

**Step 3: Verify**

```bash
pestanacode providers list
```

You should see Azure in both the Credentials and Environment sections.

**Important:** Close and reopen your terminal after setting the resource name, then run pestanacode and select an Azure model that matches your deployment name (e.g., `azure/gpt-4.1`).

**To switch Azure resources:** Update resource name and re-authenticate:
```powershell
setx AZURE_RESOURCE_NAME "new-resource-name"
pestanacode auth logout
pestanacode auth login
```

**To remove Azure:** Clear environment variables:
```powershell
[System.Environment]::SetEnvironmentVariable("AZURE_RESOURCE_NAME", $null, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("AZURE_API_KEY", $null, [System.EnvironmentVariableTarget]::User)
pestanacode auth logout
```
Then restart your terminal.

### Check authenticated accounts

```bash
pestanacode auth list
```

### Remove an account

```bash
pestanacode auth logout
```

---

## Basic Commands

```bash
# Start in current directory
pestanacode

# Show version
pestanacode --version

# Show help
pestanacode --help

# Attach to remote server
pestanacode attach <url>

# List available models
pestanacode models

# List providers
pestanacode providers
```

---

## Configuration

### Global config location

```
C:\Users\<username>\.config\opencode\config.json
```

### Project config

Create `opencode.json` in your project root for project-specific settings.

### Example config.json

```json
{
  "model": "gpt-4o",
  "theme": "opencode",
  "keybindings": "default"
}
```

---

## Terminal Requirements

Use a modern terminal with Unicode and true-color support:

**WezTerm** (recommended):
```powershell
choco install wezterm -y
```

**Ghostty**:
```powershell
choco install ghostty -y
```

Do not use Windows Terminal or cmd.exe - the TUI won't render properly.

---

## Troubleshooting

**"Azure OpenAI resource name setting is missing"**
- Add Azure config to `C:\Users\<username>\.config\opencode\config.json`:
```json
{
  "providers": {
    "azure": {
      "resourceName": "your-resource-name",
      "apiKey": "your-api-key"
    }
  }
}
```
- Restart pestanacode after saving

**"Failed to change directory"**
- Don't use `/init`, just run `pestanacode .` or `pestanacode`

**TUI doesn't render correctly**
- Install WezTerm or Ghostty
- Make sure your terminal supports Unicode

**Authentication fails**
- Check your internet connection
- Try `pestanacode auth logout` then `pestanacode auth login` again

**Command not found**
- Restart your terminal after installation
- Verify PATH includes the install directory
