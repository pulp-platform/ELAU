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
// Partial-product generator for unsigned adder-multiplier (Braun) (i.e.
// multiplier is sum of two input operands). Sign treated by sign extension
// (no Baugh-Wooley multiplier).
//
// Partial products for 4x4-bit signed multiplication (using sign extension):
//
//  x(0)y(3) x(0)y(3) x(0)y(3) x(0)y(3) x(0)y(3) x(0)y(2) x(0)y(1) x(0)y(0)
//  x(1)y(3) x(1)y(3) x(1)y(3) x(1)y(3) x(1)y(2) x(1)y(1) x(1)y(0)        0
//  x(2)y(3) x(2)y(3) x(2)y(3) x(2)y(2) x(2)y(1) x(2)y(0)        0        0
//  x(3)y(3) x(3)y(3) x(3)y(2) x(3)y(1) x(3)y(0)        0        0        0
////////////////////////////////////////////////////////////////////////////////
//      p(7)     p(6)     p(5)     p(4)     p(3)     p(2)     p(1)     p(0)
////////////////////////////////////////////////////////////////////////////////

module AddMulPPGenSgn #(
	parameter int widthX  = 8, // word width of XS, XC
	parameter int widthY  = 8, // word width of Y
	localparam int widthP = widthX+widthY
) (
	input logic [widthX-1:0] XS,  // multipliers
	input logic [widthX-1:0] XC,
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [(widthX+1)*(widthP)-1:0] PP  // partial products
);

	logic [widthX-1:0] M1, M2;  // recoded multiplier
	logic [widthY+1:0] YT, YBT;  // expanded Y

	// recode multiplier
	assign M1 = XS ^ XC;
	assign M2 = XS & XC;

	// expand Y (used for term 2y)
	assign YT  = { Y[widthY-1],  Y[widthY-1:0], 1'b0};
	assign YBT = {~Y[widthY-1], ~Y[widthY-1:0], 1'b0};

	logic [(widthX+1)*widthP-1:0] ppt;

	// partial product generation
	always_comb begin
		ppt = 0;
		for (int i = 0; i < widthX-1; i++) begin
			for (int k = 0; k <= widthY; k++) begin
				ppt[i*widthP+i+k] = (M1[i] & YT[k+1]) | (M2[i] & YT[k]);
			end
			for (int k = widthY+1; k <= (widthY+widthX-i-1); k++) begin
				ppt[i*widthP+i+k] = (M1[i] | M2[i]) & YT[widthY];
			end
		end
		for (int k = 0; k <= widthY; k++) begin
			ppt[(widthX-1)*widthP+widthX-1+k] = (M1[widthX-1] & YBT[k+1]) | (M2[widthX-1] & YBT[k]);
		end
		ppt[widthX*widthP+widthX-1] = M1[widthX-1];
		ppt[widthX*widthP+widthX  ] = M2[widthX-1];
		PP = ppt;
	end

endmodule
