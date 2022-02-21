# Building the Z80 Boot ROM

* ZBOOT.ASM - the original source listing
* ZBOOTNEW.ASM - changes to match PORTS.LIB I had
* PORTS.LIB - library support from CP/M Plus Additional Files Disk
* Z80.LIB - library support from CP/M Plus Additional Files Disk
* load.c - post-processing HEX2BIN utility

You can build the Z80 ROM using standard the standard CP/M assembler ASM. You can either do this in MESS with the v1050 emulator, or if you want more speed you can use [z80pack](https://www.autometer.de/unix4fun/z80pack/) which provides the nice feature of virtual hard disks for space to handle generated symbol, list, etc. files.

One important note: the ZBOOT.ASM code I have and the PORTS.LIB from the 1.1 BIOS are not in synch. There are two changes that need to be made to assemble:

ZBOOT.ASM references the equates VID$VERT$INT (0xA0) and VID$DISP$INT (0xB0). In the 1.1 PORTS.LIB these are defined as vert$clear and clear$6502. ZBOOTNEW.ASM is the modified source that will build with the 1.1 PORTS.LIB.

CP/M ASM will generate an Intel HEX file as output. You cannot use HEXCOM to convert this to binary since it expects a load address of 0x0100 (start of TPA for COM command files) you really need something like HEXBIN to generate a raw binary starting at 0x0000.

I had a difficult time finding a tool that would properly convert to the ASM-generated HEX to binary under Linux. Most tools I tried failed. I ended up using a small utility written by John Elliott called 'LOAD' compiled with gcc for this task. Note that I needed to delete out the extraneous ^Z (standard CP/M End-of-File mark) that pad out the CP/M 128-byte records (these remain when copying files off CP/M images using cpmcp) since I was not actually running LOAD under CP/M

    cat zboot.hex | ./load zboot.bin 

This should result in an 8K binary image. There is a 1 byte difference from the ROM dump used in MESS: which is at 0x1FFF. This is the checksum value. The ROM dump has this value as 0xEB vs. the generated 0x00.

    0x1fff	  DB 00H  ; <<< CHECK SUM VALUE >>>

    00001ff0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
    ---
    00001ff0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 eb  |................|
