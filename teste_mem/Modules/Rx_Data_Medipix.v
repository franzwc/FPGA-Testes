/*- Verilog File
--{{{ HEADER
--!@file
-------------------------------------------------------------------------------------------------
--!@brief Medipix Bridge
-------------------------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! Bridge de comunicacao com o chip medipix
--!
--! DETAILS:      
--!
--!- Project Name: Medipix_Bridge.v                       
--!- Module Name: Medipix_Bridge
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 17/2/2014     
--!- Version: 1.0.0 (Fev/2014) 
-------------------------------------------------------------------------------------------------
-- LNLS - DET - 2014
-------------------------------------------------------------------------------------------------
--}}} Header*/

module Rx_Data_Medipix (

      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------

		input               In_Reset,
	   input               In_Clk_Mdpx,
	   input               In_En_Mdpx,
      input               In_Data_Mdpx,
	   input  [2:0]        In_M,
		input  [1:0]        In_PS,
		input  [1:0]        In_CountL,
	
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output [9:0]        Out_Buffer_Addr,
		output              Out_Buffer_Wen,
		output [7:0]        Out_Buffer_Data
	
);
		
		wire                 w_En_RCL;
		wire                 w_Data_RCL;
		
		wire                 w_En_RCH;
		wire                 w_Data_RCH;
		
		wire                 w_En_RDAC;
		wire                 w_Data_RDAC;
		
		wire                 w_En_ROMR;
		wire                 w_Data_ROMR;
		
		
		Data_Discriminate u_Data_Discriminate (

            .In_Reset                                     (In_Reset),
				.In_Clk_Mdpx                                  (In_Clk_Mdpx),
				.In_En_Mdpx                                   (In_En_Mdpx),
				.In_Data_Mdpx                                 (In_Data_Mdpx),
				.In_M                                         (In_M),

				.Out_En_RCL                                   (w_En_RCL),
				.Out_Data_RCL                                 (w_Data_RCL),
				
				.Out_En_RCH                                   (w_En_RCH),
				.Out_Data_RCH                                 (w_Data_RCH),
				
				.Out_En_RDAC                                  (w_En_RDAC),
				.Out_Data_RDAC                                (w_Data_RDAC),
				
				.Out_En_ROMR                                  (w_En_ROMR),
				.Out_Data_ROMR                                (w_Data_ROMR)
				
				);
				
		Read_Counter_H u_Read_Counter_H (
		      
				.In_Reset                                     (In_Reset),
				.In_Clk_Mdpx                                  (In_Clk_Mdpx),
				.In_En_RCH                                    (w_En_RCH),
				.In_Data_RCH                                  (w_Data_RCH),
				.In_M                                         (In_M),
				.In_PS                                        (In_PS),
				.In_CountL                                    (In_CountL),

				.Out_Addr                                     (Out_Buffer_Addr),
				.Out_En_RCH                                   (Out_Buffer_Wen),
				.Out_Data_RCH                                 (Out_Buffer_Data)
		);

endmodule 