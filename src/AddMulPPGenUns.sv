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
// multiplier is sum of two input operands).

module AddMulPPGenUns #(
	parameter int widthX = 8,  // word width of XS, XC
	parameter int widthY = 8,  // word width of Y
	localparam int widthP = widthX+widthY
) (
	input logic [widthX-1:0] XS,  // multipliers
	input logic [widthX-1:0] XC,
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX*(widthP)-1:0] PP  // partial products
);

	logic [widthX-1:0] M1, M2;  // recoded multiplier
	logic [widthY+1:0] YT;  // expanded Y

	// recode multiplier
	assign M1 = XS ^ XC;
	assign M2 = XS & XC;

	// expand Y (used for term 2y)
	assign YT = {1'b0, Y, 1'b0};

	logic [widthX*widthP-1:0] ppt;

	// partial product generation
	always_comb begin
		ppt = 0;
		for (int i = 0; i < widthX; i++) begin
			for (int k = 0; k <= widthY; k++) begin
				ppt[i*widthP+i+k] = (M1[i] & YT[k+1]) | (M2[i] & YT[k]);
			end
		end
		PP = ppt;
	end

endmodule
