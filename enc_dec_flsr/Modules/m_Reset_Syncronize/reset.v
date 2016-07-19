
module Rst(
  input         In_Clk,
  output reg    Out_rst
  );

integer cont;

always @ (posedge In_Clk)
begin

    cont<=cont+1;

    if (cont< 5000)
    begin    
    Out_rst   <= 1'b0;
    end
	 else
	 begin
	 Out_rst   <= 1'b1;
	 end
	 
	 
	 if (cont==1000000) 
	 begin
	 cont<=0;
	 end
	 
end
endmodule