/*! VHDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Rst_Syncronizer
--------------------------------------------------------------------------------

 Sincroniza os resets

 Project Name: Rst_Syncronizer.v  

 Tools: Quartus II 10.0 SP1

 @name Rst_Syncronizer
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 2/12/2013
 @version 1.0.0 (Dez/2013)

--------------------------------------------------------------------------------*/

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