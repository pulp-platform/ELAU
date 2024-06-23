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
// Incrementer-decrementer using parallel-prefix propagate-lookahead logic.
// Z = DEC ? A-1: A+1

module IncDec #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,    // operand
	input  logic             DEC,  // decrement enable
	output logic [width-1:0] Z     // result
);

	logic [width-1:0] AI;  // A inverted
	logic [width-1:0] PO;  // prefix propagate out

	// invert A for decrement
	assign AI = A ^ {width{DEC}};

	// calculate prefix output propagate signal
	PrefixAnd #(width, speed) prefix_and (
		.PI(AI),
		.PO(PO)
	);

	// calculate result bits
	assign Z = A ^ {PO[width-2:0], 1'b1};

endmodule



module behavioural_IncDec #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,    // operand
	input  logic             DEC,  // decrement enable
	output logic [width-1:0] Z     // result
);
	assign Z = DEC? A-1: A+1;
endmodule