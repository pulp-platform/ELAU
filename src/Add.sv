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
// Binary adder using ripple-carry or parallel-prefix carry-lookahead logic.
// S = A+B

module Add #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic [width-1:0] S   // sum
);

	// Function: Binary adder using parallel-prefix carry-lookahead logic.

	logic [width-1:0] GI, PI;  // prefix gen./prop. in
	logic [width-1:0] GO, PO;  // prefix gen./prop. out
	logic [width-1:0] PT;  // adder propagate temp

	// Internal signals for unsigned operands
	logic [width-1:0] Auns, Buns, Suns;

	// default ripple-carry adder as slow implementation
	if (speed == lau_pkg::SLOW) begin
		// type conversion: std_logic_vector -> unsigned
		assign Auns = A;
		assign Buns = B;

		// addition
		assign Suns = Auns + Buns;

		// type conversion: unsigned -> std_logic_vector
		assign S = Suns;
	end else begin
		// parallel-prefix adders as medium and fast implementations

		// calculate prefix input generate/propagate signals
		assign GI = A & B;
		assign PI = A | B;
		// calculate adder propagate signals (PT = A xor B)
		assign PT = ~GI & PI;

		// calculate prefix output generate/propagate signals
		PrefixAndOr #(
			.width(width),
			.speed(speed)
		) prefix (
			.GI(GI),
			.PI(PI),
			.GO(GO),
			.PO(PO)
		);

		// calculate sum bits
		assign S = PT ^ {GO[width-2:0], 1'b0};
	end
endmodule



module behavioural_Add #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic [width-1:0] S   // sum
);
	assign S = A + B;
endmodule