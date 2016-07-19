module rst_syncronize (
  input         n_rst_in,
  input         clk,
  output reg    rst_out,
  output reg    nrst_out
  );

reg t_rst;
reg rst;
always @ (posedge clk or negedge n_rst_in)
begin
  if (~n_rst_in) begin
    t_rst	  <= 1'b1;
    rst		  <= 1'b1;
    rst_out   <= 1'b1;
	 nrst_out  <= 1'b0;
  end
  else begin
    t_rst 	  <= 1'b0;
    rst		  <= t_rst;
    rst_out   <= rst;
	 nrst_out  <= ~rst;
  end
end
endmodule