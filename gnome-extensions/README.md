# GNOME Shell extensions

Everything here targets GNOME Shell 51 only. Run `./install.sh` to link the
extensions into `~/.local/share/gnome-shell/extensions` and compile their
schemas; on Wayland a relogin is needed before the shell sees a new one.

`./sandbox.sh` runs a throwaway headless shell with chosen extensions, so a
change can be checked (eval, screenshots, synthetic input) without that
relogin. See the header of the script for usage.

| UUID                               | What it is                                                                                                |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `gsr-timer@afterall`               | Panel indicator for `scripts/gsr-toggle.sh` recordings                                                    |
| `lockscreen-layout-badge@afterall` | Keyboard layout labels that survive the lock screen                                                       |
| `panel-clock@afterall`             | Top bar clock as `Oct 10 · 6:35 PM` instead of GNOME's wide gap                                           |
| `clipboard-indicator@afterall`     | Fork of [Clipboard Indicator](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator) (MIT) |
| `gradia-capture@afterall`          | Fork of [Gradia Capture](https://github.com/AlexanderVanhee/gradia-companion) (GPL-3.0)                   |

Two more come straight from extensions.gnome.org and are not kept here:
[Blur my Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
and [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/).
Install them with Extension Manager; their settings come back with
`gnome-settings.dconf`.

## Forks

The forks have their own UUIDs, so extensions.gnome.org can never overwrite
them with an update. Settings schema IDs and dconf paths are kept as upstream
ones, which carried the existing settings over untouched. Translations,
build scripts and screenshots were dropped; the code was run through the repo's
Prettier config once at import.

| Fork                           | Upstream commit        |
| ------------------------------ | ---------------------- |
| `clipboard-indicator@afterall` | `c880c7f` (2026-04-02) |
| `gradia-capture@afterall`      | `f70a212` (2026-08-22) |

To pull in later upstream work, diff upstream from that commit and port the
changes by hand; a plain merge won't apply after the reformat.

### Changes against upstream

Clipboard Indicator:

- GNOME 51: the virtual keyboard comes from `global.stage.context` since
  `Clutter.get_default_backend()` is gone; `St.BoxLayout` lost `vertical`.
- Paste keys carry a real monotonic timestamp instead of 0.
- Escape in the confirm dialog works (`Clutter.Escape` never existed); the
  notification Cancel action is bound; prefs no longer add a widget twice.
- Schema defaults are the settings actually in use: icon-only, paste on
  select, Super+V, no paste/settings/private/clear buttons.
- History moved to `~/.cache/clipboard-indicator@afterall` along with the UUID.
- With nothing in the top bar (display mode 3, now the default) Super+V opens
  the menu top right, anchored to the panel's right end so it sits exactly
  like the quick settings menu, or in the centre (`floating-position`).
  Upstream left it in the top-left corner, flush with the screen edges. The
  centred menu keeps its top edge while searching shrinks the list.

Gradia Capture:

- GNOME 51 moved screenshot UI shortcuts to a binding pool that fires before
  `key-press-event`, so tool keys are caught in the capture phase. Without it
  `r` reset the selection instead of picking the rectangle, and Ctrl+C saved a
  file instead of only copying.
- Enter in the text tool commits again: the entry now only reports it as
  `activate`.
- The selection size label follows the 51 pan gesture instead of
  `motion-event`, which the selector no longer receives while dragging.
- Shutter sound is played from the shell's data dir, like the stock UI in 51.
- Tooltips are destroyed together with their buttons; upstream leaked about
  twenty actors into `uiGroup` on every screenshot UI close.
- `GioUnix.DesktopAppInfo` in prefs (GLib 2.90 deprecation).
- Default colours for rectangle and arrow are red.

Known debt: compositing strokes still loads Gdk 4 into the shell process
(`imports.gi.Gdk`), as upstream does. GJS's Cairo bindings offer no pixel
access, so the alternative is a PNG round trip on the compositor thread.
