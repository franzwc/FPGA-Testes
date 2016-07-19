/*! Verilog HDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Top Medipix
--------------------------------------------------------------------------------
 Topo de Hierarquia do projeto Top Medipix.

 Ele instancia todos os outros blocos.

 Project Name: TOP_Medipix.v

 Tools: Quartus II 10.0 SP1

 @name TOP_Medipix
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 30/10/2013
 @version 1.0.0 (Nov/2013)

--------------------------------------------------------------------------------*/

module Top_Medipix (
      //--------------------------------------------------------------------------------------------
		//-- input clocks
		//--------------------------------------------------------------------------------------------
      input                Clk25,
		input                Clk125,
		//--------------------------------------------------------------------------------------------
		//-- ddr2 sdram (1.8V)
		//--------------------------------------------------------------------------------------------
		output  [13:0]       Ddr2_A,
		output  [2:0]        Ddr2_Ba,
		output               Ddr2_Cas_N,
		output               Ddr2_Cke,
		inout                Ddr2_Clk_P,
		inout                Ddr2_Clk_N,
		output               Ddr2_Cs_N,
		inout   [1:0]        Ddr2_Dm,
		inout   [15:0]       Ddr2_Dq,
		inout   [1:0]        Ddr2_Dqs,
		output               Ddr2_Odt,
		output               Ddr2_Ras_N,
		output               Ddr2_We_N,
		//--------------------------------------------------------------------------------------------
		//-- gigabit ethernet phy rgmii interface (3.3V)
		//--------------------------------------------------------------------------------------------
		output               Eth_Txc,
		output               Eth_TxCtl,
		output  [3:0]        Eth_Txd,
		input                Eth_Rxc,
		input                Eth_RxCtl,
		input   [3:0]        Eth_Rxd,
		output               Eth_Mdc,
		inout                Eth_Mdio,
		output               Eth_Rst_N,
		//input                Eth_Int_N,
		//--------------------------------------------------------------------------------------------
		//-- i2c
		//--------------------------------------------------------------------------------------------
		inout                I2C_SCL,
		inout                I2C_SDA,
		//--------------------------------------------------------------------------------------------
		//-- spi flash (3.3V)
		//--------------------------------------------------------------------------------------------
		input                Flash_Do,
		output               Flash_Cclk,
		output               Flash_Cs_N,
		output               Flash_Di,
		//--------------------------------------------------------------------------------------------
		//-- led (1.8V)
		//--------------------------------------------------------------------------------------------
		output   [2:0]       Led_N,
		//--------------------------------------------------------------------------------------------
		//-- Controles A/D e D/A
		//--------------------------------------------------------------------------------------------
		output               ADC_Sclk,
		output               ADC_Csn,
		input                ADC_Dout,
		output               ADC_Din,
		
		output               DAC_Sclk,
		output               DAC_Csn,
      output               DAC_Sdi,
		//--------------------------------------------------------------------------------------------
		//-- Controles Medipix
		//--------------------------------------------------------------------------------------------
		output               Reset_out_Mdpx,
		output               Clk_out_Mdpx,
		output               Data_out_Mdpx,
		output               En_out_Mdpx,
		output               Shutter_out_Mdpx,
		output               Cont_sel_out_Mdpx,
      output               MtxClr_out_Mdpx,
		output               TPSWT_out_Mdpx,
		//--------------------------------------------------------------------------------------------
		//-- Dados Medipix
		//--------------------------------------------------------------------------------------------
      input                Clk_in_Mdpx,
		input                En_in_Mdpx,
		input  [7:0]         Data_in_Mdpx
);

	   wire                 Rst25;
		wire                 nRst25;
		wire                 Clk_125;
		wire                 igor_clk;
		wire                 Clk_62;
		wire                 clk_10;
		wire                 clk_20;
		wire                 clk_shutter;
		
		wire   [7:0]         table_nios_data;
		wire                 table_nios_sync;
		wire                 table_nios_valid;
		
		wire   [2:0]         w_M;
		wire   [1:0]         w_PS;
		wire   [1:0]         w_CountL;
		wire                 w_Write_FIFO_Data;
		
		wire                 spi_sclk;
		wire                 spi_csn1;
		wire                 spi_csn2;
		wire                 spi_mosi;
		wire                 spi_miso;
		
		wire   [10:0]        reg_addr_a;
		wire                 reg_oen_a;
		
		wire   [7:0]         mdpx_data;
		wire                 mdpx_valid;
		wire                 mdpx_sync;
		
		wire                 Eth_tx_en_Mdpx;
		wire   [3:0]         Eth_tx_data_Mdpx;
		wire                 Eth_tx_en_linux;
		wire   [3:0]         Eth_tx_data_linux;
		
		wire  [12:0]         w_rx_fifo_use;
		wire  [11:0]         w_eth_fifo_use;
		wire                 w_out_busy;
		
		wire 						w_eth_linux_en;
		wire 	 [3:0]         w_eth_linux_data;
		
		wire 						w_send_eq;
		wire 						w_equalize_data;
		wire 						w_equalize_valid;
		
		wire                 w_Reset_Medipix;
		wire                 w_clk_rst_Medipix;
		wire                 w_out_clock_Medipix;
		wire                 w_rx_fifo_empty;
		
		assign   DAC_Sclk = spi_sclk;
		assign   ADC_Sclk = spi_sclk;
		assign   ADC_Csn = spi_csn1;
		assign   DAC_Csn = spi_csn2;
		assign   ADC_Din = spi_mosi;
		assign   DAC_Sdi = spi_mosi;
		
		wire [2:0] gpio;
		wire [2:0] val;
		
		assign val=3'h1;
		assign Led_N = (val)? (gpio) : (3'bzzz);
		assign Reset_out_Mdpx = nRst25;
		assign Clk_out_Mdpx = w_clk_rst_Medipix | w_out_clock_Medipix;
		
		//--------------------------------------------------------------------------------------------
		//--tamanho do payload do pacote ETH
		//--------------------------------------------------------------------------------------------
		parameter  Packet_Length=1024;//!< Tamanho do Payload
		//--------------------------------------------------------------------------------------------
		//--sincronisa reset
		//--------------------------------------------------------------------------------------------
		Rst_Syncronizer u_Rst_Syncronizer (
            .In_nRst                                      (1'b1),       // pb0
            .In_Clk                                       (Clk_125),      // clk 25
				.In_Clk_Mdpx                                  (clk_10),
				
				.Out_clk_rst_mdpx                             (w_clk_rst_Medipix),
            .Out_rst                                      (Rst25),      // rst
				.Out_nrst                                     (nRst25)
            );
		//--------------------------------------------------------------------------------------------
		//--Master PLL
		//--------------------------------------------------------------------------------------------		
		cpu_pll u_cpu_pll (
            .inclk0                                       (Clk25),      // 25MHz
            .areset                                       (),
				
            .c0                                           (Clk_125),    // 125MHz 
				.c1                                           (igor_clk),   // 25MHz
            .c2                                           (clk_10),     // 10MHz
				.c3                                           (clk_20),     // 20MHz
				.c4                                           () 				// 50MHz
            );	
		
endmodule
