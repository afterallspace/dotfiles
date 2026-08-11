/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20251212 (64-bit version)
 * Copyright (c) 2000 - 2025 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt13.dat
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000131 (305)
 *     Revision         0x02
 *     Checksum         0xA5
 *     OEM ID           "HgRef"
 *     OEM Table ID     "HgPeg"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200717 (538969879)
 */
DefinitionBlock ("", "SSDT", 2, "HgRef", "HgPeg", 0x00001000)
{
    External (_SB_.PC00.PEG0, UnknownObj)
    External (_SB_.PC00.PEG0.PEGP, DeviceObj)
    External (_SB_.PC00.PEG0.POFF, MethodObj)    // 0 Arguments
    External (_SB_.PC00.PEG0.PON_, MethodObj)    // 0 Arguments
    External (_SB_.SGOV, MethodObj)    // 2 Arguments
    External (GBAS, UnknownObj)
    External (HGMD, UnknownObj)
    External (SGGP, UnknownObj)

    Scope (\_SB.PC00.PEG0.PEGP)
    {
        Method (_ON, 0, Serialized)  // _ON_: Power On
        {
            \_SB.PC00.PEG0.PON ()
            Notify (\_SB.PC00.PEG0, Zero) // Bus Check
        }

        Method (_OFF, 0, Serialized)  // _OFF: Power Off
        {
            \_SB.PC00.PEG0.POFF ()
            Notify (\_SB.PC00.PEG0, Zero) // Bus Check
        }

        Method (SGPO, 4, Serialized)
        {
            If ((Arg2 == Zero))
            {
                Arg3 = ~Arg3
                Arg3 &= One
            }

            If ((SGGP == One))
            {
                If (CondRefOf (\_SB.SGOV))
                {
                    \_SB.SGOV (Arg1, Arg3)
                }
            }
        }
    }
}

