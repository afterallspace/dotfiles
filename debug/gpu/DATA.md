# Data: measurements, references, configuration

Everything that was measured. The numbers here are the basis for any
conclusion.

---

## Reference of the healthy state

The only successful measurement in the whole investigation.
`runs/inside-clean_20260721-130305`, INSIDE 4K, 144 seconds under load.

| Metric | Value |
|---|---|
| **GPU power** | **34.9 W** average, max 35.9, min 31.0 (limit 35) |
| GPU utilization | 99% |
| SM clock | 1334 MHz average, peak 1702 (ceiling 2100) |
| GPU temperature | 60-62 °C (slowdown only at 97) |
| Throttle reason | `0x4 SwPowerCap` for all 144 s |
| CPU | 8.2 W, 1837 MHz |
| PSYS | 55.8 W with a limit of 56 |
| PCIe | Gen4 x4 |
| Battery | Charging 95%, 7.2 W |
| **FPS** | **50-61** |

## Reference of the bad state

`runs/inside-clean_20260721-134412`, same game, same settings, 111 seconds.

| Metric | Value | Delta to the reference |
|---|---|---|
| **GPU power** | **16.0 W** (max 16.6) | −54% |
| GPU utilization | 100% | — |
| SM clock | 1119 MHz, peak 1185 | −16% / −30% |
| GPU temperature | 53 °C | 9° colder |
| Throttle reason | `0x4 SwPowerCap` 109 s of 111 | the same |
| CPU | 14.3 W, 3824 MHz | higher |
| PSYS | 42.9 W with a limit of 56 | **13 W unused** |
| Battery | Not charging 100% | — |
| **FPS** | **17** | −70% |

**The key point:** the card is cold, the platform budget is unused, the CPU is
not competing — and the cap is still half as high. The driver itself is doing
the choking.

---

## All in-game measurements (`monitor.sh`) — valid

| Time | Run | Battery | GPU | FPS |
|---|---|---|---|---|
| 13:03 | `inside-clean_20260721-130305` | Charging 95% | **34.9 W** | 50-61 |
| 13:44 | `inside-clean_20260721-134412` | Not charging 100% | 16.0 W | 17 |
| 13:54 | `no-powerd_20260721-135403` | Not charging 100% | 16.0 W | 17 |
| 14:06 | `charging-test_20260721-140639` | Discharging 92% | 14.5 W | 17 |

The 13:54 run had `nvidia-powerd` stopped. It matched 13:44 to the tenth.

## `bootcheck.sh` measurements — valid (since 16:06)

Tool: `prime-run glmark2 --off-screen -b shading`. Agrees with the game.

| Time | Verdict | GPU | MHz | Battery | RTD3 | Gap | WMI |
|---|---|---|---|---|---|---|---|
| 16:06 | BAD | 16.9 W | 1308 | Charging 99% | Disabled | +371 ms | redmi-wmi |
| 16:14 | BAD | 16.7 W | 1302 | Charging 97% | Disabled | +371 ms | redmi-wmi |
| 16:16 | BAD | 16.8 W | 1287 | Charging 97% | Disabled | −33 ms | redmi-wmi |

Telemetry (`bootlog.csv`, `snapshots/`) was deleted on Aug 15 when the branch
was closed; the final statistics are in `SOLUTION.md`.

## Invalid data

`archive/bootlog-invalid.csv` — 10 checks by the old `bootcheck.sh` on `vkmark`.
They showed 9.4-10.7 W, but that is the tool's ceiling, not the card's. The
verdicts are meaningless.

`archive/runs-invalid/` — 5 `loadtest.sh` runs where the load did not land on
the dGPU (it slept at 210 MHz).

---

## Comparison of loads in the bad state

A check that the tools agree, one and the same boot:

| Load | GPU W | Utilization | Usable? |
|---|---|---|---|
| INSIDE 4K | 16.0 | 100% | reference |
| `glmark2 --off-screen` | 16.8 | 96% | **yes, it agrees** |
| `vkmark -b shading` | 9.8 | 75% | no |
| `vkmark -b desktop` | 11.4 | 87% | no |
| `vkmark -b effect2d` | 11.7 | 72% | no |
| `vkmark -b texture` | 10.3 | 76% | no |

All `vkmark` scenes hit the 60 Hz vertical sync and do not reach the card's
cap. `glmark2 --off-screen` renders without sync.

---

## Configuration

| | |
|---|---|
| Laptop | Xiaomi Book Pro 16 2022 (TIMI), BIOS XMAAD6B0P1717 dated 12/13/2022 |
| CPU | i7-1260P, TDP 28 W; PL1 set to **52 W**, PL2 64 W |
| PSYS | limit 56 W — includes the dGPU (verified by measurement) |
| GPU | RTX 2050 (GA107, Ampere) 4 GB, limit 35 W, `power.max_limit` 50, ceiling 2100 MHz |
| vBIOS | 94.07.66.00.7D |
| RAM | 15.34 GB + zram swap 15.34 GB, soldered |
| Battery | 40.5 of 70.0 Wh = **58% of factory** |
| Power adapter | original, 100 W, USB-C PD |
| Display | 3840×2400 OLED, 60 Hz, no VRR, 2.5× scale |
| Driver | nvidia-open 610.43.03 (no proprietary driver exists for Ampere since the 585 branch) |
| Kernel | 7.1.3-2-cachyos; LTS 6.18.38 is also installed |
| Session | GNOME Shell 50.3, Wayland |
| Bootloader | systemd-boot + `sdboot-manage` |

## GPU performance levels

From `nvidia-settings -q GPUPerfModes`:

```
perf=0: nvclock 210-420,  mem 405   (transfer 810)
perf=1: nvclock 210-2100, mem 810   (transfer 1620)
perf=2: nvclock 210-2100, mem 5501  (transfer 11002)
perf=3: nvclock 210-2100, mem 6001  (transfer 12002)   ← working level
```

In the bad state the card is at perf=3 with memory at 6001 MHz — so **the
performance level is not lowered**, it is specifically the power that is
limited.

## Decoding the throttle flags

| Bit | Meaning |
|---|---|
| `0x1` | idle |
| `0x4` | **hit the driver's power limit** — the only one ever observed |
| `0x8` | hardware slowdown |
| `0x40` / `0x80` | thermal slowdown |
| `0x100` | cut by the power controller — **never observed once** |

---

## Firmware errors

On **every** boot, identically in good and bad ones:

```
NVRM: GPU0 nvAssertOkFailedNoLog: Assertion failed: Invalid data passed
  [NV_ERR_INVALID_DATA] (0x00000025) returned from PlatformRequestHandler
  failed to get target temp from SBIOS      @ platform_request_handler_ctrl.c:2174
NVRM: GPU0 ... failed to get platform power mode from SBIOS
                                            @ platform_request_handler_ctrl.c:2117
```

`nvidia-powerd`:

```
ERROR! DC power limits table is not supported
ERROR! Failed to get SysPwrLimitGetInfo!!
ERROR! Client (presumably SBIOS) has requested to disable Dynamic Boost DC controller
CRITICAL! Failed to get SysPwrLimitGetInfo
ERROR! JPAC is not created/already destroyed    ← ~250 times per boot
```

Other firmware defects found along the way:

```
ACPI: video: [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
ucsi_acpi USBC000:00: bogus connector number in CCI: 2     ← ~~in bursts when the charger is plugged in~~
acpi PNP0A08:00: _OSC: platform does not support [AER]
```

> ⚠ The note "in bursts when the charger is plugged in" is **a mistake,
> corrected Aug 13**. These are not bursts: an even 1 Hz stream, 27,005 lines
> over a 14-hour boot, survives s2idle. Analysis and recipe —
> [SOLUTION.md → "UCSI: log
> storm"](SOLUTION.md#ucsi-log-storm-analyzed-aug-13).

Two kernel modules claim the same WMI GUID (a race at boot, does not affect the
symptom — verified):

```
alias wmi:46C93E13-EE9B-4262-8488-563BCA757FEF   redmi_wmi
alias wmi:46C93E13-EE9B-4262-8488-563BCA757FEF   bitland_mifs_wmi
```
