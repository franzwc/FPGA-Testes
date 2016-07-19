/* system.h
 *
 * Machine generated for a CPU named "cpu_linux" as defined in:
 * c:\Users\franz.couto\Desktop\Prototipo_Medipix\Projeto\Medipix_0\software\memtest_0_syslib\..\..\Medipix_sopc.ptf
 *
 * Generated: 2013-12-11 11:20:00.957
 *
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/*

DO NOT MODIFY THIS FILE

   Changing this file will have subtle consequences
   which will almost certainly lead to a nonfunctioning
   system. If you do modify this file, be aware that your
   changes will be overwritten and lost when this file
   is generated again.

DO NOT MODIFY THIS FILE

*/

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

/*
 * system configuration
 *
 */

#define ALT_SYSTEM_NAME "Medipix_sopc"
#define ALT_CPU_NAME "cpu_linux"
#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_DEVICE_FAMILY "CYCLONEIVE"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN_BASE 0x08001020
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_PRESENT
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT_BASE 0x08001020
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_PRESENT
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDERR_BASE 0x08001020
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_PRESENT
#define ALT_CPU_FREQ 62500000
#define ALT_IRQ_BASE NULL
#define ALT_LEGACY_INTERRUPT_API_PRESENT

/*
 * processor configuration
 *
 */

#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_BIG_ENDIAN 0
#define NIOS2_INTERRUPT_CONTROLLER_ID 0

#define NIOS2_ICACHE_SIZE 65536
#define NIOS2_DCACHE_SIZE 65536
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_FLUSHDA_SUPPORTED

#define NIOS2_EXCEPTION_ADDR 0x00000020
#define NIOS2_RESET_ADDR 0x08001800
#define NIOS2_BREAK_ADDR 0x08000820

#define NIOS2_HAS_DEBUG_STUB

#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0

/*
 * A define for each class of peripheral
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_CLOCK_CROSSING
#define __DDR2_HIGH_PERF
#define __ALTERA_AVALON_EPCS_FLASH_CONTROLLER
#define __ETH_OCM
#define __TXTABLE
#define __ALTERA_AVALON_UART

/*
 * jtag_uart_0 configuration
 *
 */

#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_BASE 0x08001020
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_IRQ 1
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_READ_CHAR_STREAM ""
#define JTAG_UART_0_SHOWASCII 1
#define JTAG_UART_0_RELATIVEPATH 0
#define JTAG_UART_0_READ_LE 0
#define JTAG_UART_0_WRITE_LE 0
#define JTAG_UART_0_ALTERA_SHOW_UNRELEASED_JTAG_UART_FEATURES 0
#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart

/*
 * sys_clk_freq configuration
 *
 */

#define SYS_CLK_FREQ_NAME "/dev/sys_clk_freq"
#define SYS_CLK_FREQ_TYPE "altera_avalon_timer"
#define SYS_CLK_FREQ_BASE 0x08001000
#define SYS_CLK_FREQ_SPAN 32
#define SYS_CLK_FREQ_IRQ 0
#define SYS_CLK_FREQ_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYS_CLK_FREQ_ALWAYS_RUN 0
#define SYS_CLK_FREQ_FIXED_PERIOD 0
#define SYS_CLK_FREQ_SNAPSHOT 1
#define SYS_CLK_FREQ_PERIOD 10
#define SYS_CLK_FREQ_PERIOD_UNITS "ms"
#define SYS_CLK_FREQ_RESET_OUTPUT 0
#define SYS_CLK_FREQ_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_FREQ_LOAD_VALUE 624999
#define SYS_CLK_FREQ_COUNTER_SIZE 32
#define SYS_CLK_FREQ_MULT 0.0010
#define SYS_CLK_FREQ_TICKS_PER_SEC 100
#define SYS_CLK_FREQ_FREQ 62500000
#define ALT_MODULE_CLASS_sys_clk_freq altera_avalon_timer

/*
 * clock_crossing configuration
 *
 */

#define CLOCK_CROSSING_NAME "/dev/clock_crossing"
#define CLOCK_CROSSING_TYPE "altera_avalon_clock_crossing"
#define CLOCK_CROSSING_BASE 0x00000000
#define CLOCK_CROSSING_SPAN 134217728
#define CLOCK_CROSSING_UPSTREAM_FIFO_DEPTH 64
#define CLOCK_CROSSING_DOWNSTREAM_FIFO_DEPTH 32
#define CLOCK_CROSSING_DATA_WIDTH 32
#define CLOCK_CROSSING_NATIVE_ADDRESS_WIDTH 25
#define CLOCK_CROSSING_USE_BYTE_ENABLE 1
#define CLOCK_CROSSING_USE_BURST_COUNT 0
#define CLOCK_CROSSING_MAXIMUM_BURST_SIZE 8
#define CLOCK_CROSSING_UPSTREAM_USE_REGISTER 0
#define CLOCK_CROSSING_DOWNSTREAM_USE_REGISTER 0
#define CLOCK_CROSSING_SLAVE_SYNCHRONIZER_DEPTH 3
#define CLOCK_CROSSING_MASTER_SYNCHRONIZER_DEPTH 3
#define CLOCK_CROSSING_DEVICE_FAMILY "CYCLONEIVE"
#define ALT_MODULE_CLASS_clock_crossing altera_avalon_clock_crossing

/*
 * ram configuration
 *
 */

#define RAM_NAME "/dev/ram"
#define RAM_TYPE "ddr2_high_perf"
#define RAM_BASE 0x00000000
#define RAM_SPAN 134217728
#define RAM_DEVICE_FAMILY "Cyclone IV E"
#define RAM_DATAWIDTH 16
#define RAM_MEMTYPE "DDR2 SDRAM"
#define RAM_LOCAL_BURST_LENGTH 4
#define RAM_NUM_CHIPSELECTS 1
#define RAM_CAS_LATENCY 5.0
#define RAM_ADDR_WIDTH 13
#define RAM_BA_WIDTH 3
#define RAM_ROW_WIDTH 13
#define RAM_COL_WIDTH 10
#define RAM_CLOCKSPEED 8000
#define RAM_DATA_WIDTH_RATIO 2
#define RAM_REG_DIMM "false"
#define RAM_DQ_PER_DQS 8
#define RAM_PHY_IF_TYPE_AFI "true"
#define RAM_DDRX "true"
#define ALT_MODULE_CLASS_ram ddr2_high_perf

/*
 * epcs_controller configuration
 *
 */

#define EPCS_CONTROLLER_NAME "/dev/epcs_controller"
#define EPCS_CONTROLLER_TYPE "altera_avalon_epcs_flash_controller"
#define EPCS_CONTROLLER_BASE 0x08001800
#define EPCS_CONTROLLER_SPAN 2048
#define EPCS_CONTROLLER_IRQ 2
#define EPCS_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_CONTROLLER_DATABITS 8
#define EPCS_CONTROLLER_TARGETCLOCK 20
#define EPCS_CONTROLLER_CLOCKUNITS "MHz"
#define EPCS_CONTROLLER_CLOCKMULT 1000000
#define EPCS_CONTROLLER_NUMSLAVES 1
#define EPCS_CONTROLLER_ISMASTER 1
#define EPCS_CONTROLLER_CLOCKPOLARITY 0
#define EPCS_CONTROLLER_CLOCKPHASE 0
#define EPCS_CONTROLLER_LSBFIRST 0
#define EPCS_CONTROLLER_EXTRADELAY 0
#define EPCS_CONTROLLER_TARGETSSDELAY 100
#define EPCS_CONTROLLER_DELAYUNITS "us"
#define EPCS_CONTROLLER_DELAYMULT "1e-006"
#define EPCS_CONTROLLER_PREFIX "epcs_"
#define EPCS_CONTROLLER_REGISTER_OFFSET 0x400
#define EPCS_CONTROLLER_IGNORE_LEGACY_CHECK 1
#define EPCS_CONTROLLER_USE_ASMI_ATOM 0
#define EPCS_CONTROLLER_CLOCKUNIT "kHz"
#define EPCS_CONTROLLER_DELAYUNIT "us"
#define EPCS_CONTROLLER_DISABLEAVALONFLOWCONTROL 0
#define EPCS_CONTROLLER_INSERT_SYNC 0
#define EPCS_CONTROLLER_SYNC_REG_DEPTH 2
#define ALT_MODULE_CLASS_epcs_controller altera_avalon_epcs_flash_controller

/*
 * igor_mac configuration
 *
 */

#define IGOR_MAC_NAME "/dev/igor_mac"
#define IGOR_MAC_TYPE "eth_ocm"
#define IGOR_MAC_BASE 0x08002000
#define IGOR_MAC_SPAN 4096
#define IGOR_MAC_IRQ 3
#define IGOR_MAC_IRQ_INTERRUPT_CONTROLLER_ID 0
#define ALT_MODULE_CLASS_igor_mac eth_ocm

/*
 * tx_table configuration
 *
 */

#define TX_TABLE_NAME "/dev/tx_table"
#define TX_TABLE_TYPE "txtable"
#define TX_TABLE_BASE 0x08000000
#define TX_TABLE_SPAN 16
#define ALT_MODULE_CLASS_tx_table txtable

/*
 * uart_0 configuration
 *
 */

#define UART_0_NAME "/dev/uart_0"
#define UART_0_TYPE "altera_avalon_uart"
#define UART_0_BASE 0x08000020
#define UART_0_SPAN 32
#define UART_0_IRQ 4
#define UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_0_BAUD 115200
#define UART_0_DATA_BITS 8
#define UART_0_FIXED_BAUD 1
#define UART_0_PARITY 'N'
#define UART_0_STOP_BITS 1
#define UART_0_SYNC_REG_DEPTH 2
#define UART_0_USE_CTS_RTS 0
#define UART_0_USE_EOP_REGISTER 0
#define UART_0_SIM_TRUE_BAUD 0
#define UART_0_SIM_CHAR_STREAM ""
#define UART_0_RELATIVEPATH 0
#define UART_0_FREQ 62500000
#define ALT_MODULE_CLASS_uart_0 altera_avalon_uart

/*
 * system library configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_CLK_FREQ
#define ALT_TIMESTAMP_CLK none

/*
 * Devices associated with code sections.
 *
 */

#define ALT_TEXT_DEVICE       RAM
#define ALT_RODATA_DEVICE     RAM
#define ALT_RWDATA_DEVICE     RAM
#define ALT_EXCEPTIONS_DEVICE RAM
#define ALT_RESET_DEVICE      EPCS_CONTROLLER


#endif /* __SYSTEM_H_ */
