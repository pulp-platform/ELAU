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
// Conditional 2's complementer using parallel-prefix propagate-lookahead
// logic.
// Z = Neg ? -A : A

module NegC #(
	parameter int width = 8,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,    // operand
	input  logic             Neg,  // negation enable
	output logic [width-1:0] Z     // result
);

	logic [width:0] AI;  // A inverted
	logic [width:0] PO;  // prefix propagate out

	// invert A for complement and attach carry-in
	assign AI = {A ^ {width{Neg}}, Neg};

	// calculate prefix output propagate signal
	PrefixAnd #(
		.width(width + 1),
		.speed(speed)
	) prefix (
		.PI(AI),
		.PO(PO)
	);

	// calculate result bits
	assign Z = AI[width:1] ^ PO[width-1:0];

endmodule



module behavioural_NegC #(
	parameter int width = 8,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,    // operand
	input  logic             Neg,  // negation enable
	output logic [width-1:0] Z     // result
);
	assign Z = Neg? -A : A;
endmodule