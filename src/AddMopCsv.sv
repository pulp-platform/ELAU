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
// Carry-save adder using linear- or tree-structured (m,2)-compressors.
// The exact bit-pattern of S and C change depending on the structure 
// of the implemented tree because operands are commutative and can be added in
// different parts of the tree, contributing either to S or C. 
// The only guarantee is that S+C is the same.

module AddMopCsv #(
	parameter int              width = 8,             // word width
	parameter int              depth = 4,             // number of operands
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [(depth*width)-1:0] A,  // operands
	output logic [        width-1:0] S,  // sum
	output logic [        width-1:0] C   // carry vector
);

	logic [      (depth*width)-1:0] AT;  // re-arranged inputs
	logic [(depth-3)*(width+1)-1:0] CI;  // intermediate carries
	logic [              width-1:0] CT;  // unshifted output carries

	// re-arrange input bits: group bits of same magnitude
	always_comb begin : swizzle
		for (int k = 0; k < depth; k++) begin
			for (int i = 0; i < width; i++) begin
				AT[i*depth+k] = A[k*width+i];
			end
		end
	end

	// set intermediate carries into first slice
	assign CI[depth-4:0] = 1'b0;

	// carry-save addition using (m,2) compressor bit-slices
	for (genvar i = 0; i < width; i++) begin : bits
		Cpr #(
			.depth(depth),
			.speed(speed)
		) slice (
			.A (AT[(i+1)*depth -1 : i*depth]),
			.CI(CI[(i+1)*(depth-3) -1 : i*(depth-3)]),
			.S (S[i]),
			.C (CT[i]),
			.CO(CI[(i+2)*(depth-3) -1 : (i+1)*(depth-3)])
		);
	end

	// shift left output carries by one position
	assign C = {CT[width-2:0], 1'b0};

endmodule
