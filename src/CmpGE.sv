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
// Magnitude (i.e. greater equal) comparison of two numbers by a simplified
// subtraction.
// GE = (A >= B)

module CmpGE #(
	parameter int width = 8,   // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic             GE  // greater equal flag
);

	logic [width-1:0] GI;  // prefix gen./prop. in
	logic [width-1:0] PI;  // prefix gen./prop. in
	logic [width-1:0] GO;  // prefix gen./prop. out
	logic [width-1:0] PO;  // prefix gen./prop. out

	// calculate prefix input generate/propagate signal (0)
	assign GI[0] = A[0] | ~B[0];
	assign PI[0] = ~(A[0] ^ B[0]);

	// calculate prefix input generate/propagate signals (1 to width-1)
	for (genvar i = 1; i < width; i++) begin : preproc
		assign GI[i] = A[i] & ~B[i];
		assign PI[i] = ~(A[i] ^ B[i]);
	end

	// calculate prefix output generate/propagate signals
	PrefixAndOr #(width, speed) prefix (
		.GI(GI),
		.PI(PI),
		.GO(GO),
		.PO(PO)
	);

	// result
	assign GE = GO[width-1];

endmodule



module behavioural_CmpGE #(
	parameter int width = 8,   // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operands
	input  logic [width-1:0] B,
	output logic             GE  // greater equal flag
);
	assign GE = (A >= B);
endmodule
