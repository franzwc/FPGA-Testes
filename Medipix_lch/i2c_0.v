// i2c_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module i2c_0 (
		input  wire       clk,           //                 clk.clk
		input  wire       reset_n,       //           clk_reset.reset_n
		inout  wire       i2c_scl,       // avalon_slave_export.export
		inout  wire       i2c_sda,       //                    .export
		input  wire [2:0] address,       //        avalon_slave.address
		input  wire [7:0] writedata,     //                    .writedata
		output wire [7:0] readdata,      //                    .readdata
		input  wire       write,         //                    .write
		input  wire       chipselect,    //                    .chipselect
		output wire       waitrequest_n, //                    .waitrequest_n
		output wire       irq            //    avalon_slave_irq.irq
	);

	i2c_master i2c_0 (
		.clk           (clk),           //                 clk.clk
		.reset_n       (reset_n),       //           clk_reset.reset_n
		.i2c_scl       (i2c_scl),       // avalon_slave_export.export
		.i2c_sda       (i2c_sda),       //                    .export
		.address       (address),       //        avalon_slave.address
		.writedata     (writedata),     //                    .writedata
		.readdata      (readdata),      //                    .readdata
		.write         (write),         //                    .write
		.chipselect    (chipselect),    //                    .chipselect
		.waitrequest_n (waitrequest_n), //                    .waitrequest_n
		.irq           (irq)            //    avalon_slave_irq.irq
	);

endmodule
