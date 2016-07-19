/* Verilog HDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix 001 texte para layout
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Topo de Hierarquia do projeto Top Medipix para validacao dos pinos para layout
--!
--! DETAILS:      
--!
--!- Project Name: TOP_Medipix.v                       
--!- Module Name: TOP_Medipix
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 30/10/2013     
--!- Version: 1.0.0 (Nov/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

module Top_Medipix (

      //--------------------------------------------------------------------------------------------
		//-- input clocks
		//--------------------------------------------------------------------------------------------

      input               Clk25,
		input               Clk125,
		
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
		//-- spi flash (3.3V)
		//--------------------------------------------------------------------------------------------

		//-- epcs controller
		input                Flash_Do,
		output               Flash_Cclk,
		output               Flash_Cs_N,
		output               Flash_Di,
		
		//--------------------------------------------------------------------------------------------
		//-- led (1.8V)
		//--------------------------------------------------------------------------------------------
		
		output   [2:0]       Led_N,
		
	   //--------------------------------------------------------------------------------------------
		//-- ts serial
		//--------------------------------------------------------------------------------------------
		
		input                rxd_uart,
		output               txd_uart,
		
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
      // conexoes de clock
	   wire                 Rst25;
		wire                 nRst25;
		wire                 Clk_125;
		wire                 igor_clk;
		wire                 Clk_62;
		wire                 clk_10;
		
		wire   [7:0]         table_nios_data;
		wire                 table_nios_sync;
		wire                 table_nios_valid;
		
		wire   [2:0]         w_M;
		
		wire                 spi_sclk;
		wire                 spi_csn1;
		wire                 spi_csn2;
		wire                 spi_mosi;
		wire                 spi_miso;
		
		wire                 w_out_en;
		wire   [7:0]         w_out_data;
		
		wire   [9:0]         buff_addr_a;
		wire   [7:0]         buff_data_a;
		wire   [7:0]         buff_dataa_a;
		wire                 buff_wen_a;
		
		wire   [9:0]         buff_addr_b;
		wire   [7:0]         buff_data_b;
		wire                 buff_wen_b;
		
		assign   DAC_Sclk = spi_sclk;
		assign   ADC_Sclk = spi_sclk;
		assign   ADC_Csn = spi_csn1;
		assign   DAC_Csn = spi_csn2;
		assign   ADC_Din = spi_mosi;
		assign   DAC_Sdi = spi_mosi;
		
		//assign   Clk_out_Mdpx = clk_10;
		
		assign  Led_N = 3'b0;
		
		// sincroniza reset
		rst_syncronize u_rst_syncronize (
            .n_rst_in                                     (1'b1),          // pb0
            .clk                                          (Clk25),         // clk 25
            .rst_out                                      (Rst25),         // rst
				.nrst_out                                     (nRst25)
            );
				
		cpu_pll u_cpu_pll (
            .inclk0                                       (Clk25),      // 25MHz
            .areset                                       (Rst25),
            .c0                                           (Clk_125),    // 125MHz 
				.c1                                           (igor_clk),   // 25MHz
            .c2                                           (clk_10),      // 25MHz 180
				.c3                                           ()
            );
		
		Grava_Memoria u_Grava_Memoria (
				
				.In_Reset                                     (Rst25),
				.In_Clk                                       (clk_10),
				.In_send                                      (table_nios_valid),
				
				.Out_Data                                     (w_out_data),
				.Out_Addr                                     (buff_addr_b),
				.Out_Wen                                      (w_out_en),
				.Out_rdaddr                                   ()
		);
		
		assign buff_data_a = ~buff_wen_a ? buff_dataa_a : (1'bz);
		
		mem_8b_1024 u_mem_8b_1024 (
		
		      .wrclock                                      (clk_10),
		      .data                                         (w_out_data),
				.wraddress                                    (buff_addr_b),
				.wren                                         (w_out_en),
				
				.rdclock                                      (Clk_62),
				.rdaddress                                    (buff_addr_a),
				
				.q                                            (buff_dataa_a)
		);
//--------------------------------------------------------------------------------------------------
// SOPC Builder generated system
//--------------------------------------------------------------------------------------------------
      wire        mdio_oen_from_the_igor_mac;
		wire        mdio_out_from_the_igor_mac;

		// Ethernet interface assignments

	
		assign Eth_Mdio    =   (mdio_oen_from_the_igor_mac) ? (mdio_out_from_the_igor_mac) : (1'bz);


		Medipix_sopc u_Medipix_sopc (
		// 1) global signals:
		.clk_125                                            (Clk_125),
		.reset_n                                            (nRst25),
  
		//the_igor_mac
		.mcoll_pad_i_to_the_igor_mac                        (),
		.mcrs_pad_i_to_the_igor_mac                         (),
		.md_pad_i_to_the_igor_mac                           (Eth_Mdio),
		.mrx_clk_pad_i_to_the_igor_mac                      (~Eth_Rxc),
		.mrxd_pad_i_to_the_igor_mac                         (Eth_Rxd[3:0]),
		.mrxdv_pad_i_to_the_igor_mac                        (Eth_RxCtl),
		.mrxerr_pad_i_to_the_igor_mac                       (),
		.mtx_clk_pad_i_to_the_igor_mac                      (igor_clk),
   
		.md_pad_o_from_the_igor_mac                         (mdio_out_from_the_igor_mac),
		.md_padoe_o_from_the_igor_mac                       (mdio_oen_from_the_igor_mac),
		.mdc_pad_o_from_the_igor_mac                        (Eth_Mdc),
		.mtxd_pad_o_from_the_igor_mac                       (Eth_Txd[3:0]),
		.mtxen_pad_o_from_the_igor_mac                      (Eth_TxCtl),
		.mtxerr_pad_o_from_the_igor_mac                     (),
  
		//uart 
		.rxd_to_the_uart_0                                  (rxd_uart),
		.txd_from_the_uart_0                                (txd_uart),
		
		//leitura
		.Buffer_ADDR_from_the_Buffer_8bit_1024K_0           (buff_addr_a),
		.Buffer_DQ_to_and_from_the_Buffer_8bit_1024K_0      (buff_data_a),
		.Buffer_WE_N_from_the_Buffer_8bit_1024K_0           (),
		.Buffer_OE_N_from_the_Buffer_8bit_1024K_0           (buff_wen_a),
		
		//spi
		.MISO_to_the_spi_0                                  (),
		.MOSI_from_the_spi_0                                (spi_mosi),
		.SCLK_from_the_spi_0                                (spi_sclk),
		.SS_n_from_the_spi_0                                ({spi_csn1,spi_csn2}),
  
		//epcs flash
		.data0_to_the_epcs_controller                       (Flash_Do),
		.dclk_from_the_epcs_controller                      (Flash_Cclk),
		.sce_from_the_epcs_controller                       (Flash_Cs_N),
		.sdo_from_the_epcs_controller                       (Flash_Di),
  
		//ddr2 ram 
		.ram_aux_full_rate_clk_out                          (),
		.ram_aux_half_rate_clk_out                          (Clk_62),
		.ram_phy_clk_out                                    (),

		.global_reset_n_to_the_ram                          (nRst25),
		.local_init_done_from_the_ram                       (),
		.local_refresh_ack_from_the_ram                     (),
		.local_wdata_req_from_the_ram                       (),
	  	
		.mem_addr_from_the_ram                              (Ddr2_A),
		.mem_ba_from_the_ram                                (Ddr2_Ba),
		.mem_cas_n_from_the_ram                             (Ddr2_Cas_N),
		.mem_cke_from_the_ram                               (Ddr2_Cke),
		.mem_clk_n_to_and_from_the_ram                      (Ddr2_Clk_N),
		.mem_clk_to_and_from_the_ram                        (Ddr2_Clk_P),
		.mem_cs_n_from_the_ram                              (Ddr2_Cs_N),  
		.mem_dm_from_the_ram                                (Ddr2_Dm),
		.mem_dq_to_and_from_the_ram                         (Ddr2_Dq),
		.mem_dqs_to_and_from_the_ram                        (Ddr2_Dqs),
		.mem_odt_from_the_ram                               (Ddr2_Odt),
		.mem_ras_n_from_the_ram                             (Ddr2_Ras_N),
		.mem_we_n_from_the_ram                              (Ddr2_We_N),
		.reset_phy_clk_n_from_the_ram                       (),
		
		.clock_vhdl_to_the_tx_table                         (clk_10),
		.in_Nreset_to_the_tx_table                          (nRst25),
		
		.info_out_from_the_tx_table                         (),
		.irq_from_the_tx_table                              (),
		.info_out_from_the_tx_table                         (),
		.out_data_from_the_tx_table                         (table_nios_data[7:0]),
		.out_sync_from_the_tx_table                         (table_nios_sync),
		.out_valid_from_the_tx_table                        (table_nios_valid)

      );
		
      assign Ddr2_A[13] = 0;
		assign Eth_Txc    = ~igor_clk;
		assign Eth_Rst_N  = ~Rst25;		
		
endmodule