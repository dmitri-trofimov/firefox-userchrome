# Firefox: Chrome-like bookmarks toolbar

A small `userChrome.css` that makes the Firefox bookmarks toolbar match Chrome's spacing: the bar height, the button padding and margins, the gap between icon and label, and the hover shape.

## What it does

| | Value |
|---|---|
| Bookmark button height | 28px |
| Bar padding (top / bottom) | 2px / 6px, so a hovered button sits equally far from the URL bar and the page |
| Bar side padding | 8px |
| Button side padding | 8px |
| Favicon → label gap | 6px |
| Hover radius | 8px |
| Bookmarks with no name (icon only) | Square 28×28 buttons |

All values are CSS variables at the top of [`chrome/userChrome.css`](chrome/userChrome.css) (`--cbb-*`), so they're easy to tweak. The CSS also overrides Firefox's density setting (compact/normal/touch) for the bookmarks bar.

## Install (Windows)

```powershell
git clone https://github.com/dmitri-trofimov/firefox-userchrome.git
cd firefox-userchrome
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Then restart Firefox.

`install.ps1`:
1. Finds the `default-release` profile in `%APPDATA%\Mozilla\Firefox\profiles.ini`.
2. Copies `chrome\userChrome.css` into `<profile>\chrome\`.
3. Adds `toolkit.legacyUserProfileCustomizations.stylesheets = true` to `<profile>\user.js`, which Firefox needs before it will load `userChrome.css`.

To target a different profile, pass one of these:

```powershell
.\install.ps1 -ProfileName default-nightly
.\install.ps1 -ProfileDir "C:\path\to\profile"
```

## Install (macOS / Linux)

1. Open `about:profiles` and find the profile's **Root Directory**.
2. Copy the `chrome` folder from this repo into that directory.
3. In `about:config`, set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`.
4. Restart Firefox.

## Keeping devices in sync

Firefox Sync does **not** sync `userChrome.css`. On each machine:

```powershell
git pull
.\install.ps1
```

Then restart Firefox.

Optional: Firefox Sync can carry the "load userChrome.css" setting itself. On one machine, open `about:config` and create a Boolean setting set to `true`:

```
services.sync.prefs.sync.toolkit.legacyUserProfileCustomizations.stylesheets
```

## Debugging

To inspect Firefox's own toolbars, use the **Browser Toolbox** (`Ctrl+Alt+Shift+I`). First enable *"Enable browser chrome and add-on debugging toolboxes"* in DevTools settings.
