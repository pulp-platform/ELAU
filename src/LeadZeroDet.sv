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
// Detection of leading zeroes. Output vector indicates position of the first
// '1' (starting at MSB).
// Example: A = "000101" -> Z = "000100".
// Use the `Encode' component for encoding the output (-> Z = "010").

module LeadZeroDet #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // LZD output
);

	logic [width-1:0] PI;  // prefix prop. in
	logic [width-1:0] PO;  // prefix prop. out
	logic [width-1:0] PIT;  // temp.
	logic [width-1:0] POT;  // temp.

	// calculate prefix propagate in signals
	assign PI = ~A;

	// reverse bit order of PI
	for (genvar i = width - 1; i >= 0; i--) begin
		assign PIT[i] = PI[width-i-1];
	end

	// solve reverse prefix problem for leading-zeroes detection
	// (example: "000101" -> "111100")
	PrefixAnd #(width, speed) prefix_and (
		.PI(PIT),
		.PO(POT)
	);

	// reverse bit order of PO
	for (genvar i = width - 1; i >= 0; i--) begin
		assign PO[i] = POT[width-i-1];
	end

	// code output: only bit indicating position of first '1' is '1'
	// (example: "000101" -> "000100")
	assign Z[width-1] = A[width-1];
	for (genvar i = width - 2; i >= 0; i--) begin
		assign Z[i] = PO[i+1] & A[i];
	end

endmodule



module behavioural_LeadZeroDet #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // LZD output
);
	logic [width-1:0] idx;
	always_comb begin
		idx = width;
		for (int i = 0; i < width ; i++ ) begin
			if(A[i] == 1'b1) begin
				idx = i;
			end
		end
		Z = 1'b1 << idx;
	end
endmodule