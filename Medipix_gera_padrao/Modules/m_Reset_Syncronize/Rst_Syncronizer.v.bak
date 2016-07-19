/* Verilog HDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Rst_Syncronizer
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Sincroniza os resets
--!
--! DETAILS:      
--!
--!- Project Name: Rst_Syncronizer.v                       
--!- Module Name: Rst_Syncronizer
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

module Rst_Syncronizer (
  input         In_nRst,
  input         In_Clk,
  output reg    Out_rst,
  output reg    Out_nrst
  );

reg t_rst;
reg rst;
always @ (posedge In_Clk or negedge In_nRst)
begin
  if (~In_nRst) begin
    t_rst	  <= 1'b1;
    rst		  <= 1'b1;
    Out_rst   <= 1'b1;
	 Out_nrst  <= 1'b0;
  end
  else begin
    t_rst 	  <= 1'b0;
    rst		  <= t_rst;
    Out_rst   <= rst;
	 Out_nrst  <= ~rst;
  end
end
endmodule