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
		
		
		wire                 w_out_en;
		wire   [7:0]         w_out_data;
		
		
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
				
		ts_packet_gen u_ts_packet_gen (
            .clk                                          (igor_clk),
            .rst                                          (Rst25),
            .enable                                       (1'b1), 
				.id                                           (8'b0),
            .len_188_204n                                 (1'b0),
				.gap                                          (16'd20),
				
				.ts_data                                      (table_nios_data),
				.ts_valid                                     (table_nios_valid),
				.ts_start                                     (table_nios_sync),
				.ts_end                                       ()
				
            );
	
		TOP_TsoIP u_TOP_TsoIP (

          	 .clk                                         (igor_clk),
				 .nRst                                        (1'b1),
				 .BTS_comp                                    (1'b0),
				 .ClkPhy                                      (igor_clk),
				 .i_ts_valid                                  (table_nios_valid),
				 .i_ts_sync                                   (table_nios_sync),
				 .i_ts_data                                   (table_nios_data),
				 .i_ts_PacketLength                           (8'd204),
				 .i_MacDest                                   (48'hffffffffffff),
				 .i_MacSource                                 (48'h585076000005),
				 .i_IpDest                                    (32'he0000001),
				 .i_IpSource                                  (32'hc0a8647c),
				 .i_Protocol                                  (8'h11),
				 .i_PortDest                                  (16'h138c),
				 .i_PortSource                                (16'h138c),
				 .i_TimeToLive                                (8'h01),
				 .i_NumberPacket                              (3'd7),
				 
				 .PhytxEna                                    (Eth_TxCtl),
				 .PhytxData                                   (Eth_Txd)

		);

		assign Eth_Txc    = ~igor_clk;
		assign Eth_Rst_N  = ~Rst25;		
		
endmodule
