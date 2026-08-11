/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20251212 (64-bit version)
 * Copyright (c) 2000 - 2025 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt3.dat
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00002B2A (11050)
 *     Revision         0x02
 *     Checksum         0x6F
 *     OEM ID           "SocCmn"
 *     OEM Table ID     "SocCmn "
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200717 (538969879)
 */
DefinitionBlock ("", "SSDT", 2, "SocCmn", "SocCmn ", 0x00003000)
{
    External (_SB_.CPPC, FieldUnitObj)
    External (_SB_.PC00.RP01, DeviceObj)
    External (_SB_.PC00.RP01.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP01.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP01.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP01.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP01.VDID, FieldUnitObj)
    External (_SB_.PC00.RP02, DeviceObj)
    External (_SB_.PC00.RP02.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP02.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP02.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP02.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP02.VDID, FieldUnitObj)
    External (_SB_.PC00.RP03, DeviceObj)
    External (_SB_.PC00.RP03.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP03.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP03.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP03.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP03.VDID, FieldUnitObj)
    External (_SB_.PC00.RP04, DeviceObj)
    External (_SB_.PC00.RP04.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP04.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP04.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP04.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP04.VDID, FieldUnitObj)
    External (_SB_.PC00.RP05, DeviceObj)
    External (_SB_.PC00.RP05.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP05.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP05.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP05.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP05.VDID, FieldUnitObj)
    External (_SB_.PC00.RP06, DeviceObj)
    External (_SB_.PC00.RP06.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP06.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP06.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP06.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP06.VDID, FieldUnitObj)
    External (_SB_.PC00.RP07, DeviceObj)
    External (_SB_.PC00.RP07.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP07.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP07.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP07.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP07.VDID, FieldUnitObj)
    External (_SB_.PC00.RP08, DeviceObj)
    External (_SB_.PC00.RP08.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP08.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP08.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP08.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP08.VDID, FieldUnitObj)
    External (_SB_.PC00.RP09, DeviceObj)
    External (_SB_.PC00.RP09.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP09.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP09.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP09.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP09.VDID, FieldUnitObj)
    External (_SB_.PC00.RP10, DeviceObj)
    External (_SB_.PC00.RP10.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP10.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP10.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP10.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP10.VDID, FieldUnitObj)
    External (_SB_.PC00.RP11, DeviceObj)
    External (_SB_.PC00.RP11.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP11.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP11.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP11.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP11.VDID, FieldUnitObj)
    External (_SB_.PC00.RP12, DeviceObj)
    External (_SB_.PC00.RP12.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP12.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP12.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP12.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP12.VDID, FieldUnitObj)
    External (_SB_.PC00.RP13, DeviceObj)
    External (_SB_.PC00.RP13.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP13.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP13.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP13.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP13.VDID, FieldUnitObj)
    External (_SB_.PC00.RP14, DeviceObj)
    External (_SB_.PC00.RP14.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP14.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP14.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP14.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP14.VDID, FieldUnitObj)
    External (_SB_.PC00.RP15, DeviceObj)
    External (_SB_.PC00.RP15.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP15.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP15.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP15.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP15.VDID, FieldUnitObj)
    External (_SB_.PC00.RP16, DeviceObj)
    External (_SB_.PC00.RP16.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP16.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP16.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP16.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP16.VDID, FieldUnitObj)
    External (_SB_.PC00.RP17, DeviceObj)
    External (_SB_.PC00.RP17.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP17.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP17.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP17.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP17.VDID, FieldUnitObj)
    External (_SB_.PC00.RP18, DeviceObj)
    External (_SB_.PC00.RP18.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP18.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP18.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP18.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP18.VDID, FieldUnitObj)
    External (_SB_.PC00.RP19, DeviceObj)
    External (_SB_.PC00.RP19.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP19.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP19.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP19.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP19.VDID, FieldUnitObj)
    External (_SB_.PC00.RP20, DeviceObj)
    External (_SB_.PC00.RP20.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP20.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP20.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP20.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP20.VDID, FieldUnitObj)
    External (_SB_.PC00.RP21, DeviceObj)
    External (_SB_.PC00.RP21.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP21.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP21.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP21.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP21.VDID, FieldUnitObj)
    External (_SB_.PC00.RP22, DeviceObj)
    External (_SB_.PC00.RP22.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP22.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP22.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP22.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP22.VDID, FieldUnitObj)
    External (_SB_.PC00.RP23, DeviceObj)
    External (_SB_.PC00.RP23.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP23.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP23.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP23.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP23.VDID, FieldUnitObj)
    External (_SB_.PC00.RP24, DeviceObj)
    External (_SB_.PC00.RP24.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP24.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP24.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP24.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP24.VDID, FieldUnitObj)
    External (_SB_.PC00.RP25, DeviceObj)
    External (_SB_.PC00.RP25.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP25.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP25.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP25.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP25.VDID, FieldUnitObj)
    External (_SB_.PC00.RP26, DeviceObj)
    External (_SB_.PC00.RP26.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP26.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP26.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP26.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP26.VDID, FieldUnitObj)
    External (_SB_.PC00.RP27, DeviceObj)
    External (_SB_.PC00.RP27.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP27.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP27.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP27.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP27.VDID, FieldUnitObj)
    External (_SB_.PC00.RP28, DeviceObj)
    External (_SB_.PC00.RP28.HPEX, FieldUnitObj)
    External (_SB_.PC00.RP28.HPSX, FieldUnitObj)
    External (_SB_.PC00.RP28.PMEX, FieldUnitObj)
    External (_SB_.PC00.RP28.PMSX, FieldUnitObj)
    External (_SB_.PC00.RP28.VDID, FieldUnitObj)
    External (_SB_.PC00.TCON, MethodObj)    // 0 Arguments
    External (_SB_.PC00.TG0N, MethodObj)    // 0 Arguments
    External (_SB_.PC00.TG1N, MethodObj)    // 0 Arguments
    External (_SB_.PC00.TRP0.HPEX, IntObj)
    External (_SB_.PC00.TRP0.HPSX, IntObj)
    External (_SB_.PC00.TRP0.PMEX, IntObj)
    External (_SB_.PC00.TRP0.PMSX, IntObj)
    External (_SB_.PC00.TRP1.HPEX, IntObj)
    External (_SB_.PC00.TRP1.HPSX, IntObj)
    External (_SB_.PC00.TRP1.PMEX, IntObj)
    External (_SB_.PC00.TRP1.PMSX, IntObj)
    External (_SB_.PC00.TRP2.HPEX, IntObj)
    External (_SB_.PC00.TRP2.HPSX, IntObj)
    External (_SB_.PC00.TRP2.PMEX, IntObj)
    External (_SB_.PC00.TRP2.PMSX, IntObj)
    External (_SB_.PC00.TRP3.HPEX, IntObj)
    External (_SB_.PC00.TRP3.HPSX, IntObj)
    External (_SB_.PC00.TRP3.PMEX, IntObj)
    External (_SB_.PC00.TRP3.PMSX, IntObj)
    External (_SB_.PC00.TXHC, DeviceObj)
    External (_SB_.PC01.TRP0.HPEX, IntObj)
    External (_SB_.PC01.TRP0.HPSX, IntObj)
    External (_SB_.PC01.TRP0.PMEX, IntObj)
    External (_SB_.PC01.TRP0.PMSX, IntObj)
    External (_SB_.PC01.TRP1.HPEX, IntObj)
    External (_SB_.PC01.TRP1.HPSX, IntObj)
    External (_SB_.PC01.TRP1.PMEX, IntObj)
    External (_SB_.PC01.TRP1.PMSX, IntObj)
    External (_SB_.PC01.TRP2.HPEX, IntObj)
    External (_SB_.PC01.TRP2.HPSX, IntObj)
    External (_SB_.PC01.TRP2.PMEX, IntObj)
    External (_SB_.PC01.TRP2.PMSX, IntObj)
    External (_SB_.PC01.TRP3.HPEX, IntObj)
    External (_SB_.PC01.TRP3.HPSX, IntObj)
    External (_SB_.PC01.TRP3.PMEX, IntObj)
    External (_SB_.PC01.TRP3.PMSX, IntObj)
    External (_SB_.PR00, DeviceObj)
    External (_SB_.PR00.LPSS, PkgObj)
    External (_SB_.PR00.TPSS, PkgObj)
    External (_SB_.PR01, DeviceObj)
    External (_SB_.PR02, DeviceObj)
    External (_SB_.PR03, DeviceObj)
    External (_SB_.PR04, DeviceObj)
    External (_SB_.PR05, DeviceObj)
    External (_SB_.PR06, DeviceObj)
    External (_SB_.PR07, DeviceObj)
    External (_SB_.PR08, DeviceObj)
    External (_SB_.PR09, DeviceObj)
    External (_SB_.PR10, DeviceObj)
    External (_SB_.PR11, DeviceObj)
    External (_SB_.PR12, DeviceObj)
    External (_SB_.PR13, DeviceObj)
    External (_SB_.PR14, DeviceObj)
    External (_SB_.PR15, DeviceObj)
    External (_SB_.TCWK, MethodObj)    // 1 Arguments
    External (ITRT, FieldUnitObj)
    External (NEXP, FieldUnitObj)
    External (OSCC, FieldUnitObj)
    External (PCHS, FieldUnitObj)
    External (PCHX, IntObj)
    External (PF00, IntObj)
    External (PF01, IntObj)
    External (PF02, IntObj)
    External (PF03, IntObj)
    External (PF04, IntObj)
    External (PF05, IntObj)
    External (PF06, IntObj)
    External (PF07, IntObj)
    External (PF08, IntObj)
    External (PF09, IntObj)
    External (PF10, IntObj)
    External (PF11, IntObj)
    External (PF12, IntObj)
    External (PF13, IntObj)
    External (PF14, IntObj)
    External (PF15, IntObj)
    External (TCNT, FieldUnitObj)
    External (TRTD, FieldUnitObj)

    Method (NHPG, 0, Serialized)
    {
        \_SB.PC00.RP01.HPEX = Zero
        \_SB.PC00.RP02.HPEX = Zero
        \_SB.PC00.RP03.HPEX = Zero
        \_SB.PC00.RP04.HPEX = Zero
        \_SB.PC00.RP05.HPEX = Zero
        \_SB.PC00.RP06.HPEX = Zero
        \_SB.PC00.RP07.HPEX = Zero
        \_SB.PC00.RP08.HPEX = Zero
        \_SB.PC00.RP09.HPEX = Zero
        \_SB.PC00.RP10.HPEX = Zero
        \_SB.PC00.RP11.HPEX = Zero
        \_SB.PC00.RP12.HPEX = Zero
        If ((PCHS == PCHX))
        {
            \_SB.PC00.RP13.HPEX = Zero
            \_SB.PC00.RP14.HPEX = Zero
            \_SB.PC00.RP15.HPEX = Zero
            \_SB.PC00.RP16.HPEX = Zero
            \_SB.PC00.RP17.HPEX = Zero
            \_SB.PC00.RP18.HPEX = Zero
            \_SB.PC00.RP19.HPEX = Zero
            \_SB.PC00.RP20.HPEX = Zero
            \_SB.PC00.RP21.HPEX = Zero
            \_SB.PC00.RP22.HPEX = Zero
            \_SB.PC00.RP23.HPEX = Zero
            \_SB.PC00.RP24.HPEX = Zero
            \_SB.PC00.RP25.HPEX = Zero
            \_SB.PC00.RP26.HPEX = Zero
            \_SB.PC00.RP27.HPEX = Zero
            \_SB.PC00.RP28.HPEX = Zero
        }

        If (CondRefOf (\_SB.PC00.TXHC))
        {
            If (CondRefOf (\_SB.PC01))
            {
                \_SB.PC01.TRP0.HPEX = Zero
                \_SB.PC01.TRP1.HPEX = Zero
                \_SB.PC01.TRP2.HPEX = Zero
                \_SB.PC01.TRP3.HPEX = Zero
            }
            Else
            {
                \_SB.PC00.TRP0.HPEX = Zero
                \_SB.PC00.TRP1.HPEX = Zero
                \_SB.PC00.TRP2.HPEX = Zero
                \_SB.PC00.TRP3.HPEX = Zero
            }
        }

        \_SB.PC00.RP01.HPSX = One
        \_SB.PC00.RP02.HPSX = One
        \_SB.PC00.RP03.HPSX = One
        \_SB.PC00.RP04.HPSX = One
        \_SB.PC00.RP05.HPSX = One
        \_SB.PC00.RP06.HPSX = One
        \_SB.PC00.RP07.HPSX = One
        \_SB.PC00.RP08.HPSX = One
        \_SB.PC00.RP09.HPSX = One
        \_SB.PC00.RP10.HPSX = One
        \_SB.PC00.RP11.HPSX = One
        \_SB.PC00.RP12.HPSX = One
        If ((PCHS == PCHX))
        {
            \_SB.PC00.RP13.HPSX = One
            \_SB.PC00.RP14.HPSX = One
            \_SB.PC00.RP15.HPSX = One
            \_SB.PC00.RP16.HPSX = One
            \_SB.PC00.RP17.HPSX = One
            \_SB.PC00.RP18.HPSX = One
            \_SB.PC00.RP19.HPSX = One
            \_SB.PC00.RP20.HPSX = One
            \_SB.PC00.RP21.HPSX = One
            \_SB.PC00.RP22.HPSX = One
            \_SB.PC00.RP23.HPSX = One
            \_SB.PC00.RP24.HPSX = One
            \_SB.PC00.RP25.HPSX = One
            \_SB.PC00.RP26.HPSX = One
            \_SB.PC00.RP27.HPSX = One
            \_SB.PC00.RP28.HPSX = One
        }

        If (CondRefOf (\_SB.PC00.TXHC))
        {
            If (CondRefOf (\_SB.PC01))
            {
                \_SB.PC01.TRP0.HPSX = One
                \_SB.PC01.TRP1.HPSX = One
                \_SB.PC01.TRP2.HPSX = One
                \_SB.PC01.TRP3.HPSX = One
            }
            Else
            {
                \_SB.PC00.TRP0.HPSX = One
                \_SB.PC00.TRP1.HPSX = One
                \_SB.PC00.TRP2.HPSX = One
                \_SB.PC00.TRP3.HPSX = One
            }
        }
    }

    Method (NPME, 0, Serialized)
    {
        \_SB.PC00.RP01.PMEX = Zero
        \_SB.PC00.RP02.PMEX = Zero
        \_SB.PC00.RP03.PMEX = Zero
        \_SB.PC00.RP04.PMEX = Zero
        \_SB.PC00.RP05.PMEX = Zero
        \_SB.PC00.RP06.PMEX = Zero
        \_SB.PC00.RP07.PMEX = Zero
        \_SB.PC00.RP08.PMEX = Zero
        \_SB.PC00.RP09.PMEX = Zero
        \_SB.PC00.RP10.PMEX = Zero
        \_SB.PC00.RP11.PMEX = Zero
        \_SB.PC00.RP12.PMEX = Zero
        If ((PCHS == PCHX))
        {
            \_SB.PC00.RP13.PMEX = Zero
            \_SB.PC00.RP14.PMEX = Zero
            \_SB.PC00.RP15.PMEX = Zero
            \_SB.PC00.RP16.PMEX = Zero
            \_SB.PC00.RP17.PMEX = Zero
            \_SB.PC00.RP18.PMEX = Zero
            \_SB.PC00.RP19.PMEX = Zero
            \_SB.PC00.RP20.PMEX = Zero
            \_SB.PC00.RP21.PMEX = Zero
            \_SB.PC00.RP22.PMEX = Zero
            \_SB.PC00.RP23.PMEX = Zero
            \_SB.PC00.RP24.PMEX = Zero
            \_SB.PC00.RP21.PMEX = Zero
            \_SB.PC00.RP22.PMEX = Zero
            \_SB.PC00.RP23.PMEX = Zero
            \_SB.PC00.RP24.PMEX = Zero
            \_SB.PC00.RP25.PMEX = Zero
            \_SB.PC00.RP26.PMEX = Zero
            \_SB.PC00.RP27.PMEX = Zero
            \_SB.PC00.RP28.PMEX = Zero
        }

        If (CondRefOf (\_SB.PC00.TXHC))
        {
            If (CondRefOf (\_SB.PC01))
            {
                \_SB.PC01.TRP0.PMEX = Zero
                \_SB.PC01.TRP1.PMEX = Zero
                \_SB.PC01.TRP2.PMEX = Zero
                \_SB.PC01.TRP3.PMEX = Zero
            }
            Else
            {
                \_SB.PC00.TRP0.PMEX = Zero
                \_SB.PC00.TRP1.PMEX = Zero
                \_SB.PC00.TRP2.PMEX = Zero
                \_SB.PC00.TRP3.PMEX = Zero
            }
        }

        \_SB.PC00.RP01.PMSX = One
        \_SB.PC00.RP02.PMSX = One
        \_SB.PC00.RP03.PMSX = One
        \_SB.PC00.RP04.PMSX = One
        \_SB.PC00.RP05.PMSX = One
        \_SB.PC00.RP06.PMSX = One
        \_SB.PC00.RP07.PMSX = One
        \_SB.PC00.RP08.PMSX = One
        \_SB.PC00.RP09.PMSX = One
        \_SB.PC00.RP10.PMSX = One
        \_SB.PC00.RP11.PMSX = One
        \_SB.PC00.RP12.PMSX = One
        If ((PCHS == PCHX))
        {
            \_SB.PC00.RP13.PMSX = One
            \_SB.PC00.RP14.PMSX = One
            \_SB.PC00.RP15.PMSX = One
            \_SB.PC00.RP16.PMSX = One
            \_SB.PC00.RP17.PMSX = One
            \_SB.PC00.RP18.PMSX = One
            \_SB.PC00.RP19.PMSX = One
            \_SB.PC00.RP20.PMSX = One
            \_SB.PC00.RP21.PMSX = One
            \_SB.PC00.RP22.PMSX = One
            \_SB.PC00.RP23.PMSX = One
            \_SB.PC00.RP24.PMSX = One
            \_SB.PC00.RP25.PMSX = One
            \_SB.PC00.RP26.PMSX = One
            \_SB.PC00.RP27.PMSX = One
            \_SB.PC00.RP28.PMSX = One
        }

        If (CondRefOf (\_SB.PC00.TXHC))
        {
            If (CondRefOf (\_SB.PC01))
            {
                \_SB.PC01.TRP0.PMSX = One
                \_SB.PC01.TRP1.PMSX = One
                \_SB.PC01.TRP2.PMSX = One
                \_SB.PC01.TRP3.PMSX = One
            }
            Else
            {
                \_SB.PC00.TRP0.PMSX = One
                \_SB.PC00.TRP1.PMSX = One
                \_SB.PC00.TRP2.PMSX = One
                \_SB.PC00.TRP3.PMSX = One
            }
        }
    }

    Method (SPNT, 0, Serialized)
    {
        If ((\PF00 & 0x0400))
        {
            If (CondRefOf (\_SB.PR00.TPSS))
            {
                \_SB.CPPC = (SizeOf (\_SB.PR00.TPSS) - One)
            }
        }
        ElseIf (CondRefOf (\_SB.PR00.LPSS))
        {
            \_SB.CPPC = (SizeOf (\_SB.PR00.LPSS) - One)
        }

        If ((TCNT > One))
        {
            If ((\PF00 & 0x08))
            {
                Notify (\_SB.PR00, 0x80) // Status Change
            }

            If ((\PF01 & 0x08))
            {
                Notify (\_SB.PR01, 0x80) // Status Change
            }

            If ((\PF02 & 0x08))
            {
                Notify (\_SB.PR02, 0x80) // Status Change
            }

            If ((\PF03 & 0x08))
            {
                Notify (\_SB.PR03, 0x80) // Status Change
            }

            If ((\PF04 & 0x08))
            {
                Notify (\_SB.PR04, 0x80) // Status Change
            }

            If ((\PF05 & 0x08))
            {
                Notify (\_SB.PR05, 0x80) // Status Change
            }

            If ((\PF06 & 0x08))
            {
                Notify (\_SB.PR06, 0x80) // Status Change
            }

            If ((\PF07 & 0x08))
            {
                Notify (\_SB.PR07, 0x80) // Status Change
            }

            If ((\PF08 & 0x08))
            {
                Notify (\_SB.PR08, 0x80) // Status Change
            }

            If ((\PF09 & 0x08))
            {
                Notify (\_SB.PR09, 0x80) // Status Change
            }

            If ((\PF10 & 0x08))
            {
                Notify (\_SB.PR10, 0x80) // Status Change
            }

            If ((\PF11 & 0x08))
            {
                Notify (\_SB.PR11, 0x80) // Status Change
            }

            If ((\PF12 & 0x08))
            {
                Notify (\_SB.PR12, 0x80) // Status Change
            }

            If ((\PF13 & 0x08))
            {
                Notify (\_SB.PR13, 0x80) // Status Change
            }

            If ((\PF14 & 0x08))
            {
                Notify (\_SB.PR14, 0x80) // Status Change
            }

            If ((\PF15 & 0x08))
            {
                Notify (\_SB.PR15, 0x80) // Status Change
            }
        }
        Else
        {
            Notify (\_SB.PR00, 0x80) // Status Change
        }

        If ((TCNT > One))
        {
            If (((\PF00 & 0x08) && (\PF00 & 0x10)))
            {
                Notify (\_SB.PR00, 0x81) // Information Change
            }

            If (((\PF01 & 0x08) && (\PF01 & 0x10)))
            {
                Notify (\_SB.PR01, 0x81) // Information Change
            }

            If (((\PF02 & 0x08) && (\PF02 & 0x10)))
            {
                Notify (\_SB.PR02, 0x81) // Information Change
            }

            If (((\PF03 & 0x08) && (\PF03 & 0x10)))
            {
                Notify (\_SB.PR03, 0x81) // Information Change
            }

            If (((\PF04 & 0x08) && (\PF04 & 0x10)))
            {
                Notify (\_SB.PR04, 0x81) // Information Change
            }

            If (((\PF05 & 0x08) && (\PF05 & 0x10)))
            {
                Notify (\_SB.PR05, 0x81) // Information Change
            }

            If (((\PF06 & 0x08) && (\PF06 & 0x10)))
            {
                Notify (\_SB.PR06, 0x81) // Information Change
            }

            If (((\PF07 & 0x08) && (\PF07 & 0x10)))
            {
                Notify (\_SB.PR07, 0x81) // Information Change
            }

            If (((\PF08 & 0x08) && (\PF08 & 0x10)))
            {
                Notify (\_SB.PR08, 0x81) // Information Change
            }

            If (((\PF09 & 0x08) && (\PF09 & 0x10)))
            {
                Notify (\_SB.PR09, 0x81) // Information Change
            }

            If (((\PF10 & 0x08) && (\PF10 & 0x10)))
            {
                Notify (\_SB.PR10, 0x81) // Information Change
            }

            If (((\PF11 & 0x08) && (\PF11 & 0x10)))
            {
                Notify (\_SB.PR11, 0x81) // Information Change
            }

            If (((\PF12 & 0x08) && (\PF12 & 0x10)))
            {
                Notify (\_SB.PR12, 0x81) // Information Change
            }

            If (((\PF13 & 0x08) && (\PF13 & 0x10)))
            {
                Notify (\_SB.PR13, 0x81) // Information Change
            }

            If (((\PF14 & 0x08) && (\PF14 & 0x10)))
            {
                Notify (\_SB.PR14, 0x81) // Information Change
            }

            If (((\PF15 & 0x08) && (\PF15 & 0x10)))
            {
                Notify (\_SB.PR15, 0x81) // Information Change
            }
        }
        Else
        {
            Notify (\_SB.PR00, 0x81) // Information Change
        }
    }

    Method (SPTS, 1, NotSerialized)
    {
        If (CondRefOf (\_SB.PC00.TXHC))
        {
            If (TRTD)
            {
                \_SB.PC00.TCON ()
            }

            If (ITRT)
            {
                \_SB.PC00.TG0N ()
                \_SB.PC00.TG1N ()
            }
        }
    }

    Method (SWAK, 2, NotSerialized)
    {
        If (NEXP)
        {
            If ((OSCC & One))
            {
                NHPG ()
            }

            If ((OSCC & 0x04))
            {
                NPME ()
            }
        }

        If (((Arg0 == 0x03) || (Arg0 == 0x04)))
        {
            If ((\_SB.PC00.RP01.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x02) != One))
                {
                    Notify (\_SB.PC00.RP01, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP02.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x04) != One))
                {
                    Notify (\_SB.PC00.RP02, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP03.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x08) != One))
                {
                    Notify (\_SB.PC00.RP03, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP04.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x10) != One))
                {
                    Notify (\_SB.PC00.RP04, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP05.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x20) != One))
                {
                    Notify (\_SB.PC00.RP05, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP06.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x40) != One))
                {
                    Notify (\_SB.PC00.RP06, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP07.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x80) != One))
                {
                    Notify (\_SB.PC00.RP07, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP08.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x0100) != One))
                {
                    Notify (\_SB.PC00.RP08, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP09.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x0200) != One))
                {
                    Notify (\_SB.PC00.RP09, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP10.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x0400) != One))
                {
                    Notify (\_SB.PC00.RP10, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP11.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x0800) != One))
                {
                    Notify (\_SB.PC00.RP11, Zero) // Bus Check
                }
            }

            If ((\_SB.PC00.RP12.VDID != 0xFFFFFFFF))
            {
                If (((Arg1 & 0x1000) != One))
                {
                    Notify (\_SB.PC00.RP12, Zero) // Bus Check
                }
            }

            If ((PCHS == PCHX))
            {
                If ((\_SB.PC00.RP13.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x2000) != One))
                    {
                        Notify (\_SB.PC00.RP13, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP14.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x4000) != One))
                    {
                        Notify (\_SB.PC00.RP14, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP15.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x8000) != One))
                    {
                        Notify (\_SB.PC00.RP15, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP16.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00010000) != One))
                    {
                        Notify (\_SB.PC00.RP16, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP17.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00020000) != One))
                    {
                        Notify (\_SB.PC00.RP17, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP18.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00040000) != One))
                    {
                        Notify (\_SB.PC00.RP18, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP19.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00080000) != One))
                    {
                        Notify (\_SB.PC00.RP19, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP20.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00100000) != One))
                    {
                        Notify (\_SB.PC00.RP20, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP21.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00200000) != One))
                    {
                        Notify (\_SB.PC00.RP21, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP22.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00400000) != One))
                    {
                        Notify (\_SB.PC00.RP22, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP23.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x00800000) != One))
                    {
                        Notify (\_SB.PC00.RP23, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP24.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x01000000) != One))
                    {
                        Notify (\_SB.PC00.RP24, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP25.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x02000000) != One))
                    {
                        Notify (\_SB.PC00.RP25, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP26.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x04000000) != One))
                    {
                        Notify (\_SB.PC00.RP26, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP27.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x08000000) != One))
                    {
                        Notify (\_SB.PC00.RP27, Zero) // Bus Check
                    }
                }

                If ((\_SB.PC00.RP28.VDID != 0xFFFFFFFF))
                {
                    If (((Arg1 & 0x10000000) != One))
                    {
                        Notify (\_SB.PC00.RP28, Zero) // Bus Check
                    }
                }
            }

            If (CondRefOf (\_SB.PC00.TXHC))
            {
                \_SB.TCWK (Arg0)
            }
        }
    }
}

