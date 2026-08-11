/*
 * NVST: write a mode to the EC register STNM (1/2/3) and run the stock
 * _Q24 handler, the way the EC itself does on a mode change. An exact
 * reproduction of the evening of Jul 21: NVST 3 = the state in which the card was
 * unlocked (33 W / 50 W cap). A separate table so it can load
 * independently of nvpcf-fix (methods must not be duplicated across tables).
 *
 * Usage (or through nvpcf-unlock.sh --stnm 3):
 *   sudo mkdir /sys/kernel/config/acpi/table/nvpcfstnm
 *   sudo tee /sys/kernel/config/acpi/table/nvpcfstnm/aml < nvpcf-stnm.aml >/dev/null
 *   echo '\NVST 3' | sudo tee /proc/acpi/call && sudo cat /proc/acpi/call
 */
DefinitionBlock ("", "SSDT", 2, "GPUDBG", "NVPCFSTN", 0x00000001)
{
    External (\_SB.PC00.LPCB.H_EC.STNM, FieldUnitObj)
    External (\_SB.PC00.LPCB.H_EC._Q24, MethodObj)

    Method (\NVST, 1, Serialized)
    {
        \_SB.PC00.LPCB.H_EC.STNM = Arg0
        \_SB.PC00.LPCB.H_EC._Q24 ()
        Return (\_SB.PC00.LPCB.H_EC.STNM)
    }
}
