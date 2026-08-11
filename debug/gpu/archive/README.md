# Archive: invalid data and outdated tools

Kept so that nothing has to be rebuilt and no one steps on the same rake again.
**No conclusions drawn from here are valid.**

## `bootlog-invalid.csv`

10 checks by the old `bootcheck.sh`, which loaded the card through `vkmark` in
a window. It hits the 60 Hz vertical sync and gives at most ~11 W in any scene —
**below the 16 W cap**, so it could not tell a good boot from a bad one in
principle. All the `BAD` verdicts in this file mean nothing.

On this data the following were judged failures: the `blacklist redmi_wmi`
option, the option of removing `kms` from HOOKS, and the first "reboot while
charging" test. Charging was later re-tested with the fixed tool and closed
honestly; the other two remain only weakly tested.

## `runs-invalid/`

5 `loadtest.sh` runs where the load did not land on the dGPU — it slept at
210 MHz the whole time. Three causes, discovered one after another:

1. `vkmark` was started without `prime-run` and went to the integrated Intel;
2. a wrong argument `-b :duration=999` (empty scene name);
3. `-p immediate` — a mode the card does not support, `vkmark` crashed
   instantly with `Selected present mode Immediate is not supported`.

The output was silenced into `/dev/null`, so the error stayed invisible for
five runs in a row.

## `loadtest.sh`, `loadtest-report.sh`

A synthetic test that separated GPU and CPU load to check whether the CPU takes
power away from the video card. The hypothesis was closed by measurements
(CPU 14.3 W with a limit of 52, PSYS 42.9 of 56), the test is no longer needed.

Besides, it is built on `vkmark`, which on this machine does not reach the
card's cap. If a synthetic load is needed, use `prime-run glmark2
--off-screen`, as in `bootcheck.sh`.

## `cpu-cap.sh`

A temporary limit on the CPU's PL1/PL2 for testing the power budget hypothesis.
Never run: the hypothesis was closed by measurements before it came to an
intervention.
