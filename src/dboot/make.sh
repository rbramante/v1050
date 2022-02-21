echo "### Compiling..."
# -f3 specified to output as 'raw' format
dasm DBOOTNEW.ASM -f3 -odboot.64k -ldboot.lst -sdboot.sym

echo "### Extracting ROM from generated image..."
# DASM outputs a 64K (minus 32 bytes due to ORG $20) image, 
# we need to cut out the upper 8K for the EPROM.  The rest 
# is throwaway.
dd if=dboot.64k of=dboot.bin ibs=32 skip=1791

echo "### Calculating MD5 for generated ROM..."
md5sum dboot.bin
