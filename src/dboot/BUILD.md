# Building the 6502 Display ROM

* DBOOT.ASM - the original source listing
* DBOOTNEW.ASM - port to dasm assembler

I am not sure what tools were used to originally build the 6502 ROM source. A possibility was the version of the Microsoft MACRO-80 assembler that had 6502 code generation support, but the version I found could not assemble clean. From some documents I found, the format of DBOOT.ASM sounded close to what was described for Atari Macro Assembler (AMAC) released by Atari Program Exchange (APX). Unfortunately I could not find a copy of this assembler to try.

UPDATE 2012-Oct-06: In a thread on the comp.os.cpm newsgroup entitled [6502 ROM Assembly under CP/M](https://comp.os.cpm.narkive.com/SJ3U2oqQ/6502-rom-assembly-under-cp-m), Emmanuel Roche claims success using XASM65 from Avocet Systems, Inc. to compile this code under CP/M.

I wound up porting the DBOOT.ASM code to [dasm](https://github.com/dasm-assembler/dasm) assembler and cross-assembling on linux. The ported code is DBOOTNEW.ASM.

I chose dasm format '3' because generated a blob from which it was easy to extract the 8K of ROM. One issue this caused was a "reverse-index" error caused by padding in the source code to overrun addresses for subsequent ORG specifications. dasm format '2' would allow this but I chose to remain with '3' and to instead comment out some of the pad bytes in the source file.

As with the Z80 ROM the resulting 8K binary image had a 1 byte difference from the ROM dump used in MESS: which is at 0x16A0. This is again a checksum value (HASHTOT, which does not seem to actually be referenced by the source). The ROM dump has this value as 0x62 vs. the generated 0x00.

    f6a0	       00		      DC.B	$00	;THIS IS WHERE THE HASH TOTAL WILL GO

    000016a0  00 a2 20 ca a9 00 95 00  8a d0 f8 a2 20 ca b5 00  |.. ......... ...|
    ---
    000016a0  62 a2 20 ca a9 00 95 00  8a d0 f8 a2 20 ca b5 00  |b. ......... ...|

Note that the discrepancy between 0xF6A0 and 0x16A0 is due to the byte compare dump occuring on the extracted 8K ROM image.

Here is a small script I used to assemble the code and extract the appropriate 8K for the ROM:

    # -f3 specified to output as 'raw' format
    dasm DBOOTNEW.ASM -f3 -odboot.64k -ldboot.lst -sdboot.sym

    # DASM outputs a 64K (minus 32 bytes due to ORG $20) image, 
    # we need to cut out the upper 8K for the EPROM.  The rest 
    # is throwaway.
    dd if=dboot.64k of=dboot.bin ibs=32 skip=1791
