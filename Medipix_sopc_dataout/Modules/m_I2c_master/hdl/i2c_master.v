/* FPS-Tech I2C Wrapper
 * 
 * - Verilog wrapper for OpenCores (www.opencores.org) I2C Master Core
 * - Wrapper interfaces with Alteras Avalon Bus as a SOPC Builder component
 * 
 * - Ver: 1.0
 */

module i2c_master(clk, reset_n, address,
writedata, readdata, write, chipselect, 
irq, waitrequest_n, i2c_scl, i2c_sda
);

input clk, reset_n;
input [2:0] address;
input [7:0] writedata;
output [7:0] readdata;
input write, chipselect;

output irq, waitrequest_n;

inout i2c_scl;
inout i2c_sda;

wire rst;
assign rst = 1'b0;
wire scl_pad_o;
wire scl_padoen_o;
wire scl_pad_i;

wire sda_pad_o;
wire sda_padoen_o;
wire sda_pad_i;

assign i2c_sda = sda_padoen_o ? 1'bZ : sda_pad_o;
assign i2c_scl = scl_padoen_o ? 1'bZ : scl_pad_o;
assign sda_pad_i = i2c_sda;
assign scl_pad_i = i2c_scl;

i2c_master_top i2c_inst(
	clk, rst, reset_n, address, writedata, readdata,
	write, chipselect, chipselect, waitrequest_n, irq,
	scl_pad_i, scl_pad_o, scl_padoen_o, sda_pad_i, sda_pad_o, sda_padoen_o );



endmodule

