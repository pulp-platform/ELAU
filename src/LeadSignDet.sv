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
// Detection of leading signs (i.e. leading-zeroes/ones detection for signed
// numbers). Output vector indicates position of the first bit which differs
// from the sign (starting at MSB).
// Examples: A = "000101" -> Z = "000100", A = "111010" -> Z = "000100".
// Use the `Encode' component for encoding the output (-> Z = "010").

module LeadSignDet #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // LSD output
);

	logic [width-2:0] PI;  // prefix prop. in
	logic [width-2:0] PO;  // prefix prop. out
	logic [width-2:0] PIT;  // temp.
	logic [width-2:0] POT;  // temp.

	// calculate prefix propagate in signals (depends on sign)
	for (genvar i = width - 2; i >= 0; i--) begin
		assign PI[i] = ~(A[width-1] ^ A[i]);
	end

	// reverse bit order of PI
	for (genvar i = width - 2; i >= 0; i--) begin
		assign PIT[i] = PI[width-i-2];
	end

	// solve reverse prefix problem for leading-signs detection
	// (example: "000101" -> "111100")
	PrefixAnd #(width - 1, speed) prefix_and (
		.PI(PIT),
		.PO(POT)
	);

	// reverse bit order of PO
	for (genvar i = width - 2; i >= 0; i--) begin
		assign PO[i] = POT[width-i-2];
	end

	// code output: only bit indicating position of first non-sign is '1'
	// (example: "000101" -> "000100")
	assign Z[width-1] = 1'b0;
	assign Z[width-2] = A[width-1] ^ A[width-2];
	for (genvar i = width - 3; i >= 0; i--) begin
		assign Z[i] = PO[i+1] & (A[width-1] ^ A[i]);
	end

endmodule



module behavioural_LeadSignDet #(
	parameter int width = 8,     // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // LSD output
);
	logic msb;
	logic [width-1:0] idx;
	always_comb begin
		msb = A[width-1];
		idx = width;
		for (int i = 0; i < width ; i++ ) begin
			if(A[i] == ~msb) begin
				idx = i;
			end
		end
		Z = 1'b1 << idx;
	end
endmodule