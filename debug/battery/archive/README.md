# Archive of the battery branch

Unlike [`../../gpu/archive/`](../../gpu/archive/README.md), this is **not invalid
data**. The tool works, and the conclusions obtained with it are valid and are
included in [`../BATTERY.md`](../BATTERY.md). It is in the archive because the
path is closed, not because it is wrong.

## `chargelimit.sh`

Controls the charge limit through MIFS WMI (`\_SB.PC00.WMID.WMAA`) and, above all,
diagnoses this interface. Written on 2026-08-05, and the branch was closed with
it.

**Why it is a dead end:** the SMI handler in BIOS `XMAAD6B0P1717` accepts the call
but does not implement command group `0x10` (charge protection). Proved by a
chain: the method is called → the write to shared memory arrives (`CTID`/`MTID`
read back) → an SMI is generated (`MSR 0x34` gives +1 per call against a zero
background) → a response is never written. The full analysis is in
`../BATTERY.md`, section "Charge limit: investigation closed".

**Why it is worth keeping:**

- It is a ready re-check in case Xiaomi does release a new BIOS. `diag` and `smi`
  give a verdict in a couple of minutes instead of reverse engineering the
  protocol again.
- The script's header records the entire decoded MIFS protocol: the layout of the
  32-byte buffer, operation codes, sub-functions of group `0x10`, the table of
  limit codes. It is the only place in the repository that has it.
- `smi` is a universal technique for this machine: it shows whether a write to
  port `0xB2` reaches SMM at all. It will come in handy in any future ACPI
  investigation on the TM2121.

**Subcommands** (all except `set`/`off` only read):

| Command | What it does |
|---|---|
| `status` | limit, firmware health, adapter watts |
| `diag` | whether the transport is alive: `MTID`, `CTID`, `PSSP`, buffer |
| `smi` | counts SMIs through `MSR 0x34` before/after a call, with background |
| `mem` | what really lands in memory (needs `/dev/mem`, currently refused) |
| `rotsweep` | skew precompensation sweep over all 32 positions |
| `calib` | checks the response layout against a reference from `hwmon` |
| `probe` | sweep of firmware functions `0x01`…`0x30` |
| `raw` | one call, raw bytes |
| `set <%>` / `off` | writes the limit — **will not work on this firmware** |

⚠ The script requires root and the `acpi_call` module. It fails with an error
instead of substituting a zero — per the branch's rule on silent zeros.
