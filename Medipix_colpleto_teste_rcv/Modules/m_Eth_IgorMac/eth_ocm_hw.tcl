# TCL File Generated by Component Editor 8.0sp1
# Wed Oct 08 08:58:57 MDT 2008
# DO NOT MODIFY


# +-----------------------------------
# | 
# | eth_ocm "OpenCores 10/100 Ethernet MAC Avalon" v8.0.3
# | Jakob Jones 2008.10.08.08:58:57
# | 
# | 
# | C:/altera/80/ip/sopc_builder_ip/eth_ocm/eth_ocm.v
# | 
# |    ./eth_ocm.v syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | module eth_ocm
# | 
set_module_property DESCRIPTION ""
set_module_property NAME eth_ocm
set_module_property VERSION 8.0.3
set_module_property GROUP "Franz/Ethernet"
set_module_property AUTHOR "Franz Wagner"
set_module_property DISPLAY_NAME "Franz 10/100 Ethernet MAC Avalon"
set_module_property TOP_LEVEL_HDL_FILE eth_ocm.v
set_module_property TOP_LEVEL_HDL_MODULE eth_ocm
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property SIMULATION_MODEL_IN_VERILOG false
set_module_property SIMULATION_MODEL_IN_VHDL false
set_module_property SIMULATION_MODEL_HAS_TULIPS false
set_module_property SIMULATION_MODEL_IS_OBFUSCATED false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file eth_ocm.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter TOTAL_DESCRIPTORS int 128 "Total number of DMA descriptors"
set_parameter_property TOTAL_DESCRIPTORS DISPLAY_NAME TOTAL_DESCRIPTORS
set_parameter_property TOTAL_DESCRIPTORS UNITS None
set_parameter_property TOTAL_DESCRIPTORS AFFECTS_PORT_WIDTHS true
add_parameter TX_FIFO_SIZE_IN_BYTES int 128 "Transmit FIFO size in bytes"
set_parameter_property TX_FIFO_SIZE_IN_BYTES DISPLAY_NAME TX_FIFO_SIZE_IN_BYTES
set_parameter_property TX_FIFO_SIZE_IN_BYTES UNITS None
set_parameter_property TX_FIFO_SIZE_IN_BYTES AFFECTS_PORT_WIDTHS true
add_parameter RX_FIFO_SIZE_IN_BYTES int 4096 "Receive FIFO size in bytes"
set_parameter_property RX_FIFO_SIZE_IN_BYTES DISPLAY_NAME RX_FIFO_SIZE_IN_BYTES
set_parameter_property RX_FIFO_SIZE_IN_BYTES UNITS None
set_parameter_property RX_FIFO_SIZE_IN_BYTES AFFECTS_PORT_WIDTHS true
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point control_port
# | 
add_interface control_port avalon end
set_interface_property control_port holdTime 0
set_interface_property control_port linewrapBursts false
set_interface_property control_port minimumUninterruptedRunLength 1
set_interface_property control_port bridgesToMaster ""
set_interface_property control_port isMemoryDevice false
set_interface_property control_port burstOnBurstBoundariesOnly false
set_interface_property control_port addressSpan 4096
set_interface_property control_port timingUnits Cycles
set_interface_property control_port setupTime 0
set_interface_property control_port writeWaitTime 0
set_interface_property control_port isNonVolatileStorage false
set_interface_property control_port addressAlignment DYNAMIC
set_interface_property control_port maximumPendingReadTransactions 0
set_interface_property control_port readWaitTime 1
set_interface_property control_port readLatency 0
set_interface_property control_port printableDevice false

set_interface_property control_port ASSOCIATED_CLOCK clock

add_interface_port control_port av_address address Input 10
add_interface_port control_port av_chipselect chipselect Input 1
add_interface_port control_port av_write write Input 1
add_interface_port control_port av_read read Input 1
add_interface_port control_port av_writedata writedata Input 32
add_interface_port control_port av_readdata readdata Output 32
add_interface_port control_port av_waitrequest_n waitrequest_n Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock ptfSchematicName ""

add_interface_port clock av_clk clk Input 1
add_interface_port clock av_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point tx_master
# | 
add_interface tx_master avalon start
set_interface_property tx_master linewrapBursts false
set_interface_property tx_master adaptsTo ""
set_interface_property tx_master doStreamReads false
set_interface_property tx_master doStreamWrites false
set_interface_property tx_master burstOnBurstBoundariesOnly false

set_interface_property tx_master ASSOCIATED_CLOCK clock

add_interface_port tx_master av_tx_readdata readdata Input 32
add_interface_port tx_master av_tx_waitrequest waitrequest Input 1
add_interface_port tx_master av_tx_readdatavalid readdatavalid Input 1
add_interface_port tx_master av_tx_address address Output 32
add_interface_port tx_master av_tx_read read Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point rx_master
# | 
add_interface rx_master avalon start
set_interface_property rx_master linewrapBursts false
set_interface_property rx_master adaptsTo ""
set_interface_property rx_master doStreamReads false
set_interface_property rx_master doStreamWrites false
set_interface_property rx_master burstOnBurstBoundariesOnly false

set_interface_property rx_master ASSOCIATED_CLOCK clock

add_interface_port rx_master av_rx_waitrequest waitrequest Input 1
add_interface_port rx_master av_rx_address address Output 32
add_interface_port rx_master av_rx_write write Output 1
add_interface_port rx_master av_rx_writedata writedata Output 32
add_interface_port rx_master av_rx_byteenable byteenable Output 4
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point global
# | 
add_interface global conduit end

set_interface_property global ASSOCIATED_CLOCK clock

add_interface_port global mtx_clk_pad_i export Input 1
add_interface_port global mtxd_pad_o export Output 4
add_interface_port global mtxen_pad_o export Output 1
add_interface_port global mtxerr_pad_o export Output 1
add_interface_port global mrx_clk_pad_i export Input 1
add_interface_port global mrxd_pad_i export Input 4
add_interface_port global mrxdv_pad_i export Input 1
add_interface_port global mrxerr_pad_i export Input 1
add_interface_port global mcoll_pad_i export Input 1
add_interface_port global mcrs_pad_i export Input 1
add_interface_port global mdc_pad_o export Output 1
add_interface_port global md_pad_i export Input 1
add_interface_port global md_pad_o export Output 1
add_interface_port global md_padoe_o export Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point control_port_irq
# | 
add_interface control_port_irq interrupt end
set_interface_property control_port_irq associatedAddressablePoint control_port

set_interface_property control_port_irq ASSOCIATED_CLOCK clock

add_interface_port control_port_irq av_irq irq Output 1
# | 
# +-----------------------------------