/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20251212 (64-bit version)
 * Copyright (c) 2000 - 2025 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt14.dat
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000059C1 (22977)
 *     Revision         0x02
 *     Checksum         0xB6
 *     OEM ID           "DptfTb"
 *     OEM Table ID     "DptfTabl"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200717 (538969879)
 */
DefinitionBlock ("", "SSDT", 2, "DptfTb", "DptfTabl", 0x00001000)
{
    External (_SB_.AAC0, FieldUnitObj)
    External (_SB_.ACRT, FieldUnitObj)
    External (_SB_.APSV, FieldUnitObj)
    External (_SB_.CBMI, FieldUnitObj)
    External (_SB_.CFGD, FieldUnitObj)
    External (_SB_.CLVL, FieldUnitObj)
    External (_SB_.CPPC, FieldUnitObj)
    External (_SB_.CTC0, FieldUnitObj)
    External (_SB_.CTC1, FieldUnitObj)
    External (_SB_.CTC2, FieldUnitObj)
    External (_SB_.OSCP, IntObj)
    External (_SB_.PAGD, DeviceObj)
    External (_SB_.PAGD._PUR, PkgObj)
    External (_SB_.PAGD._STA, MethodObj)    // 0 Arguments
    External (_SB_.PC00, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.CHGR, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.CHRG, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.DGPU, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.ECAV, IntObj)
    External (_SB_.PC00.LPCB.H_EC.ECF2, OpRegionObj)
    External (_SB_.PC00.LPCB.H_EC.ECMD, MethodObj)    // 1 Arguments
    External (_SB_.PC00.LPCB.H_EC.ECRD, MethodObj)    // 1 Arguments
    External (_SB_.PC00.LPCB.H_EC.ECWT, MethodObj)    // 2 Arguments
    External (_SB_.PC00.LPCB.H_EC.FCHG, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.NTDP, MethodObj)    // 1 Arguments
    External (_SB_.PC00.LPCB.H_EC.SEN2, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.SEN3, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.SEN4, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.SEN5, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.STNM, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TFN1, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.TFN2, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.TFN3, DeviceObj)
    External (_SB_.PC00.LPCB.H_EC.TSR1, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TSR2, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TSR3, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TSR4, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TSR5, FieldUnitObj)
    External (_SB_.PC00.LPCB.H_EC.TSR6, FieldUnitObj)
    External (_SB_.PC00.MC__.MHBR, FieldUnitObj)
    External (_SB_.PC00.TCPU, DeviceObj)
    External (_SB_.PL10, FieldUnitObj)
    External (_SB_.PL11, FieldUnitObj)
    External (_SB_.PL12, FieldUnitObj)
    External (_SB_.PL20, FieldUnitObj)
    External (_SB_.PL21, FieldUnitObj)
    External (_SB_.PL22, FieldUnitObj)
    External (_SB_.PLW0, FieldUnitObj)
    External (_SB_.PLW1, FieldUnitObj)
    External (_SB_.PLW2, FieldUnitObj)
    External (_SB_.PR00, ProcessorObj)
    External (_SB_.PR00._PSS, MethodObj)    // 0 Arguments
    External (_SB_.PR00._TPC, IntObj)
    External (_SB_.PR00._TSD, MethodObj)    // 0 Arguments
    External (_SB_.PR00._TSS, MethodObj)    // 0 Arguments
    External (_SB_.PR00.LPSS, PkgObj)
    External (_SB_.PR00.TPSS, PkgObj)
    External (_SB_.PR00.TSMC, PkgObj)
    External (_SB_.PR00.TSMF, PkgObj)
    External (_SB_.PR01, ProcessorObj)
    External (_SB_.PR02, ProcessorObj)
    External (_SB_.PR03, ProcessorObj)
    External (_SB_.PR04, ProcessorObj)
    External (_SB_.PR05, ProcessorObj)
    External (_SB_.PR06, ProcessorObj)
    External (_SB_.PR07, ProcessorObj)
    External (_SB_.PR08, ProcessorObj)
    External (_SB_.PR09, ProcessorObj)
    External (_SB_.PR10, ProcessorObj)
    External (_SB_.PR11, ProcessorObj)
    External (_SB_.PR12, ProcessorObj)
    External (_SB_.PR13, ProcessorObj)
    External (_SB_.PR14, ProcessorObj)
    External (_SB_.PR15, ProcessorObj)
    External (_SB_.PR16, ProcessorObj)
    External (_SB_.PR17, ProcessorObj)
    External (_SB_.PR18, ProcessorObj)
    External (_SB_.PR19, ProcessorObj)
    External (_SB_.PR20, ProcessorObj)
    External (_SB_.PR21, ProcessorObj)
    External (_SB_.PR22, ProcessorObj)
    External (_SB_.PR23, ProcessorObj)
    External (_SB_.PR24, ProcessorObj)
    External (_SB_.PR25, ProcessorObj)
    External (_SB_.PR26, ProcessorObj)
    External (_SB_.PR27, ProcessorObj)
    External (_SB_.PR28, ProcessorObj)
    External (_SB_.PR29, ProcessorObj)
    External (_SB_.PR30, ProcessorObj)
    External (_SB_.PR31, ProcessorObj)
    External (_SB_.TAR0, FieldUnitObj)
    External (_SB_.TAR1, FieldUnitObj)
    External (_SB_.TAR2, FieldUnitObj)
    External (_SB_.TPWR, DeviceObj)
    External (_TZ_.ETMD, IntObj)
    External (_TZ_.TZ00, ThermalZoneObj)
    External (ACTT, IntObj)
    External (ATPC, IntObj)
    External (BATR, IntObj)
    External (CHGE, IntObj)
    External (CRTT, IntObj)
    External (DCFE, IntObj)
    External (DPTF, IntObj)
    External (FND1, IntObj)
    External (FND2, IntObj)
    External (FND3, IntObj)
    External (HIDW, MethodObj)    // 4 Arguments
    External (HIWC, MethodObj)    // 1 Arguments
    External (IN34, IntObj)
    External (IPCS, MethodObj)    // 7 Arguments
    External (OD06, IntObj)
    External (OD07, IntObj)
    External (OD08, IntObj)
    External (ODV0, IntObj)
    External (ODV1, IntObj)
    External (ODV2, IntObj)
    External (ODV3, IntObj)
    External (ODV4, IntObj)
    External (ODV5, IntObj)
    External (PCHE, FieldUnitObj)
    External (PDFG, UnknownObj)
    External (PF00, IntObj)
    External (PLID, IntObj)
    External (PNHM, IntObj)
    External (PPPR, IntObj)
    External (PPSZ, IntObj)
    External (PSVT, IntObj)
    External (PTPC, IntObj)
    External (PWRE, IntObj)
    External (PWRS, IntObj)
    External (S1DE, IntObj)
    External (S2DE, IntObj)
    External (S3DE, IntObj)
    External (S4DE, IntObj)
    External (S5DE, IntObj)
    External (S6DE, IntObj)
    External (S6P2, IntObj)
    External (SADE, IntObj)
    External (SSP1, IntObj)
    External (SSP2, IntObj)
    External (SSP3, IntObj)
    External (SSP4, IntObj)
    External (SSP5, IntObj)
    External (TCNT, IntObj)
    External (TSOD, IntObj)

    Scope (\_SB)
    {
        Device (IETM)
        {
            Method (GHID, 1, Serialized)
            {
                If ((Arg0 == "IETM"))
                {
                    Return ("INTC1041")
                }

                If ((Arg0 == "SEN1"))
                {
                    Return ("INTC1046")
                }

                If ((Arg0 == "SEN2"))
                {
                    Return ("INTC1046")
                }

                If ((Arg0 == "SEN3"))
                {
                    Return ("INTC1046")
                }

                If ((Arg0 == "SEN4"))
                {
                    Return ("INTC1046")
                }

                If ((Arg0 == "SEN5"))
                {
                    Return ("INTC1046")
                }

                If ((Arg0 == "TPCH"))
                {
                    Return ("INTC1049")
                }

                If ((Arg0 == "TFN1"))
                {
                    Return ("INTC1048")
                }

                If ((Arg0 == "TFN2"))
                {
                    Return ("INTC1048")
                }

                If ((Arg0 == "TFN3"))
                {
                    Return ("INTC1048")
                }

                If ((Arg0 == "TPWR"))
                {
                    Return ("INTC1060")
                }

                If ((Arg0 == "1"))
                {
                    Return ("INTC1061")
                }

                If ((Arg0 == "CHRG"))
                {
                    Return ("INTC1046")
                }

                Return ("XXXX9999")
            }

            Name (_UID, "IETM")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If (CondRefOf (HIWC))
                {
                    If (HIWC (Arg0))
                    {
                        If (CondRefOf (HIDW))
                        {
                            Return (HIDW (Arg0, Arg1, Arg2, Arg3))
                        }
                    }
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((\DPTF == One) && (\IN34 == One)))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Name (PTRP, Zero)
            Name (PSEM, Zero)
            Name (ATRP, Zero)
            Name (ASEM, Zero)
            Name (YTRP, Zero)
            Name (YSEM, Zero)
            Method (_OSC, 4, Serialized)  // _OSC: Operating System Capabilities
            {
                CreateDWordField (Arg3, Zero, STS1)
                CreateDWordField (Arg3, 0x04, CAP1)
                If ((Arg1 != One))
                {
                    STS1 &= 0xFFFFFF00
                    STS1 |= 0x0A
                    Return (Arg3)
                }

                If ((Arg2 != 0x02))
                {
                    STS1 &= 0xFFFFFF00
                    STS1 |= 0x02
                    Return (Arg3)
                }

                If (CondRefOf (\_SB.APSV))
                {
                    If ((PSEM == Zero))
                    {
                        PSEM = One
                        PTRP = \_SB.APSV /* External reference */
                    }
                }

                If (CondRefOf (\_SB.AAC0))
                {
                    If ((ASEM == Zero))
                    {
                        ASEM = One
                        ATRP = \_SB.AAC0 /* External reference */
                    }
                }

                If (CondRefOf (\_SB.ACRT))
                {
                    If ((YSEM == Zero))
                    {
                        YSEM = One
                        YTRP = \_SB.ACRT /* External reference */
                    }
                }

                If ((Arg0 == ToUUID ("b23ba85d-c8b7-3542-88de-8de2ffcfd698") /* Unknown UUID */))
                {
                    If (~(STS1 & One))
                    {
                        If ((CAP1 & One))
                        {
                            If ((CAP1 & 0x02))
                            {
                                \_SB.AAC0 = 0x6E
                                \_TZ.ETMD = Zero
                            }
                            Else
                            {
                                \_SB.AAC0 = ATRP /* \_SB_.IETM.ATRP */
                                \_TZ.ETMD = One
                            }

                            If ((CAP1 & 0x04))
                            {
                                \_SB.APSV = 0x6E
                            }
                            Else
                            {
                                \_SB.APSV = PTRP /* \_SB_.IETM.PTRP */
                            }

                            If ((CAP1 & 0x08))
                            {
                                \_SB.ACRT = 0xD2
                            }
                            Else
                            {
                                \_SB.ACRT = YTRP /* \_SB_.IETM.YTRP */
                            }

                            If (CondRefOf (\_TZ.TZ00))
                            {
                                Notify (\_TZ.TZ00, 0x81) // Information Change
                            }
                        }
                        Else
                        {
                            \_SB.ACRT = YTRP /* \_SB_.IETM.YTRP */
                            \_SB.APSV = PTRP /* \_SB_.IETM.PTRP */
                            \_SB.AAC0 = ATRP /* \_SB_.IETM.ATRP */
                            \_TZ.ETMD = One
                        }

                        If (CondRefOf (\_TZ.TZ00))
                        {
                            Notify (\_TZ.TZ00, 0x81) // Information Change
                        }
                    }

                    Return (Arg3)
                }

                Return (Arg3)
            }

            Method (DCFG, 0, NotSerialized)
            {
                Return (\DCFE) /* External reference */
            }

            Name (ODVX, Package (0x09)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            })
            Method (ODVP, 0, Serialized)
            {
                ODVX [Zero] = \ODV0 /* External reference */
                ODVX [One] = \ODV1 /* External reference */
                ODVX [0x02] = \ODV2 /* External reference */
                ODVX [0x03] = \ODV3 /* External reference */
                ODVX [0x04] = \ODV4 /* External reference */
                ODVX [0x05] = \ODV5 /* External reference */
                ODVX [0x06] = \OD06 /* External reference */
                ODVX [0x07] = \OD07 /* External reference */
                ODVX [0x08] = \OD08 /* External reference */
                Return (ODVX) /* \_SB_.IETM.ODVX */
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Mutex (PATM, 0x00)
        Method (_QF1, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If ((\_SB.PC00.LPCB.H_EC.ECRD (RefOf (\_SB.PC00.LPCB.H_EC.TSR5)) >= 0x41))
            {
                \ODV0 = One
                \ODV1 = Zero
                \ODV2 = Zero
                \ODV3 = Zero
                Notify (\_SB.IETM, 0x88) // Device-Specific
            }
            Else
            {
                \ODV0 = Zero
                \_SB.PC00.LPCB.H_EC.NTDP (\_SB.PC00.LPCB.H_EC.STNM)
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (CHRG)
        {
            Name (_UID, "CHRG")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Charger"))  // _STR: Description String
            Name (PTYP, 0x0B)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\CHGE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Name (PSSS, Zero)
            Name (PPS1, Package (0x08)
            {
                Package (0x08)
                {
                    0x64, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x0DAC, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x55, 
                    Zero, 
                    Zero, 
                    Zero, 
                    One, 
                    0x0BB8, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x47, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x02, 
                    0x09C4, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x39, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x03, 
                    0x07D0, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x2A, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x04, 
                    0x05DC, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x1C, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x05, 
                    0x03E8, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x0E, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x06, 
                    0x01F4, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x07, 
                    Zero, 
                    "MilliAmps", 
                    Zero
                }
            })
            Name (PPS2, Package (0x0A)
            {
                Package (0x08)
                {
                    0x64, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x1194, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x58, 
                    Zero, 
                    Zero, 
                    Zero, 
                    One, 
                    0x0FA0, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x4D, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x02, 
                    0x0DAC, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x42, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x03, 
                    0x0BB8, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x37, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x04, 
                    0x09C4, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x2C, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x05, 
                    0x07D0, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x21, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x06, 
                    0x05DC, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x16, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x07, 
                    0x03E8, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    0x0B, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x08, 
                    0x01F4, 
                    "MilliAmps", 
                    Zero
                }, 

                Package (0x08)
                {
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    0x09, 
                    Zero, 
                    "MilliAmps", 
                    Zero
                }
            })
            Method (PPSS, 0, Serialized)
            {
                If ((ECRD (RefOf (FCHG)) == One))
                {
                    Return (PPS2) /* \_SB_.PC00.LPCB.H_EC.CHRG.PPS2 */
                }
                Else
                {
                    Return (PPS1) /* \_SB_.PC00.LPCB.H_EC.CHRG.PPS1 */
                }
            }

            Method (PCAL, 0, Serialized)
            {
                If ((ECRD (RefOf (FCHG)) == One))
                {
                    PSSS = SizeOf (PPS2)
                }
                Else
                {
                    PSSS = SizeOf (PPS1)
                }
            }

            Method (PPPC, 0, NotSerialized)
            {
                PCAL ()
                If (\PWRS)
                {
                    Return (Zero)
                }
                Else
                {
                    Return ((PSSS - One))
                }
            }

            Method (SPPC, 1, Serialized)
            {
                PCAL ()
                If ((ToInteger (Arg0) <= (PSSS - One)))
                {
                    If ((ECRD (RefOf (FCHG)) == One))
                    {
                        Local1 = DerefOf (DerefOf (PPS2 [Arg0]) [0x05])
                    }
                    Else
                    {
                        Local1 = DerefOf (DerefOf (PPS1 [Arg0]) [0x05])
                    }

                    \_SB.PC00.LPCB.H_EC.ECWT (Local1, RefOf (\_SB.PC00.LPCB.H_EC.CHGR))
                    \_SB.PC00.LPCB.H_EC.ECMD (0x37)
                }
            }

            Method (PPDL, 0, NotSerialized)
            {
                PCAL ()
                Return ((PSSS - One))
            }
        }
    }

    Scope (\_SB)
    {
        Device (BAT1)
        {
            Name (_UID, "1")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Battery 1 Participant"))  // _STR: Description String
            Name (PTYP, 0x0C)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\BATR == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (PMAX, 0, Serialized)
            {
                Return (Zero)
            }

            Method (CTYP, 0, NotSerialized)
            {
                Return (0x03)
            }

            Method (PBSS, 0, NotSerialized)
            {
                Return (0x64)
            }

            Method (DPSP, 0, Serialized)
            {
                Return (\PPPR) /* External reference */
            }

            Method (RBHF, 0, NotSerialized)
            {
                Return (0xFFFFFFFF)
            }

            Method (VBNL, 0, NotSerialized)
            {
                Return (0xFFFFFFFF)
            }

            Method (CMPP, 0, NotSerialized)
            {
                Return (0xFFFFFFFF)
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (SEN1)
        {
            Name (_UID, "SEN1")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("CPU temperature"))  // _STR: Description String
            Name (PTYP, 0x03)
            Name (CTYP, Zero)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\S1DE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                If (\_SB.PC00.LPCB.H_EC.ECAV)
                {
                    Return (\_SB.IETM.CTOK (\_SB.PC00.LPCB.H_EC.TSR1))
                }
                Else
                {
                    Return (0x0BB8)
                }
            }

            Name (PATC, 0x02)
            Method (PAT0, 1, Serialized)
            {
            }

            Method (PAT1, 1, Serialized)
            {
            }

            Name (GTSH, 0x14)
            Name (LSTM, Zero)
            Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
            {
                LSTM = Arg0
                Notify (\_SB.PC00.LPCB.H_EC.SEN1, 0x91) // Device-Specific
            }

            Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
            {
                Return (0x0ADE)
            }

            Name (S1AC, 0x6E)
            Name (S1A1, 0x6E)
            Name (S1A2, 0x6E)
            Name (S1PV, 0x6E)
            Name (S1CC, 0x6E)
            Name (S1C3, 0x6E)
            Name (S1HP, 0x6E)
            Name (SSP1, 0x0A)
            Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
            {
                Return (SSP1) /* \_SB_.PC00.LPCB.H_EC.SEN1.SSP1 */
            }

            Method (_AC0, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Local1 = \_SB.IETM.CTOK (S1AC)
                If ((LSTM >= Local1))
                {
                    Return ((Local1 - 0x14))
                }
                Else
                {
                    Return (Local1)
                }
            }

            Method (_AC1, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S1A1))
            }

            Method (_AC2, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S1A2))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.IETM.CTOK (S1PV))
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.IETM.CTOK (S1CC))
            }

            Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
            {
                Return (\_SB.IETM.CTOK (S1C3))
            }

            Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
            {
                Return (\_SB.IETM.CTOK (S1HP))
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (SEN2)
        {
            Name (_UID, "SEN2")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("DGPU temperature"))  // _STR: Description String
            Name (PTYP, 0x03)
            Name (CTYP, Zero)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\S2DE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                If (\_SB.PC00.LPCB.H_EC.ECAV)
                {
                    Return (\_SB.IETM.CTOK (\_SB.PC00.LPCB.H_EC.TSR3))
                }
                Else
                {
                    Return (0x0BB8)
                }
            }

            Name (PATC, 0x02)
            Method (PAT0, 1, Serialized)
            {
            }

            Method (PAT1, 1, Serialized)
            {
            }

            Name (GTSH, 0x14)
            Name (LSTM, Zero)
            Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
            {
                LSTM = Arg0
                Notify (\_SB.PC00.LPCB.H_EC.SEN2, 0x91) // Device-Specific
            }

            Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
            {
                Return (0x0ADE)
            }

            Name (S2AC, 0x6E)
            Name (S2A1, 0x6E)
            Name (S2A2, 0x6E)
            Name (S2PV, 0x6E)
            Name (S2CC, 0x6E)
            Name (S2C3, 0x6E)
            Name (S2HP, 0x6E)
            Name (SSP2, 0x0A)
            Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
            {
                Return (SSP2) /* \_SB_.PC00.LPCB.H_EC.SEN2.SSP2 */
            }

            Method (_AC0, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Local1 = \_SB.IETM.CTOK (S2AC)
                If ((LSTM >= Local1))
                {
                    Return ((Local1 - 0x14))
                }
                Else
                {
                    Return (Local1)
                }
            }

            Method (_AC1, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S2A1))
            }

            Method (_AC2, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S2A2))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.IETM.CTOK (S2PV))
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.IETM.CTOK (S2CC))
            }

            Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
            {
                Return (\_SB.IETM.CTOK (S2C3))
            }

            Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
            {
                Return (\_SB.IETM.CTOK (S2HP))
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (SEN3)
        {
            Name (_UID, "SEN3")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Charger temperature"))  // _STR: Description String
            Name (PTYP, 0x03)
            Name (CTYP, Zero)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\S3DE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                If (\_SB.PC00.LPCB.H_EC.ECAV)
                {
                    Return (\_SB.IETM.CTOK (\_SB.PC00.LPCB.H_EC.TSR6))
                }
                Else
                {
                    Return (0x0BB8)
                }
            }

            Name (PATC, 0x02)
            Method (PAT0, 1, Serialized)
            {
            }

            Method (PAT1, 1, Serialized)
            {
            }

            Name (GTSH, 0x14)
            Name (LSTM, Zero)
            Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
            {
                LSTM = Arg0
                Notify (\_SB.PC00.LPCB.H_EC.SEN3, 0x91) // Device-Specific
            }

            Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
            {
                Return (0x0ADE)
            }

            Name (S3AC, 0x6E)
            Name (S3A1, 0x6E)
            Name (S3A2, 0x6E)
            Name (S3PV, 0x6E)
            Name (S3CC, 0x6E)
            Name (S3C3, 0x6E)
            Name (S3HP, 0x6E)
            Name (SSP3, 0x0A)
            Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
            {
                Return (SSP3) /* \_SB_.PC00.LPCB.H_EC.SEN3.SSP3 */
            }

            Method (_AC3, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Local1 = \_SB.IETM.CTOK (S3AC)
                If ((LSTM >= Local1))
                {
                    Return ((Local1 - 0x14))
                }
                Else
                {
                    Return (Local1)
                }
            }

            Method (_AC4, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S3A1))
            }

            Method (_AC5, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S3A2))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.IETM.CTOK (S3PV))
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.IETM.CTOK (S3CC))
            }

            Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
            {
                Return (\_SB.IETM.CTOK (S3C3))
            }

            Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
            {
                Return (\_SB.IETM.CTOK (S3HP))
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (SEN4)
        {
            Name (_UID, "SEN4")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Ambient temperature"))  // _STR: Description String
            Name (PTYP, 0x03)
            Name (CTYP, Zero)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\S4DE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                If (\_SB.PC00.LPCB.H_EC.ECAV)
                {
                    Return (\_SB.IETM.CTOK (\_SB.PC00.LPCB.H_EC.TSR5))
                }
                Else
                {
                    Return (0x0BB8)
                }
            }

            Name (PATC, 0x02)
            Method (PAT0, 1, Serialized)
            {
            }

            Method (PAT1, 1, Serialized)
            {
            }

            Name (GTSH, 0x14)
            Name (LSTM, Zero)
            Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
            {
                LSTM = Arg0
                Notify (\_SB.PC00.LPCB.H_EC.SEN4, 0x91) // Device-Specific
            }

            Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
            {
                Return (0x0ADE)
            }

            Name (S4AC, 0x6E)
            Name (S4A1, 0x6E)
            Name (S4A2, 0x6E)
            Name (S4PV, 0x6E)
            Name (S4CC, 0x6E)
            Name (S4C3, 0x6E)
            Name (S4HP, 0x6E)
            Name (SSP4, 0x0A)
            Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
            {
                Return (SSP4) /* \_SB_.PC00.LPCB.H_EC.SEN4.SSP4 */
            }

            Method (_AC0, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Local1 = \_SB.IETM.CTOK (S4AC)
                If ((LSTM >= Local1))
                {
                    Return ((Local1 - 0x14))
                }
                Else
                {
                    Return (Local1)
                }
            }

            Method (_AC1, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S4A1))
            }

            Method (_AC2, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S4A2))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.IETM.CTOK (S4PV))
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.IETM.CTOK (S4CC))
            }

            Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
            {
                Return (\_SB.IETM.CTOK (S4C3))
            }

            Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
            {
                Return (\_SB.IETM.CTOK (S4HP))
            }
        }
    }

    Scope (\_SB.PC00.LPCB.H_EC)
    {
        Device (SEN5)
        {
            Name (_UID, "SEN5")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Type C temperature"))  // _STR: Description String
            Name (PTYP, 0x03)
            Name (CTYP, Zero)
            Name (PFLG, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\S5DE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_TMP, 0, Serialized)  // _TMP: Temperature
            {
                If (\_SB.PC00.LPCB.H_EC.ECAV)
                {
                    Return (\_SB.IETM.CTOK (\_SB.PC00.LPCB.H_EC.TSR4))
                }
                Else
                {
                    Return (0x0BB8)
                }
            }

            Name (PATC, 0x02)
            Method (PAT0, 1, Serialized)
            {
            }

            Method (PAT1, 1, Serialized)
            {
            }

            Name (GTSH, 0x14)
            Name (LSTM, Zero)
            Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
            {
                LSTM = Arg0
                Notify (\_SB.PC00.LPCB.H_EC.SEN5, 0x91) // Device-Specific
            }

            Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
            {
                Return (0x0ADE)
            }

            Name (S5AC, 0x6E)
            Name (S5A1, 0x6E)
            Name (S5A2, 0x6E)
            Name (S5PV, 0x6E)
            Name (S5CC, 0x6E)
            Name (S5C3, 0x6E)
            Name (S5HP, 0x6E)
            Name (SSP5, 0x0A)
            Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
            {
                Return (SSP5) /* \_SB_.PC00.LPCB.H_EC.SEN5.SSP5 */
            }

            Method (_AC0, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Local1 = \_SB.IETM.CTOK (S5AC)
                If ((LSTM >= Local1))
                {
                    Return ((Local1 - 0x14))
                }
                Else
                {
                    Return (Local1)
                }
            }

            Method (_AC1, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S5A1))
            }

            Method (_AC2, 0, Serialized)  // _ACx: Active Cooling, x=0-9
            {
                Return (\_SB.IETM.CTOK (S5A2))
            }

            Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.IETM.CTOK (S5PV))
            }

            Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.IETM.CTOK (S5CC))
            }

            Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
            {
                Return (\_SB.IETM.CTOK (S5C3))
            }

            Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
            {
                Return (\_SB.IETM.CTOK (S5HP))
            }
        }
    }

    Scope (\_SB.IETM)
    {
        Name (TRT0, Package (0x01)
        {
            Package (0x08)
            {
                \_SB.PC00.LPCB.H_EC.CHRG, 
                \_SB.PC00.LPCB.H_EC.SEN4, 
                0x14, 
                0xC8, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }
        })
        Method (_TRT, 0, NotSerialized)  // _TRT: Thermal Relationship Table
        {
            Return (TRT0) /* \_SB_.IETM.TRT0 */
        }
    }

    Scope (\_SB.IETM)
    {
        Name (PTTL, 0x14)
        Name (PSVT, Package (0x01)
        {
            0x02
        })
    }

    Scope (\_SB.IETM)
    {
        Method (KTOC, 1, Serialized)
        {
            If ((Arg0 > 0x0AAC))
            {
                Return (((Arg0 - 0x0AAC) / 0x0A))
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (CTOK, 1, Serialized)
        {
            Return (((Arg0 * 0x0A) + 0x0AAC))
        }

        Method (C10K, 1, Serialized)
        {
            Name (TMP1, Buffer (0x10)
            {
                 0x00                                             // .
            })
            CreateByteField (TMP1, Zero, TMPL)
            CreateByteField (TMP1, One, TMPH)
            Local0 = (Arg0 + 0x0AAC)
            TMPL = (Local0 & 0xFF)
            TMPH = ((Local0 & 0xFF00) >> 0x08)
            ToInteger (TMP1, Local1)
            Return (Local1)
        }

        Method (K10C, 1, Serialized)
        {
            If ((Arg0 > 0x0AAC))
            {
                Return ((Arg0 - 0x0AAC))
            }
            Else
            {
                Return (Zero)
            }
        }
    }

    Scope (\_SB.PC00.TCPU)
    {
        Name (PFLG, Zero)
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If ((\SADE == One))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }

        OperationRegion (CPWR, SystemMemory, ((\_SB.PC00.MC.MHBR << 0x0F) + 0x5000), 0x1000)
        Field (CPWR, ByteAcc, NoLock, Preserve)
        {
            Offset (0x930), 
            PTDP,   15, 
            Offset (0x932), 
            PMIN,   15, 
            Offset (0x934), 
            PMAX,   15, 
            Offset (0x936), 
            TMAX,   7, 
            Offset (0x938), 
            PWRU,   4, 
            Offset (0x939), 
            EGYU,   5, 
            Offset (0x93A), 
            TIMU,   4, 
            Offset (0x958), 
            Offset (0x95C), 
            LPMS,   1, 
            CTNL,   2, 
            Offset (0x978), 
            PCTP,   8, 
            Offset (0x998), 
            RP0C,   8, 
            RP1C,   8, 
            RPNC,   8, 
            Offset (0xF3C), 
            TRAT,   8, 
            Offset (0xF40), 
            PTD1,   15, 
            Offset (0xF42), 
            TRA1,   8, 
            Offset (0xF44), 
            PMX1,   15, 
            Offset (0xF46), 
            PMN1,   15, 
            Offset (0xF48), 
            PTD2,   15, 
            Offset (0xF4A), 
            TRA2,   8, 
            Offset (0xF4C), 
            PMX2,   15, 
            Offset (0xF4E), 
            PMN2,   15, 
            Offset (0xF50), 
            CTCL,   2, 
                ,   29, 
            CLCK,   1, 
            MNTR,   8
        }

        Name (XPCC, Zero)
        Method (PPCC, 0, Serialized)
        {
            If (((XPCC == Zero) && CondRefOf (\_SB.CBMI)))
            {
                Switch (ToInteger (\_SB.CBMI))
                {
                    Case (Zero)
                    {
                        If (((\_SB.CLVL >= One) && (\_SB.CLVL <= 0x03)))
                        {
                            CPL0 ()
                            XPCC = One
                        }
                    }
                    Case (One)
                    {
                        If (((\_SB.CLVL == 0x02) || (\_SB.CLVL == 0x03)))
                        {
                            CPL1 ()
                            XPCC = One
                        }
                    }
                    Case (0x02)
                    {
                        If ((\_SB.CLVL == 0x03))
                        {
                            CPL2 ()
                            XPCC = One
                        }
                    }

                }
            }

            Return (NPCC) /* \_SB_.PC00.TCPU.NPCC */
        }

        Name (NPCC, Package (0x03)
        {
            0x02, 
            Package (0x06)
            {
                Zero, 
                0x88B8, 
                0xAFC8, 
                0x6D60, 
                0x7D00, 
                0x03E8
            }, 

            Package (0x06)
            {
                One, 
                0xDBBA, 
                0xDBBA, 
                Zero, 
                Zero, 
                0x03E8
            }
        })
        Method (CPNU, 2, Serialized)
        {
            Name (CNVT, Zero)
            Name (PPUU, Zero)
            Name (RMDR, Zero)
            If ((PWRU == Zero))
            {
                PPUU = One
            }
            Else
            {
                PPUU = (PWRU-- << 0x02)
            }

            Divide (Arg0, PPUU, RMDR, CNVT) /* \_SB_.PC00.TCPU.CPNU.CNVT */
            If ((Arg1 == Zero))
            {
                Return (CNVT) /* \_SB_.PC00.TCPU.CPNU.CNVT */
            }
            Else
            {
                CNVT *= 0x03E8
                RMDR *= 0x03E8
                RMDR /= PPUU
                CNVT += RMDR /* \_SB_.PC00.TCPU.CPNU.RMDR */
                Return (CNVT) /* \_SB_.PC00.TCPU.CPNU.CNVT */
            }
        }

        Method (CPL0, 0, NotSerialized)
        {
            \_SB.PC00.TCPU.NPCC [Zero] = 0x02
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [Zero] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [One] = 0x7D
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x02] = CPNU (\_SB.PL10, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x03] = (\_SB.PLW0 * 0x03E8)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x04] = ((\_SB.PLW0 * 0x03E8
                ) + 0x0FA0)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x05] = PPSZ /* External reference */
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [Zero] = One
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [One] = CPNU (\_SB.PL20, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x02] = CPNU (\_SB.PL20, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x03] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x04] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x05] = PPSZ /* External reference */
        }

        Method (CPL1, 0, NotSerialized)
        {
            \_SB.PC00.TCPU.NPCC [Zero] = 0x02
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [Zero] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [One] = 0x7D
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x02] = CPNU (\_SB.PL11, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x03] = (\_SB.PLW1 * 0x03E8)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x04] = ((\_SB.PLW1 * 0x03E8
                ) + 0x0FA0)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x05] = PPSZ /* External reference */
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [Zero] = One
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [One] = CPNU (\_SB.PL21, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x02] = CPNU (\_SB.PL21, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x03] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x04] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x05] = PPSZ /* External reference */
        }

        Method (CPL2, 0, NotSerialized)
        {
            \_SB.PC00.TCPU.NPCC [Zero] = 0x02
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [Zero] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [One] = 0x7D
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x02] = CPNU (\_SB.PL12, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x03] = (\_SB.PLW2 * 0x03E8)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x04] = ((\_SB.PLW2 * 0x03E8
                ) + 0x0FA0)
            DerefOf (\_SB.PC00.TCPU.NPCC [One]) [0x05] = PPSZ /* External reference */
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [Zero] = One
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [One] = CPNU (\_SB.PL22, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x02] = CPNU (\_SB.PL22, One)
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x03] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x04] = Zero
            DerefOf (\_SB.PC00.TCPU.NPCC [0x02]) [0x05] = PPSZ /* External reference */
        }

        Name (LSTM, Zero)
        Name (_PPC, Zero)  // _PPC: Performance Present Capabilities
        Method (SPPC, 1, Serialized)
        {
            If (CondRefOf (\_SB.CPPC))
            {
                \_SB.CPPC = Arg0
            }

            If ((ToInteger (\TCNT) > Zero))
            {
                Notify (\_SB.PR00, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > One))
            {
                Notify (\_SB.PR01, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x02))
            {
                Notify (\_SB.PR02, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x03))
            {
                Notify (\_SB.PR03, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x04))
            {
                Notify (\_SB.PR04, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x05))
            {
                Notify (\_SB.PR05, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x06))
            {
                Notify (\_SB.PR06, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x07))
            {
                Notify (\_SB.PR07, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x08))
            {
                Notify (\_SB.PR08, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x09))
            {
                Notify (\_SB.PR09, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0A))
            {
                Notify (\_SB.PR10, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0B))
            {
                Notify (\_SB.PR11, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0C))
            {
                Notify (\_SB.PR12, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0D))
            {
                Notify (\_SB.PR13, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0E))
            {
                Notify (\_SB.PR14, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x0F))
            {
                Notify (\_SB.PR15, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x10))
            {
                Notify (\_SB.PR16, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x11))
            {
                Notify (\_SB.PR17, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x12))
            {
                Notify (\_SB.PR18, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x13))
            {
                Notify (\_SB.PR19, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x14))
            {
                Notify (\_SB.PR20, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x15))
            {
                Notify (\_SB.PR21, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x16))
            {
                Notify (\_SB.PR22, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x17))
            {
                Notify (\_SB.PR23, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x18))
            {
                Notify (\_SB.PR24, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x19))
            {
                Notify (\_SB.PR25, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1A))
            {
                Notify (\_SB.PR26, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1B))
            {
                Notify (\_SB.PR27, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1C))
            {
                Notify (\_SB.PR28, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1D))
            {
                Notify (\_SB.PR29, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1E))
            {
                Notify (\_SB.PR30, 0x80) // Status Change
            }

            If ((ToInteger (\TCNT) > 0x1F))
            {
                Notify (\_SB.PR31, 0x80) // Status Change
            }
        }

        Method (SPUR, 1, NotSerialized)
        {
            If ((Arg0 <= \TCNT))
            {
                If ((\_SB.PAGD._STA () == 0x0F))
                {
                    \_SB.PAGD._PUR [One] = Arg0
                    Notify (\_SB.PAGD, 0x80) // Status Change
                }
            }
        }

        Method (PCCC, 0, Serialized)
        {
            PCCX [Zero] = One
            Switch (ToInteger (CPNU (PTDP, Zero)))
            {
                Case (0x39)
                {
                    DerefOf (PCCX [One]) [Zero] = 0xA7F8
                    DerefOf (PCCX [One]) [One] = 0x00017318
                }
                Case (0x2F)
                {
                    DerefOf (PCCX [One]) [Zero] = 0x9858
                    DerefOf (PCCX [One]) [One] = 0x00014C08
                }
                Case (0x25)
                {
                    DerefOf (PCCX [One]) [Zero] = 0x7148
                    DerefOf (PCCX [One]) [One] = 0xD6D8
                }
                Case (0x19)
                {
                    DerefOf (PCCX [One]) [Zero] = 0x3E80
                    DerefOf (PCCX [One]) [One] = 0x7D00
                }
                Case (0x0F)
                {
                    DerefOf (PCCX [One]) [Zero] = 0x36B0
                    DerefOf (PCCX [One]) [One] = 0x7D00
                }
                Case (0x0B)
                {
                    DerefOf (PCCX [One]) [Zero] = 0x36B0
                    DerefOf (PCCX [One]) [One] = 0x61A8
                }
                Default
                {
                    DerefOf (PCCX [One]) [Zero] = 0xFF
                    DerefOf (PCCX [One]) [One] = 0xFF
                }

            }

            Return (PCCX) /* \_SB_.PC00.TCPU.PCCX */
        }

        Name (PCCX, Package (0x02)
        {
            0x80000000, 
            Package (0x02)
            {
                0x80000000, 
                0x80000000
            }
        })
        Name (KEFF, Package (0x1E)
        {
            Package (0x02)
            {
                0x01BC, 
                Zero
            }, 

            Package (0x02)
            {
                0x01CF, 
                0x27
            }, 

            Package (0x02)
            {
                0x01E1, 
                0x4B
            }, 

            Package (0x02)
            {
                0x01F3, 
                0x6C
            }, 

            Package (0x02)
            {
                0x0206, 
                0x8B
            }, 

            Package (0x02)
            {
                0x0218, 
                0xA8
            }, 

            Package (0x02)
            {
                0x022A, 
                0xC3
            }, 

            Package (0x02)
            {
                0x023D, 
                0xDD
            }, 

            Package (0x02)
            {
                0x024F, 
                0xF4
            }, 

            Package (0x02)
            {
                0x0261, 
                0x010B
            }, 

            Package (0x02)
            {
                0x0274, 
                0x011F
            }, 

            Package (0x02)
            {
                0x032C, 
                0x01BD
            }, 

            Package (0x02)
            {
                0x03D7, 
                0x0227
            }, 

            Package (0x02)
            {
                0x048B, 
                0x026D
            }, 

            Package (0x02)
            {
                0x053E, 
                0x02A1
            }, 

            Package (0x02)
            {
                0x05F7, 
                0x02C6
            }, 

            Package (0x02)
            {
                0x06A8, 
                0x02E6
            }, 

            Package (0x02)
            {
                0x075D, 
                0x02FF
            }, 

            Package (0x02)
            {
                0x0818, 
                0x0311
            }, 

            Package (0x02)
            {
                0x08CF, 
                0x0322
            }, 

            Package (0x02)
            {
                0x179C, 
                0x0381
            }, 

            Package (0x02)
            {
                0x2DDC, 
                0x039C
            }, 

            Package (0x02)
            {
                0x44A8, 
                0x039E
            }, 

            Package (0x02)
            {
                0x5C35, 
                0x0397
            }, 

            Package (0x02)
            {
                0x747D, 
                0x038D
            }, 

            Package (0x02)
            {
                0x8D7F, 
                0x0382
            }, 

            Package (0x02)
            {
                0xA768, 
                0x0376
            }, 

            Package (0x02)
            {
                0xC23B, 
                0x0369
            }, 

            Package (0x02)
            {
                0xDE26, 
                0x035A
            }, 

            Package (0x02)
            {
                0xFB7C, 
                0x034A
            }
        })
        Name (CEUP, Package (0x06)
        {
            0x80000000, 
            0x80000000, 
            0x80000000, 
            0x80000000, 
            0x80000000, 
            0x80000000
        })
        Method (_TMP, 0, Serialized)  // _TMP: Temperature
        {
            Return (\_SB.IETM.CTOK (PCTP))
        }

        Method (_DTI, 1, NotSerialized)  // _DTI: Device Temperature Indication
        {
            LSTM = Arg0
            Notify (\_SB.PC00.TCPU, 0x91) // Device-Specific
        }

        Method (_NTT, 0, NotSerialized)  // _NTT: Notification Temperature Threshold
        {
            Return (0x0ADE)
        }

        Name (PTYP, Zero)
        Method (_PSS, 0, NotSerialized)  // _PSS: Performance Supported States
        {
            If (CondRefOf (\_SB.PR00._PSS))
            {
                Return (\_SB.PR00._PSS ())
            }
            Else
            {
                Return (Package (0x02)
                {
                    Package (0x06)
                    {
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero
                    }, 

                    Package (0x06)
                    {
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero
                    }
                })
            }
        }

        Method (_TSS, 0, NotSerialized)  // _TSS: Throttling Supported States
        {
            If (CondRefOf (\_SB.PR00._TSS))
            {
                Return (\_SB.PR00._TSS ())
            }
            Else
            {
                Return (Package (0x01)
                {
                    Package (0x05)
                    {
                        One, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero
                    }
                })
            }
        }

        Method (_TPC, 0, NotSerialized)  // _TPC: Throttling Present Capabilities
        {
            If (CondRefOf (\_SB.PR00._TPC))
            {
                Return (\_SB.PR00._TPC) /* External reference */
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (_PTC, 0, NotSerialized)  // _PTC: Processor Throttling Control
        {
            If ((CondRefOf (\PF00) && (\PF00 != 0x80000000)))
            {
                If ((\PF00 & 0x04))
                {
                    Return (Package (0x02)
                    {
                        ResourceTemplate ()
                        {
                            Register (FFixedHW, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }, 

                        ResourceTemplate ()
                        {
                            Register (FFixedHW, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }
                    })
                }
                Else
                {
                    Return (Package (0x02)
                    {
                        ResourceTemplate ()
                        {
                            Register (SystemIO, 
                                0x05,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000001810, // Address
                                ,)
                        }, 

                        ResourceTemplate ()
                        {
                            Register (SystemIO, 
                                0x05,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000001810, // Address
                                ,)
                        }
                    })
                }
            }
            Else
            {
                Return (Package (0x02)
                {
                    ResourceTemplate ()
                    {
                        Register (FFixedHW, 
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    }, 

                    ResourceTemplate ()
                    {
                        Register (FFixedHW, 
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    }
                })
            }
        }

        Method (_TSD, 0, NotSerialized)  // _TSD: Throttling State Dependencies
        {
            If (CondRefOf (\_SB.PR00._TSD))
            {
                Return (\_SB.PR00._TSD ())
            }
            Else
            {
                Return (Package (0x01)
                {
                    Package (0x05)
                    {
                        0x05, 
                        Zero, 
                        Zero, 
                        0xFC, 
                        Zero
                    }
                })
            }
        }

        Method (_TDL, 0, NotSerialized)  // _TDL: T-State Depth Limit
        {
            If ((CondRefOf (\_SB.PR00._TSS) && CondRefOf (\_SB.CFGD)))
            {
                If ((\_SB.CFGD & 0x2000))
                {
                    Return ((SizeOf (\_SB.PR00.TSMF) - One))
                }
                Else
                {
                    Return ((SizeOf (\_SB.PR00.TSMC) - One))
                }
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (_PDL, 0, NotSerialized)  // _PDL: P-state Depth Limit
        {
            If (CondRefOf (\_SB.PR00._PSS))
            {
                If ((\_SB.OSCP & 0x0400))
                {
                    Return ((SizeOf (\_SB.PR00.TPSS) - One))
                }
                Else
                {
                    Return ((SizeOf (\_SB.PR00.LPSS) - One))
                }
            }
            Else
            {
                Return (Zero)
            }
        }

        Name (TJMX, 0x6E)
        Method (_TSP, 0, Serialized)  // _TSP: Thermal Sampling Period
        {
            Return (Zero)
        }

        Method (_AC0, 0, Serialized)  // _ACx: Active Cooling, x=0-9
        {
            Local1 = \_SB.IETM.CTOK (TJMX)
            Local1 -= 0x0A
            If ((LSTM >= Local1))
            {
                Return ((Local1 - 0x14))
            }
            Else
            {
                Return (Local1)
            }
        }

        Method (_AC1, 0, Serialized)  // _ACx: Active Cooling, x=0-9
        {
            Local1 = \_SB.IETM.CTOK (TJMX)
            Local1 -= 0x1E
            If ((LSTM >= Local1))
            {
                Return ((Local1 - 0x14))
            }
            Else
            {
                Return (Local1)
            }
        }

        Method (_AC2, 0, Serialized)  // _ACx: Active Cooling, x=0-9
        {
            Local1 = \_SB.IETM.CTOK (TJMX)
            Local1 -= 0x28
            If ((LSTM >= Local1))
            {
                Return ((Local1 - 0x14))
            }
            Else
            {
                Return (Local1)
            }
        }

        Method (_AC3, 0, Serialized)  // _ACx: Active Cooling, x=0-9
        {
            Local1 = \_SB.IETM.CTOK (TJMX)
            Local1 -= 0x37
            If ((LSTM >= Local1))
            {
                Return ((Local1 - 0x14))
            }
            Else
            {
                Return (Local1)
            }
        }

        Method (_AC4, 0, Serialized)  // _ACx: Active Cooling, x=0-9
        {
            Local1 = \_SB.IETM.CTOK (TJMX)
            Local1 -= 0x46
            If ((LSTM >= Local1))
            {
                Return ((Local1 - 0x14))
            }
            Else
            {
                Return (Local1)
            }
        }

        Method (_PSV, 0, Serialized)  // _PSV: Passive Temperature
        {
            Return (\_SB.IETM.CTOK (TJMX))
        }

        Method (_CRT, 0, Serialized)  // _CRT: Critical Temperature
        {
            Return (\_SB.IETM.CTOK (TJMX))
        }

        Method (_CR3, 0, Serialized)  // _CR3: Warm/Standby Temperature
        {
            Return (\_SB.IETM.CTOK (TJMX))
        }

        Method (_HOT, 0, Serialized)  // _HOT: Hot Temperature
        {
            Return (\_SB.IETM.CTOK (TJMX))
        }

        Method (UVTH, 1, Serialized)
        {
        }
    }

    Scope (\_SB.IETM)
    {
        Name (CTSP, Package (0x01)
        {
            ToUUID ("e145970a-e4c1-4d73-900e-c9c5a69dd067") /* Unknown UUID */
        })
    }

    Scope (\_SB.PC00.TCPU)
    {
        Method (TDPL, 0, Serialized)
        {
            Name (AAAA, Zero)
            Name (BBBB, Zero)
            Name (CCCC, Zero)
            Local0 = CTNL /* \_SB_.PC00.TCPU.CTNL */
            If (((Local0 == One) || (Local0 == 0x02)))
            {
                Local0 = \_SB.CLVL /* External reference */
            }
            Else
            {
                Return (Package (0x01)
                {
                    Zero
                })
            }

            If ((CLCK == One))
            {
                Local0 = One
            }

            AAAA = CPNU (\_SB.PL10, One)
            BBBB = CPNU (\_SB.PL11, One)
            CCCC = CPNU (\_SB.PL12, One)
            Name (TMP1, Package (0x01)
            {
                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }
            })
            Name (TMP2, Package (0x02)
            {
                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }, 

                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }
            })
            Name (TMP3, Package (0x03)
            {
                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }, 

                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }, 

                Package (0x05)
                {
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000, 
                    0x80000000
                }
            })
            If ((Local0 == 0x03))
            {
                If ((AAAA > BBBB))
                {
                    If ((AAAA > CCCC))
                    {
                        If ((BBBB > CCCC))
                        {
                            Local3 = Zero
                            LEV0 = Zero
                            Local4 = One
                            LEV1 = One
                            Local5 = 0x02
                            LEV2 = 0x02
                        }
                        Else
                        {
                            Local3 = Zero
                            LEV0 = Zero
                            Local5 = One
                            LEV1 = 0x02
                            Local4 = 0x02
                            LEV2 = One
                        }
                    }
                    Else
                    {
                        Local5 = Zero
                        LEV0 = 0x02
                        Local3 = One
                        LEV1 = Zero
                        Local4 = 0x02
                        LEV2 = One
                    }
                }
                ElseIf ((BBBB > CCCC))
                {
                    If ((AAAA > CCCC))
                    {
                        Local4 = Zero
                        LEV0 = One
                        Local3 = One
                        LEV1 = Zero
                        Local5 = 0x02
                        LEV2 = 0x02
                    }
                    Else
                    {
                        Local4 = Zero
                        LEV0 = One
                        Local5 = One
                        LEV1 = 0x02
                        Local3 = 0x02
                        LEV2 = Zero
                    }
                }
                Else
                {
                    Local5 = Zero
                    LEV0 = 0x02
                    Local4 = One
                    LEV1 = One
                    Local3 = 0x02
                    LEV2 = Zero
                }

                Local1 = (\_SB.TAR0 + One)
                Local2 = (Local1 * 0x64)
                DerefOf (TMP3 [Local3]) [Zero] = AAAA /* \_SB_.PC00.TCPU.TDPL.AAAA */
                DerefOf (TMP3 [Local3]) [One] = Local2
                DerefOf (TMP3 [Local3]) [0x02] = \_SB.CTC0 /* External reference */
                DerefOf (TMP3 [Local3]) [0x03] = Local1
                DerefOf (TMP3 [Local3]) [0x04] = Zero
                Local1 = (\_SB.TAR1 + One)
                Local2 = (Local1 * 0x64)
                DerefOf (TMP3 [Local4]) [Zero] = BBBB /* \_SB_.PC00.TCPU.TDPL.BBBB */
                DerefOf (TMP3 [Local4]) [One] = Local2
                DerefOf (TMP3 [Local4]) [0x02] = \_SB.CTC1 /* External reference */
                DerefOf (TMP3 [Local4]) [0x03] = Local1
                DerefOf (TMP3 [Local4]) [0x04] = Zero
                Local1 = (\_SB.TAR2 + One)
                Local2 = (Local1 * 0x64)
                DerefOf (TMP3 [Local5]) [Zero] = CCCC /* \_SB_.PC00.TCPU.TDPL.CCCC */
                DerefOf (TMP3 [Local5]) [One] = Local2
                DerefOf (TMP3 [Local5]) [0x02] = \_SB.CTC2 /* External reference */
                DerefOf (TMP3 [Local5]) [0x03] = Local1
                DerefOf (TMP3 [Local5]) [0x04] = Zero
                Return (TMP3) /* \_SB_.PC00.TCPU.TDPL.TMP3 */
            }

            If ((Local0 == 0x02))
            {
                If ((AAAA > BBBB))
                {
                    Local3 = Zero
                    Local4 = One
                    LEV0 = Zero
                    LEV1 = One
                    LEV2 = Zero
                }
                Else
                {
                    Local4 = Zero
                    Local3 = One
                    LEV0 = One
                    LEV1 = Zero
                    LEV2 = Zero
                }

                Local1 = (\_SB.TAR0 + One)
                Local2 = (Local1 * 0x64)
                DerefOf (TMP2 [Local3]) [Zero] = AAAA /* \_SB_.PC00.TCPU.TDPL.AAAA */
                DerefOf (TMP2 [Local3]) [One] = Local2
                DerefOf (TMP2 [Local3]) [0x02] = \_SB.CTC0 /* External reference */
                DerefOf (TMP2 [Local3]) [0x03] = Local1
                DerefOf (TMP2 [Local3]) [0x04] = Zero
                Local1 = (\_SB.TAR1 + One)
                Local2 = (Local1 * 0x64)
                DerefOf (TMP2 [Local4]) [Zero] = BBBB /* \_SB_.PC00.TCPU.TDPL.BBBB */
                DerefOf (TMP2 [Local4]) [One] = Local2
                DerefOf (TMP2 [Local4]) [0x02] = \_SB.CTC1 /* External reference */
                DerefOf (TMP2 [Local4]) [0x03] = Local1
                DerefOf (TMP2 [Local4]) [0x04] = Zero
                Return (TMP2) /* \_SB_.PC00.TCPU.TDPL.TMP2 */
            }

            If ((Local0 == One))
            {
                Switch (ToInteger (\_SB.CBMI))
                {
                    Case (Zero)
                    {
                        Local1 = (\_SB.TAR0 + One)
                        Local2 = (Local1 * 0x64)
                        DerefOf (TMP1 [Zero]) [Zero] = AAAA /* \_SB_.PC00.TCPU.TDPL.AAAA */
                        DerefOf (TMP1 [Zero]) [One] = Local2
                        DerefOf (TMP1 [Zero]) [0x02] = \_SB.CTC0 /* External reference */
                        DerefOf (TMP1 [Zero]) [0x03] = Local1
                        DerefOf (TMP1 [Zero]) [0x04] = Zero
                        LEV0 = Zero
                        LEV1 = Zero
                        LEV2 = Zero
                    }
                    Case (One)
                    {
                        Local1 = (\_SB.TAR1 + One)
                        Local2 = (Local1 * 0x64)
                        DerefOf (TMP1 [Zero]) [Zero] = BBBB /* \_SB_.PC00.TCPU.TDPL.BBBB */
                        DerefOf (TMP1 [Zero]) [One] = Local2
                        DerefOf (TMP1 [Zero]) [0x02] = \_SB.CTC1 /* External reference */
                        DerefOf (TMP1 [Zero]) [0x03] = Local1
                        DerefOf (TMP1 [Zero]) [0x04] = Zero
                        LEV0 = One
                        LEV1 = One
                        LEV2 = One
                    }
                    Case (0x02)
                    {
                        Local1 = (\_SB.TAR2 + One)
                        Local2 = (Local1 * 0x64)
                        DerefOf (TMP1 [Zero]) [Zero] = CCCC /* \_SB_.PC00.TCPU.TDPL.CCCC */
                        DerefOf (TMP1 [Zero]) [One] = Local2
                        DerefOf (TMP1 [Zero]) [0x02] = \_SB.CTC2 /* External reference */
                        DerefOf (TMP1 [Zero]) [0x03] = Local1
                        DerefOf (TMP1 [Zero]) [0x04] = Zero
                        LEV0 = 0x02
                        LEV1 = 0x02
                        LEV2 = 0x02
                    }

                }

                Return (TMP1) /* \_SB_.PC00.TCPU.TDPL.TMP1 */
            }

            Return (Zero)
        }

        Name (MAXT, Zero)
        Method (TDPC, 0, NotSerialized)
        {
            Return (MAXT) /* \_SB_.PC00.TCPU.MAXT */
        }

        Name (LEV0, Zero)
        Name (LEV1, Zero)
        Name (LEV2, Zero)
        Method (STDP, 1, Serialized)
        {
            If ((Arg0 >= \_SB.CLVL))
            {
                Return (Zero)
            }

            Switch (ToInteger (Arg0))
            {
                Case (Zero)
                {
                    Local0 = LEV0 /* \_SB_.PC00.TCPU.LEV0 */
                }
                Case (One)
                {
                    Local0 = LEV1 /* \_SB_.PC00.TCPU.LEV1 */
                }
                Case (0x02)
                {
                    Local0 = LEV2 /* \_SB_.PC00.TCPU.LEV2 */
                }

            }

            Switch (ToInteger (Local0))
            {
                Case (Zero)
                {
                    CPL0 ()
                }
                Case (One)
                {
                    CPL1 ()
                }
                Case (0x02)
                {
                    CPL2 ()
                }

            }

            Notify (\_SB.PC00.TCPU, 0x83) // Device-Specific Change
        }
    }

    Scope (\_SB)
    {
        Device (TPCH)
        {
            Name (_UID, "TPCH")  // _UID: Unique ID
            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                Return (\_SB.IETM.GHID (_UID))
            }

            Name (_STR, Unicode ("Intel PCH FIVR Participant"))  // _STR: Description String
            Name (PTYP, 0x05)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\PCHE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (RFC0, 1, Serialized)
            {
                IPCS (0xA3, One, 0x08, Zero, Arg0, Zero, Zero)
                Return (Package (0x01)
                {
                    Zero
                })
            }

            Method (RFC1, 1, Serialized)
            {
                IPCS (0xA3, One, 0x08, One, Arg0, Zero, Zero)
                Return (Package (0x01)
                {
                    Zero
                })
            }

            Method (SEMI, 1, Serialized)
            {
                IPCS (0xA3, One, 0x08, 0x02, Arg0, Zero, Zero)
                Return (Package (0x01)
                {
                    Zero
                })
            }

            Method (PKGC, 1, Serialized)
            {
                Name (PPKG, Package (0x02)
                {
                    Zero, 
                    Zero
                })
                PPKG [Zero] = DerefOf (Arg0 [Zero])
                PPKG [One] = DerefOf (Arg0 [One])
                Return (PPKG) /* \_SB_.TPCH.PKGC.PPKG */
            }

            Method (GFC0, 0, Serialized)
            {
                Local0 = IPCS (0xA3, Zero, 0x08, Zero, Zero, Zero, Zero)
                Local1 = \_SB.TPCH.PKGC (Local0)
                Return (Local1)
            }

            Method (GFC1, 0, Serialized)
            {
                Local0 = IPCS (0xA3, Zero, 0x08, One, Zero, Zero, Zero)
                Local1 = \_SB.TPCH.PKGC (Local0)
                Return (Local1)
            }

            Method (GEMI, 0, Serialized)
            {
                Local0 = IPCS (0xA3, Zero, 0x08, 0x02, Zero, Zero, Zero)
                Local1 = \_SB.TPCH.PKGC (Local0)
                Return (Local1)
            }

            Method (GFFS, 0, Serialized)
            {
                Local0 = IPCS (0xA3, Zero, 0x08, 0x03, Zero, Zero, Zero)
                Local1 = \_SB.TPCH.PKGC (Local0)
                Return (Local1)
            }

            Method (GFCS, 0, Serialized)
            {
                Local0 = IPCS (0xA3, Zero, 0x08, 0x04, Zero, Zero, Zero)
                Local1 = \_SB.TPCH.PKGC (Local0)
                Return (Local1)
            }
        }
    }

    Scope (\_SB.IETM)
    {
        Name (DP2P, Package (0x01)
        {
            ToUUID ("9e04115a-ae87-4d1c-9500-0f3e340bfe75") /* Unknown UUID */
        })
        Name (DPSP, Package (0x01)
        {
            ToUUID ("42a441d6-ae6a-462b-a84b-4a8ce79027d3") /* Unknown UUID */
        })
        Name (DASP, Package (0x01)
        {
            ToUUID ("3a95c389-e4b8-4629-a526-c52c88626bae") /* Unknown UUID */
        })
        Name (DA2P, Package (0x01)
        {
            ToUUID ("0e56fab6-bdfc-4e8c-8246-40ecfd4d74ea") /* Unknown UUID */
        })
        Name (DCSP, Package (0x01)
        {
            ToUUID ("97c68ae7-15fa-499c-b8c9-5da81d606e0a") /* Unknown UUID */
        })
        Name (RFIP, Package (0x01)
        {
            ToUUID ("c4ce1849-243a-49f3-b8d5-f97002f38e6a") /* Unknown UUID */
        })
        Name (POBP, Package (0x01)
        {
            ToUUID ("f5a35014-c209-46a4-993a-eb56de7530a1") /* Unknown UUID */
        })
        Name (DAPP, Package (0x01)
        {
            ToUUID ("63be270f-1c11-48fd-a6f7-3af253ff3e2d") /* Unknown UUID */
        })
        Name (DVSP, Package (0x01)
        {
            ToUUID ("6ed722a7-9240-48a5-b479-31eef723d7cf") /* Unknown UUID */
        })
        Name (DPID, Package (0x01)
        {
            ToUUID ("42496e14-bc1b-46e8-a798-ca915464426f") /* Unknown UUID */
        })
    }

    Scope (\_SB.IETM)
    {
        Method (TEVT, 2, Serialized)
        {
            Switch (ToInteger (Arg0))
            {
                Case ("IETM")
                {
                    Notify (\_SB.IETM, Arg1)
                }
                Case ("TCPU")
                {
                    Notify (\_SB.PC00.TCPU, Arg1)
                }
                Case ("TPCH")
                {
                    Notify (\_SB.TPCH, Arg1)
                }

            }
        }
    }

    Scope (\_SB.IETM)
    {
        Method (GDDV, 0, Serialized)
        {
            If (((PDFG & 0x08) == Zero))
            {
                If (((PDFG & 0x30) == Zero))
                {
                    Return (Package (0x01)
                    {
                        Buffer (0x0730)
                        {
                            /* 0000 */  0xE5, 0x1F, 0x94, 0x00, 0x00, 0x00, 0x00, 0x02,  // ........
                            /* 0008 */  0x00, 0x00, 0x00, 0x40, 0x67, 0x64, 0x64, 0x76,  // ...@gddv
                            /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x4F, 0x45, 0x4D, 0x20,  // ....OEM 
                            /* 0030 */  0x45, 0x78, 0x70, 0x6F, 0x72, 0x74, 0x65, 0x64,  // Exported
                            /* 0038 */  0x20, 0x44, 0x61, 0x74, 0x61, 0x56, 0x61, 0x75,  //  DataVau
                            /* 0040 */  0x6C, 0x74, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // lt......
                            /* 0048 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0050 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0058 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0068 */  0x00, 0x00, 0x00, 0x00, 0x36, 0xA5, 0x07, 0xCF,  // ....6...
                            /* 0070 */  0x48, 0xE7, 0x62, 0xE5, 0x3E, 0xCD, 0x60, 0xF9,  // H.b.>.`.
                            /* 0078 */  0x8F, 0xFA, 0xDC, 0x84, 0x32, 0x9E, 0x43, 0xCF,  // ....2.C.
                            /* 0080 */  0x77, 0x6E, 0xA7, 0xD5, 0x00, 0x0A, 0x8D, 0xEF,  // wn......
                            /* 0088 */  0x04, 0x0D, 0xD8, 0xC0, 0x9C, 0x06, 0x00, 0x00,  // ........
                            /* 0090 */  0x52, 0x45, 0x50, 0x4F, 0x5D, 0x00, 0x00, 0x00,  // REPO]...
                            /* 0098 */  0x01, 0xA5, 0x7B, 0x00, 0x00, 0x00, 0x00, 0x00,  // ..{.....
                            /* 00A0 */  0x00, 0x00, 0x72, 0x87, 0xCD, 0xFF, 0x6D, 0x24,  // ..r...m$
                            /* 00A8 */  0x47, 0xDB, 0x3D, 0x24, 0x92, 0xB4, 0x16, 0x6F,  // G.=$...o
                            /* 00B0 */  0x45, 0xD8, 0xC3, 0xF5, 0x66, 0x14, 0x9F, 0x22,  // E...f.."
                            /* 00B8 */  0xD7, 0xF7, 0xDE, 0x67, 0x90, 0x9A, 0xA2, 0x0D,  // ...g....
                            /* 00C0 */  0x39, 0x25, 0xAD, 0xC3, 0x1A, 0xAD, 0x52, 0x0B,  // 9%....R.
                            /* 00C8 */  0x75, 0x38, 0xE1, 0xA4, 0x14, 0x41, 0x44, 0xB8,  // u8...AD.
                            /* 00D0 */  0x7B, 0x0D, 0xC1, 0x28, 0x5F, 0xE9, 0x79, 0x5A,  // {..(_.yZ
                            /* 00D8 */  0x4A, 0xB9, 0xD4, 0xD5, 0xB3, 0x4D, 0x0D, 0x0B,  // J....M..
                            /* 00E0 */  0xC0, 0x11, 0x14, 0xDE, 0x13, 0x58, 0xB8, 0x57,  // .....X.W
                            /* 00E8 */  0xDC, 0x81, 0x92, 0x4E, 0x6E, 0x01, 0xDE, 0x66,  // ...Nn..f
                            /* 00F0 */  0x7B, 0x43, 0x57, 0x62, 0xFA, 0x28, 0x10, 0x14,  // {CWb.(..
                            /* 00F8 */  0xB5, 0x38, 0x90, 0x49, 0xB3, 0x59, 0xCF, 0xF7,  // .8.I.Y..
                            /* 0100 */  0x1E, 0xCD, 0xD7, 0x96, 0xAB, 0xB0, 0xE1, 0xC2,  // ........
                            /* 0108 */  0x7F, 0x61, 0xA6, 0xDB, 0x09, 0x38, 0x88, 0x24,  // .a...8.$
                            /* 0110 */  0xE7, 0x10, 0x44, 0xFA, 0x18, 0xC9, 0x9C, 0xDF,  // ..D.....
                            /* 0118 */  0x96, 0x07, 0x20, 0x87, 0x54, 0x3F, 0x30, 0xAD,  // .. .T?0.
                            /* 0120 */  0x3D, 0x6F, 0xBE, 0xE6, 0x9D, 0x9D, 0x5E, 0xB8,  // =o....^.
                            /* 0128 */  0xA9, 0xDC, 0x9C, 0x7F, 0x62, 0xAE, 0xFB, 0xD2,  // ....b...
                            /* 0130 */  0x6A, 0x90, 0x04, 0xE1, 0x99, 0x3C, 0xD6, 0xE4,  // j....<..
                            /* 0138 */  0x6F, 0xC0, 0x24, 0x06, 0x0C, 0x49, 0x2E, 0x13,  // o.$..I..
                            /* 0140 */  0x99, 0x3D, 0x78, 0xCC, 0x45, 0x5A, 0x87, 0xB3,  // .=x.EZ..
                            /* 0148 */  0xF1, 0xF3, 0x2C, 0xAF, 0xE2, 0x7C, 0x01, 0x53,  // ..,..|.S
                            /* 0150 */  0x77, 0x9E, 0x8F, 0xE4, 0xE7, 0x4E, 0x93, 0xDB,  // w....N..
                            /* 0158 */  0x94, 0x3D, 0x86, 0x5B, 0x9A, 0xC4, 0x38, 0xFD,  // .=.[..8.
                            /* 0160 */  0x66, 0x4B, 0x8B, 0xF9, 0x4E, 0x98, 0x8A, 0xD7,  // fK..N...
                            /* 0168 */  0x75, 0xC9, 0x8A, 0x51, 0x9D, 0x8C, 0x1C, 0xE1,  // u..Q....
                            /* 0170 */  0x14, 0x22, 0x57, 0x9C, 0xFA, 0xC5, 0x6D, 0x48,  // ."W...mH
                            /* 0178 */  0xCA, 0xFD, 0x08, 0x0D, 0x4F, 0xB1, 0xC7, 0xE0,  // ....O...
                            /* 0180 */  0x8D, 0x80, 0xE7, 0xEE, 0xFA, 0x8F, 0x06, 0xE3,  // ........
                            /* 0188 */  0xD3, 0xEB, 0xAA, 0xBD, 0xDE, 0x21, 0x9B, 0xFA,  // .....!..
                            /* 0190 */  0xC2, 0x71, 0xF3, 0x3B, 0xC7, 0xBF, 0x99, 0x48,  // .q.;...H
                            /* 0198 */  0x1E, 0xF5, 0xB7, 0x40, 0x58, 0x55, 0x16, 0xA4,  // ...@XU..
                            /* 01A0 */  0x29, 0x13, 0x41, 0xF3, 0x54, 0x8C, 0x6F, 0x16,  // ).A.T.o.
                            /* 01A8 */  0x00, 0x9E, 0x76, 0x9A, 0x34, 0xC2, 0x00, 0x61,  // ..v.4..a
                            /* 01B0 */  0x4E, 0x01, 0xA1, 0xAF, 0xF9, 0xC7, 0x21, 0x2E,  // N.....!.
                            /* 01B8 */  0xE2, 0xA5, 0xC8, 0x04, 0x0B, 0xB1, 0x29, 0x0C,  // ......).
                            /* 01C0 */  0x82, 0xE7, 0x05, 0x5D, 0x86, 0xDF, 0xF7, 0x49,  // ...]...I
                            /* 01C8 */  0xB9, 0xF5, 0x7D, 0x73, 0xBC, 0xB9, 0xEF, 0x8D,  // ..}s....
                            /* 01D0 */  0xDD, 0x05, 0xE6, 0x0E, 0x5C, 0x0E, 0xA7, 0x5C,  // ....\..\
                            /* 01D8 */  0x12, 0xEF, 0xF9, 0xCE, 0xCF, 0x31, 0x02, 0x3B,  // .....1.;
                            /* 01E0 */  0x36, 0xDB, 0xD6, 0x23, 0xF4, 0x72, 0xB0, 0xA9,  // 6..#.r..
                            /* 01E8 */  0x26, 0xF9, 0x0A, 0xDD, 0xCB, 0x83, 0x05, 0x5A,  // &......Z
                            /* 01F0 */  0x4C, 0xBA, 0x92, 0x31, 0x0E, 0x02, 0x51, 0xD9,  // L..1..Q.
                            /* 01F8 */  0x13, 0x9A, 0x22, 0x24, 0x8C, 0x5B, 0xC2, 0xCD,  // .."$.[..
                            /* 0200 */  0x46, 0x8B, 0xB8, 0x19, 0x74, 0xDB, 0x82, 0xE0,  // F...t...
                            /* 0208 */  0xE8, 0x9F, 0x07, 0xE9, 0xBC, 0x0A, 0x49, 0xF5,  // ......I.
                            /* 0210 */  0x0A, 0x04, 0x71, 0xB1, 0x4E, 0x4C, 0x26, 0xD1,  // ..q.NL&.
                            /* 0218 */  0xFC, 0xD3, 0x3C, 0x6A, 0xAB, 0x12, 0x70, 0xDC,  // ..<j..p.
                            /* 0220 */  0x7A, 0xC7, 0xAD, 0xF8, 0x9D, 0xB8, 0x43, 0xB7,  // z.....C.
                            /* 0228 */  0x84, 0x7E, 0xB0, 0xB3, 0x29, 0x8D, 0x8A, 0xF7,  // .~..)...
                            /* 0230 */  0x23, 0xD7, 0x27, 0xC0, 0xFE, 0xBB, 0x13, 0xD0,  // #.'.....
                            /* 0238 */  0x7E, 0x63, 0x3F, 0x04, 0x22, 0xED, 0x4A, 0xAC,  // ~c?.".J.
                            /* 0240 */  0x8E, 0x58, 0x06, 0x77, 0xD9, 0x42, 0x14, 0x76,  // .X.w.B.v
                            /* 0248 */  0x8F, 0x9B, 0xFD, 0x48, 0x4D, 0x57, 0x81, 0xA7,  // ...HMW..
                            /* 0250 */  0x93, 0x78, 0x63, 0x19, 0x15, 0xD5, 0x27, 0x1E,  // .xc...'.
                            /* 0258 */  0xB1, 0x82, 0xFE, 0x62, 0x1D, 0xF4, 0x89, 0xF2,  // ...b....
                            /* 0260 */  0x9F, 0x6D, 0x20, 0x15, 0xA8, 0x90, 0x9C, 0x3B,  // .m ....;
                            /* 0268 */  0xE1, 0x71, 0x92, 0xEB, 0x6D, 0xDD, 0x6B, 0x73,  // .q..m.ks
                            /* 0270 */  0x50, 0xDB, 0x25, 0xCD, 0x25, 0x8A, 0x49, 0xD6,  // P.%.%.I.
                            /* 0278 */  0x39, 0x63, 0x64, 0x16, 0x75, 0x65, 0xFA, 0x5F,  // 9cd.ue._
                            /* 0280 */  0x0A, 0x14, 0x63, 0xAC, 0x0E, 0x37, 0x42, 0xDD,  // ..c..7B.
                            /* 0288 */  0x4C, 0x8E, 0x56, 0x28, 0x4E, 0xB0, 0x9C, 0x95,  // L.V(N...
                            /* 0290 */  0x33, 0x65, 0x2F, 0x39, 0x23, 0x42, 0x95, 0xE7,  // 3e/9#B..
                            /* 0298 */  0x66, 0x03, 0x26, 0x74, 0x9F, 0x64, 0xFB, 0x68,  // f.&t.d.h
                            /* 02A0 */  0x56, 0x7A, 0xD6, 0x92, 0x62, 0x0B, 0x2E, 0x36,  // Vz..b..6
                            /* 02A8 */  0x34, 0xC2, 0xC2, 0xFE, 0xDD, 0x64, 0x29, 0x10,  // 4....d).
                            /* 02B0 */  0x68, 0x97, 0x56, 0x9D, 0x17, 0x30, 0x33, 0x3F,  // h.V..03?
                            /* 02B8 */  0x15, 0xD1, 0x4E, 0x8C, 0x4E, 0x99, 0x11, 0xBD,  // ..N.N...
                            /* 02C0 */  0xE2, 0xA8, 0xAB, 0xCA, 0xCB, 0x0D, 0x14, 0x38,  // .......8
                            /* 02C8 */  0x8A, 0xD4, 0xE4, 0x45, 0x11, 0x03, 0x6C, 0xF5,  // ...E..l.
                            /* 02D0 */  0xAB, 0xE0, 0xD0, 0x76, 0x18, 0x15, 0x84, 0xE7,  // ...v....
                            /* 02D8 */  0x99, 0xC4, 0xE1, 0xF3, 0xDB, 0x3B, 0x54, 0x3C,  // .....;T<
                            /* 02E0 */  0x00, 0x3A, 0xF1, 0x21, 0x72, 0xA9, 0xDE, 0x4E,  // .:.!r..N
                            /* 02E8 */  0x52, 0x63, 0x48, 0xAE, 0x24, 0x2D, 0xDD, 0x48,  // RcH.$-.H
                            /* 02F0 */  0xF7, 0xEC, 0x1C, 0xB1, 0x8B, 0xFA, 0x31, 0x0E,  // ......1.
                            /* 02F8 */  0x44, 0x9F, 0x93, 0x02, 0xAC, 0x0C, 0xB5, 0xD7,  // D.......
                            /* 0300 */  0x7C, 0x0B, 0x9A, 0x89, 0x41, 0xAE, 0x14, 0xAB,  // |...A...
                            /* 0308 */  0x03, 0xAA, 0x9F, 0x0A, 0xA4, 0x2D, 0x99, 0x7E,  // .....-.~
                            /* 0310 */  0x7B, 0xD9, 0x7F, 0x33, 0x72, 0xE3, 0x41, 0xE8,  // {..3r.A.
                            /* 0318 */  0x2C, 0x05, 0x15, 0x2C, 0xBC, 0xCF, 0xB3, 0x5E,  // ,..,...^
                            /* 0320 */  0xAD, 0x0E, 0x89, 0x93, 0xAB, 0x12, 0x6D, 0xC1,  // ......m.
                            /* 0328 */  0xF0, 0x47, 0xF6, 0x8A, 0x99, 0x01, 0x3E, 0xF7,  // .G....>.
                            /* 0330 */  0x67, 0x3E, 0x7A, 0xBB, 0x76, 0xF3, 0xE0, 0x14,  // g>z.v...
                            /* 0338 */  0x24, 0x70, 0xC3, 0xE9, 0xEF, 0x1E, 0xB6, 0x64,  // $p.....d
                            /* 0340 */  0x1C, 0xF5, 0xDF, 0xBE, 0x13, 0xC0, 0x89, 0x0E,  // ........
                            /* 0348 */  0x87, 0xF6, 0x0A, 0x91, 0xC2, 0x92, 0x1C, 0xC7,  // ........
                            /* 0350 */  0xF7, 0xA4, 0x76, 0x68, 0xA5, 0x94, 0x6F, 0x05,  // ..vh..o.
                            /* 0358 */  0x81, 0x3E, 0x06, 0xA7, 0xB2, 0x5C, 0x39, 0xCF,  // .>...\9.
                            /* 0360 */  0x4A, 0x32, 0xD1, 0xD8, 0x0A, 0xCE, 0x77, 0x3C,  // J2....w<
                            /* 0368 */  0xE7, 0x77, 0xA6, 0x96, 0x93, 0x09, 0x91, 0xA0,  // .w......
                            /* 0370 */  0xD6, 0xC7, 0xAD, 0x85, 0xA7, 0xCB, 0x67, 0xFF,  // ......g.
                            /* 0378 */  0xDC, 0x0B, 0xF7, 0x3B, 0x36, 0xDC, 0xFB, 0xD3,  // ...;6...
                            /* 0380 */  0x08, 0x78, 0x46, 0xDC, 0x11, 0x05, 0x95, 0x3A,  // .xF....:
                            /* 0388 */  0xDC, 0xAD, 0x36, 0x8C, 0x0D, 0x00, 0x0F, 0x11,  // ..6.....
                            /* 0390 */  0xB7, 0x7C, 0xBB, 0x83, 0xDD, 0x88, 0xFF, 0x2E,  // .|......
                            /* 0398 */  0x6C, 0x6E, 0x7D, 0xB9, 0xF3, 0x34, 0xD7, 0xE6,  // ln}..4..
                            /* 03A0 */  0xE3, 0x49, 0x15, 0xC9, 0x71, 0xBF, 0xFE, 0x9C,  // .I..q...
                            /* 03A8 */  0x23, 0x7A, 0x40, 0x69, 0xE8, 0x3E, 0x9D, 0x1C,  // #z@i.>..
                            /* 03B0 */  0x9C, 0x8E, 0xA8, 0xDB, 0x38, 0xEF, 0x61, 0xAD,  // ....8.a.
                            /* 03B8 */  0x81, 0x60, 0xD2, 0xD2, 0x82, 0xCD, 0x72, 0x3E,  // .`....r>
                            /* 03C0 */  0xAC, 0x74, 0xA3, 0xEB, 0x63, 0x3E, 0x61, 0x3F,  // .t..c>a?
                            /* 03C8 */  0x90, 0xD6, 0xDC, 0x9D, 0x9F, 0x7B, 0xB2, 0x0D,  // .....{..
                            /* 03D0 */  0xE5, 0xE9, 0x63, 0x0A, 0x26, 0x71, 0x28, 0x61,  // ..c.&q(a
                            /* 03D8 */  0xB2, 0xE1, 0x0E, 0x99, 0x30, 0xFB, 0x86, 0xEA,  // ....0...
                            /* 03E0 */  0xC5, 0x85, 0x8E, 0x84, 0x63, 0x64, 0xAE, 0x39,  // ....cd.9
                            /* 03E8 */  0x6F, 0x18, 0x19, 0xF0, 0xAD, 0x2D, 0x31, 0x04,  // o....-1.
                            /* 03F0 */  0x7E, 0x85, 0x31, 0xA9, 0x12, 0x75, 0x5C, 0xD5,  // ~.1..u\.
                            /* 03F8 */  0xB4, 0x5B, 0xBE, 0x85, 0x8C, 0xD3, 0x60, 0x77,  // .[....`w
                            /* 0400 */  0x68, 0x89, 0x13, 0x1F, 0xE9, 0x4E, 0xBF, 0x99,  // h....N..
                            /* 0408 */  0x37, 0x53, 0x44, 0xF1, 0x2D, 0x4C, 0xD3, 0xA5,  // 7SD.-L..
                            /* 0410 */  0xFB, 0x7B, 0xF1, 0x6E, 0xE8, 0x15, 0xF3, 0x02,  // .{.n....
                            /* 0418 */  0x49, 0xDD, 0x75, 0xA0, 0x16, 0xEE, 0x78, 0xD2,  // I.u...x.
                            /* 0420 */  0x04, 0x07, 0x50, 0x4F, 0xC3, 0x36, 0xFF, 0x97,  // ..PO.6..
                            /* 0428 */  0xA9, 0xA3, 0x2E, 0x72, 0x8A, 0xD3, 0xAB, 0x09,  // ...r....
                            /* 0430 */  0x73, 0x5D, 0x35, 0xD6, 0x4F, 0xEA, 0xDF, 0x53,  // s]5.O..S
                            /* 0438 */  0x37, 0x30, 0x98, 0xA7, 0x76, 0x43, 0x89, 0x7A,  // 70..vC.z
                            /* 0440 */  0x91, 0xCD, 0x34, 0x30, 0xD3, 0x86, 0x83, 0xE6,  // ..40....
                            /* 0448 */  0x83, 0x75, 0xFC, 0x8E, 0x62, 0x58, 0x87, 0xF4,  // .u..bX..
                            /* 0450 */  0x8F, 0x1B, 0x94, 0xFB, 0x9F, 0x60, 0x58, 0x84,  // .....`X.
                            /* 0458 */  0x2D, 0x3A, 0x83, 0x8E, 0xBE, 0x0E, 0x73, 0x06,  // -:....s.
                            /* 0460 */  0x96, 0x65, 0x12, 0x67, 0x55, 0x6A, 0x67, 0xBD,  // .e.gUjg.
                            /* 0468 */  0x06, 0x57, 0x29, 0xD9, 0x8C, 0xFB, 0x46, 0x2E,  // .W)...F.
                            /* 0470 */  0x72, 0x25, 0x3B, 0x5C, 0x65, 0x10, 0xEE, 0xDA,  // r%;\e...
                            /* 0478 */  0xBB, 0xBA, 0x80, 0xB8, 0x9B, 0x2D, 0xE7, 0x6F,  // .....-.o
                            /* 0480 */  0xE1, 0xE6, 0x7A, 0x49, 0x76, 0xD8, 0x0D, 0x4E,  // ..zIv..N
                            /* 0488 */  0xA4, 0x52, 0xC1, 0xFA, 0x5A, 0x71, 0x6E, 0xD9,  // .R..Zqn.
                            /* 0490 */  0xE7, 0x3C, 0xFD, 0x6C, 0xB3, 0x38, 0x75, 0x1B,  // .<.l.8u.
                            /* 0498 */  0xE9, 0xC6, 0x4D, 0xA7, 0x54, 0x8E, 0xCE, 0xA0,  // ..M.T...
                            /* 04A0 */  0x05, 0x5E, 0xA9, 0x27, 0xEE, 0x9B, 0x46, 0xAC,  // .^.'..F.
                            /* 04A8 */  0x30, 0x0F, 0x93, 0xB2, 0xA6, 0x8E, 0x41, 0xF7,  // 0.....A.
                            /* 04B0 */  0x91, 0xE6, 0x9C, 0x3E, 0x9D, 0xB0, 0xCC, 0xEB,  // ...>....
                            /* 04B8 */  0x86, 0xF3, 0x1E, 0xA3, 0xB4, 0x2C, 0x75, 0xFC,  // .....,u.
                            /* 04C0 */  0xBA, 0x06, 0x6B, 0xEA, 0x49, 0x00, 0xC7, 0x6C,  // ..k.I..l
                            /* 04C8 */  0xD8, 0xBD, 0x9F, 0x64, 0xC4, 0x7F, 0x96, 0xC0,  // ...d....
                            /* 04D0 */  0x82, 0x0D, 0x7A, 0xA8, 0x29, 0xB4, 0xC9, 0x67,  // ..z.)..g
                            /* 04D8 */  0xC2, 0xE4, 0x33, 0x39, 0xAA, 0x93, 0xA2, 0xD0,  // ..39....
                            /* 04E0 */  0xB0, 0x18, 0xAE, 0xC5, 0xB0, 0x06, 0x85, 0x8C,  // ........
                            /* 04E8 */  0x3A, 0xBD, 0xB7, 0x6D, 0xBA, 0xCE, 0x40, 0x45,  // :..m..@E
                            /* 04F0 */  0x49, 0xAD, 0x4E, 0x1E, 0xF1, 0x2A, 0x80, 0x84,  // I.N..*..
                            /* 04F8 */  0x58, 0x59, 0x47, 0x0B, 0x11, 0x5A, 0xF8, 0xAC,  // XYG..Z..
                            /* 0500 */  0xF1, 0xBB, 0xDE, 0x5D, 0xC9, 0xF2, 0xD9, 0xBC,  // ...]....
                            /* 0508 */  0x43, 0x0B, 0x63, 0x63, 0x92, 0xFC, 0x01, 0x4F,  // C.cc...O
                            /* 0510 */  0x63, 0x5F, 0xE1, 0xAC, 0xF5, 0x1A, 0x5D, 0x93,  // c_....].
                            /* 0518 */  0x26, 0x27, 0x8F, 0xB8, 0x32, 0xF4, 0x24, 0xCB,  // &'..2.$.
                            /* 0520 */  0x64, 0x20, 0x36, 0x41, 0x0B, 0xBF, 0xB6, 0x0A,  // d 6A....
                            /* 0528 */  0x12, 0xA6, 0xE3, 0x16, 0xE3, 0x6A, 0x54, 0xB9,  // .....jT.
                            /* 0530 */  0xFF, 0x46, 0x2A, 0x03, 0x25, 0xA5, 0x76, 0x77,  // .F*.%.vw
                            /* 0538 */  0xB5, 0x1A, 0xAD, 0x27, 0x71, 0x1B, 0x27, 0x60,  // ...'q.'`
                            /* 0540 */  0x1B, 0x60, 0x34, 0xA4, 0x6D, 0xAB, 0x3C, 0x98,  // .`4.m.<.
                            /* 0548 */  0x16, 0x00, 0x93, 0x6C, 0xA8, 0xB1, 0xAE, 0x39,  // ...l...9
                            /* 0550 */  0x27, 0x93, 0xFC, 0xCF, 0x68, 0xBB, 0xEE, 0xF6,  // '...h...
                            /* 0558 */  0x5A, 0x1B, 0xFA, 0x44, 0x24, 0x01, 0x9A, 0x80,  // Z..D$...
                            /* 0560 */  0x89, 0x53, 0xF3, 0x18, 0x00, 0x43, 0x3A, 0xB0,  // .S...C:.
                            /* 0568 */  0xAD, 0x6A, 0x59, 0x48, 0xDC, 0xCA, 0xAA, 0x56,  // .jYH...V
                            /* 0570 */  0x51, 0xAA, 0x75, 0xDC, 0x62, 0xCF, 0xB1, 0x3D,  // Q.u.b..=
                            /* 0578 */  0x81, 0x1D, 0xED, 0xFF, 0xBC, 0xAA, 0xDD, 0xDD,  // ........
                            /* 0580 */  0xBC, 0xE6, 0xBE, 0xC3, 0x08, 0xD0, 0xF4, 0x61,  // .......a
                            /* 0588 */  0x4B, 0x68, 0xA1, 0x74, 0x30, 0xBB, 0xB4, 0xBD,  // Kh.t0...
                            /* 0590 */  0xED, 0x9E, 0xCE, 0x63, 0x94, 0x21, 0xB3, 0x40,  // ...c.!.@
                            /* 0598 */  0x34, 0x02, 0x7C, 0x89, 0x90, 0x7D, 0xAD, 0xA2,  // 4.|..}..
                            /* 05A0 */  0xE3, 0xB4, 0x74, 0x89, 0x7F, 0x26, 0x8E, 0xB1,  // ..t..&..
                            /* 05A8 */  0x67, 0x70, 0x9B, 0xD9, 0x6B, 0x4F, 0x7D, 0x53,  // gp..kO}S
                            /* 05B0 */  0xD4, 0x28, 0xD3, 0xB1, 0xD6, 0x0F, 0x56, 0x68,  // .(....Vh
                            /* 05B8 */  0x67, 0xC2, 0x60, 0x5C, 0xBA, 0x70, 0x49, 0x93,  // g.`\.pI.
                            /* 05C0 */  0xFE, 0xDA, 0x67, 0x43, 0xFC, 0x06, 0x72, 0xDD,  // ..gC..r.
                            /* 05C8 */  0x1E, 0xB4, 0x7E, 0x89, 0xE5, 0xC9, 0x25, 0x5D,  // ..~...%]
                            /* 05D0 */  0x83, 0x1E, 0x9C, 0x0B, 0x3E, 0x58, 0x08, 0xEA,  // ....>X..
                            /* 05D8 */  0x97, 0x2B, 0x7B, 0xA1, 0xE2, 0x7F, 0xCD, 0x80,  // .+{.....
                            /* 05E0 */  0xF4, 0xD7, 0xE4, 0xB3, 0x16, 0x39, 0x59, 0x5C,  // .....9Y\
                            /* 05E8 */  0xEA, 0x27, 0x29, 0xFB, 0x9C, 0xDF, 0xA7, 0xF4,  // .').....
                            /* 05F0 */  0x2F, 0x3E, 0xDE, 0x77, 0x57, 0x85, 0x74, 0xF9,  // />.wW.t.
                            /* 05F8 */  0xA9, 0x75, 0xAD, 0x7C, 0xB7, 0x7C, 0xA3, 0xE4,  // .u.|.|..
                            /* 0600 */  0xC3, 0x9D, 0x85, 0x99, 0x41, 0x5F, 0x11, 0x3C,  // ....A_.<
                            /* 0608 */  0xCE, 0x20, 0xB1, 0x93, 0xEA, 0xD7, 0x95, 0x8F,  // . ......
                            /* 0610 */  0x27, 0xDD, 0x24, 0x5F, 0xBE, 0xBC, 0xB9, 0xEC,  // '.$_....
                            /* 0618 */  0x85, 0xF3, 0x75, 0x53, 0xD1, 0xCC, 0xDB, 0x30,  // ..uS...0
                            /* 0620 */  0xBA, 0xF7, 0xBA, 0x9E, 0x38, 0x7B, 0x72, 0xDA,  // ....8{r.
                            /* 0628 */  0x35, 0x79, 0xAF, 0xF4, 0x68, 0x9E, 0xE1, 0xC8,  // 5y..h...
                            /* 0630 */  0x9D, 0x5B, 0x2B, 0xA9, 0x55, 0x2C, 0x10, 0xA3,  // .[+.U,..
                            /* 0638 */  0xD2, 0xB9, 0xB5, 0xDE, 0xBF, 0x82, 0x80, 0x57,  // .......W
                            /* 0640 */  0x96, 0xF1, 0x19, 0xFE, 0xF6, 0xA3, 0xBE, 0x6D,  // .......m
                            /* 0648 */  0x8D, 0xC0, 0xE6, 0x59, 0xD6, 0x78, 0x07, 0x70,  // ...Y.x.p
                            /* 0650 */  0xCC, 0xDA, 0x42, 0x05, 0x50, 0xAE, 0x0D, 0xEA,  // ..B.P...
                            /* 0658 */  0xF6, 0x9B, 0xFD, 0x13, 0x29, 0x0E, 0x76, 0xE3,  // ....).v.
                            /* 0660 */  0x4D, 0x8B, 0x69, 0x64, 0x44, 0x60, 0x6A, 0x5B,  // M.idD`j[
                            /* 0668 */  0xB1, 0xA7, 0x9A, 0xC7, 0x40, 0x41, 0x85, 0xBE,  // ....@A..
                            /* 0670 */  0x6C, 0xA1, 0x55, 0x4A, 0x17, 0xCB, 0x6D, 0x3F,  // l.UJ..m?
                            /* 0678 */  0xBF, 0xC5, 0xF2, 0x79, 0x0B, 0xB6, 0xC3, 0x28,  // ...y...(
                            /* 0680 */  0x50, 0xD0, 0x15, 0xEE, 0x98, 0xBC, 0xB7, 0x95,  // P.......
                            /* 0688 */  0xCA, 0x91, 0xE1, 0xBD, 0x39, 0xEC, 0xF6, 0xBC,  // ....9...
                            /* 0690 */  0xBE, 0x29, 0x4B, 0xF5, 0x7A, 0x8E, 0x3A, 0x1B,  // .)K.z.:.
                            /* 0698 */  0xCF, 0xB1, 0xB0, 0xC4, 0x27, 0xA8, 0x1C, 0xBC,  // ....'...
                            /* 06A0 */  0x7B, 0x51, 0x88, 0x12, 0xA5, 0xD1, 0xF8, 0x1F,  // {Q......
                            /* 06A8 */  0x9A, 0x53, 0x7E, 0x65, 0x26, 0xE9, 0x43, 0x3F,  // .S~e&.C?
                            /* 06B0 */  0xDE, 0x98, 0xE1, 0x80, 0x7A, 0xA4, 0xE4, 0xDD,  // ....z...
                            /* 06B8 */  0x82, 0x67, 0x0A, 0xF2, 0x6D, 0xA9, 0x04, 0xEC,  // .g..m...
                            /* 06C0 */  0x86, 0x80, 0xFD, 0xF3, 0xC6, 0xA6, 0xCB, 0xB3,  // ........
                            /* 06C8 */  0xEF, 0x85, 0x65, 0x23, 0x94, 0x1E, 0x81, 0x98,  // ..e#....
                            /* 06D0 */  0x72, 0xE8, 0xB0, 0x06, 0xDB, 0x28, 0xE0, 0x4C,  // r....(.L
                            /* 06D8 */  0xC6, 0x22, 0xBC, 0xD7, 0x50, 0xAF, 0xB3, 0x26,  // ."..P..&
                            /* 06E0 */  0xB0, 0x2A, 0x31, 0xAD, 0xB9, 0x1D, 0x48, 0xB2,  // .*1...H.
                            /* 06E8 */  0xB4, 0xFD, 0x0E, 0xD8, 0xAC, 0x66, 0xA6, 0x67,  // .....f.g
                            /* 06F0 */  0x0B, 0x16, 0xFA, 0xCE, 0xD0, 0x5F, 0x20, 0x17,  // ....._ .
                            /* 06F8 */  0xF7, 0xE0, 0x01, 0x03, 0x3F, 0xBD, 0x22, 0xE5,  // ....?.".
                            /* 0700 */  0x83, 0x9A, 0xD7, 0x8C, 0x8D, 0x17, 0xF4, 0x7A,  // .......z
                            /* 0708 */  0xDA, 0x29, 0x2A, 0x2A, 0x09, 0xDD, 0x96, 0x32,  // .)**...2
                            /* 0710 */  0x02, 0xDE, 0xF0, 0x2E, 0x30, 0xA7, 0x4D, 0xD1,  // ....0.M.
                            /* 0718 */  0xC7, 0x4C, 0x74, 0x43, 0x02, 0xD1, 0x65, 0x44,  // .LtC..eD
                            /* 0720 */  0x2C, 0x07, 0x13, 0x35, 0xA7, 0xF2, 0xAE, 0xFF,  // ,..5....
                            /* 0728 */  0x78, 0xCB, 0x62, 0x15, 0x25, 0x95, 0x4E, 0x68   // x.b.%.Nh
                        }
                    })
                }
                Else
                {
                    Return (Package (0x01)
                    {
                        Buffer (0x07B2)
                        {
                            /* 0000 */  0xE5, 0x1F, 0x94, 0x00, 0x00, 0x00, 0x00, 0x02,  // ........
                            /* 0008 */  0x00, 0x00, 0x00, 0x40, 0x67, 0x64, 0x64, 0x76,  // ...@gddv
                            /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x4F, 0x45, 0x4D, 0x20,  // ....OEM 
                            /* 0030 */  0x45, 0x78, 0x70, 0x6F, 0x72, 0x74, 0x65, 0x64,  // Exported
                            /* 0038 */  0x20, 0x44, 0x61, 0x74, 0x61, 0x56, 0x61, 0x75,  //  DataVau
                            /* 0040 */  0x6C, 0x74, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // lt......
                            /* 0048 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0050 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0058 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 0068 */  0x00, 0x00, 0x00, 0x00, 0x30, 0x6C, 0xC2, 0x66,  // ....0l.f
                            /* 0070 */  0xCC, 0x5B, 0xF8, 0xCF, 0x3C, 0x20, 0x99, 0x61,  // .[..< .a
                            /* 0078 */  0xA7, 0xC2, 0x74, 0xF4, 0x82, 0x1A, 0x79, 0xBE,  // ..t...y.
                            /* 0080 */  0x9A, 0x81, 0xD3, 0x7A, 0xA7, 0xEF, 0x99, 0xD3,  // ...z....
                            /* 0088 */  0x1C, 0x0C, 0x0E, 0x70, 0x1E, 0x07, 0x00, 0x00,  // ...p....
                            /* 0090 */  0x52, 0x45, 0x50, 0x4F, 0x5D, 0x00, 0x00, 0x00,  // REPO]...
                            /* 0098 */  0x01, 0xC8, 0x91, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                            /* 00A0 */  0x00, 0x00, 0x72, 0x87, 0xCD, 0xFF, 0x6D, 0x24,  // ..r...m$
                            /* 00A8 */  0x47, 0xDB, 0x3D, 0x24, 0x92, 0xB4, 0x16, 0x6F,  // G.=$...o
                            /* 00B0 */  0x45, 0xD8, 0xC3, 0xF5, 0x66, 0x14, 0x9F, 0x22,  // E...f.."
                            /* 00B8 */  0xD7, 0xF7, 0xDE, 0x67, 0x90, 0x9A, 0xA2, 0x0D,  // ...g....
                            /* 00C0 */  0x39, 0x25, 0xAD, 0xC3, 0x1A, 0xAD, 0x52, 0x0B,  // 9%....R.
                            /* 00C8 */  0x75, 0x38, 0xE1, 0xA4, 0x14, 0x43, 0x61, 0xA2,  // u8...Ca.
                            /* 00D0 */  0xEA, 0x4A, 0xC6, 0xFA, 0xF0, 0xD6, 0xB5, 0x10,  // .J......
                            /* 00D8 */  0xC3, 0x8C, 0xE9, 0xAA, 0xDF, 0x67, 0x70, 0x5D,  // .....gp]
                            /* 00E0 */  0xA1, 0xCE, 0x2B, 0x71, 0xC2, 0x34, 0xAE, 0xC1,  // ..+q.4..
                            /* 00E8 */  0xF5, 0x19, 0xE9, 0xE9, 0xAD, 0x4F, 0xAD, 0x80,  // .....O..
                            /* 00F0 */  0x4B, 0x21, 0x03, 0xA3, 0xC9, 0xBC, 0x46, 0x50,  // K!....FP
                            /* 00F8 */  0x60, 0x3B, 0xF3, 0xB4, 0x9E, 0x63, 0xF4, 0xF4,  // `;...c..
                            /* 0100 */  0x1E, 0x27, 0xD8, 0x70, 0x71, 0x28, 0xCD, 0xA8,  // .'.pq(..
                            /* 0108 */  0xBF, 0xD7, 0x7A, 0x80, 0xB5, 0x01, 0xEA, 0xF9,  // ..z.....
                            /* 0110 */  0x24, 0x79, 0xAF, 0xAA, 0xE5, 0x02, 0x9E, 0x70,  // $y.....p
                            /* 0118 */  0x9F, 0xF5, 0x5A, 0xD6, 0xE3, 0xC5, 0xED, 0xCE,  // ..Z.....
                            /* 0120 */  0xC4, 0x60, 0x44, 0x3D, 0xAB, 0x28, 0xA7, 0x27,  // .`D=.(.'
                            /* 0128 */  0x4E, 0xBD, 0x12, 0xAA, 0xDB, 0xD2, 0x08, 0xDE,  // N.......
                            /* 0130 */  0x08, 0x73, 0xD8, 0xF4, 0xC4, 0x8F, 0xE1, 0x93,  // .s......
                            /* 0138 */  0x7E, 0xC6, 0xFE, 0x65, 0x56, 0xC8, 0xEC, 0x26,  // ~..eV..&
                            /* 0140 */  0x52, 0x78, 0xE6, 0xCA, 0xA8, 0xC0, 0x99, 0x56,  // Rx.....V
                            /* 0148 */  0xDF, 0x23, 0xBD, 0xE4, 0x05, 0x55, 0x6E, 0xA8,  // .#...Un.
                            /* 0150 */  0x8B, 0xC9, 0xA2, 0x9B, 0x50, 0xBE, 0x4D, 0xB7,  // ....P.M.
                            /* 0158 */  0xE2, 0xE1, 0x5C, 0x20, 0x73, 0x18, 0xC6, 0xFA,  // ..\ s...
                            /* 0160 */  0xF5, 0xA0, 0xF1, 0x97, 0x7A, 0xFF, 0xDA, 0x96,  // ....z...
                            /* 0168 */  0xFB, 0x72, 0x68, 0xF6, 0x66, 0x5E, 0x63, 0xD6,  // .rh.f^c.
                            /* 0170 */  0xAE, 0xFC, 0x5B, 0x41, 0x41, 0x65, 0x59, 0x75,  // ..[AAeYu
                            /* 0178 */  0x7F, 0x07, 0x9B, 0x74, 0x20, 0xA6, 0x47, 0xF9,  // ...t .G.
                            /* 0180 */  0xB0, 0x5F, 0xAC, 0xD7, 0x49, 0x6F, 0x57, 0xAE,  // ._..IoW.
                            /* 0188 */  0x34, 0xD0, 0x81, 0xA0, 0xD1, 0x9E, 0x1A, 0x1F,  // 4.......
                            /* 0190 */  0xB9, 0x7D, 0x45, 0xEA, 0xA1, 0x66, 0xCB, 0x03,  // .}E..f..
                            /* 0198 */  0x96, 0x76, 0x94, 0xFE, 0xC1, 0xC8, 0xD0, 0xCA,  // .v......
                            /* 01A0 */  0xB0, 0x10, 0xD4, 0x52, 0x4D, 0xD2, 0x8A, 0xDE,  // ...RM...
                            /* 01A8 */  0xB7, 0x34, 0x93, 0x8D, 0xB2, 0xD9, 0x07, 0x83,  // .4......
                            /* 01B0 */  0xDC, 0x0B, 0x35, 0x84, 0xF7, 0x36, 0x3A, 0x41,  // ..5..6:A
                            /* 01B8 */  0x4E, 0x4A, 0x4F, 0xB4, 0xD5, 0x3F, 0x70, 0x77,  // NJO..?pw
                            /* 01C0 */  0x42, 0xEE, 0xFB, 0x09, 0x3F, 0xF4, 0x6E, 0x0D,  // B...?.n.
                            /* 01C8 */  0x1F, 0xF8, 0x52, 0xEA, 0xF0, 0x2D, 0x71, 0xC4,  // ..R..-q.
                            /* 01D0 */  0x54, 0x44, 0x80, 0x20, 0xC8, 0x47, 0xAB, 0x62,  // TD. .G.b
                            /* 01D8 */  0x71, 0x4D, 0xF0, 0x3B, 0xAA, 0xF5, 0x29, 0xD3,  // qM.;..).
                            /* 01E0 */  0xF5, 0x61, 0x0C, 0xE1, 0x8B, 0x03, 0xF7, 0x69,  // .a.....i
                            /* 01E8 */  0x29, 0x7B, 0x00, 0x5C, 0xAA, 0x7B, 0x75, 0x7A,  // ){.\.{uz
                            /* 01F0 */  0x99, 0xE0, 0xDE, 0xCC, 0xEF, 0xAD, 0xBC, 0x6E,  // .......n
                            /* 01F8 */  0x2F, 0x07, 0xCD, 0xF0, 0x31, 0x09, 0x7B, 0xB6,  // /...1.{.
                            /* 0200 */  0xBB, 0x83, 0x10, 0x5A, 0xDE, 0x79, 0x8B, 0x8E,  // ...Z.y..
                            /* 0208 */  0xC9, 0x5D, 0x14, 0x7B, 0xC7, 0x03, 0xFA, 0xAC,  // .].{....
                            /* 0210 */  0xFC, 0x7A, 0xC9, 0xF5, 0xA4, 0x81, 0x6F, 0x58,  // .z....oX
                            /* 0218 */  0x93, 0x4A, 0x03, 0xE5, 0x75, 0x8F, 0xE8, 0xF4,  // .J..u...
                            /* 0220 */  0x43, 0xAF, 0xDC, 0xB7, 0x6B, 0x3E, 0x2C, 0xEB,  // C...k>,.
                            /* 0228 */  0xDF, 0xF6, 0x55, 0x0C, 0xFE, 0x7A, 0xD7, 0xC1,  // ..U..z..
                            /* 0230 */  0x08, 0x8C, 0x1F, 0xAB, 0xB4, 0xCF, 0x26, 0xC6,  // ......&.
                            /* 0238 */  0x6C, 0x3E, 0xDB, 0x0D, 0xBF, 0xC8, 0x6E, 0x0F,  // l>....n.
                            /* 0240 */  0x3E, 0x9B, 0xBF, 0xEB, 0x5E, 0x59, 0xCC, 0x9B,  // >...^Y..
                            /* 0248 */  0xF7, 0x26, 0x1C, 0x45, 0xD8, 0x19, 0x59, 0xF2,  // .&.E..Y.
                            /* 0250 */  0x3C, 0x3F, 0x57, 0x70, 0x8B, 0xA6, 0xFB, 0xD4,  // <?Wp....
                            /* 0258 */  0xC5, 0x94, 0x75, 0x1A, 0xDD, 0x04, 0x3B, 0x79,  // ..u...;y
                            /* 0260 */  0xD6, 0x20, 0xB2, 0xE9, 0x9D, 0xDB, 0x21, 0x15,  // . ....!.
                            /* 0268 */  0x29, 0xA9, 0x53, 0xE3, 0xDA, 0x74, 0x4E, 0x86,  // ).S..tN.
                            /* 0270 */  0xCD, 0x75, 0x94, 0x66, 0x33, 0xC4, 0x8E, 0x27,  // .u.f3..'
                            /* 0278 */  0x17, 0x85, 0x16, 0xB1, 0xF1, 0xAE, 0xBD, 0xCC,  // ........
                            /* 0280 */  0x1D, 0x4E, 0x2A, 0x1F, 0xBB, 0x16, 0x81, 0xF9,  // .N*.....
                            /* 0288 */  0x30, 0x79, 0x80, 0x6A, 0xF4, 0xAE, 0xAB, 0xD2,  // 0y.j....
                            /* 0290 */  0x95, 0xAA, 0x34, 0x60, 0x06, 0x10, 0xC7, 0xB9,  // ..4`....
                            /* 0298 */  0x94, 0xDC, 0xF1, 0x24, 0x12, 0x24, 0xE5, 0xFD,  // ...$.$..
                            /* 02A0 */  0x30, 0xB8, 0x5E, 0x76, 0xA2, 0xDE, 0x0C, 0x53,  // 0.^v...S
                            /* 02A8 */  0xCF, 0xFB, 0x4B, 0x6E, 0xDB, 0xB7, 0x52, 0xFA,  // ..Kn..R.
                            /* 02B0 */  0xCB, 0x33, 0x02, 0x08, 0xF1, 0xB3, 0x0F, 0x1D,  // .3......
                            /* 02B8 */  0xC7, 0x65, 0x68, 0x01, 0x55, 0x02, 0x96, 0xC7,  // .eh.U...
                            /* 02C0 */  0xBC, 0xA3, 0x89, 0xA4, 0x9B, 0xAD, 0x32, 0x35,  // ......25
                            /* 02C8 */  0x22, 0x9F, 0xC2, 0xED, 0x49, 0xF7, 0x5C, 0xF9,  // "...I.\.
                            /* 02D0 */  0xC2, 0xA4, 0xEB, 0x2E, 0x1E, 0x2D, 0x1D, 0x73,  // .....-.s
                            /* 02D8 */  0x27, 0x95, 0xE3, 0x5A, 0xE7, 0xD4, 0x3A, 0x6A,  // '..Z..:j
                            /* 02E0 */  0x82, 0xCE, 0xFF, 0xA2, 0x0C, 0xDF, 0xF5, 0xAD,  // ........
                            /* 02E8 */  0x08, 0x36, 0x93, 0x13, 0x1D, 0x0D, 0xDF, 0x6A,  // .6.....j
                            /* 02F0 */  0xD7, 0xCE, 0x34, 0x48, 0x59, 0x5C, 0x03, 0x37,  // ..4HY\.7
                            /* 02F8 */  0xE6, 0xF2, 0x3E, 0xBB, 0xE0, 0xB3, 0xA2, 0xC9,  // ..>.....
                            /* 0300 */  0x82, 0x3B, 0x8E, 0x4C, 0x25, 0xD8, 0xE3, 0x0B,  // .;.L%...
                            /* 0308 */  0x81, 0xA4, 0xE6, 0x5F, 0xF8, 0x0E, 0xE6, 0x60,  // ..._...`
                            /* 0310 */  0xE6, 0x44, 0xEC, 0xD6, 0x47, 0x9F, 0x3D, 0xCD,  // .D..G.=.
                            /* 0318 */  0x54, 0x48, 0x9E, 0xC4, 0xC9, 0x2F, 0xC9, 0xC9,  // TH.../..
                            /* 0320 */  0x44, 0x40, 0x45, 0x8D, 0xEF, 0x90, 0x8B, 0xFA,  // D@E.....
                            /* 0328 */  0x33, 0x63, 0xF0, 0x88, 0xD7, 0xF1, 0x26, 0xE8,  // 3c....&.
                            /* 0330 */  0x5D, 0x49, 0xAD, 0x01, 0xC4, 0x68, 0xA3, 0x44,  // ]I...h.D
                            /* 0338 */  0xD6, 0x7F, 0xEF, 0x75, 0x1A, 0xD8, 0xCE, 0x87,  // ...u....
                            /* 0340 */  0xB2, 0xE5, 0xA4, 0xB9, 0xF5, 0xC6, 0x03, 0x2E,  // ........
                            /* 0348 */  0x12, 0x84, 0x1B, 0x14, 0xB3, 0x03, 0xD1, 0x4E,  // .......N
                            /* 0350 */  0x9C, 0x29, 0xF3, 0xF0, 0xCC, 0xE8, 0x32, 0xCC,  // .)....2.
                            /* 0358 */  0x8C, 0x5A, 0x90, 0x19, 0x4D, 0xAD, 0x7F, 0x21,  // .Z..M..!
                            /* 0360 */  0x98, 0x34, 0x15, 0x17, 0x65, 0xF3, 0x97, 0xEF,  // .4..e...
                            /* 0368 */  0x56, 0xC5, 0x79, 0x00, 0x1B, 0x45, 0xD8, 0xB2,  // V.y..E..
                            /* 0370 */  0x89, 0xE8, 0x55, 0x19, 0xEE, 0x59, 0x38, 0xB5,  // ..U..Y8.
                            /* 0378 */  0xE0, 0x07, 0x88, 0xBC, 0x2E, 0xFB, 0xB6, 0xC8,  // ........
                            /* 0380 */  0x47, 0x95, 0x00, 0x6D, 0x84, 0x28, 0x57, 0xDB,  // G..m.(W.
                            /* 0388 */  0xD6, 0x27, 0x4D, 0xF6, 0xD3, 0xF6, 0xD5, 0x37,  // .'M....7
                            /* 0390 */  0x87, 0xBF, 0x34, 0x47, 0x5D, 0x75, 0x6D, 0xD7,  // ..4G]um.
                            /* 0398 */  0xC4, 0xC3, 0x8F, 0xCD, 0x00, 0x30, 0xD4, 0x4D,  // .....0.M
                            /* 03A0 */  0x74, 0x69, 0x2E, 0xB1, 0x77, 0x0A, 0x0B, 0xE4,  // ti..w...
                            /* 03A8 */  0x8D, 0xB6, 0x65, 0x96, 0xDC, 0x66, 0xCC, 0x2A,  // ..e..f.*
                            /* 03B0 */  0x37, 0x67, 0x47, 0x1B, 0x45, 0x26, 0x18, 0x49,  // 7gG.E&.I
                            /* 03B8 */  0x4E, 0x2D, 0x2F, 0x03, 0xA0, 0x17, 0x33, 0xB9,  // N-/...3.
                            /* 03C0 */  0xBA, 0xE5, 0xBF, 0x2C, 0xF0, 0xA5, 0x53, 0x10,  // ...,..S.
                            /* 03C8 */  0x5B, 0x33, 0x62, 0xD9, 0x34, 0xF2, 0xC3, 0xD9,  // [3b.4...
                            /* 03D0 */  0x14, 0x95, 0x95, 0x83, 0x32, 0x1E, 0x0A, 0x33,  // ....2..3
                            /* 03D8 */  0xAF, 0xC6, 0xFA, 0x2D, 0x25, 0x96, 0x99, 0x4E,  // ...-%..N
                            /* 03E0 */  0x4B, 0x3B, 0x11, 0xD0, 0x53, 0x97, 0x20, 0x86,  // K;..S. .
                            /* 03E8 */  0x48, 0xDB, 0x62, 0xF1, 0x30, 0x02, 0xDC, 0xFD,  // H.b.0...
                            /* 03F0 */  0x34, 0x54, 0x13, 0x9A, 0xA7, 0xED, 0x1B, 0xC8,  // 4T......
                            /* 03F8 */  0xC0, 0xA7, 0xAE, 0x55, 0x26, 0xC4, 0x9B, 0x20,  // ...U&.. 
                            /* 0400 */  0x74, 0xC6, 0x65, 0x78, 0x94, 0xE0, 0x53, 0xB3,  // t.ex..S.
                            /* 0408 */  0xD7, 0x6E, 0xF2, 0xDC, 0xCD, 0x86, 0xCD, 0x97,  // .n......
                            /* 0410 */  0x7A, 0xFC, 0x61, 0x93, 0x38, 0x49, 0xBA, 0xAF,  // z.a.8I..
                            /* 0418 */  0x62, 0xF2, 0xE9, 0xC1, 0xFB, 0x9A, 0x5B, 0x62,  // b.....[b
                            /* 0420 */  0x71, 0x0D, 0xEA, 0x39, 0xB1, 0x09, 0xF5, 0xD6,  // q..9....
                            /* 0428 */  0xF4, 0xAD, 0xFE, 0xB8, 0x42, 0xE8, 0xF7, 0xD9,  // ....B...
                            /* 0430 */  0xEA, 0xE5, 0xFE, 0xA1, 0x07, 0x41, 0xE1, 0x41,  // .....A.A
                            /* 0438 */  0x68, 0x73, 0xEF, 0x77, 0xE2, 0xC1, 0x63, 0x98,  // hs.w..c.
                            /* 0440 */  0x5F, 0x34, 0x41, 0xB8, 0x7A, 0x68, 0x53, 0xC5,  // _4A.zhS.
                            /* 0448 */  0x76, 0x42, 0x33, 0x31, 0x8F, 0xA2, 0x5F, 0x7F,  // vB31.._.
                            /* 0450 */  0xD0, 0xFA, 0xA3, 0xF1, 0x7C, 0x87, 0xE7, 0x28,  // ....|..(
                            /* 0458 */  0xF3, 0xAB, 0xA5, 0xE3, 0x6F, 0xE3, 0x76, 0xED,  // ....o.v.
                            /* 0460 */  0x72, 0xB7, 0x63, 0xC6, 0x01, 0xDB, 0xAE, 0xE1,  // r.c.....
                            /* 0468 */  0x62, 0x77, 0x21, 0x3D, 0x24, 0x52, 0xA1, 0x4B,  // bw!=$R.K
                            /* 0470 */  0x4B, 0x34, 0x97, 0x42, 0x7F, 0x35, 0xD7, 0x2D,  // K4.B.5.-
                            /* 0478 */  0xC4, 0x6A, 0x6D, 0x79, 0xA0, 0x11, 0x94, 0xAD,  // .jmy....
                            /* 0480 */  0x37, 0x9D, 0xC9, 0xC5, 0x4A, 0xC5, 0xFC, 0x55,  // 7...J..U
                            /* 0488 */  0x96, 0x0B, 0x2A, 0x03, 0xBA, 0xD1, 0xC2, 0xDF,  // ..*.....
                            /* 0490 */  0xF4, 0x3A, 0x88, 0x88, 0x3F, 0x18, 0xF9, 0xB4,  // .:..?...
                            /* 0498 */  0xA0, 0xE4, 0x36, 0x07, 0xA7, 0x49, 0xAF, 0xA3,  // ..6..I..
                            /* 04A0 */  0xF7, 0x09, 0x19, 0x24, 0x79, 0xE6, 0xC3, 0x56,  // ...$y..V
                            /* 04A8 */  0x8B, 0x56, 0x46, 0x18, 0x44, 0xDC, 0xBE, 0xB7,  // .VF.D...
                            /* 04B0 */  0xBF, 0x4A, 0xBA, 0xA6, 0xBB, 0xEF, 0xC9, 0x9A,  // .J......
                            /* 04B8 */  0xA2, 0x97, 0xDE, 0xBF, 0xFB, 0x62, 0xE7, 0xF5,  // .....b..
                            /* 04C0 */  0x60, 0x2A, 0x43, 0x0B, 0x00, 0xE8, 0x90, 0xBE,  // `*C.....
                            /* 04C8 */  0x45, 0x8D, 0xA4, 0x8B, 0x10, 0xF6, 0x5E, 0x25,  // E.....^%
                            /* 04D0 */  0xBD, 0x0F, 0xFA, 0xEF, 0xC1, 0x17, 0xF6, 0x4E,  // .......N
                            /* 04D8 */  0x7A, 0x0C, 0xC3, 0x79, 0x73, 0x09, 0x76, 0x55,  // z..ys.vU
                            /* 04E0 */  0x63, 0x0B, 0x83, 0x4B, 0x3B, 0x70, 0xDB, 0xC1,  // c..K;p..
                            /* 04E8 */  0xCC, 0xEF, 0xBA, 0x3E, 0x7F, 0xC8, 0xD1, 0xD5,  // ...>....
                            /* 04F0 */  0x9E, 0x05, 0xA3, 0x3E, 0x4A, 0x06, 0x37, 0x55,  // ...>J.7U
                            /* 04F8 */  0xBF, 0xE2, 0xC4, 0xE6, 0xF5, 0x17, 0x57, 0x75,  // ......Wu
                            /* 0500 */  0xE7, 0x76, 0x2D, 0xA5, 0x01, 0x97, 0x28, 0x1A,  // .v-...(.
                            /* 0508 */  0xF4, 0xA6, 0x10, 0xE9, 0x54, 0xDE, 0xD6, 0xC1,  // ....T...
                            /* 0510 */  0x89, 0xF8, 0xC5, 0x74, 0x09, 0x39, 0x42, 0x72,  // ...t.9Br
                            /* 0518 */  0x64, 0xEF, 0x9C, 0x16, 0x20, 0x9B, 0xD4, 0x09,  // d... ...
                            /* 0520 */  0x73, 0x46, 0xE0, 0x77, 0x1C, 0x21, 0x02, 0xD7,  // sF.w.!..
                            /* 0528 */  0x72, 0x1C, 0xD6, 0x9B, 0xCC, 0xA0, 0x9D, 0x44,  // r......D
                            /* 0530 */  0xC9, 0x63, 0x6A, 0x46, 0xE7, 0xB4, 0x6B, 0x8E,  // .cjF..k.
                            /* 0538 */  0xF5, 0xE4, 0xE4, 0x92, 0xE7, 0x07, 0xCF, 0x06,  // ........
                            /* 0540 */  0xCF, 0xF8, 0xF2, 0xA0, 0x48, 0xCC, 0x31, 0x01,  // ....H.1.
                            /* 0548 */  0x61, 0xDF, 0xEA, 0xD3, 0x70, 0x74, 0x9B, 0x78,  // a...pt.x
                            /* 0550 */  0x36, 0xAF, 0x87, 0x13, 0xDE, 0x21, 0x9E, 0xB3,  // 6....!..
                            /* 0558 */  0xED, 0x24, 0xF1, 0x67, 0x43, 0x8C, 0x75, 0xB8,  // .$.gC.u.
                            /* 0560 */  0xB0, 0xD5, 0xF3, 0x62, 0x15, 0x13, 0xD7, 0xE2,  // ...b....
                            /* 0568 */  0xFF, 0xC9, 0x0C, 0xE0, 0x94, 0x92, 0xAF, 0x60,  // .......`
                            /* 0570 */  0xDE, 0x41, 0x4D, 0x43, 0xD6, 0xC6, 0x84, 0xF5,  // .AMC....
                            /* 0578 */  0x6B, 0xEE, 0x72, 0x0A, 0x38, 0x86, 0x6C, 0x7C,  // k.r.8.l|
                            /* 0580 */  0x7A, 0x05, 0x84, 0x9A, 0x4F, 0x1E, 0xEF, 0x44,  // z...O..D
                            /* 0588 */  0x3D, 0x8A, 0x3C, 0xB4, 0x69, 0x48, 0x24, 0x43,  // =.<.iH$C
                            /* 0590 */  0xDA, 0x1F, 0xEE, 0xC7, 0xEF, 0x10, 0x12, 0x40,  // .......@
                            /* 0598 */  0xC5, 0xDC, 0x75, 0x1E, 0xC5, 0xF7, 0xFA, 0xB8,  // ..u.....
                            /* 05A0 */  0xDF, 0x40, 0xC6, 0xA9, 0xD9, 0xAC, 0xD4, 0xDC,  // .@......
                            /* 05A8 */  0x5F, 0x47, 0x87, 0xBD, 0x7E, 0xB9, 0x51, 0xCA,  // _G..~.Q.
                            /* 05B0 */  0x48, 0x79, 0xA2, 0xC7, 0x5F, 0x38, 0xB3, 0xDD,  // Hy.._8..
                            /* 05B8 */  0x29, 0xE4, 0x8A, 0x5F, 0x18, 0xB5, 0x38, 0x71,  // ).._..8q
                            /* 05C0 */  0xA2, 0x98, 0xE8, 0xE9, 0xF7, 0x16, 0x7A, 0xFC,  // ......z.
                            /* 05C8 */  0x4C, 0x87, 0xB2, 0x1D, 0x5F, 0x0F, 0x40, 0xD9,  // L..._.@.
                            /* 05D0 */  0x59, 0xA5, 0xA1, 0xDF, 0xBC, 0xC5, 0xC1, 0xE2,  // Y.......
                            /* 05D8 */  0xDA, 0xAE, 0xD6, 0xCF, 0x72, 0x22, 0x45, 0xAF,  // ....r"E.
                            /* 05E0 */  0x9F, 0x2C, 0xD9, 0x2A, 0x43, 0x70, 0x29, 0xC3,  // .,.*Cp).
                            /* 05E8 */  0xEA, 0x83, 0x10, 0x05, 0x9D, 0x76, 0x34, 0xD0,  // .....v4.
                            /* 05F0 */  0x74, 0xFF, 0xD2, 0x6D, 0x1F, 0x8E, 0xD0, 0x0F,  // t..m....
                            /* 05F8 */  0x78, 0x86, 0x0D, 0xBF, 0x98, 0xD0, 0x9E, 0x08,  // x.......
                            /* 0600 */  0x9C, 0x12, 0xB0, 0xEC, 0x15, 0xBF, 0xB1, 0xF8,  // ........
                            /* 0608 */  0xCF, 0xEB, 0x16, 0x4B, 0x57, 0x1A, 0x8E, 0xAB,  // ...KW...
                            /* 0610 */  0xE3, 0x9B, 0x87, 0x18, 0x4C, 0x2E, 0xAA, 0x4E,  // ....L..N
                            /* 0618 */  0x94, 0xB6, 0xB2, 0x69, 0x13, 0xCE, 0x5C, 0x78,  // ...i..\x
                            /* 0620 */  0xD4, 0x13, 0xFA, 0xA8, 0x83, 0x05, 0xAB, 0xA4,  // ........
                            /* 0628 */  0xC3, 0xCB, 0xE5, 0x8F, 0xC2, 0xBB, 0xC0, 0x08,  // ........
                            /* 0630 */  0xC9, 0xFA, 0x70, 0x48, 0x97, 0x3F, 0x06, 0xEF,  // ..pH.?..
                            /* 0638 */  0xBC, 0x1C, 0x03, 0xFE, 0x9A, 0xAB, 0xFD, 0x42,  // .......B
                            /* 0640 */  0xF5, 0x40, 0xA4, 0x98, 0x0B, 0x67, 0xD7, 0x57,  // .@...g.W
                            /* 0648 */  0x52, 0x02, 0xE8, 0xB5, 0xF9, 0x89, 0xB1, 0xEA,  // R.......
                            /* 0650 */  0xEC, 0x96, 0x32, 0x98, 0x81, 0x2D, 0x42, 0x5B,  // ..2..-B[
                            /* 0658 */  0x8B, 0x9F, 0x40, 0x36, 0x03, 0xA3, 0x0A, 0xB4,  // ..@6....
                            /* 0660 */  0x17, 0x0E, 0xAF, 0x82, 0x53, 0x73, 0xCD, 0xE3,  // ....Ss..
                            /* 0668 */  0x6F, 0x63, 0x4C, 0x26, 0xA3, 0xF5, 0x4F, 0x00,  // ocL&..O.
                            /* 0670 */  0x7D, 0x9A, 0x92, 0x18, 0x86, 0x80, 0x3E, 0x25,  // }.....>%
                            /* 0678 */  0x8F, 0x2B, 0xD9, 0xF2, 0x05, 0xF8, 0x83, 0x7E,  // .+.....~
                            /* 0680 */  0x32, 0xD7, 0x13, 0x39, 0x03, 0xB4, 0x2A, 0x1F,  // 2..9..*.
                            /* 0688 */  0xE1, 0x6C, 0x02, 0xBC, 0xA6, 0xBC, 0x1F, 0x9A,  // .l......
                            /* 0690 */  0x35, 0x35, 0x9B, 0x9A, 0x01, 0x2D, 0xB1, 0x5C,  // 55...-.\
                            /* 0698 */  0x78, 0xFC, 0xF1, 0xBB, 0xB5, 0xCF, 0xA8, 0x6D,  // x......m
                            /* 06A0 */  0x57, 0xDD, 0xE8, 0x6C, 0x35, 0xDD, 0x7D, 0x32,  // W..l5.}2
                            /* 06A8 */  0xB2, 0x32, 0xFA, 0xD8, 0x92, 0xE9, 0xCF, 0x63,  // .2.....c
                            /* 06B0 */  0x0B, 0x6E, 0x00, 0x69, 0xFA, 0x0D, 0x81, 0x8F,  // .n.i....
                            /* 06B8 */  0x8A, 0xF1, 0x20, 0xFE, 0xBF, 0xD8, 0xFD, 0x29,  // .. ....)
                            /* 06C0 */  0x73, 0x44, 0xC7, 0x82, 0xB1, 0xB8, 0xE2, 0x38,  // sD.....8
                            /* 06C8 */  0xFE, 0xFE, 0x12, 0x5B, 0x57, 0xF0, 0x84, 0xAA,  // ...[W...
                            /* 06D0 */  0x95, 0xBE, 0x1D, 0x39, 0x3C, 0xEA, 0x44, 0x40,  // ...9<.D@
                            /* 06D8 */  0x18, 0xAA, 0xAE, 0x98, 0x11, 0x93, 0xCD, 0xC4,  // ........
                            /* 06E0 */  0xEE, 0xC1, 0xB1, 0xF4, 0x48, 0x2F, 0xCC, 0xE0,  // ....H/..
                            /* 06E8 */  0xDD, 0x4A, 0xE8, 0x9D, 0xAF, 0x53, 0x2E, 0xEF,  // .J...S..
                            /* 06F0 */  0xA7, 0x7F, 0x32, 0x35, 0x89, 0xD1, 0x69, 0x8B,  // ..25..i.
                            /* 06F8 */  0xC5, 0xAE, 0x8E, 0xA2, 0xF3, 0x0E, 0x60, 0x3A,  // ......`:
                            /* 0700 */  0x82, 0xA2, 0x6A, 0x16, 0xAF, 0xDE, 0x16, 0x74,  // ..j....t
                            /* 0708 */  0x13, 0x29, 0x29, 0xF7, 0x58, 0x95, 0xBE, 0x68,  // .)).X..h
                            /* 0710 */  0x2D, 0x81, 0xF7, 0x34, 0x35, 0xA3, 0x7B, 0x6A,  // -..45.{j
                            /* 0718 */  0x08, 0xA0, 0x3F, 0x11, 0xE6, 0xE9, 0x97, 0x5B,  // ..?....[
                            /* 0720 */  0xE4, 0x77, 0xBB, 0xD1, 0x13, 0x22, 0x9A, 0xFD,  // .w..."..
                            /* 0728 */  0xCB, 0x83, 0xF0, 0xB6, 0x8B, 0x41, 0x33, 0x46,  // .....A3F
                            /* 0730 */  0xE0, 0xC3, 0xEA, 0xDD, 0x6E, 0x81, 0xFA, 0x79,  // ....n..y
                            /* 0738 */  0x01, 0xC9, 0x4E, 0x3D, 0x14, 0xAD, 0xD3, 0xF3,  // ..N=....
                            /* 0740 */  0x58, 0x22, 0x1A, 0x08, 0x15, 0xE6, 0x8F, 0x26,  // X".....&
                            /* 0748 */  0x31, 0xE1, 0x0F, 0x22, 0x78, 0x69, 0xF0, 0xF0,  // 1.."xi..
                            /* 0750 */  0x01, 0x0B, 0x75, 0x02, 0x98, 0x84, 0x11, 0xBA,  // ..u.....
                            /* 0758 */  0xCF, 0x0F, 0xF3, 0x45, 0xED, 0xF3, 0x75, 0x0E,  // ...E..u.
                            /* 0760 */  0xCD, 0x09, 0x45, 0x75, 0x44, 0x4A, 0xD1, 0x44,  // ..EuDJ.D
                            /* 0768 */  0xD5, 0x71, 0xC3, 0x9C, 0x0B, 0x8F, 0xC6, 0xCD,  // .q......
                            /* 0770 */  0x26, 0x2F, 0xEA, 0x18, 0x4F, 0xF0, 0x54, 0x78,  // &/..O.Tx
                            /* 0778 */  0x3F, 0x3A, 0x7B, 0x94, 0xA4, 0x77, 0xBE, 0xB5,  // ?:{..w..
                            /* 0780 */  0xF0, 0x24, 0x69, 0x25, 0x3B, 0xB0, 0x77, 0x23,  // .$i%;.w#
                            /* 0788 */  0xDD, 0x1F, 0xCF, 0x63, 0x4B, 0x76, 0x39, 0x33,  // ...cKv93
                            /* 0790 */  0x1F, 0xB4, 0x57, 0x13, 0xC9, 0x2A, 0x86, 0xCC,  // ..W..*..
                            /* 0798 */  0xE8, 0x6D, 0xCD, 0x76, 0xB9, 0x4F, 0x7B, 0x76,  // .m.v.O{v
                            /* 07A0 */  0x09, 0x16, 0xFF, 0x55, 0x03, 0xA4, 0xD7, 0xB3,  // ...U....
                            /* 07A8 */  0x43, 0xFC, 0xD4, 0x26, 0xB3, 0xD5, 0xBB, 0x34,  // C..&...4
                            /* 07B0 */  0x38, 0x6D                                       // 8m
                        }
                    })
                }
            }
            ElseIf (((PDFG & 0x30) == Zero))
            {
                Return (Package (0x01)
                {
                    Buffer (0x06F2)
                    {
                        /* 0000 */  0xE5, 0x1F, 0x94, 0x00, 0x00, 0x00, 0x00, 0x02,  // ........
                        /* 0008 */  0x00, 0x00, 0x00, 0x40, 0x67, 0x64, 0x64, 0x76,  // ...@gddv
                        /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x4F, 0x45, 0x4D, 0x20,  // ....OEM 
                        /* 0030 */  0x45, 0x78, 0x70, 0x6F, 0x72, 0x74, 0x65, 0x64,  // Exported
                        /* 0038 */  0x20, 0x44, 0x61, 0x74, 0x61, 0x56, 0x61, 0x75,  //  DataVau
                        /* 0040 */  0x6C, 0x74, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // lt......
                        /* 0048 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0050 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0058 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0068 */  0x00, 0x00, 0x00, 0x00, 0xD9, 0xEF, 0x5A, 0x9A,  // ......Z.
                        /* 0070 */  0x95, 0x61, 0x7A, 0xA1, 0x7C, 0x65, 0x8E, 0x33,  // .az.|e.3
                        /* 0078 */  0xF4, 0x73, 0x94, 0xE4, 0x59, 0xEF, 0x1E, 0x33,  // .s..Y..3
                        /* 0080 */  0xF8, 0xEA, 0x36, 0x8C, 0x11, 0x7A, 0xF3, 0xA1,  // ..6..z..
                        /* 0088 */  0xEF, 0x18, 0x64, 0x92, 0x5E, 0x06, 0x00, 0x00,  // ..d.^...
                        /* 0090 */  0x52, 0x45, 0x50, 0x4F, 0x5D, 0x00, 0x00, 0x00,  // REPO]...
                        /* 0098 */  0x01, 0x6F, 0x74, 0x00, 0x00, 0x00, 0x00, 0x00,  // .ot.....
                        /* 00A0 */  0x00, 0x00, 0x72, 0x87, 0xCD, 0xFF, 0x6D, 0x24,  // ..r...m$
                        /* 00A8 */  0x47, 0xDB, 0x3D, 0x24, 0x92, 0xB4, 0x16, 0x6F,  // G.=$...o
                        /* 00B0 */  0x45, 0xD8, 0xC3, 0xF5, 0x66, 0x14, 0x9F, 0x22,  // E...f.."
                        /* 00B8 */  0xD7, 0xF7, 0xDE, 0x67, 0x90, 0x9A, 0xA2, 0x0D,  // ...g....
                        /* 00C0 */  0x39, 0x25, 0xAD, 0xC3, 0x1A, 0xAD, 0x52, 0x0B,  // 9%....R.
                        /* 00C8 */  0x75, 0x38, 0xE1, 0xA4, 0x14, 0x42, 0x1C, 0xF7,  // u8...B..
                        /* 00D0 */  0xBD, 0xD1, 0x4D, 0x0D, 0x5A, 0xA6, 0xA7, 0x4F,  // ..M.Z..O
                        /* 00D8 */  0x59, 0x64, 0x81, 0x58, 0x15, 0x51, 0x2B, 0xB8,  // Yd.X.Q+.
                        /* 00E0 */  0x46, 0x9A, 0x0D, 0xBA, 0xD6, 0xE4, 0x14, 0x4D,  // F......M
                        /* 00E8 */  0x76, 0x8F, 0xD2, 0xDB, 0xEE, 0x33, 0x7F, 0x27,  // v....3.'
                        /* 00F0 */  0xB9, 0x34, 0x49, 0xDE, 0x81, 0xA0, 0x17, 0x2A,  // .4I....*
                        /* 00F8 */  0xC8, 0xF1, 0x05, 0xA2, 0x1F, 0x83, 0x62, 0x48,  // ......bH
                        /* 0100 */  0x97, 0x09, 0x0C, 0x10, 0x64, 0xFD, 0x02, 0x45,  // ....d..E
                        /* 0108 */  0x0C, 0x73, 0xD0, 0x41, 0x30, 0x23, 0x1D, 0xD2,  // .s.A0#..
                        /* 0110 */  0xDC, 0x67, 0x90, 0xE7, 0xCC, 0xC9, 0x1A, 0x5D,  // .g.....]
                        /* 0118 */  0x78, 0x4E, 0x74, 0xC7, 0x28, 0x07, 0x28, 0x38,  // xNt.(.(8
                        /* 0120 */  0x7A, 0xDC, 0xC7, 0xB0, 0x86, 0x9B, 0x68, 0x58,  // z.....hX
                        /* 0128 */  0xC2, 0x03, 0x65, 0x5C, 0x59, 0xB5, 0xBB, 0x3A,  // ..e\Y..:
                        /* 0130 */  0xA0, 0x64, 0x32, 0xCA, 0x94, 0xCA, 0x1A, 0x8A,  // .d2.....
                        /* 0138 */  0x5B, 0xDC, 0x88, 0x17, 0x83, 0x94, 0x8E, 0x59,  // [......Y
                        /* 0140 */  0xB0, 0x2F, 0x70, 0x94, 0xCB, 0x3D, 0x17, 0x04,  // ./p..=..
                        /* 0148 */  0xF8, 0x8D, 0xAD, 0xEA, 0xB1, 0x96, 0x8A, 0x4B,  // .......K
                        /* 0150 */  0x9E, 0x68, 0x61, 0x0E, 0xE5, 0x99, 0x01, 0x5E,  // .ha....^
                        /* 0158 */  0xED, 0x41, 0xA9, 0xBC, 0x05, 0x52, 0x83, 0x63,  // .A...R.c
                        /* 0160 */  0xBF, 0xFE, 0x26, 0xB5, 0x69, 0x46, 0xB3, 0x62,  // ..&.iF.b
                        /* 0168 */  0xDA, 0xE5, 0x12, 0xAE, 0x11, 0xC4, 0x32, 0x5E,  // ......2^
                        /* 0170 */  0x19, 0x08, 0xAC, 0x0B, 0x8A, 0x09, 0x48, 0x8D,  // ......H.
                        /* 0178 */  0x92, 0x9E, 0x51, 0xA5, 0xB9, 0xAB, 0x28, 0x52,  // ..Q...(R
                        /* 0180 */  0xDF, 0xE9, 0x50, 0x63, 0x08, 0x5C, 0xF4, 0x45,  // ..Pc.\.E
                        /* 0188 */  0xFE, 0x89, 0xCD, 0xBD, 0xA0, 0xB7, 0x38, 0x7D,  // ......8}
                        /* 0190 */  0x7A, 0xE5, 0x32, 0x79, 0xE4, 0x02, 0x91, 0x39,  // z.2y...9
                        /* 0198 */  0xCE, 0xA6, 0xDD, 0x4E, 0xB8, 0x6B, 0x3D, 0x21,  // ...N.k=!
                        /* 01A0 */  0xB9, 0xB6, 0xED, 0x92, 0xBA, 0xD2, 0xC9, 0x48,  // .......H
                        /* 01A8 */  0x02, 0x38, 0x91, 0xCA, 0x21, 0x24, 0x33, 0xCD,  // .8..!$3.
                        /* 01B0 */  0x7A, 0x2B, 0x46, 0x15, 0xF6, 0x3E, 0x20, 0xDE,  // z+F..> .
                        /* 01B8 */  0x03, 0x00, 0x2C, 0x74, 0x1A, 0x5E, 0xB3, 0x8E,  // ..,t.^..
                        /* 01C0 */  0xB7, 0x33, 0x89, 0x8D, 0x99, 0x89, 0x80, 0xCB,  // .3......
                        /* 01C8 */  0x25, 0x10, 0x75, 0xD5, 0x1C, 0xE0, 0x88, 0x1E,  // %.u.....
                        /* 01D0 */  0x7B, 0x37, 0x5A, 0x44, 0x1C, 0x2E, 0x8A, 0x57,  // {7ZD...W
                        /* 01D8 */  0x08, 0xF0, 0x91, 0xBE, 0xF0, 0x80, 0x0B, 0x24,  // .......$
                        /* 01E0 */  0x2E, 0xDF, 0x1D, 0x83, 0x3D, 0x8B, 0x6C, 0x7C,  // ....=.l|
                        /* 01E8 */  0x9E, 0x5E, 0x18, 0xE4, 0x6E, 0xB4, 0x87, 0xC7,  // .^..n...
                        /* 01F0 */  0x4D, 0xA6, 0xE6, 0xCA, 0xA5, 0x18, 0xD8, 0x7B,  // M......{
                        /* 01F8 */  0x67, 0x4B, 0xF7, 0xF1, 0xB1, 0xA5, 0x65, 0x4F,  // gK....eO
                        /* 0200 */  0xF0, 0xED, 0x81, 0x31, 0x45, 0x80, 0x34, 0x1B,  // ...1E.4.
                        /* 0208 */  0xDE, 0x22, 0xD6, 0xF7, 0x13, 0x23, 0x7B, 0xE2,  // ."...#{.
                        /* 0210 */  0x51, 0x2B, 0x87, 0x00, 0x62, 0xE6, 0xD5, 0x00,  // Q+..b...
                        /* 0218 */  0x92, 0x69, 0x27, 0xD4, 0x0D, 0x2C, 0x6F, 0x94,  // .i'..,o.
                        /* 0220 */  0x4F, 0xC1, 0x5C, 0x5E, 0xDE, 0x87, 0x68, 0xBD,  // O.\^..h.
                        /* 0228 */  0x10, 0xE8, 0x41, 0x4B, 0x16, 0x46, 0x54, 0x1C,  // ..AK.FT.
                        /* 0230 */  0xF6, 0xE0, 0xD9, 0x3B, 0x77, 0xEF, 0xA9, 0x21,  // ...;w..!
                        /* 0238 */  0xBB, 0xB5, 0x93, 0x45, 0xBA, 0x67, 0x3C, 0x76,  // ...E.g<v
                        /* 0240 */  0xC8, 0x7A, 0xC0, 0x6D, 0xCF, 0x97, 0x50, 0x1C,  // .z.m..P.
                        /* 0248 */  0x6A, 0x8B, 0x78, 0xBC, 0x99, 0x05, 0x02, 0xFB,  // j.x.....
                        /* 0250 */  0xF4, 0x15, 0x15, 0xCC, 0x81, 0x4A, 0xAD, 0x61,  // .....J.a
                        /* 0258 */  0x11, 0x48, 0x4F, 0x10, 0x0E, 0xC1, 0xD4, 0x02,  // .HO.....
                        /* 0260 */  0xD2, 0xDD, 0xA2, 0x91, 0xEB, 0xEB, 0x4E, 0x6E,  // ......Nn
                        /* 0268 */  0x84, 0x32, 0x5B, 0xD2, 0x17, 0xBF, 0x18, 0x3F,  // .2[....?
                        /* 0270 */  0x4C, 0x28, 0x5D, 0x02, 0x39, 0x06, 0x59, 0x49,  // L(].9.YI
                        /* 0278 */  0x86, 0xE7, 0xE7, 0xBE, 0x80, 0x55, 0x71, 0x2C,  // .....Uq,
                        /* 0280 */  0x0B, 0x7C, 0xCE, 0x23, 0x75, 0x52, 0xD0, 0x84,  // .|.#uR..
                        /* 0288 */  0xCD, 0xF8, 0x78, 0xFA, 0xA5, 0x3D, 0x3C, 0x59,  // ..x..=<Y
                        /* 0290 */  0x7D, 0x06, 0x75, 0x17, 0x1B, 0xC1, 0xA2, 0x1B,  // }.u.....
                        /* 0298 */  0x3E, 0x0D, 0xC8, 0x1F, 0x02, 0xE9, 0x4C, 0x0D,  // >.....L.
                        /* 02A0 */  0x67, 0x7D, 0x6C, 0xD0, 0xF4, 0xB2, 0xF7, 0xBB,  // g}l.....
                        /* 02A8 */  0x03, 0x6D, 0x25, 0x8C, 0x4A, 0xBB, 0xAB, 0x5B,  // .m%.J..[
                        /* 02B0 */  0x7E, 0x7B, 0xD4, 0xD9, 0x0F, 0x3D, 0x50, 0x78,  // ~{...=Px
                        /* 02B8 */  0x90, 0x54, 0x5E, 0x4E, 0x1D, 0xCD, 0xC9, 0xEA,  // .T^N....
                        /* 02C0 */  0x8F, 0xCD, 0xCB, 0x1E, 0x48, 0xAB, 0x10, 0xD9,  // ....H...
                        /* 02C8 */  0xE8, 0x87, 0xE0, 0x1B, 0x51, 0x33, 0xDC, 0xBE,  // ....Q3..
                        /* 02D0 */  0xFF, 0xFC, 0xF1, 0xB4, 0x03, 0x6B, 0x27, 0x97,  // .....k'.
                        /* 02D8 */  0xB6, 0x56, 0x3E, 0x34, 0x54, 0x18, 0x58, 0x76,  // .V>4T.Xv
                        /* 02E0 */  0xC0, 0x93, 0x27, 0xD0, 0x58, 0x2B, 0x14, 0xA1,  // ..'.X+..
                        /* 02E8 */  0xC1, 0x94, 0x56, 0x91, 0x34, 0x14, 0x66, 0xB7,  // ..V.4.f.
                        /* 02F0 */  0x0C, 0xBA, 0x46, 0x91, 0x91, 0x9B, 0x04, 0x19,  // ..F.....
                        /* 02F8 */  0x0F, 0xFC, 0x94, 0xD1, 0xF8, 0x86, 0x97, 0x45,  // .......E
                        /* 0300 */  0x0E, 0xB9, 0xF3, 0x1A, 0xCA, 0xA7, 0x0E, 0x6D,  // .......m
                        /* 0308 */  0xEA, 0x52, 0x81, 0x76, 0xCF, 0xE0, 0xCA, 0xDC,  // .R.v....
                        /* 0310 */  0xAE, 0x17, 0x53, 0x7F, 0x4E, 0xAE, 0x7E, 0x98,  // ..S.N.~.
                        /* 0318 */  0xE6, 0x5A, 0x95, 0xFE, 0xE5, 0x93, 0x55, 0x14,  // .Z....U.
                        /* 0320 */  0x4B, 0xA0, 0x66, 0x4E, 0xBB, 0xC4, 0x7E, 0xEC,  // K.fN..~.
                        /* 0328 */  0xDA, 0xE1, 0x9D, 0xB1, 0xF8, 0x93, 0x09, 0x46,  // .......F
                        /* 0330 */  0xF4, 0xFD, 0xA8, 0x14, 0x86, 0xD8, 0x8E, 0x38,  // .......8
                        /* 0338 */  0xDE, 0x1F, 0x69, 0x51, 0x7D, 0xCC, 0x80, 0x04,  // ..iQ}...
                        /* 0340 */  0x21, 0x3F, 0x69, 0x60, 0x57, 0xDB, 0xCC, 0x46,  // !?i`W..F
                        /* 0348 */  0x9A, 0xCD, 0xCE, 0x1D, 0xA7, 0x9C, 0xDE, 0xAA,  // ........
                        /* 0350 */  0xAB, 0xD8, 0x8E, 0x5C, 0x08, 0x2E, 0xD3, 0x72,  // ...\...r
                        /* 0358 */  0xCB, 0x9C, 0xCB, 0x6C, 0x0A, 0x89, 0x33, 0x3B,  // ...l..3;
                        /* 0360 */  0x04, 0xBC, 0xD7, 0x92, 0x06, 0x82, 0xF1, 0x4E,  // .......N
                        /* 0368 */  0xA2, 0xCC, 0x98, 0xD8, 0x62, 0x19, 0x50, 0xE5,  // ....b.P.
                        /* 0370 */  0x29, 0xE4, 0x1F, 0xAE, 0x0F, 0x78, 0x0C, 0xF5,  // )....x..
                        /* 0378 */  0xE8, 0xB0, 0xAF, 0x05, 0xE1, 0x46, 0xE1, 0xE6,  // .....F..
                        /* 0380 */  0x80, 0xFF, 0x96, 0x84, 0xB0, 0xA2, 0x40, 0xCC,  // ......@.
                        /* 0388 */  0x5B, 0x3C, 0x15, 0x85, 0xDF, 0x43, 0xBA, 0xE0,  // [<...C..
                        /* 0390 */  0xD1, 0xDE, 0x3A, 0x12, 0x18, 0x7B, 0xBA, 0xB1,  // ..:..{..
                        /* 0398 */  0xC4, 0x53, 0x7D, 0xBE, 0x02, 0xFF, 0x6D, 0x3D,  // .S}...m=
                        /* 03A0 */  0xD4, 0xE4, 0xEF, 0x65, 0x17, 0x4C, 0x1D, 0x0C,  // ...e.L..
                        /* 03A8 */  0x8D, 0x89, 0x61, 0x43, 0xB5, 0x4F, 0xCF, 0x79,  // ..aC.O.y
                        /* 03B0 */  0xD0, 0x32, 0x6E, 0xC2, 0xC4, 0x17, 0xAA, 0x7E,  // .2n....~
                        /* 03B8 */  0xAA, 0x87, 0x20, 0x39, 0x5D, 0xAB, 0x7C, 0x0C,  // .. 9].|.
                        /* 03C0 */  0x81, 0x3F, 0x41, 0x1B, 0x96, 0xEC, 0x8D, 0x04,  // .?A.....
                        /* 03C8 */  0x5D, 0x69, 0x83, 0xE8, 0xE3, 0x92, 0x03, 0x56,  // ]i.....V
                        /* 03D0 */  0xC7, 0x8C, 0xD4, 0x5F, 0xD7, 0xA2, 0xE5, 0xC6,  // ..._....
                        /* 03D8 */  0xEA, 0xE4, 0x50, 0x94, 0xBB, 0x27, 0xF8, 0x1D,  // ..P..'..
                        /* 03E0 */  0x6F, 0x71, 0x13, 0xFD, 0x42, 0x79, 0x13, 0xAF,  // oq..By..
                        /* 03E8 */  0x64, 0xAF, 0x9B, 0x76, 0x2E, 0x49, 0xE4, 0x88,  // d..v.I..
                        /* 03F0 */  0x65, 0xCB, 0x42, 0x31, 0x00, 0xB2, 0x77, 0xE5,  // e.B1..w.
                        /* 03F8 */  0x4B, 0xE1, 0xDD, 0xF2, 0x1A, 0x40, 0xC8, 0x96,  // K....@..
                        /* 0400 */  0x2A, 0xFD, 0x03, 0x22, 0xDE, 0x29, 0xF8, 0xE1,  // *..".)..
                        /* 0408 */  0x95, 0x6F, 0xFD, 0xAE, 0x05, 0x89, 0x88, 0x8D,  // .o......
                        /* 0410 */  0x90, 0x26, 0xF7, 0xA1, 0x9B, 0x15, 0x34, 0x6F,  // .&....4o
                        /* 0418 */  0x4B, 0x9D, 0xCC, 0x31, 0x1C, 0x42, 0x6E, 0x2C,  // K..1.Bn,
                        /* 0420 */  0x47, 0x1C, 0xE3, 0x0C, 0xFF, 0x37, 0xCA, 0xFD,  // G....7..
                        /* 0428 */  0x04, 0x8B, 0x45, 0x6A, 0x55, 0x9A, 0x4E, 0x86,  // ..EjU.N.
                        /* 0430 */  0x67, 0xA0, 0x6C, 0x7B, 0xF3, 0x7D, 0x89, 0x22,  // g.l{.}."
                        /* 0438 */  0x70, 0x36, 0x5B, 0x52, 0x2D, 0xA2, 0x93, 0x24,  // p6[R-..$
                        /* 0440 */  0xE3, 0x68, 0x7F, 0xA5, 0x58, 0x65, 0xF8, 0xC7,  // .h..Xe..
                        /* 0448 */  0x14, 0x8D, 0xAD, 0x61, 0x4E, 0xD6, 0xC6, 0xAF,  // ...aN...
                        /* 0450 */  0x1D, 0xF8, 0x76, 0xC7, 0x38, 0xCB, 0x30, 0xCE,  // ..v.8.0.
                        /* 0458 */  0x49, 0x62, 0x95, 0x9F, 0x72, 0xFF, 0xB1, 0x2F,  // Ib..r../
                        /* 0460 */  0xEE, 0x6E, 0xB7, 0x55, 0xAE, 0x62, 0x08, 0x1D,  // .n.U.b..
                        /* 0468 */  0xD1, 0x34, 0x9F, 0x92, 0xA4, 0xDC, 0xE8, 0xDC,  // .4......
                        /* 0470 */  0x05, 0x85, 0x13, 0x6E, 0xD1, 0xEB, 0x68, 0xD9,  // ...n..h.
                        /* 0478 */  0x2C, 0xFA, 0x52, 0xC4, 0xF4, 0xAF, 0xB7, 0x63,  // ,.R....c
                        /* 0480 */  0x9E, 0x62, 0x41, 0x58, 0x0E, 0xF5, 0xAD, 0x94,  // .bAX....
                        /* 0488 */  0x3B, 0x69, 0x61, 0xF2, 0x3C, 0x9F, 0x37, 0x05,  // ;ia.<.7.
                        /* 0490 */  0xFA, 0xC7, 0x1B, 0x24, 0x19, 0x67, 0xB0, 0x6D,  // ...$.g.m
                        /* 0498 */  0x6E, 0x54, 0x76, 0x65, 0x66, 0x48, 0x4B, 0xB6,  // nTvefHK.
                        /* 04A0 */  0xD9, 0x49, 0x10, 0xC7, 0x22, 0x7C, 0xB9, 0x8C,  // .I.."|..
                        /* 04A8 */  0xB9, 0x22, 0xA3, 0x8D, 0xF1, 0xF6, 0xAD, 0x5C,  // .".....\
                        /* 04B0 */  0xE0, 0xE6, 0xBA, 0x1E, 0x7C, 0x7B, 0x1D, 0x7B,  // ....|{.{
                        /* 04B8 */  0x5D, 0xBA, 0xFC, 0xFF, 0xDC, 0xDE, 0xCB, 0x03,  // ].......
                        /* 04C0 */  0x0D, 0x74, 0xDE, 0x75, 0x62, 0xC5, 0x9C, 0x97,  // .t.ub...
                        /* 04C8 */  0xCF, 0x9F, 0xBA, 0xAE, 0xE5, 0xDF, 0x95, 0xF6,  // ........
                        /* 04D0 */  0x03, 0x19, 0x7B, 0x25, 0xF0, 0x30, 0x04, 0x4B,  // ..{%.0.K
                        /* 04D8 */  0x39, 0xF2, 0xA0, 0xEF, 0x47, 0x56, 0x58, 0x7E,  // 9...GVX~
                        /* 04E0 */  0x9A, 0x65, 0xE9, 0x65, 0xB9, 0x92, 0xEE, 0x62,  // .e.e...b
                        /* 04E8 */  0xD7, 0x1F, 0x05, 0xC0, 0x8C, 0xD2, 0xD7, 0xE3,  // ........
                        /* 04F0 */  0x07, 0xED, 0xA3, 0xD6, 0x77, 0xC9, 0xCF, 0xD1,  // ....w...
                        /* 04F8 */  0xE4, 0xFB, 0x14, 0xDD, 0x68, 0xB5, 0x4C, 0xC8,  // ....h.L.
                        /* 0500 */  0xDD, 0x0F, 0x98, 0xC0, 0xF9, 0xEA, 0xC9, 0x5B,  // .......[
                        /* 0508 */  0x6D, 0xFB, 0x13, 0x55, 0x4B, 0x60, 0x4A, 0x6C,  // m..UK`Jl
                        /* 0510 */  0x0B, 0xD9, 0xD8, 0x78, 0x35, 0xE2, 0x44, 0x7A,  // ...x5.Dz
                        /* 0518 */  0x73, 0x52, 0xCC, 0x64, 0xF5, 0x5E, 0xFA, 0xAC,  // sR.d.^..
                        /* 0520 */  0xC0, 0xD7, 0x47, 0x66, 0x5D, 0xD3, 0xFC, 0x9F,  // ..Gf]...
                        /* 0528 */  0x35, 0x96, 0xA0, 0xC9, 0x57, 0x34, 0x6C, 0x61,  // 5...W4la
                        /* 0530 */  0xF9, 0xE9, 0x52, 0x82, 0xD4, 0xE5, 0x8F, 0x03,  // ..R.....
                        /* 0538 */  0xFF, 0xCD, 0x67, 0xDA, 0xC2, 0x4A, 0xD2, 0xCE,  // ..g..J..
                        /* 0540 */  0xD0, 0xA5, 0x52, 0x27, 0x1A, 0x0D, 0xE8, 0xA0,  // ..R'....
                        /* 0548 */  0xD6, 0x7A, 0xD7, 0xAE, 0xFB, 0x03, 0xC8, 0x2A,  // .z.....*
                        /* 0550 */  0xA4, 0xAD, 0x3A, 0x52, 0xCE, 0xF9, 0xEE, 0x69,  // ..:R...i
                        /* 0558 */  0x04, 0x6B, 0x7B, 0x7A, 0xEB, 0x62, 0xFD, 0x28,  // .k{z.b.(
                        /* 0560 */  0x6C, 0xCB, 0xF9, 0xCB, 0x3D, 0x1A, 0x67, 0xDA,  // l...=.g.
                        /* 0568 */  0x4A, 0x04, 0xB2, 0xEC, 0xFC, 0xBE, 0x9C, 0xCA,  // J.......
                        /* 0570 */  0xC1, 0x58, 0xA6, 0x7F, 0xC0, 0xF1, 0x3B, 0x0B,  // .X....;.
                        /* 0578 */  0x91, 0xA7, 0xA0, 0x9B, 0xC6, 0xFB, 0xE1, 0x0C,  // ........
                        /* 0580 */  0x54, 0x16, 0x5A, 0xB4, 0x50, 0x65, 0xA5, 0x53,  // T.Z.Pe.S
                        /* 0588 */  0x1B, 0x96, 0x53, 0x98, 0x0D, 0x08, 0x72, 0x86,  // ..S...r.
                        /* 0590 */  0xBE, 0x87, 0x7C, 0x45, 0x2F, 0xF3, 0x6A, 0xBD,  // ..|E/.j.
                        /* 0598 */  0xD7, 0x66, 0xBA, 0x09, 0x4E, 0x70, 0x11, 0x14,  // .f..Np..
                        /* 05A0 */  0x32, 0xD1, 0xB2, 0x72, 0x20, 0xA8, 0x6D, 0x09,  // 2..r .m.
                        /* 05A8 */  0x2F, 0x9B, 0x77, 0x5C, 0x7A, 0x94, 0x01, 0xF3,  // /.w\z...
                        /* 05B0 */  0xB2, 0x13, 0x86, 0xDC, 0x6D, 0xAB, 0xA0, 0xEA,  // ....m...
                        /* 05B8 */  0xCA, 0x5E, 0xBB, 0x63, 0xDD, 0x49, 0x23, 0xF9,  // .^.c.I#.
                        /* 05C0 */  0x47, 0xE4, 0xA8, 0xA3, 0xD1, 0x07, 0xEB, 0xEC,  // G.......
                        /* 05C8 */  0xEE, 0x5F, 0xCB, 0xE1, 0xE1, 0x3B, 0xD4, 0x96,  // ._...;..
                        /* 05D0 */  0x94, 0xE8, 0x92, 0x68, 0x9B, 0xAF, 0xD8, 0xBE,  // ...h....
                        /* 05D8 */  0xBA, 0x70, 0x9C, 0x28, 0x79, 0xF0, 0xDB, 0xF3,  // .p.(y...
                        /* 05E0 */  0xE9, 0x34, 0xC6, 0x7F, 0xA7, 0xA8, 0x9E, 0xDC,  // .4......
                        /* 05E8 */  0x45, 0xFB, 0xA9, 0x4A, 0x2C, 0xD0, 0x5E, 0x7C,  // E..J,.^|
                        /* 05F0 */  0x2E, 0x56, 0x58, 0xFD, 0x7A, 0x59, 0xA8, 0x84,  // .VX.zY..
                        /* 05F8 */  0x23, 0x86, 0xE6, 0x8A, 0x5C, 0x79, 0x2D, 0xB7,  // #...\y-.
                        /* 0600 */  0xF0, 0x44, 0x18, 0x5F, 0x97, 0xCB, 0x5D, 0xF7,  // .D._..].
                        /* 0608 */  0x43, 0x03, 0x75, 0x0A, 0x52, 0x8E, 0xA3, 0x03,  // C.u.R...
                        /* 0610 */  0x48, 0xE6, 0xEB, 0x2D, 0x02, 0x03, 0x9A, 0x91,  // H..-....
                        /* 0618 */  0xB6, 0x92, 0x5F, 0x31, 0x14, 0x01, 0x8B, 0x5F,  // .._1..._
                        /* 0620 */  0xCA, 0xEE, 0x27, 0x44, 0x06, 0x33, 0xE9, 0xED,  // ..'D.3..
                        /* 0628 */  0xC1, 0x00, 0xE5, 0xA9, 0x93, 0x48, 0x22, 0xC5,  // .....H".
                        /* 0630 */  0xCE, 0x18, 0x4D, 0x38, 0xF2, 0xF5, 0xEA, 0xC5,  // ..M8....
                        /* 0638 */  0xB5, 0xF8, 0xA9, 0x12, 0xDE, 0x1F, 0xD3, 0xC5,  // ........
                        /* 0640 */  0xE7, 0xE7, 0x6F, 0x0E, 0x3F, 0x45, 0xFB, 0x5D,  // ..o.?E.]
                        /* 0648 */  0x64, 0x1E, 0xEB, 0xD5, 0x8D, 0xFD, 0x8D, 0x09,  // d.......
                        /* 0650 */  0x50, 0x06, 0x28, 0xB7, 0x74, 0xE3, 0x77, 0xF7,  // P.(.t.w.
                        /* 0658 */  0x39, 0xE2, 0x2E, 0x7E, 0xDF, 0x59, 0x3B, 0xFA,  // 9..~.Y;.
                        /* 0660 */  0x70, 0xE4, 0x03, 0x30, 0x27, 0x1B, 0x99, 0x71,  // p..0'..q
                        /* 0668 */  0xD2, 0xB6, 0x4D, 0x72, 0x8A, 0xEB, 0x40, 0x43,  // ..Mr..@C
                        /* 0670 */  0xDF, 0xE7, 0xCF, 0x71, 0x62, 0xDE, 0x1E, 0xD3,  // ...qb...
                        /* 0678 */  0x89, 0x53, 0x95, 0xA5, 0x41, 0xED, 0xFD, 0x2A,  // .S..A..*
                        /* 0680 */  0x5D, 0x44, 0x9D, 0x44, 0x5B, 0xB3, 0xC8, 0xA0,  // ]D.D[...
                        /* 0688 */  0x7C, 0xBF, 0x80, 0x9B, 0x7C, 0x76, 0x06, 0xAD,  // |...|v..
                        /* 0690 */  0xCF, 0xC4, 0xFF, 0xDD, 0x8E, 0xBC, 0x4D, 0x54,  // ......MT
                        /* 0698 */  0xE1, 0x01, 0x1F, 0xD4, 0x73, 0x5D, 0xFA, 0x03,  // ....s]..
                        /* 06A0 */  0xA3, 0x7D, 0x84, 0x52, 0xD9, 0x1C, 0x81, 0xDB,  // .}.R....
                        /* 06A8 */  0x5B, 0x75, 0x8B, 0xA5, 0x03, 0xD8, 0xFD, 0x38,  // [u.....8
                        /* 06B0 */  0x87, 0x2F, 0x9E, 0xD0, 0x5D, 0x95, 0x0E, 0x9F,  // ./..]...
                        /* 06B8 */  0x9D, 0x72, 0x6D, 0xA3, 0xA4, 0x98, 0x74, 0x8C,  // .rm...t.
                        /* 06C0 */  0xAC, 0xDB, 0x37, 0xA7, 0x92, 0x3C, 0xD8, 0x84,  // ..7..<..
                        /* 06C8 */  0x82, 0xEA, 0x53, 0xCC, 0x4C, 0x22, 0xBF, 0x9D,  // ..S.L"..
                        /* 06D0 */  0x57, 0x89, 0x5A, 0xDA, 0x3A, 0x48, 0x8E, 0x61,  // W.Z.:H.a
                        /* 06D8 */  0xEC, 0x09, 0x9D, 0x1A, 0xB2, 0x68, 0xB2, 0xC6,  // .....h..
                        /* 06E0 */  0xC7, 0xAE, 0xF2, 0x0E, 0x5F, 0xFB, 0xB8, 0xDE,  // ...._...
                        /* 06E8 */  0x1F, 0x9F, 0xC3, 0x47, 0xFE, 0xB0, 0x07, 0x2E,  // ...G....
                        /* 06F0 */  0xAE, 0x80                                       // ..
                    }
                })
            }
            Else
            {
                Return (Package (0x01)
                {
                    Buffer (0x0813)
                    {
                        /* 0000 */  0xE5, 0x1F, 0x94, 0x00, 0x00, 0x00, 0x00, 0x02,  // ........
                        /* 0008 */  0x00, 0x00, 0x00, 0x40, 0x67, 0x64, 0x64, 0x76,  // ...@gddv
                        /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x4F, 0x45, 0x4D, 0x20,  // ....OEM 
                        /* 0030 */  0x45, 0x78, 0x70, 0x6F, 0x72, 0x74, 0x65, 0x64,  // Exported
                        /* 0038 */  0x20, 0x44, 0x61, 0x74, 0x61, 0x56, 0x61, 0x75,  //  DataVau
                        /* 0040 */  0x6C, 0x74, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // lt......
                        /* 0048 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0050 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0058 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0068 */  0x00, 0x00, 0x00, 0x00, 0x2A, 0x65, 0x93, 0xD4,  // ....*e..
                        /* 0070 */  0x7A, 0xA9, 0x14, 0x67, 0xE0, 0x6E, 0x76, 0x92,  // z..g.nv.
                        /* 0078 */  0xFE, 0xC3, 0xD6, 0x4E, 0xF6, 0x5A, 0xDC, 0x71,  // ...N.Z.q
                        /* 0080 */  0x6D, 0x71, 0x62, 0xBC, 0x9B, 0x50, 0x19, 0xF6,  // mqb..P..
                        /* 0088 */  0x0E, 0x92, 0x29, 0xB5, 0x7F, 0x07, 0x00, 0x00,  // ..).....
                        /* 0090 */  0x52, 0x45, 0x50, 0x4F, 0x5D, 0x00, 0x00, 0x00,  // REPO]...
                        /* 0098 */  0x01, 0xB5, 0x9E, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 00A0 */  0x00, 0x00, 0x72, 0x87, 0xCD, 0xFF, 0x6D, 0x24,  // ..r...m$
                        /* 00A8 */  0x47, 0xDB, 0x3D, 0x24, 0x92, 0xB4, 0x16, 0x6F,  // G.=$...o
                        /* 00B0 */  0x45, 0xD8, 0xC3, 0xF5, 0x66, 0x14, 0x9F, 0x22,  // E...f.."
                        /* 00B8 */  0xD7, 0xF7, 0xDE, 0x67, 0x90, 0x9A, 0xA2, 0x0D,  // ...g....
                        /* 00C0 */  0x39, 0x25, 0xAD, 0xC3, 0x1A, 0xAD, 0x52, 0x0B,  // 9%....R.
                        /* 00C8 */  0x75, 0x38, 0xE1, 0xA4, 0x14, 0x42, 0x76, 0x31,  // u8...Bv1
                        /* 00D0 */  0x7D, 0x1C, 0x67, 0x5D, 0xB9, 0x62, 0xC8, 0x0A,  // }.g].b..
                        /* 00D8 */  0xCB, 0x46, 0x69, 0x45, 0x7F, 0x35, 0x47, 0x94,  // .FiE.5G.
                        /* 00E0 */  0x93, 0x17, 0x36, 0x4E, 0x43, 0x92, 0x85, 0xE4,  // ..6NC...
                        /* 00E8 */  0x5E, 0x82, 0xC8, 0xAB, 0x65, 0x58, 0x98, 0x67,  // ^...eX.g
                        /* 00F0 */  0x21, 0x48, 0x54, 0xFC, 0xCE, 0x3C, 0x8E, 0x30,  // !HT..<.0
                        /* 00F8 */  0xC0, 0xF5, 0x5E, 0xB1, 0xD9, 0x2C, 0x72, 0x9E,  // ..^..,r.
                        /* 0100 */  0xAB, 0xF3, 0x14, 0x0A, 0x8F, 0x38, 0x67, 0x26,  // .....8g&
                        /* 0108 */  0x48, 0x6C, 0xC2, 0x71, 0x63, 0x6C, 0x02, 0xD0,  // Hl.qcl..
                        /* 0110 */  0x2C, 0xB6, 0x93, 0x42, 0x0F, 0x30, 0x25, 0x7E,  // ,..B.0%~
                        /* 0118 */  0xBB, 0xA5, 0x6E, 0x97, 0x5F, 0x08, 0xD2, 0x68,  // ..n._..h
                        /* 0120 */  0x8B, 0xEC, 0xE6, 0xA7, 0x77, 0x00, 0xE2, 0x28,  // ....w..(
                        /* 0128 */  0xBE, 0xEB, 0x66, 0x01, 0x3C, 0x0D, 0x2D, 0x84,  // ..f.<.-.
                        /* 0130 */  0xBF, 0xE0, 0x50, 0xBD, 0x2A, 0x4C, 0x5F, 0x0D,  // ..P.*L_.
                        /* 0138 */  0x11, 0x21, 0x38, 0xDA, 0x99, 0xC1, 0xE2, 0x80,  // .!8.....
                        /* 0140 */  0xD2, 0xE3, 0x42, 0xA4, 0xE6, 0xE1, 0xD6, 0x57,  // ..B....W
                        /* 0148 */  0x8A, 0x86, 0x42, 0x88, 0x25, 0x7B, 0xDB, 0x8C,  // ..B.%{..
                        /* 0150 */  0x57, 0x50, 0xC7, 0x2D, 0x8F, 0xB9, 0x4C, 0x21,  // WP.-..L!
                        /* 0158 */  0x78, 0x52, 0x29, 0xF0, 0xE8, 0xA4, 0xCE, 0x7C,  // xR)....|
                        /* 0160 */  0x49, 0xC5, 0xFB, 0x08, 0xF4, 0x05, 0x71, 0x90,  // I.....q.
                        /* 0168 */  0xAB, 0xFB, 0x9D, 0x0A, 0x15, 0x54, 0xD2, 0x11,  // .....T..
                        /* 0170 */  0x5B, 0x27, 0x31, 0x1F, 0x12, 0xC2, 0xAC, 0xD3,  // ['1.....
                        /* 0178 */  0xBA, 0xA6, 0x51, 0xB9, 0x8A, 0x4B, 0xE9, 0x2E,  // ..Q..K..
                        /* 0180 */  0xAE, 0x46, 0x02, 0x8E, 0x13, 0x4A, 0x73, 0x2D,  // .F...Js-
                        /* 0188 */  0x17, 0x65, 0x6C, 0xD3, 0x41, 0x54, 0x25, 0x54,  // .el.AT%T
                        /* 0190 */  0x6F, 0x80, 0xFB, 0x8B, 0xFC, 0xE3, 0xE9, 0xF7,  // o.......
                        /* 0198 */  0xC3, 0x62, 0x41, 0x6C, 0x97, 0xFB, 0x56, 0x6A,  // .bAl..Vj
                        /* 01A0 */  0xE3, 0xC4, 0x56, 0x77, 0x3C, 0x5F, 0xE4, 0xB0,  // ..Vw<_..
                        /* 01A8 */  0xD0, 0xA5, 0x66, 0x96, 0x79, 0xAE, 0x02, 0x85,  // ..f.y...
                        /* 01B0 */  0xB4, 0x52, 0xF7, 0x52, 0xEA, 0x9B, 0x1F, 0xA1,  // .R.R....
                        /* 01B8 */  0x9F, 0xBD, 0x0F, 0xA3, 0xB4, 0x30, 0x77, 0x55,  // .....0wU
                        /* 01C0 */  0xE1, 0x55, 0x5C, 0xC8, 0x3D, 0xB5, 0xE3, 0xF3,  // .U\.=...
                        /* 01C8 */  0x0E, 0xCF, 0x80, 0x06, 0x4A, 0x12, 0xCB, 0x7D,  // ....J..}
                        /* 01D0 */  0xC3, 0xA5, 0x64, 0x5A, 0x0C, 0xF5, 0x67, 0x29,  // ..dZ..g)
                        /* 01D8 */  0x29, 0x69, 0x82, 0xBA, 0x64, 0xE5, 0xB4, 0xD3,  // )i..d...
                        /* 01E0 */  0xB3, 0xEF, 0xA2, 0x79, 0xC8, 0xCB, 0x7C, 0x0D,  // ...y..|.
                        /* 01E8 */  0xB9, 0x75, 0x5B, 0xDC, 0x46, 0xFE, 0x85, 0x36,  // .u[.F..6
                        /* 01F0 */  0x09, 0xD4, 0xA4, 0x82, 0xA5, 0x79, 0x0B, 0x36,  // .....y.6
                        /* 01F8 */  0x3C, 0x61, 0x75, 0xD1, 0x72, 0x87, 0x35, 0x25,  // <au.r.5%
                        /* 0200 */  0x88, 0x3A, 0x94, 0x56, 0x40, 0x15, 0xDC, 0xE9,  // .:.V@...
                        /* 0208 */  0x68, 0xD3, 0x85, 0x08, 0xF5, 0xBA, 0x05, 0x4B,  // h......K
                        /* 0210 */  0x7A, 0x2E, 0x7E, 0xB7, 0x57, 0xDE, 0x07, 0x7F,  // z.~.W...
                        /* 0218 */  0x51, 0xFF, 0x81, 0x7A, 0x79, 0xB4, 0x81, 0xA4,  // Q..zy...
                        /* 0220 */  0x83, 0x5A, 0xD4, 0x46, 0x52, 0xFB, 0xAF, 0x1D,  // .Z.FR...
                        /* 0228 */  0x65, 0x39, 0x15, 0x7F, 0x23, 0x33, 0xFD, 0x08,  // e9..#3..
                        /* 0230 */  0xBB, 0xF3, 0x53, 0xE8, 0x93, 0x29, 0xDA, 0x44,  // ..S..).D
                        /* 0238 */  0x5E, 0x6C, 0xDE, 0xC5, 0x47, 0x17, 0x5B, 0x9C,  // ^l..G.[.
                        /* 0240 */  0xE9, 0x2D, 0xE2, 0xA5, 0x21, 0x45, 0xF6, 0xF2,  // .-..!E..
                        /* 0248 */  0x40, 0x91, 0x44, 0x3B, 0x87, 0xFE, 0x5E, 0x56,  // @.D;..^V
                        /* 0250 */  0x61, 0x11, 0x40, 0xAB, 0xD1, 0xA0, 0xEA, 0xBE,  // a.@.....
                        /* 0258 */  0x67, 0x30, 0x6F, 0x8A, 0x57, 0x92, 0x87, 0xB5,  // g0o.W...
                        /* 0260 */  0x7E, 0xB9, 0xF9, 0x9C, 0xF5, 0x8A, 0x43, 0x69,  // ~.....Ci
                        /* 0268 */  0x25, 0x78, 0x55, 0x1D, 0xEE, 0x84, 0xDC, 0x76,  // %xU....v
                        /* 0270 */  0x21, 0x98, 0x01, 0xEC, 0x04, 0x42, 0x5B, 0xA7,  // !....B[.
                        /* 0278 */  0x67, 0x0E, 0x86, 0x7A, 0x5E, 0x59, 0x49, 0xBF,  // g..z^YI.
                        /* 0280 */  0x0B, 0xA0, 0x97, 0xFC, 0xF9, 0xB4, 0x98, 0x71,  // .......q
                        /* 0288 */  0xDB, 0xFE, 0xCF, 0xAB, 0x8D, 0xF7, 0x5E, 0xC7,  // ......^.
                        /* 0290 */  0x98, 0x64, 0x06, 0x81, 0x0E, 0x22, 0x81, 0x1E,  // .d..."..
                        /* 0298 */  0x3D, 0xC9, 0xB7, 0x72, 0xA0, 0xA7, 0x11, 0x16,  // =..r....
                        /* 02A0 */  0xD7, 0x3B, 0x24, 0x9A, 0xC2, 0x64, 0xDC, 0x5C,  // .;$..d.\
                        /* 02A8 */  0x6D, 0xFB, 0x06, 0xCE, 0x10, 0x1B, 0x64, 0x35,  // m.....d5
                        /* 02B0 */  0xE4, 0x5C, 0xFF, 0x63, 0xB0, 0x27, 0x50, 0x8F,  // .\.c.'P.
                        /* 02B8 */  0xE9, 0xE5, 0x4E, 0x0E, 0x59, 0x6F, 0xA5, 0xBE,  // ..N.Yo..
                        /* 02C0 */  0xA2, 0x19, 0x53, 0x13, 0x6B, 0xC1, 0x02, 0x89,  // ..S.k...
                        /* 02C8 */  0x1D, 0x00, 0x30, 0x93, 0xB4, 0x8A, 0xA0, 0x2C,  // ..0....,
                        /* 02D0 */  0x81, 0xE1, 0xAF, 0x25, 0x26, 0x11, 0xE7, 0xBD,  // ...%&...
                        /* 02D8 */  0x97, 0x3C, 0x4D, 0xD5, 0x2A, 0x42, 0x86, 0xD1,  // .<M.*B..
                        /* 02E0 */  0x26, 0xD4, 0xB3, 0xB0, 0x32, 0xE1, 0x49, 0x39,  // &...2.I9
                        /* 02E8 */  0x81, 0x9C, 0x37, 0xEB, 0x5B, 0x0E, 0xF1, 0xE5,  // ..7.[...
                        /* 02F0 */  0xCF, 0x32, 0xE5, 0x4E, 0x12, 0xC3, 0x13, 0x43,  // .2.N...C
                        /* 02F8 */  0x31, 0x31, 0x51, 0xB6, 0x9C, 0x03, 0x46, 0x14,  // 11Q...F.
                        /* 0300 */  0x14, 0x05, 0xEE, 0x4B, 0x28, 0x4A, 0x70, 0xBB,  // ...K(Jp.
                        /* 0308 */  0x9C, 0x33, 0xD4, 0xD3, 0x0B, 0x54, 0x2D, 0xB9,  // .3...T-.
                        /* 0310 */  0xEA, 0xB4, 0x8C, 0x21, 0x45, 0x21, 0xFF, 0x26,  // ...!E!.&
                        /* 0318 */  0xEE, 0xAD, 0xA1, 0xA8, 0x0B, 0x6A, 0x37, 0x54,  // .....j7T
                        /* 0320 */  0xA8, 0x7F, 0x1A, 0xEF, 0x56, 0x3C, 0x4B, 0xF1,  // ....V<K.
                        /* 0328 */  0x1D, 0xD2, 0xC3, 0x81, 0x18, 0x37, 0x0F, 0xF2,  // .....7..
                        /* 0330 */  0x25, 0xB0, 0x99, 0x91, 0xE0, 0xB2, 0x52, 0xC2,  // %.....R.
                        /* 0338 */  0xCF, 0x11, 0x81, 0xD5, 0x83, 0x85, 0x22, 0x8F,  // ......".
                        /* 0340 */  0xE5, 0xE3, 0x7B, 0x62, 0x69, 0x3F, 0x25, 0xAB,  // ..{bi?%.
                        /* 0348 */  0xB0, 0x46, 0x5A, 0x78, 0x3C, 0x90, 0x51, 0xEC,  // .FZx<.Q.
                        /* 0350 */  0x83, 0xA3, 0x1F, 0xD6, 0x26, 0xEE, 0xB3, 0x3C,  // ....&..<
                        /* 0358 */  0xD3, 0x68, 0x4F, 0xD3, 0x99, 0xB1, 0x5D, 0xD0,  // .hO...].
                        /* 0360 */  0xCC, 0x2D, 0x98, 0x21, 0x06, 0xD7, 0x6D, 0xB0,  // .-.!..m.
                        /* 0368 */  0xE3, 0xDA, 0xD5, 0x1E, 0xC0, 0x92, 0xA2, 0xC6,  // ........
                        /* 0370 */  0x17, 0x99, 0x9B, 0x78, 0xDF, 0x07, 0xCA, 0x43,  // ...x...C
                        /* 0378 */  0x54, 0xCB, 0x3F, 0xFD, 0x3F, 0xF2, 0x35, 0xB6,  // T.?.?.5.
                        /* 0380 */  0xE5, 0x08, 0xC2, 0x89, 0xD1, 0xE9, 0x7D, 0x56,  // ......}V
                        /* 0388 */  0x38, 0x6F, 0xA0, 0x39, 0x7A, 0x9C, 0x82, 0x0B,  // 8o.9z...
                        /* 0390 */  0xCE, 0x1A, 0xAA, 0xBF, 0xE5, 0x37, 0x8B, 0x13,  // .....7..
                        /* 0398 */  0xDB, 0x31, 0xB8, 0x39, 0x46, 0x93, 0x6F, 0x1B,  // .1.9F.o.
                        /* 03A0 */  0x01, 0x7D, 0x2F, 0x54, 0x4D, 0x45, 0x70, 0x29,  // .}/TMEp)
                        /* 03A8 */  0xBD, 0x73, 0xAE, 0x3F, 0x7F, 0x95, 0xD0, 0x9B,  // .s.?....
                        /* 03B0 */  0xE4, 0xBF, 0x85, 0x8D, 0x0C, 0x04, 0xC5, 0x2F,  // ......./
                        /* 03B8 */  0x81, 0x20, 0xAE, 0x33, 0xC2, 0x85, 0x13, 0x06,  // . .3....
                        /* 03C0 */  0xA2, 0x44, 0xAC, 0x96, 0x77, 0x9F, 0xB7, 0x65,  // .D..w..e
                        /* 03C8 */  0x39, 0xD0, 0x52, 0xB0, 0xF4, 0xC7, 0xE9, 0x27,  // 9.R....'
                        /* 03D0 */  0x5D, 0x25, 0x77, 0xA7, 0x32, 0x32, 0xD6, 0xBD,  // ]%w.22..
                        /* 03D8 */  0x47, 0x76, 0x2D, 0xD8, 0x8B, 0xB5, 0x22, 0xE1,  // Gv-...".
                        /* 03E0 */  0x41, 0xB5, 0xBA, 0x51, 0x88, 0x51, 0xD3, 0xB5,  // A..Q.Q..
                        /* 03E8 */  0x80, 0xDA, 0xD8, 0xB9, 0x06, 0x41, 0x55, 0xD3,  // .....AU.
                        /* 03F0 */  0xFF, 0x5D, 0x1F, 0x8B, 0xDE, 0xA7, 0x9E, 0x0E,  // .]......
                        /* 03F8 */  0x27, 0xC7, 0xDE, 0xBE, 0x78, 0x90, 0x03, 0x90,  // '...x...
                        /* 0400 */  0x2C, 0xE1, 0xC7, 0x4A, 0xDE, 0x93, 0x1C, 0x3A,  // ,..J...:
                        /* 0408 */  0x85, 0xDF, 0x71, 0xAE, 0xC8, 0x11, 0xE5, 0x54,  // ..q....T
                        /* 0410 */  0xDB, 0x5A, 0xC6, 0x2F, 0x97, 0x01, 0x39, 0xE8,  // .Z./..9.
                        /* 0418 */  0x96, 0x39, 0x17, 0x3C, 0xD1, 0x49, 0xAF, 0x6D,  // .9.<.I.m
                        /* 0420 */  0x92, 0x67, 0x15, 0x43, 0x75, 0xE5, 0x37, 0xB3,  // .g.Cu.7.
                        /* 0428 */  0xBF, 0xC7, 0xDE, 0x4B, 0x39, 0x57, 0x99, 0x34,  // ...K9W.4
                        /* 0430 */  0x5D, 0x29, 0x89, 0xE3, 0x36, 0x7F, 0x07, 0x4C,  // ])..6..L
                        /* 0438 */  0x5C, 0xE6, 0x95, 0x0E, 0xA8, 0xD7, 0x91, 0xFF,  // \.......
                        /* 0440 */  0xB7, 0x50, 0xBA, 0x21, 0x99, 0x30, 0x48, 0x21,  // .P.!.0H!
                        /* 0448 */  0xA6, 0x71, 0x2C, 0x26, 0xD5, 0xB6, 0xB4, 0xF0,  // .q,&....
                        /* 0450 */  0x06, 0x61, 0x05, 0xC9, 0x65, 0x7C, 0xD9, 0xEA,  // .a..e|..
                        /* 0458 */  0xDD, 0xAF, 0xC1, 0x8A, 0xFC, 0xF4, 0x20, 0x6A,  // ...... j
                        /* 0460 */  0x6A, 0x7F, 0x2D, 0x9B, 0x2B, 0xC4, 0x5D, 0xF6,  // j.-.+.].
                        /* 0468 */  0xC5, 0xFA, 0xF8, 0x69, 0xBA, 0x00, 0x3E, 0xA5,  // ...i..>.
                        /* 0470 */  0xF1, 0xA3, 0xF3, 0x92, 0x38, 0x92, 0x8A, 0xEA,  // ....8...
                        /* 0478 */  0x9D, 0x0B, 0x2D, 0x6A, 0xC0, 0xB8, 0xFB, 0x7F,  // ..-j....
                        /* 0480 */  0xBB, 0xC5, 0xC1, 0x39, 0xD4, 0x93, 0xB7, 0xF2,  // ...9....
                        /* 0488 */  0x7D, 0x56, 0xBA, 0x1C, 0x72, 0x9D, 0x85, 0x90,  // }V..r...
                        /* 0490 */  0xF5, 0x38, 0x50, 0x1D, 0x74, 0xC2, 0xBF, 0x6C,  // .8P.t..l
                        /* 0498 */  0x97, 0x0A, 0x67, 0x3F, 0xC2, 0xE0, 0x37, 0x02,  // ..g?..7.
                        /* 04A0 */  0xE6, 0xA5, 0x0E, 0x92, 0x98, 0xD2, 0xE6, 0xD8,  // ........
                        /* 04A8 */  0xB1, 0x0F, 0x48, 0x32, 0xCD, 0xE7, 0xD9, 0xE3,  // ..H2....
                        /* 04B0 */  0x66, 0xE8, 0x22, 0x58, 0xAA, 0x37, 0x85, 0xEE,  // f."X.7..
                        /* 04B8 */  0x3F, 0x19, 0x13, 0xCD, 0x0F, 0x81, 0xA0, 0xC0,  // ?.......
                        /* 04C0 */  0xCA, 0xAB, 0x9A, 0xC7, 0xB5, 0x8D, 0x98, 0x57,  // .......W
                        /* 04C8 */  0xD8, 0x04, 0x50, 0x5E, 0x78, 0x88, 0xBD, 0x55,  // ..P^x..U
                        /* 04D0 */  0x11, 0x95, 0xF0, 0xEE, 0xC8, 0xE6, 0xA2, 0xF8,  // ........
                        /* 04D8 */  0x5B, 0xE9, 0x7F, 0xA3, 0xE0, 0x45, 0xFE, 0x0D,  // [....E..
                        /* 04E0 */  0x6A, 0x57, 0x03, 0x48, 0xB6, 0x8F, 0x49, 0x81,  // jW.H..I.
                        /* 04E8 */  0xC5, 0xD8, 0x4F, 0xF6, 0x76, 0xA2, 0x80, 0x2D,  // ..O.v..-
                        /* 04F0 */  0xB8, 0xFF, 0xA5, 0xCC, 0xED, 0xE2, 0xD7, 0x8D,  // ........
                        /* 04F8 */  0x80, 0xBA, 0xC2, 0x23, 0x82, 0x01, 0xE5, 0x28,  // ...#...(
                        /* 0500 */  0x84, 0xB6, 0x69, 0x66, 0xA2, 0x3F, 0x27, 0x89,  // ..if.?'.
                        /* 0508 */  0x5C, 0x89, 0xE9, 0x52, 0xD6, 0x1B, 0x36, 0xB2,  // \..R..6.
                        /* 0510 */  0x62, 0xA7, 0x3D, 0x1D, 0xD4, 0x65, 0xFD, 0xA8,  // b.=..e..
                        /* 0518 */  0x73, 0x88, 0x52, 0x09, 0xA9, 0x84, 0x15, 0x9F,  // s.R.....
                        /* 0520 */  0x54, 0x0E, 0xF6, 0x56, 0xBC, 0x7B, 0x9B, 0x55,  // T..V.{.U
                        /* 0528 */  0xA6, 0xC5, 0xC2, 0x32, 0xD8, 0x58, 0x05, 0x87,  // ...2.X..
                        /* 0530 */  0x54, 0xC9, 0x7E, 0x22, 0x87, 0x80, 0x3E, 0xF5,  // T.~"..>.
                        /* 0538 */  0x81, 0x49, 0x8B, 0x9E, 0x12, 0x0D, 0x80, 0x8C,  // .I......
                        /* 0540 */  0x5F, 0xDC, 0x9B, 0x12, 0xF7, 0x25, 0x09, 0xE5,  // _....%..
                        /* 0548 */  0xA6, 0x2B, 0x27, 0x6E, 0x9D, 0xA1, 0xFC, 0x00,  // .+'n....
                        /* 0550 */  0x11, 0xAB, 0x67, 0xC7, 0xA9, 0xDD, 0x1E, 0x02,  // ..g.....
                        /* 0558 */  0x53, 0x41, 0xDC, 0x2A, 0x40, 0x54, 0xCE, 0xEC,  // SA.*@T..
                        /* 0560 */  0x5F, 0xAE, 0x7A, 0xAC, 0x17, 0x8D, 0xB4, 0x05,  // _.z.....
                        /* 0568 */  0x1C, 0xDD, 0xA9, 0x26, 0x17, 0xFF, 0x45, 0xA0,  // ...&..E.
                        /* 0570 */  0x21, 0x32, 0xE0, 0xD2, 0xE5, 0x5B, 0xC8, 0xFC,  // !2...[..
                        /* 0578 */  0xCF, 0xC8, 0xC9, 0x94, 0x78, 0xE2, 0xCA, 0x8B,  // ....x...
                        /* 0580 */  0x0C, 0xE7, 0x55, 0xF6, 0x2D, 0x3E, 0xB2, 0x0C,  // ..U.->..
                        /* 0588 */  0x36, 0x3C, 0x38, 0xB0, 0xB0, 0xEC, 0x07, 0x24,  // 6<8....$
                        /* 0590 */  0xF8, 0xC1, 0x7D, 0x8A, 0xA6, 0x51, 0x82, 0x17,  // ..}..Q..
                        /* 0598 */  0x02, 0xFF, 0x77, 0xB1, 0x9E, 0x52, 0x36, 0x4E,  // ..w..R6N
                        /* 05A0 */  0x28, 0x70, 0x18, 0xA0, 0x92, 0xA6, 0x2E, 0x85,  // (p......
                        /* 05A8 */  0x51, 0xF6, 0x9F, 0xBA, 0xA9, 0x1E, 0xB0, 0xB1,  // Q.......
                        /* 05B0 */  0x32, 0xB6, 0x41, 0x25, 0x51, 0xB8, 0x2C, 0x6F,  // 2.A%Q.,o
                        /* 05B8 */  0x63, 0x3E, 0x3A, 0xFE, 0x45, 0x4C, 0x6A, 0x14,  // c>:.ELj.
                        /* 05C0 */  0x16, 0x5F, 0x45, 0x6D, 0xD6, 0xC0, 0x4D, 0xFB,  // ._Em..M.
                        /* 05C8 */  0xAB, 0xEF, 0x47, 0xF5, 0x5F, 0x71, 0x2E, 0x69,  // ..G._q.i
                        /* 05D0 */  0xBD, 0x1A, 0xD1, 0xFD, 0xAD, 0xFD, 0xF0, 0xB0,  // ........
                        /* 05D8 */  0x35, 0x96, 0xB4, 0x15, 0x09, 0xE3, 0xE6, 0x24,  // 5......$
                        /* 05E0 */  0xD5, 0x2A, 0x13, 0x44, 0x13, 0xCD, 0x78, 0x73,  // .*.D..xs
                        /* 05E8 */  0xD3, 0x68, 0xEE, 0x09, 0x58, 0xF1, 0x9E, 0xC5,  // .h..X...
                        /* 05F0 */  0x25, 0xE1, 0x36, 0x22, 0x67, 0xD1, 0xB3, 0xC5,  // %.6"g...
                        /* 05F8 */  0x8C, 0xE4, 0x51, 0x1A, 0x16, 0x6A, 0x8F, 0x7E,  // ..Q..j.~
                        /* 0600 */  0x98, 0xBA, 0x63, 0x9A, 0x27, 0x3B, 0xD3, 0xDB,  // ..c.';..
                        /* 0608 */  0x18, 0x95, 0xDC, 0x99, 0xF4, 0xEE, 0x6B, 0xD7,  // ......k.
                        /* 0610 */  0x8F, 0x0A, 0xEE, 0x6A, 0x36, 0x12, 0xCB, 0xEF,  // ...j6...
                        /* 0618 */  0x4D, 0xEC, 0xAC, 0xB4, 0xF0, 0x40, 0x18, 0xF1,  // M....@..
                        /* 0620 */  0x7E, 0x54, 0xF7, 0x7E, 0xED, 0x4F, 0xB5, 0x6B,  // ~T.~.O.k
                        /* 0628 */  0x99, 0xCB, 0x30, 0x13, 0x26, 0xDF, 0xE3, 0xF4,  // ..0.&...
                        /* 0630 */  0x7E, 0xD0, 0x30, 0xBA, 0x1C, 0x08, 0xAF, 0x7D,  // ~.0....}
                        /* 0638 */  0x7F, 0x7C, 0xC5, 0xA5, 0x09, 0xFE, 0xE5, 0xA8,  // .|......
                        /* 0640 */  0xC8, 0xDC, 0xD5, 0xAB, 0x61, 0x4D, 0xCF, 0x01,  // ....aM..
                        /* 0648 */  0x21, 0x48, 0xC1, 0xB3, 0x73, 0x8F, 0x81, 0x4B,  // !H..s..K
                        /* 0650 */  0x2F, 0x9C, 0x9A, 0xC6, 0x99, 0x7C, 0xE4, 0x0C,  // /....|..
                        /* 0658 */  0x25, 0x63, 0x98, 0x33, 0x50, 0x43, 0xF8, 0x16,  // %c.3PC..
                        /* 0660 */  0xFB, 0x24, 0xB8, 0x63, 0x0B, 0x77, 0xEB, 0x43,  // .$.c.w.C
                        /* 0668 */  0xB2, 0x00, 0x6F, 0x34, 0xC1, 0xE2, 0xEC, 0xD8,  // ..o4....
                        /* 0670 */  0xEB, 0xD4, 0x91, 0x5D, 0x0D, 0x67, 0xAB, 0x26,  // ...].g.&
                        /* 0678 */  0x55, 0xAC, 0x8E, 0x2B, 0x73, 0xCB, 0x1D, 0x6E,  // U..+s..n
                        /* 0680 */  0xDE, 0xCD, 0xDA, 0xD8, 0x3C, 0xF8, 0x00, 0xF8,  // ....<...
                        /* 0688 */  0x69, 0xDF, 0x47, 0x3C, 0x24, 0x61, 0x99, 0x94,  // i.G<$a..
                        /* 0690 */  0x24, 0x88, 0xFF, 0x86, 0xCD, 0x13, 0xCD, 0x1E,  // $.......
                        /* 0698 */  0x68, 0x3E, 0x35, 0xD9, 0xA8, 0xEC, 0x20, 0x9A,  // h>5... .
                        /* 06A0 */  0x76, 0xE2, 0x5F, 0x05, 0x90, 0x0F, 0x60, 0x27,  // v._...`'
                        /* 06A8 */  0xEB, 0xC4, 0x80, 0x5B, 0xFD, 0x59, 0x52, 0xD7,  // ...[.YR.
                        /* 06B0 */  0x14, 0x87, 0x5A, 0xF0, 0xDF, 0xAC, 0x17, 0xF6,  // ..Z.....
                        /* 06B8 */  0xB9, 0xC2, 0x30, 0x2C, 0xB8, 0x9F, 0x1E, 0x6A,  // ..0,...j
                        /* 06C0 */  0x7C, 0x2F, 0xE7, 0x72, 0x12, 0x78, 0x8B, 0xB0,  // |/.r.x..
                        /* 06C8 */  0x58, 0x17, 0x33, 0xBE, 0xE0, 0x99, 0x2B, 0x39,  // X.3...+9
                        /* 06D0 */  0xA1, 0xA1, 0xFE, 0xE0, 0x2D, 0x26, 0x2B, 0x5D,  // ....-&+]
                        /* 06D8 */  0x8B, 0x34, 0xD9, 0x43, 0xD5, 0x70, 0x44, 0x5F,  // .4.C.pD_
                        /* 06E0 */  0xA9, 0x7D, 0x35, 0xAF, 0xDA, 0x77, 0xCE, 0xAF,  // .}5..w..
                        /* 06E8 */  0x38, 0x78, 0x28, 0xED, 0x9A, 0xB5, 0x22, 0x19,  // 8x(...".
                        /* 06F0 */  0xE7, 0x73, 0x07, 0xEC, 0xB7, 0x6E, 0x74, 0xE2,  // .s...nt.
                        /* 06F8 */  0xAE, 0x96, 0x4D, 0xA1, 0x49, 0x04, 0x12, 0x0B,  // ..M.I...
                        /* 0700 */  0x17, 0x62, 0x87, 0xC8, 0xCD, 0x52, 0x13, 0x93,  // .b...R..
                        /* 0708 */  0xEA, 0x7D, 0x6C, 0x9C, 0x30, 0x92, 0x94, 0x7F,  // .}l.0...
                        /* 0710 */  0xA9, 0xD2, 0x27, 0x79, 0xBA, 0xC2, 0x0E, 0x30,  // ..'y...0
                        /* 0718 */  0xDE, 0x62, 0x3E, 0x9D, 0xEB, 0x21, 0xCA, 0xFF,  // .b>..!..
                        /* 0720 */  0xBB, 0xF6, 0x48, 0x03, 0x0E, 0xA6, 0x2B, 0x64,  // ..H...+d
                        /* 0728 */  0xEC, 0x1D, 0xF8, 0x78, 0x4E, 0x5F, 0x6B, 0x4D,  // ...xN_kM
                        /* 0730 */  0x86, 0x65, 0x86, 0x10, 0xE8, 0xD4, 0x50, 0xBA,  // .e....P.
                        /* 0738 */  0xE9, 0x51, 0xE5, 0x17, 0x4C, 0xAA, 0xB5, 0x6E,  // .Q..L..n
                        /* 0740 */  0x02, 0x54, 0xF4, 0x6A, 0x8B, 0xAB, 0xF7, 0x3A,  // .T.j...:
                        /* 0748 */  0x1D, 0xE6, 0x3E, 0x93, 0xA7, 0x04, 0xDC, 0x3A,  // ..>....:
                        /* 0750 */  0x85, 0x8E, 0xD6, 0x0F, 0xA7, 0xED, 0x1C, 0x93,  // ........
                        /* 0758 */  0xE4, 0xA6, 0x00, 0xA2, 0x66, 0xB9, 0x71, 0x71,  // ....f.qq
                        /* 0760 */  0xD5, 0x1A, 0x10, 0xDA, 0x07, 0xAB, 0x4C, 0x58,  // ......LX
                        /* 0768 */  0xA0, 0xD6, 0xFD, 0xC0, 0x20, 0x6A, 0x83, 0x40,  // .... j.@
                        /* 0770 */  0x3B, 0xF8, 0x1A, 0x15, 0x84, 0x84, 0x76, 0x8B,  // ;.....v.
                        /* 0778 */  0x58, 0x6F, 0x0C, 0xD4, 0xD4, 0x8E, 0x8B, 0x2D,  // Xo.....-
                        /* 0780 */  0x4D, 0xCB, 0x34, 0x21, 0x4E, 0x7E, 0xDD, 0x06,  // M.4!N~..
                        /* 0788 */  0x88, 0x99, 0xAE, 0xF2, 0xA9, 0x84, 0x24, 0xED,  // ......$.
                        /* 0790 */  0xCB, 0x1C, 0x2C, 0xB3, 0x75, 0x17, 0x64, 0x0E,  // ..,.u.d.
                        /* 0798 */  0xAB, 0xDD, 0xE3, 0x3A, 0xED, 0x8D, 0x88, 0x31,  // ...:...1
                        /* 07A0 */  0xBB, 0x4C, 0xF9, 0xFE, 0x1D, 0xE5, 0xD7, 0x1A,  // .L......
                        /* 07A8 */  0x77, 0xFA, 0xBB, 0x98, 0xE4, 0xB5, 0x69, 0xF8,  // w.....i.
                        /* 07B0 */  0xEB, 0xEE, 0x6C, 0x85, 0x5C, 0x73, 0xBA, 0x92,  // ..l.\s..
                        /* 07B8 */  0xB8, 0x5A, 0x37, 0x3E, 0x5F, 0x9C, 0x3A, 0xDA,  // .Z7>_.:.
                        /* 07C0 */  0xB7, 0xBF, 0x9D, 0x11, 0x28, 0x92, 0xA0, 0x6F,  // ....(..o
                        /* 07C8 */  0x33, 0xCA, 0xB9, 0x41, 0xBE, 0x2B, 0x4C, 0x30,  // 3..A.+L0
                        /* 07D0 */  0xF7, 0x1A, 0xB6, 0xC9, 0x9C, 0x88, 0x91, 0x56,  // .......V
                        /* 07D8 */  0x36, 0x94, 0xB7, 0x94, 0x4A, 0x55, 0x2F, 0x53,  // 6...JU/S
                        /* 07E0 */  0x88, 0x1F, 0x10, 0x99, 0xEE, 0xEC, 0x03, 0x51,  // .......Q
                        /* 07E8 */  0x13, 0x4D, 0x24, 0x41, 0x81, 0xF5, 0x34, 0x5F,  // .M$A..4_
                        /* 07F0 */  0x35, 0xAE, 0x57, 0xCD, 0xAC, 0x64, 0xB9, 0xA7,  // 5.W..d..
                        /* 07F8 */  0x11, 0xB8, 0xB4, 0x0D, 0x7B, 0x0E, 0x60, 0x2A,  // ....{.`*
                        /* 0800 */  0xC7, 0x27, 0x7F, 0xED, 0xE0, 0x64, 0xA8, 0x0D,  // .'...d..
                        /* 0808 */  0x67, 0xE8, 0xEE, 0xB8, 0x86, 0x41, 0x8E, 0x3A,  // g....A.:
                        /* 0810 */  0x7D, 0xE2, 0xFB                                 // }..
                    }
                })
            }
        }

        Method (IMOK, 1, NotSerialized)
        {
            Return (Arg0)
        }
    }
}

