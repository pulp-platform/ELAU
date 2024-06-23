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
// (m,k)-counter adds m bits. Result is sum vector of k bits.
// Composed of (m,k)-counter slices. Condition: depth > 1.
// S = A[0]+A[1]+A[2]...+A[depth-1]

module Cnt #(
	parameter int              depth = 18,            // number of input bits
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [depth-1:0] A,  // input bits
	output logic [lau_pkg::log2floor(depth):0] S  // sum output
);

	localparam m = depth;  // number of input bits
	localparam n = lau_pkg::log2floor(depth) +1;  // number of output bits
	logic [m*n:0] CT;  // intermediate carries

	// input bits are first intermediate carries
	assign CT[m-1:0] = A;

	// linear arrangement of (m,k)-counter slices
	for (genvar i = 0; i < n-2; i++) begin : bits
		CntSlice #(m/(2**i), speed) slice (
			.A (CT[i*m + m/(2**i) -1 : i*m]),
			.S (S[i]),
			.CO(CT[(i+1)*m + m/(2**(i+1)) -1 : (i+1)*m])
		);
	end

	// add third carry if only two exist
	if (m/ 2**(n-2) == 2) begin : even
		assign CT[(n-2)*m+2] = 1'b0;
	end

	// full-adder for adding the last three carries
	FullAdder fa0 (
		.A (CT[(n-2)*m]),
		.B (CT[(n-2)*m+1]),
		.CI(CT[(n-2)*m+2]),
		.S (S[n-2]),
		.CO(S[n-1])
	);

endmodule



module behavioural_Cnt #(
	parameter int              depth = 18,            // number of input bits
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [depth-1:0] A,  // input bits
	output logic [lau_pkg::log2floor(depth):0] S  // sum output
);
	always_comb begin
		S = '0;
		for(int i = 0; i < depth; i++) begin
			S += A[i];
		end
	end
endmodule