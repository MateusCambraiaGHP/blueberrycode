# How to Change Icons / Logos

This project uses icons and logos in several different surfaces. Below is a map of every location and what to change.

---

## 1. TUI (Terminal) ASCII Logo

**File:** `packages/opencode/src/cli/logo.ts`

The terminal logo is plain ASCII art exported as a string array. Edit `logo.left` and `logo.right` to change what is shown when the TUI starts.

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
1. Edit `mark.svg` and `mark-light.svg` with your new design.
2. Export PNGs at the sizes listed above and overwrite the existing files.

---

## 7. Desktop App (Electron) — `packages/desktop-electron`

The desktop window icon is loaded from:

```
packages/desktop-electron/resources/icons/icon.ico   ← Windows
packages/desktop-electron/resources/icons/icon.png   ← Linux / macOS
```

Replace those files with your own. The `.ico` file should contain multiple resolutions (16×16, 32×32, 48×48, 256×256). The `.png` should be 512×512.

The path is resolved in `packages/desktop-electron/src/main/windows.ts` via `iconsDir()` — no code change is needed when only replacing the image files.

---

## Quick reference — which file for which surface

| Surface | File(s) |
|---------|---------|
| Terminal splash | `packages/opencode/src/cli/logo.ts` |
| Custom branded build | `.opencode/custom/imgs/logo.svg` |
| Console web app | `packages/console/app/src/asset/logo*.svg` |
| Marketing / landing | `packages/console/app/src/asset/lander/logo-*.svg` |
| Web app | `packages/web/src/assets/logo-*.svg` |
| Docs site | `packages/docs/logo/{dark,light}.svg` |
| Brand marks / favicons | `packages/identity/mark*.svg` + PNGs |
| Desktop window icon | `packages/desktop-electron/resources/icons/icon.{ico,png}` |
