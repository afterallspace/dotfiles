# [Bug report draft for forums.developer.nvidia.com / Linux forum]

Title: RTX 2050 laptop GPU permanently capped at ~1327 MHz / 17 W (boost
clocks forbidden) on ~90 % of boots — Xiaomi Book Pro 16 2022, open driver
610.43.03, GSP; reproducible ACPI-level workaround included

## System

- Laptop: Xiaomi Book Pro 16 2022 (TIMI), BIOS XMAAD6B0P1717 (12/13/2022),
  Insyde; EC: XMCC2121
- GPU: NVIDIA GeForce RTX 2050 (GA107), vBIOS 94.07.66.00.7D, default TGP
  35 W, max 50 W
- CPU: i7-1260P (Alder Lake-P), hybrid graphics (i915 primary, PRIME offload)
- Driver: nvidia-open 610.43.03 (GSP), also reproduced on earlier builds;
  kernel 7.1.3 (CachyOS) and 6.18 LTS — identical behavior
- Session: GNOME 50 Wayland; nvidia-powerd enabled

## Symptom

On ~90 % of boots the GPU is limited to **SM clock ≤ ~1327 MHz** under full
load (100 % utilization, temp ~55 °C, power ~17 W of the 35 W limit,
`Current Power Limit` still reports 35 W). Boost clock range (1600–2100 MHz)
is never entered. On the remaining ~10 % of boots the same workload runs at
1700+ MHz / 32–35 W. The state is latched at driver/GSP init and never
changes within a session on its own. FPS in games drops 55–60 → 17.

Throttle reasons show only SwPowerCap (or Idle); never HW slowdown.
`nvidia-smi -lgc` can push clocks only to ~1500–1600 MHz at ~20 W, so an
internal power/boost policy stays in force.

## Platform handshake errors (every boot, locked or not)

    NVRM: GPU0 ... PlatformRequestHandler failed to get target temp from SBIOS
      [NV_ERR_INVALID_DATA] @ platform_request_handler_ctrl.c:2174
    NVRM: GPU0 ... failed to get platform power mode from SBIOS @ :2117

nvidia-powerd:

    ERROR! DC power limits table is not supported
    ERROR! Failed to get SysPwrLimitGetInfo!!
    ERROR! Client (presumably SBIOS) has requested to disable Dynamic Boost DC controller
    ERROR! JPAC is not created/already destroyed   (repeats every few seconds)

The SBIOS NVPCF static table (\_SB.NPCF, SSDT "NvdTable") reports
TPP AC = 0xA0 (20 W in 1/8 W units) or 0x78 (15 W) depending on a config
flag, and TPP DC = 0. GPS fun 0x2A returns target temp 66 °C unless the EC
mode register (STNM, EC offset 0x7E) equals 3.

## Reproducible runtime unlock (workaround) — points at the mechanism

The EC query handler `_Q24` in the DSDT switches NVPCF variables by STNM
(2 → Dynamic Boost controllers ON, 1/3 → OFF) and sends Notify 0xC0 to the
GPU and NVPCF devices. Driving it via a runtime SSDT (acpi_call):

    write STNM=3 + invoke _Q24; wait ~20 s; write STNM=1 + invoke _Q24

reliably takes the GPU from 1327 MHz / 17 W to 1725 MHz / 32 W **at runtime,
persistently** (validated many times; log excerpts below). Conversely,
invoking `_Q24` while EC reports STNM=2 re-locks the card. So the lock is
the GSP boost/power controller being engaged with broken platform data
(JPAC never created, TPP table nonsensical), which then forbids boost
clocks; with the controller disengaged the GPU runs correctly at its vBIOS
TGP.

Suggested driver-side issues:
1. GSP accepts an obviously invalid NVPCF configuration (TPP 15–20 W < base
   TGP, no DC table) and engages a boost controller that can never work,
   capping clocks at the non-boost maximum.
2. The engaged/disengaged decision depends on a boot-time race with EC
   events; no re-evaluation happens later (PlatformRequestHandler queries
   keep failing with NV_ERR_INVALID_DATA).

Expected behavior: with an invalid/incomplete NVPCF table the driver should
fall back to vBIOS defaults (35 W static TGP), as it effectively does on the
~10 % lucky boots and after the manual EC sequence above.

## Attached / available on request

- Paired good/bad boot kernel logs, `nvidia-smi -q` dumps, nvidia-powerd logs
- Decompiled NvdTable SSDT and DSDT `_Q24` excerpts
- Boot statistics CSV (30+ boots with clock/power/battery/EC state)
- nvidia-bug-report.log.gz from both states

## Notes

- Not thermal (55–62 °C, slowdown at 97 °C), not PSYS (43/56 W used), not
  RTD3 (reproduced with DynamicPowerManagement=0), not nvidia-powerd
  (reproduced with the daemon stopped), not kernel-version-specific.
- Table-override experiments (patched NvdTable via initrd ACPI upgrade:
  gate closed / controller-off / target-temp forced) do NOT prevent the
  boot-time lock — only the EC `_Q24` sequence at runtime unlocks.
