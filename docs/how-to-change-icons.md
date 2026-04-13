# How to Change Icons / Logos

This project uses icons and logos in several different surfaces. Below is a map of every location and what to change.

---

## Required tools

Most icon files are SVGs that you can edit in any text editor. For generating PNGs and `.ico` files you need **Inkscape** and **ImageMagick**.

### Installing with Chocolatey (Windows)

If you don't have Chocolatey installed yet, open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Then install the tools in the same elevated shell:

```powershell
choco install inkscape -y
choco install imagemagick -y
```

Restart your terminal after installation, then verify:

```bash
inkscape --version
magick --version
```

### What each tool is used for

| Tool | Purpose |
|------|---------|
| **Inkscape** | Edit SVG files, export SVG → PNG at any resolution |
| **ImageMagick** | Convert PNG → `.ico` with multiple embedded resolutions, batch resize |

---

## 1. TUI (Terminal) ASCII Logo

**File:** `packages/opencode/src/cli/logo.ts`

The terminal logo is plain ASCII art — no tools needed, just a text editor.

Edit `logo.left` and `logo.right` to change what is shown when the TUI starts:

```ts
export const logo = {
  left: [
    "line 1",
    "line 2",
    "line 3",
  ],
  right: ["line 1", "line 2", "line 3"],
}
```

`marks` defines the decoration characters used in the border animation (`_^~` by default).

---

## 2. Custom Branding Override (`.opencode/`)

**File:** `.opencode/custom/imgs/logo.svg`

This SVG is the primary logo used when running a customized/branded build. Replace the contents of this file with your own SVG to rebrand the app globally without touching package sources.

Edit with any SVG editor or directly in a text editor.

---

## 3. Console App (`packages/console`)

| File | Used for |
|------|----------|
| `packages/console/app/src/asset/logo.svg` | Main logo |
| `packages/console/app/src/asset/logo-ornate-dark.svg` | Dark-mode ornate variant |
| `packages/console/app/src/asset/logo-ornate-light.svg` | Light-mode ornate variant |
| `packages/console/app/src/asset/lander/logo-dark.svg` | Landing page dark logo |
| `packages/console/app/src/asset/lander/logo-light.svg` | Landing page light logo |

Replace the SVG files directly. No build step is required — the dev server picks them up automatically.

---

## 4. Web App (`packages/web`)

| File | Used for |
|------|----------|
| `packages/web/src/assets/logo-dark.svg` | Dark mode |
| `packages/web/src/assets/logo-light.svg` | Light mode |
| `packages/web/src/assets/logo-ornate-dark.svg` | Dark ornate variant |
| `packages/web/src/assets/logo-ornate-light.svg` | Light ornate variant |

Replace the SVG files directly.

---

## 5. Docs Site (`packages/docs`)

| File | Used for |
|------|----------|
| `packages/docs/logo/dark.svg` | Dark logo in docs header |
| `packages/docs/logo/light.svg` | Light logo in docs header |

---

## 6. Identity / Brand Marks (`packages/identity`)

These are the small "mark" icons (favicon-like) used across all surfaces.

| File | Size / Purpose |
|------|----------------|
| `packages/identity/mark.svg` | Source SVG (dark) |
| `packages/identity/mark-light.svg` | Source SVG (light) |
| `packages/identity/mark-192x192.png` | PWA / Android icon |
| `packages/identity/mark-512x512.png` | PWA large icon |
| `packages/identity/mark-512x512-light.png` | PWA large icon (light) |
| `packages/identity/mark-96x96.png` | Small favicon |

**Workflow to update:**

1. Edit `mark.svg` and `mark-light.svg` in Inkscape (or any editor).

2. Export PNGs from the SVG using Inkscape CLI:

```bash
# Export dark mark at each required size
inkscape packages/identity/mark.svg --export-filename=packages/identity/mark-512x512.png --export-width=512 --export-height=512
inkscape packages/identity/mark.svg --export-filename=packages/identity/mark-192x192.png --export-width=192 --export-height=192
inkscape packages/identity/mark.svg --export-filename=packages/identity/mark-96x96.png   --export-width=96  --export-height=96

# Export light mark
inkscape packages/identity/mark-light.svg --export-filename=packages/identity/mark-512x512-light.png --export-width=512 --export-height=512
```

---

## 7. Desktop App (Electron) — `packages/desktop-electron`

The desktop window icon is loaded from:

```
packages/desktop-electron/resources/icons/icon.ico   ← Windows
packages/desktop-electron/resources/icons/icon.png   ← Linux / macOS
```

The `.ico` must contain multiple resolutions (16×16, 32×32, 48×48, 256×256). The `.png` should be 512×512.

**Workflow to update:**

1. Start from a high-resolution PNG (512×512 minimum) of your new icon.

2. Generate the `.png` for Linux/macOS:

```bash
inkscape your-icon.svg --export-filename=packages/desktop-electron/resources/icons/icon.png --export-width=512 --export-height=512
```

3. Generate the multi-resolution `.ico` for Windows using ImageMagick:

```bash
magick your-icon.svg -define icon:auto-resize=256,48,32,16 packages/desktop-electron/resources/icons/icon.ico
```

No code change is needed — the path is resolved automatically in `packages/desktop-electron/src/main/windows.ts`.

---

## Quick reference — which file for which surface

| Surface | File(s) | Tools needed |
|---------|---------|--------------|
| Terminal splash | `packages/opencode/src/cli/logo.ts` | Text editor only |
| Custom branded build | `.opencode/custom/imgs/logo.svg` | Text editor / Inkscape |
| Console web app | `packages/console/app/src/asset/logo*.svg` | Text editor / Inkscape |
| Marketing / landing | `packages/console/app/src/asset/lander/logo-*.svg` | Text editor / Inkscape |
| Web app | `packages/web/src/assets/logo-*.svg` | Text editor / Inkscape |
| Docs site | `packages/docs/logo/{dark,light}.svg` | Text editor / Inkscape |
| Brand marks / favicons | `packages/identity/mark*.svg` + PNGs | Inkscape |
| Desktop window icon | `packages/desktop-electron/resources/icons/icon.{ico,png}` | Inkscape + ImageMagick |
