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
// Incrementer for Gray numbers using parallel-prefix propagate-lookahead
// logic.
// Bases on the following algorithm:
//   P = A(n-1) xor A(n-2) xor ... xor A(0)
//   Z(0) = A(0) xnor P
//   Z(i) = A(i) xor (A(i-1) and not A(i-2) and not A(i-3) ...
//                           and not A(0) and P)              ; i = 1, ..., n-2
//   Z(n-1) = A(n-1) xor (not A(n-3) and not A(n-4) ... and not A(0) and P)

module IncGray #(
	parameter int width = 16,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);

	logic [width-2:0] PI;  // prefix prop. in
	logic [width-2:0] PO;  // prefix prop. out
	logic             P;  // parity bit
	logic [width-1:2] T1;  // temp.
	logic [width-1:0] T2;  // temp.

	// calculate parity bit P
	RedXor #(width) parity (
		.A(A),
		.Z(P)
	);

	// calculate prefix input propagate signal (PI = not A(i))
	assign PI[width-2:1] = ~A[width-3:0];

	// feed slow P signal into prefix circuit for slow architecture
	if (speed == lau_pkg::SLOW) begin
		assign PI[0] = P;
	end else begin
		assign PI[0] = 1'b1;
	end

	// calculate prefix output prop. signal (PO = not A(i-2) ... and not A(0))
	PrefixAnd #(width-1, speed) prefix_and (
		.PI(PI),
		.PO(PO)
	);

	// calculate (A and PO)
	assign T1[width-2:2] = A[width-3:1] & PO[width-3:1];
	// special case
	assign T1[width-1] = PO[width-2];

	// calculate (T1 and P) in fast architecture
	for (genvar i = width-1; i >= 2; i--) begin
		if (speed == lau_pkg::SLOW) begin
			assign T2[i] = T1[i];
		end else begin
			assign T2[i] = T1[i] & P;
		end
	end

	// special cases
	assign T2[1] = A[0] & P;
	assign T2[0] = ~P;

	// calculate result bits
	assign Z = A ^ T2;

endmodule



module behavioural_IncGray #(
	parameter int width = 16,  // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] A,  // operand
	output logic [width-1:0] Z   // result
);
	logic [width-1:0] Abin, Zbin;
	behavioural_Gray2Bin #(width, speed) i_gray2bin (
		.G(A),
		.B(Abin)
	);
	
	assign Zbin = Abin + 1;

	behavioural_Bin2Gray #(width) i_bin2gray (
		.B(Zbin),
		.G(Z)
	);

endmodule
