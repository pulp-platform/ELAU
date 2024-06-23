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
// Computes the absolute value using a parallel-prefix 2's complementer.
// Z = |A|

module AbsVal #(
	parameter int width = 8,   // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);

	logic           Neg;  // negation enable
	logic [width:0] AI;  // A inverted
	logic [width:0] PO;  // prefix propagate out

	// negation enable is sign (MSB) of A
	assign Neg = A[width-1];

	// invert A for complement and attach carry-in
	assign AI  = {(A ^ {width{Neg}}), Neg};

	// calculate prefix output propagate signal
	PrefixAnd #(width + 1, speed) prefix (
		.PI (AI),
		.PO (PO)
	);

	// calculate result bits
	assign Z = AI[width:1] ^ PO[width-1:0];

endmodule



module behavioural_AbsVal #(
	parameter int width = 8,   // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);
	assign Z = (signed'(A) < 0) ? -A : A;
endmodule
