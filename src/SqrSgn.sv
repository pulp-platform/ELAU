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
// Squarer for signed numbers using optimized partial-product generation,
// carry-save adder and final adder.
// P = X*X

module SqrSgn #(
	parameter width = 8,
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [  width-1:0] X,  // operand
	output logic [2*width-1:0] P   // product
);

	logic [(width/2+1)*2*width-1:0] PP;  // partial products
	logic [2*width-1:0] ST, CT;  // intermediate sum/carry bits

	// Generation of partial products
	SqrPPGenSgn #(width) ppGen (
		.X (X),
		.PP(PP)
	);

	// Carry-save addition of partial products
	AddMopCsv #(2*width, width/2 +1, speed) csvAdd (
		.A(PP),
		.S(ST),
		.C(CT)
	);

	// Final carry-propagate addition
	Add #(2*width, speed) cpAdd (
		.A(ST),
		.B(CT),
		.S(P)
	);

endmodule



module behavioural_SqrSgn #(
	parameter width = 8,
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [  width-1:0] X,  // operand
	output logic [2*width-1:0] P   // product
);
	assign P = signed'(X) * signed'(X);
endmodule