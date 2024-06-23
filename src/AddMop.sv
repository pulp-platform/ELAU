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
// Multi-operand adder using carry-save adder /array/tree and
// ripple-carry/parallel-prefix final adder.
// S = A[0]+A[1]+A[2]...+A[depth-1]

module AddMop #(
	parameter int              width = 8,             // word width
	parameter int              depth = 4,             // number of operands
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [(depth*width)-1:0] A,  // operands
	output logic [        width-1:0] S   // sum
);

	logic [width-1:0] ST, CT;  // interm. sum/carry bits

	// carry-save addition
	AddMopCsv #(
		.width(width),
		.depth(depth),
		.speed(speed)
	) csvAdd (
		.A (A),
		.S (ST),
		.C (CT)
	);

	// final carry-propagate addition
	Add #(
		.width(width),
		.speed(speed)
	) finalAdd (
		.A (ST),
		.B (CT),
		.S (S)
	);

endmodule



module behavioural_AddMop #(
	parameter int              width = 8,             // word width
	parameter int              depth = 4,             // number of operands
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [(depth*width)-1:0] A,  // operands
	output logic [        width-1:0] S   // sum
);
	always_comb begin : reduction
		S = '0;
		for (int i = 0; i < depth; i++) begin
			S += A[width*i +: width];
		end
	end
endmodule
