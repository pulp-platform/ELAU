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
// Multiplier for unsigned numbers with one input operand and the
// result in carry-save number representation (Brown). First adds two
// numbers, then multiplies the result with the multiplicand without
// performing final addition. Result is only valid if sum of
// carry-save input operands does not overflow.
// The exact bit-pattern of S and C change depending on the structure 
// of the implemented tree because operands are commutative and can be added in
// different parts of the tree, contributing either to S or C. 
// The only guarantee is that S+C is the same.

module MulCsvUns #(
	parameter int widthX = 8,     // word width of XS, XC (<= widthY)
	parameter int widthY = 8,     // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] XS,  // multiplier
	input logic [widthX-1:0] XC,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] PS,  // sum
	output logic [widthX+widthY-1:0] PC  // carry
);

	logic [widthX*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthX+widthY-1:0] ST, CT;  // intermediate sum/carry bits

	// generation of partial products
	AddMulPPGenUns #(widthX, widthY) ppGen (
		.XS(XS),
		.XC(XC),
		.Y (Y),
		.PP(PP)
	);

	// carry-save addition of partial products
	AddMopCsv #(widthX+widthY, widthX, speed) csvAdd (
		.A (PP),
		.S (PS),
		.C (PC)
	);

endmodule
