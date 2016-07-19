/* Verilog HDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix 001 texte para layout
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Topo de Hierarquia do projeto Top MedOIP
--!
--! DETAILS:      
--!
--!- Project Name: TOP_MedOIP.v                       
--!- Module Name: TOP_MedOIP
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 22/04/2014     
--!- Version: 1.0.0 (Abr/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header*/

module Top_MedOIP (

      //--------------------------------------------------------------------------------------------
		//-- input clocks
		//--------------------------------------------------------------------------------------------

      input               Clk25,
		input               Clk125,
		
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
		//-- led (1.8V)
		//--------------------------------------------------------------------------------------------
		
		output   [2:0]       Led_N

);
      // conexoes de clock
	   wire                 Rst25;
		wire                 nRst25;
		wire                 Clk_25_180;
		wire                 Clk_25;
		
		wire  [7:0]          data;
		wire                 valid;
		wire                 sync;
		
		
		assign  Led_N = 3'b0;
		
		Top_pll u_Top_pll (
            .inclk0                                       (Clk25),      // 25MHz
            .areset                                       (1'b0),
            .c0                                           (Clk_25),    // 125MHz 
				.c1                                           (Clk_25_180),
				.c2                                           ()
            );
		
	   ts_packet_gen u_ts_packet_gen (
            .clk                                          (Clk_25),
            .rst                                          (1'b0),
            .enable                                       (1'b1), 
				.id                                           (8'b0),
				.gap                                          (16'd1000),
				
				.ts_data                                      (data),
				.ts_valid                                     (valid),
				.ts_start                                     (sync),
				.ts_end                                       ()
				
            );
	
		assign Eth_Txc    = ~Clk_25;
		assign Eth_Rst_N  = 1'b1;		
		
endmodule
