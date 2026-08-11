/*
 * NVSW: write a mode to the EC register STNM WITHOUT calling _Q24.
 * Needed because _Q24 run while the EC reports STNM=2 lands in the
 * "Dynamic Boost on" branch and LOCKS the card (hit on Jul 22). The safe
 * order: NVSW 3 → wait until reading STNM returns 3 → only then
 * _Q24. Implemented in nvpcf-unlock.sh (the default mode).
 */
DefinitionBlock ("", "SSDT", 2, "GPUDBG", "NVPCFSET", 0x00000001)
{
    External (\_SB.PC00.LPCB.H_EC.STNM, FieldUnitObj)

    Method (\NVSW, 1, Serialized)
    {
        \_SB.PC00.LPCB.H_EC.STNM = Arg0
        Return (\_SB.PC00.LPCB.H_EC.STNM)
    }
}
