#!/usr/bin/env bash
# Load test report: shows GPU/CPU power in each phase.
#   ./loadtest-report.sh runs/<directory>
set -uo pipefail
D="${1:?specify the run directory}"
[ -f "$D/phases.csv" ] || { echo "no phases.csv, this is not a loadtest.sh run"; exit 1; }

echo "══════════════════════════════════════════════════════════════════════"
echo " LOAD TEST: $(basename "$D")"
echo "══════════════════════════════════════════════════════════════════════"
grep -E "battery|AC online|RAPL|nvidia power|platform_profile" "$D/static.txt" | sed 's/^--- /  /'
echo

# gpu.csv: ts in the format "YYYY/MM/DD HH:MM:SS.mmm" → converted to epoch via date
awk -F',' 'NR>0 {print $1}' "$D/gpu.csv" > /tmp/.gts 2>/dev/null

python3 - "$D" <<'PY'
import csv, sys, datetime, statistics as st

d = sys.argv[1]

phases = []
with open(f"{d}/phases.csv") as f:
    for line in f:
        t, name = line.strip().split(',')
        phases.append((int(t), name))

def phase_of(ep):
    cur = None
    for t, name in phases:
        if ep >= t: cur = name
        else: break
    return cur

# --- GPU ---
gpu = {}
with open(f"{d}/gpu.csv") as f:
    for row in csv.reader(f):
        if len(row) < 11: continue
        try:
            ts = datetime.datetime.strptime(row[0].strip()[:19], "%Y/%m/%d %H:%M:%S")
            ep = int(ts.timestamp())
            w, sm, util, temp = float(row[1]), float(row[2]), float(row[4]), float(row[6])
            reason = row[10].strip()
        except (ValueError, IndexError):
            continue
        gpu.setdefault(ep, (w, sm, util, temp, reason))

# --- system ---
sysd = {}
with open(f"{d}/sys.csv") as f:
    r = csv.DictReader(f)
    for row in r:
        try:
            ep = int(row["epoch"])
            sysd[ep] = (float(row["pkg_w"]), float(row["psys_w"] or 0),
                        float(row["cpu_freq_max_mhz"]), float(row["pkg_temp_c"]),
                        float(row["bat_power_w"] or 0), row["bat_status"])
        except (ValueError, KeyError, TypeError):
            continue

order = ["idle", "gpu", "cpu", "both", "idle2"]
label = {"idle": "IDLE", "gpu": "GPU ONLY", "cpu": "CPU ONLY",
         "both": "GPU + CPU TOGETHER", "idle2": "COOLDOWN"}

print(f"{'phase':<20} {'GPU W':>8} {'GPU MHz':>9} {'CPU W':>8} {'PSYS W':>9} {'CPU MHz':>9} {'bat W':>8}")
print("─" * 78)

res = {}
for ph in order:
    eps = [e for e in gpu if phase_of(e) == ph]
    # discard the first 10 s of a phase: transient
    if eps:
        eps = sorted(eps)[10:]
    if not eps:
        continue
    gw   = st.mean(gpu[e][0] for e in eps)
    gsm  = st.mean(gpu[e][1] for e in eps)
    se   = [e for e in eps if e in sysd]
    pw   = st.mean(sysd[e][0] for e in se) if se else 0
    psw  = st.mean(sysd[e][1] for e in se) if se else 0
    cf   = st.mean(sysd[e][2] for e in se) if se else 0
    bw   = st.mean(sysd[e][4] for e in se) if se else 0
    res[ph] = (gw, gsm, pw, psw, cf, bw)
    print(f"{label[ph]:<20} {gw:>8.1f} {gsm:>9.0f} {pw:>8.1f} {psw:>9.1f} {cf:>9.0f} {bw:>8.1f}")

print()
print("══ CONCLUSION ═════════════════════════════════════════════════════════")

g_only = res.get("gpu")
both   = res.get("both")
c_only = res.get("cpu")

if g_only and g_only[1] < 400:
    print("  ✖ TEST INVALID: in the 'GPU only' phase the dGPU stayed at an idle")
    print(f"    {g_only[1]:.0f} MHz: the load went to the integrated Intel, the RTX 2050 slept.")
    print("    Update loadtest.sh (it must contain prime-run) and rerun.")
    print("═" * 70)
    sys.exit(0)

if g_only:
    gw = g_only[0]
    print(f"  On its own the GPU takes {gw:.1f} W of its rated 35 W.")
    if gw < 25:
        print("  ⚠ The GPU does NOT REACH its limit even without CPU load.")
        print("    → so it is not about sharing with the CPU, the platform/EC is cutting it.")
    else:
        print("  ✔ On its own the GPU reaches its limit: the hardware is fine.")

if g_only and both:
    drop = g_only[0] - both[0]
    pct  = 100 * drop / g_only[0] if g_only[0] else 0
    print(f"\n  When CPU load is added: {g_only[0]:.1f} W → {both[0]:.1f} W "
          f"(lost {drop:.1f} W, {pct:.0f}%).")
    if pct > 25:
        print("  ⚠ BUDGET SHARING CONFIRMED: the CPU takes power away from the GPU.")
        print("    Cured by limiting the CPU's PL1/PL2, see README.md, step 2.")
    else:
        print("  ✔ The CPU does not take budget from the GPU.")

if c_only:
    print(f"\n  On its own the CPU takes {c_only[2]:.1f} W (PL1 is currently set to 52 W "
          f"against the rated 28 W of the i7-1260P).")

bat = res.get("both", res.get("gpu", (0,)*6))[5]
if bat > 5:
    print(f"\n  ⚠ The battery was charging during the test ({bat:.1f} W). This eats into the adapter's budget.")
    print("    BE SURE to repeat the test at 100% charge, this is a separate hypothesis.")

print("═" * 70)
PY
