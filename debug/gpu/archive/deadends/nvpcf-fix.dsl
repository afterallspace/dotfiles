/*
 * Curative SSDT: the \NVFX method rewrites the \_SB.NPCF variables with sane ones
 * and sends the driver Notify 0xC0 "re-read the power config".
 *
 * Idea: Xiaomi's factory table gives the GSP TPP AC = 20 W (0xA0 in 1/8 W),
 * which caps the card at ~17 W instead of the vBIOS default of 35. We set TPP 45 W
 * (no longer a limiter), CTGP offsets 0 (no overclocking, just a
 * return to the stock 35 W), Dynamic Boost on.
 *
 * Load on the fly (reversible by a reboot):
 *   sudo modprobe acpi_configfs acpi_call
 *   sudo mkdir /sys/kernel/config/acpi/table/nvpcffix
 *   sudo tee /sys/kernel/config/acpi/table/nvpcffix/aml < nvpcf-fix.aml >/dev/null
 *   echo '\NVFX' | sudo tee /proc/acpi/call && sudo cat /proc/acpi/call
 */
DefinitionBlock ("", "SSDT", 2, "GPUDBG", "NVPCFFIX", 0x00000001)
{
    External (\_SB.NPCF, DeviceObj)
    External (\_SB.NPCF.DBAC, IntObj)
    External (\_SB.NPCF.DBDC, IntObj)
    External (\_SB.NPCF.ACBT, IntObj)
    External (\_SB.NPCF.DCBT, IntObj)
    External (\_SB.NPCF.AMAT, IntObj)
    External (\_SB.NPCF.AMIT, IntObj)
    External (\_SB.NPCF.ATPP, IntObj)
    External (\_SB.NPCF.DTPP, IntObj)
    External (\_SB.PC00.PEG0.PEGP, DeviceObj)

    /*
     * NVOF: reproduces the _Q24 branch for STNM==3, in which the unlocked
     * state was observed (33 W / 50 W cap): boost controller OFF,
     * offsets 0, and a notification for the driver to re-read the config.
     * Try FIRST when the card is capped.
     */
    Method (\NVOF, 0, Serialized)
    {
        \_SB.NPCF.DBAC = Zero
        \_SB.NPCF.DBDC = Zero
        \_SB.NPCF.ACBT = Zero
        \_SB.NPCF.DCBT = Zero
        Notify (\_SB.PC00.PEG0.PEGP, 0xC0)
        Notify (\_SB.NPCF, 0xC0)
        Return (Zero)
    }

    /*
     * NVFX: the alternative: boost controller ON, but with a sane TPP of 45 W
     * instead of the factory 20. Try if NVOF did not help.
     * (The NVST method, which changes the EC mode, is in a separate table nvpcf-stnm.dsl,
     * so the tables can load independently.)
     */
    Method (\NVFX, 0, Serialized)
    {
        \_SB.NPCF.DBAC = One        // Dynamic Boost AC on
        \_SB.NPCF.DBDC = One        // Dynamic Boost DC on
        \_SB.NPCF.ACBT = Zero       // CTGP offset AC: 0 → the stock 35 W, no overclocking
        \_SB.NPCF.DCBT = Zero
        \_SB.NPCF.AMAT = 0x50       // max boost offset 10 W (factory value of the PDFG&8 branch)
        \_SB.NPCF.AMIT = Zero
        \_SB.NPCF.ATPP = 0x0168     // TPP AC 45 W, no longer a limiter
        \_SB.NPCF.DTPP = 0x78       // TPP DC 15 W, legitimizes the observed DC mode
        Notify (\_SB.PC00.PEG0.PEGP, 0xC0)
        Notify (\_SB.NPCF, 0xC0)
        Return (Zero)
    }
}
