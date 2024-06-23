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
// Detects an all-zeroes sum of an addition in constant time, i.e. without
// waiting for the slow addition result (or without performing the addition).
// Z = ( (A + B +CI)==0 )

module SumZeroDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,
	input  logic [width-1:0] B,  // operands
	input  logic             CI,  // carry in
	output logic             Z    // all-zeroes sum flag
);

	// zero flag for individual bits
	logic [width-1:0] ZT;
	always_comb begin
		ZT[0] = ~((A[0] ^ B[0]) ^ CI);
		for (int i = 1; i < width; i++) begin
			ZT[i] = ~((A[i] ^ B[i]) ^ (A[i-1] | B[i-1]));
		end
	end

	// AND all bit zero flags
	RedAnd #(
		.width(width)
	) zeroFlag (
		.A(ZT),
		.Z(Z)
	);

endmodule



module behavioural_SumZeroDet #(
	parameter int width = 8  // word width
) (
	input  logic [width-1:0] A,
	input  logic [width-1:0] B,  // operands
	input  logic             CI,  // carry in
	output logic             Z    // all-zeroes sum flag
);
	assign Z = ((A+B+CI) == '0);
endmodule