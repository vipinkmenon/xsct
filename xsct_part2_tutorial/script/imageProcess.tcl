connect
target 2
fpga rgbGreySystem_wrapper.bit
source ps7_init.tcl
ps7_init
ps7_post_config
dow xsct_test.elf
bpadd -addr &main
con -block -timeout 500
dow -data lena_color.bin 0x11C05C
con -timeout 5
mrd -size b -bin -file out.bin 0x10C05C 65536