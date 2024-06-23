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
// Binary adder modulo (2^n - 1) with double zero representation
// (1's complement adder) using end-around carry parallel-prefix structure
// S = A+B mod (2^n -1)

module AddMod2Nm1 #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic [width-1:0] S   // sum
);

	logic [width-1:0] GI, PI;  // prefix gen./prop. in
	logic [width-1:0] GO, PO;  // prefix gen./prop. out
	logic [width-1:0] PT;  // adder propagate temp
	logic CI, CO;  // end-around carries

	// calculate prefix input generate/propagate signals
	assign GI = A & B;
	assign PI = A | B;
	// calculate adder propagate signals (PT = A xor B)
	assign PT = ~GI & PI;

	// calculate prefix output generate/propagate signals with end-around carries
	PrefixAndOrCendaround #(width, speed) prefix (
		.GI (GI),
		.PI (PI),
		.CI (CI),
		.GO (GO),
		.PO (PO),
		.CO (CO)
	);

	// end-around carry for addition modulo (2^n - 1), double zero repres.
	assign CI = CO;

	// calculate sum bits
	assign S  = PT ^ {GO[width-2:0], CI};

endmodule



module behavioural_AddMod2Nm1 #(
	parameter int              width = 8,             // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic [width-1:0] S   // sum
);
	localparam int unsigned mod = 2**width -1;
	logic [width:0] total;
	assign total = {1'b0, A} + {1'b0, B};
	// double-zero so total==mod is non-wrapping
	assign S = (total <= mod) ? total : (total - mod);
endmodule