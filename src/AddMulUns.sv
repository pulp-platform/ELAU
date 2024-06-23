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
// Adder-multiplier for unsigned numbers (Brown). First adds two numbers, then
// multiplies the result with the multiplicand. Can be used for multiplication
// with an input operand in carry-save number format. Result is only valid if
// sum does not overflow.
// P = (XS+XC)*Y

module AddMulUns #(
	parameter int widthX = 8,     // word width of XS, XC (<= widthY)
	parameter int widthY = 8,     // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] XS,  // multipliers
	input logic [widthX-1:0] XC,
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);

	logic [widthX*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthX+widthY-1:0] ST, CT;  // intermediate sum/carry bits

	// generation of partial products
	AddMulPPGenUns #(
		.widthX(widthX),
		.widthY(widthY)
	) ppGen (
		.XS(XS),
		.XC(XC),
		.Y (Y),
		.PP(PP)
	);

	// carry-save addition of partial products
	AddMopCsv #(
		.width(widthX + widthY),
		.depth(widthX),
		.speed(speed)
	) csvAdd (
		.A(PP),
		.S(ST),
		.C(CT)
	);

	// final carry-propagate addition
	Add #(
		.width(widthX + widthY),
		.speed(speed)
	) cpAdd (
		.A(ST),
		.B(CT),
		.S(P)
	);

endmodule



module behavioural_AddMulUns #(
	parameter int widthX = 8,     // word width of XS, XC (<= widthY)
	parameter int widthY = 8,     // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] XS,  // multipliers
	input logic [widthX-1:0] XC,
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);
	assign P = (XS + XC) * Y;
endmodule