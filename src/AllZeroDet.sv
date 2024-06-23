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
// Detection of the all-zeroes vector.
// Z = (A == '0)

module AllZeroDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,  // operand
	output logic             Z   // all-zeroes flag
);

	logic ZT;  // temp.

	// all-zeroes detection
	RedOr #(width) zeroFlag (
		.A(A),
		.Z(ZT)
	);

	// result
	assign Z = ~ZT;

endmodule



module behavioural_AllZeroDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,  // operand
	output logic             Z   // all-zeroes flag
);
	assign Z = (A == '0);
endmodule