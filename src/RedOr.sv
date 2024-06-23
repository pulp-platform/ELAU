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
// OR all bits of the input vector.
// Z = A[0] | A[1] | A[2]... | A[width-1]

module RedOr #(
	parameter int width = 8  // word width
) (
	input logic [width-1:0] A,  // input vector
	output logic Z  // output bit
);

	logic zv;
	
	// OR all bits
	// behavioral description used (well handled by all synthesizers)
	always_comb begin
		zv = A[0];
		for (int i = 1; i < width; i++) begin
			zv |= A[i];
		end
		Z = zv;
	end

endmodule



module behavioural_RedOr #(
	parameter int width = 8  // word width
) (
	input logic [width-1:0] A,  // input vector
	output logic Z  // output bit
);

	assign Z = |A;

endmodule
