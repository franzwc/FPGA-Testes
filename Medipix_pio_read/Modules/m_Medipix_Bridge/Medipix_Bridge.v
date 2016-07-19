/* VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix Bridge
--------------------------------------------------------------------------------                                                                      
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
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

module Medipix_Bridge (

      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------

		input               In_Reset,
		input               In_Clk_nios,
		input               In_Clk,

		input               In_En_nios,
		input               In_Sync_nios,
		input  [7:0]        In_Data_nios,
	
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output reg          Out_TPSWT_Mdpx
	
);
		reg cont=0;
		reg saida=0;

		always@(posedge(In_Clk_nios))
		begin
			
			if(cont==0)
			begin 
				cont=~cont;
			end
			else 
			begin
				cont=~cont;
				saida=~saida;
			end
			Out_TPSWT_Mdpx = saida;
		end
		

endmodule 
