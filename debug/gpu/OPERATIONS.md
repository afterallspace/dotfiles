# Operations: day-to-day GPU unlock

Short runbook. Mechanism and history — [SOLUTION.md](SOLUTION.md),
investigation — [INVESTIGATION.md](INVESTIGATION.md).

## How it works normally

On every session login the user unit `nvpcf-unlock.service` (after 15 s)
starts `nvpcf-session-unlock.sh`: it loads the dGPU with glmark, measures the
SM clock under load and, if it is locked at ~1327 MHz, runs the
`NVST 3 → 20 s → NVST 1` recipe up to three times through the root helper
`/usr/local/bin/nvpcf-boot-fix.sh`. The outcome goes to the journal only (file
logging was removed on 2026-08-15, the branch is closed).

**Check after boot:**
`journalctl --user -u nvpcf-unlock.service -b 0` — look for
`OK: already unlocked` or `OK: unlocked (attempt N)`.
Do not run `bootcheck.sh` during the first ~2 minutes after login (the service
is running).

## If the card is capped (17 FPS, 1327 MHz)

```fish
cd ~/.config/debug/gpu
prime-run glmark2 --off-screen -b shading:duration=600 &   # load
sudo ./nvpcf-unlock.sh                                     # the proven recipe
./bootcheck.sh                                             # verdict
```
The verdict always goes by clock: ~1327 MHz = locked, 1600+ = free. Do not
trust the watts (the battery or a starved charger understate them).

## Reinstalling the automation from scratch (after an OS reinstall, etc.)

```fish
sudo pacman -S --needed acpi_call-dkms glmark2 nvidia-prime
sudo install -o root -g root -m 755 ~/.config/debug/gpu/nvpcf-boot-fix.sh /usr/local/bin/nvpcf-boot-fix.sh
sudo mkdir -p /usr/local/share/nvpcf-fix
sudo cp ~/.config/debug/gpu/acpi/nvpcf-stnm.aml /usr/local/share/nvpcf-fix/
echo "afterall ALL=(root) NOPASSWD: /usr/local/bin/nvpcf-boot-fix.sh" | sudo tee /etc/sudoers.d/nvpcf-fix
# the unit lives in ~/.config/systemd/user/nvpcf-unlock.service
systemctl --user daemon-reload && systemctl --user enable nvpcf-unlock.service
```

If `nvpcf-stnm.aml` is missing, rebuild it from source:
`cd ~/.config/debug/gpu/acpi && iasl nvpcf-stnm.dsl` (package `acpica`).

## After updates

- **Kernel** — do nothing (dkms rebuilds acpi_call).
- **NVIDIA driver** — run `./bootcheck.sh` in a bad state and after the unlock;
  if the recipe stopped working, see SOLUTION.md → "Next steps by priority".
- **BIOS** — re-take the ACPI dump (instructions in SOLUTION.md), compare
  `\_SB.NPCF` and `_Q24`; re-verify the recipe.

## Complete removal

```fish
systemctl --user disable --now nvpcf-unlock.service
rm ~/.config/systemd/user/nvpcf-unlock.service
sudo rm /usr/local/bin/nvpcf-boot-fix.sh /etc/sudoers.d/nvpcf-fix
sudo rm -r /usr/local/share/nvpcf-fix
sudo pacman -R acpi_call-dkms   # optional
```

## File map

| File | Role |
|---|---|
| `nvpcf-session-unlock.sh` | the unit's wrapper: load, verdict by clock, up to 3 attempts |
| `nvpcf-boot-fix.sh` | root helper: SSDT + NVST 3 → NVST 1 (a copy in /usr/local/bin) |
| `nvpcf-unlock.sh` | running the recipe by hand and EC experiments |
| `nvpcf-peek.sh` | reading the mechanism's ACPI variables (`--dsm`, `--kick`) |
| `acpi/nvpcf-stnm.dsl/.aml` | runtime SSDT with the `\NVST` method |
| `bootcheck.sh` | boot verdict (25 s), records nothing — pure diagnostics |
| `archive/` | closed monitoring: `monitor.sh`, `summary.sh`, `compare-boots.sh` |
| `archive/deadends/` | dead-end tools (override tables, etc.) — do not use |
| `BUGREPORT.md` | bug report text for NVIDIA |

Related: the gamemode clock lock for games — `~/.config/scripts/gamemode-tweaks.sh`
(called through `gamemoderun %command%`, config `~/.config/gamemode.ini`).
