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
// Converts a number from binary to Gray representation.

module Bin2Gray #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] B,  // binary input
	output logic [width-1:0] G   // Gray output
);

	logic [width:0] BT;  // temp.

	// expand B
	assign BT = {1'b0, B};

	// convert binary to Gray
	for (genvar i = 0; i < width; i++) begin : b2g
		assign G[i] = BT[i+1] ^ BT[i];
	end

endmodule



module behavioural_Bin2Gray #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] B,  // binary input
	output logic [width-1:0] G   // Gray output
);

	assign G = B ^ (B >> 1);

endmodule
