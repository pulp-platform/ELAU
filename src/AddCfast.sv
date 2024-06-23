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
// Binary adder using parallel-prefix carry-lookahead logic with:
//   - fast carry-in (CI)
//   - carry-out (CO)
// {CO,S} = A+B+CI

module AddCfast #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,   // operands
	input  logic [width-1:0] B,
	input  logic             CI,  // carry in
	output logic [width-1:0] S,   // sum
	output logic             CO   // carry out
);

	logic [width-1:0] GI, PI;  // prefix gen./prop. in
	logic [width-1:0] GO, PO;  // prefix gen./prop. out
	logic [width-1:0] PT;  // adder propagate temp

	// calculate prefix input generate/propagate signals
	assign GI = A & B;
	assign PI = A | B;
	// calculate adder propagate signals (PT = A xor B)
	assign PT = ~GI & PI;

	// calculate prefix output generate/propagate signals with fast carry-in
	PrefixAndOrCfast #(width, speed) prefix (
		.GI (GI),
		.PI (PI),
		.CI (CI),
		.GO (GO),
		.PO (PO)
	);

	// calculate sum and carry-out bits
	assign S  = PT ^ {GO[width-2:0], CI};
	assign CO = GO[width-1];

endmodule



module behavioural_AddCfast #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,   // operands
	input  logic [width-1:0] B,
	input  logic             CI,  // carry in
	output logic [width-1:0] S,   // sum
	output logic             CO   // carry out
);
	assign {CO,S} = A + B + CI;
endmodule