// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Based on the work by Reto Zimmermann 1998 - ETH Zürich
// Originally written in VHDL, available under: 
// https://iis-people.ee.ethz.ch/~zimmi/arith_lib.html#library
//
// Authors:
// - Thomas Benz <tbenz@iis.ee.ethz.ch>
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>
// - Paul Scheffler <paulsc@iis.ee.ethz.ch>
//
// Description :
// Converts a number from Gray to binary representation. Corresponds to a
// prefix problem in reversed bit order (compared to addition)

module Gray2Bin #(
	parameter int width = 8,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] G,  // Gray input
	output logic [width-1:0] B   // binary output
);

	logic [width-1:0] BT, GT;  // temp.

	// reverse bit order of G
	for (genvar i = 0; i < width; i++) begin : revG
		assign GT[i] = G[width-i-1];
	end


	// convert Gray to binary using prefix XOR computation
	PrefixXor #(
		.width(width),
		.speed(speed)
	) prefix_xor (
		.PI(GT),
		.PO(BT)
	);

	// reverse bit order of B

	for (genvar i = 0; i < width; i++) begin : revB
		assign B[i] = BT[width-1-i];
	end


endmodule



module behavioural_Gray2Bin #(
	parameter int width = 8,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] G,  // Gray input
	output logic [width-1:0] B   // binary output
);

    for (genvar i = 0; i < width; i++)
        assign B[i] = ^G[width-1:i];

endmodule
