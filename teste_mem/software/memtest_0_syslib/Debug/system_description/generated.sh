#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "cpu_linux" as defined in:
# c:\Users\franz.couto\Desktop\Prototipo_Medipix\Projeto\Medipix_0\software\memtest_0_syslib\..\..\Medipix_sopc.ptf
#
# Generated: 2013-12-11 11:21:52.225

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# This variable indicates where the PTF file for this design is located
ptf=c:\Users\franz.couto\Desktop\Prototipo_Medipix\Projeto\Medipix_0\software\memtest_0_syslib\..\..\Medipix_sopc.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=cpu_linux

# Include operating system specific parameters, if they are supplied.

if test -f /cygdrive/d/Altera/10.0/nios2eds/components/altera_hal/build/os.sh ; then
   . /cygdrive/d/Altera/10.0/nios2eds/components/altera_hal/build/os.sh
fi
