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
// Composed of full-adders arranged in linear or tree structure. Used as slice
// for building (m,k)-counters. Forwards carries to next higher slice.
// Condition: m > 3.

module CntSlice #(
	parameter int              depth = 4,             // number of input bits
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [  depth-1:0] A,  // input bits
	output logic               S,  // sum out
	output logic [depth/2-1:0] CO  // carries out
);

	localparam noFA = depth / 2;  // number of used full-adders
	localparam depthOdd = depth + ((depth + 1) % 2);  // next higher odd
	logic [3*noFA:0] F;  // FIFO vector of int. signals

	// put input bits to beginning of FIFO vector
	assign F[depth-1:0] = A;
	// add a zero if even number of input bits
	if (depth < depthOdd) begin
		assign F[depthOdd-1] = 1'b0;
	end

	// counter with linear structure
	if (speed == lau_pkg::SLOW) begin : slowCnt
		// first full-adder
		FullAdder fa0 (
			.A (F[0]),
			.B (F[1]),
			.CI(F[2]),
			.S (F[depthOdd]),
			.CO(CO[0])
		);

		// linear arrangement of full-adders
		for (genvar i = 1; i < noFA; i++) begin : linear
			FullAdder fa (
				.A (F[i*2+1]),
				.B (F[i*2+2]),
				.CI(F[depthOdd+i-1]),
				.S (F[depthOdd+i]),
				.CO(CO[i])
			);
		end
	end  // counter with tree structure
	else begin : fastCnt
		// tree arrangement of full-adders
		for (genvar i = 0; i < noFA; i++) begin : tree
			FullAdder fa (
				.A (F[i*3]),
				.B (F[i*3+1]),
				.CI(F[i*3+2]),
				.S (F[depthOdd+i]),
				.CO(CO[i])
			);
		end
	end

	// sum out
	assign S = F[3*noFA];

endmodule
