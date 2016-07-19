// na_gpio_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module na_gpio_0 (
		output wire [1:0] readdata,   //    avalon_slave_0.readdata
		input  wire [2:0] address,    //                  .address
		input  wire       write_n,    //                  .write_n
		input  wire [1:0] writedata,  //                  .writedata
		input  wire       clk,        //       clock_reset.clk
		input  wire       reset_n,    // clock_reset_reset.reset_n
		inout  wire [2:0] bidir_port  //       conduit_end.export
	);

	gpio #(
		.GPIO_WIDTH (3),
		.GPIO_ADDR  (3)
	) na_gpio_0 (
		.readdata   (readdata),   //    avalon_slave_0.readdata
		.address    (address),    //                  .address
		.write_n    (write_n),    //                  .write_n
		.writedata  (writedata),  //                  .writedata
		.clk        (clk),        //       clock_reset.clk
		.reset_n    (reset_n),    // clock_reset_reset.reset_n
		.bidir_port (bidir_port)  //       conduit_end.export
	);

endmodule
