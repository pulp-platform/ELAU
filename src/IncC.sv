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
// Incrementer using parallel-prefix propagate-lookahead logic with:
//   - carry-in (CI)
//   - carry-out (CO)
// {CO,Z} = A+CI

module IncC #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,   // operand
	input  logic             CI,  // carry in
	output logic [width-1:0] Z,   // result
	output logic             CO   // carry out
);

	logic [width:0] AI;  // A inverted
	logic [width:0] PO;  // prefix propagate out

	// attach carry-in
	assign AI = {A, CI};

	// calculate prefix output propagate signal
	PrefixAnd #(width+1, speed) prefix_and (
		.PI(AI),
		.PO(PO)
	);

	// calculate result and carry-out bits
	assign Z  = A ^ PO[width-1:0];
	assign CO = PO[width];

endmodule


module behavioural_IncC #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,   // operand
	input  logic             CI,  // carry in
	output logic [width-1:0] Z,   // result
	output logic             CO   // carry out
);
	assign {CO,Z} = A + CI;
endmodule