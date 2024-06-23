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
// Detection of the all-ones vector.
// Z = (A == {width{1'b1}})

module AllOneDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,  // operand
	output logic             Z   // all-ones flag
);
	// all-ones detection
	RedAnd #(width) zeroFlag (
		.A(A),
		.Z(Z)
	);

endmodule



module behavioural_AllOneDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,  // operand
	output logic             Z   // all-ones flag
);
	assign Z = (A == {width{1'b1}});
endmodule