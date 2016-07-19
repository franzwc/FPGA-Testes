// Buffer_8bit_1024K_0.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module Buffer_8bit_1024K_0 (
		output wire [7:0] oDATA,       // avalon_slave.readdata
		input  wire [7:0] iDATA,       //             .writedata
		input  wire [9:0] iADDR,       //             .address
		input  wire       iWE_N,       //             .write
		input  wire       iOE_N,       //             .read
		inout  wire [7:0] Buffer_DQ,   //  conduit_end.export
		output wire [9:0] Buffer_ADDR, //             .export
		output wire       Buffer_WE_N, //             .export
		output wire       Buffer_OE_N, //             .export
		input  wire       iCLK         //   clock_sink.clk
	);

	Buffer_8bit_1024K buffer_8bit_1024k_0 (
		.oDATA       (oDATA),       // avalon_slave.readdata
		.iDATA       (iDATA),       //             .writedata
		.iADDR       (iADDR),       //             .address
		.iWE_N       (iWE_N),       //             .write
		.iOE_N       (iOE_N),       //             .read
		.Buffer_DQ   (Buffer_DQ),   //  conduit_end.export
		.Buffer_ADDR (Buffer_ADDR), //             .export
		.Buffer_WE_N (Buffer_WE_N), //             .export
		.Buffer_OE_N (Buffer_OE_N), //             .export
		.iCLK        (iCLK)         //   clock_sink.clk
	);

endmodule
