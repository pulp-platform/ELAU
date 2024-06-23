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
// Multiplier for unsigned numbers (Brown) using carry-save adder and
// final adder.
// P = X*Y

module MulUns #(
	parameter int widthX = 16,  // word width of X (X <= Y)
	parameter int widthY = 16,  // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] X,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);

	logic [widthX*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthX+widthY-1:0] ST, CT;  // intermediate sum/carry bits

	// Generation of partial products
	MulPPGenUns #(
		.widthX(widthX),
		.widthY(widthY)
	) ppGen (
		.X (X),
		.Y (Y),
		.PP(PP)
	);

	// Carry-save addition of partial products
	AddMopCsv #(
		.width(widthX+widthY),
		.depth(widthX),
		.speed (speed)
	) csvAdd (
		.A(PP),
		.S(ST),
		.C(CT)
	);

	// Final carry-propagate addition
	Add #(
		.width(widthX+widthY),
		.speed(speed)
	) cpAdd (
		.A(ST),
		.B(CT),
		.S(P)
	);

endmodule



module behavioural_MulUns #(
	parameter int widthX = 16,  // word width of X (X <= Y)
	parameter int widthY = 16,  // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] X,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);
	assign P = unsigned'(X) * unsigned'(Y);
endmodule