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
// Decrementer using parallel-prefix propagate-lookahead logic.
// Z = A-1

module Dec #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);

	logic [width-1:0] AI;  // A inverted
	logic [width-1:0] PO;  // prefix propagate out

	// invert A for decrement
	assign AI = ~A;

	// calculate prefix output propagate signal
	PrefixAnd #(
		.width(width),
		.speed(speed)
	) prefix (
		.PI(AI),
		.PO(PO)
	);

	// calculate result bits
	assign Z = A ^ {PO[width-2:0], 1'b1};

endmodule



module behavioural_Dec #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);
	assign Z = A - 1;
endmodule