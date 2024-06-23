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
// Multiplier-adder for signed numbers (Baugh-Wooley). First multiplies two
// numbers, then adds an additional operand to the result.
// P = (X*Y) +A

module MulAddSgn #(
	parameter int              widthX = 8,             // word width of XS, XC (<= widthY)
	parameter int              widthY = 8,             // word width of Y
	parameter int              widthA = 20,            // word width of A (>= widthX+widthY)
	parameter lau_pkg::speed_e speed  = lau_pkg::FAST  // performance parameter
) (
	input  logic [widthX-1:0] X,  // multiplier
	input  logic [widthY-1:0] Y,  // multiplicand
	input  logic [widthA-1:0] A,  // augend
	output logic [widthA-1:0] P   // product
);

	logic [(widthX+2)*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthA-1:0] ST1, CT1, ST2, CT2;  // intermediate sum/carry bits

	// generation of partial products
	MulPPGenSgn #(widthX, widthY) ppGen (
		.X (X),
		.Y (Y),
		.PP(PP)
	);

	// carry-save addition of partial products
	AddMopCsv #(widthX+widthY, widthX+2, speed) csvAdd1 (
		.A (PP),
		.S (ST1[widthX+widthY-1:0]),
		.C (CT1[widthX+widthY-1:0])
	);

	// extend
	always_comb begin
		if (widthA > widthX + widthY) begin
			ST1[widthX+widthY] = ~ST1[widthX+widthY-1];
			ST1[widthA-1:widthX+widthY+1] = '0;
			for (int i = widthX + widthY; i < widthA ; i++) CT1[i] = 1'b1;
		end
	end

	// carry-save addition of augend
	AddCsv #(widthA) csvAdd2 (
		.A1(A),
		.A2(CT1),
		.A3(ST1),
		.S (ST2),
		.C (CT2)
	);

	// final carry-propagate addition
	Add #(widthA, speed) cpAdd (
		.A(ST2),
		.B(CT2),
		.S(P)
	);

endmodule



module behavioural_MulAddSgn #(
	parameter int              widthX = 8,             // word width of XS, XC (<= widthY)
	parameter int              widthY = 8,             // word width of Y
	parameter int              widthA = 20,            // word width of A (>= widthX+widthY)
	parameter lau_pkg::speed_e speed  = lau_pkg::FAST  // performance parameter
) (
	input  logic [widthX-1:0] X,  // multiplier
	input  logic [widthY-1:0] Y,  // multiplicand
	input  logic [widthA-1:0] A,  // augend
	output logic [widthA-1:0] P   // product
);
	assign P = (signed'(X) * signed'(Y)) + signed'(A);
endmodule