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
// Partial-product generator for unsigned multiplier (Braun).
//
// Partial products for 4x4-bit unsigned multiplication:
//
//      0         0         0         0  x(0)y(3)  x(0)y(2)  x(0)y(1)  x(0)y(0)
//      0         0         0  x(1)y(3)  x(1)y(2)  x(1)y(1)  x(1)y(0)         0
//      0         0  x(2)y(3)  x(2)y(2)  x(2)y(1)  x(2)y(0)         0         0
//      0  x(3)y(3)  x(3)y(2)  x(3)y(1)  x(3)y(0)         0         0         0
////////////////////////////////////////////////////////////////////////////////
//   p(7)      p(6)      p(5)      p(4)      p(3)      p(2)      p(1)      p(0)
////////////////////////////////////////////////////////////////////////////////

module MulPPGenUns #(
	parameter widthX = 8,  // word width of X
	parameter widthY = 8
)  // word width of Y
(
	input logic [widthX-1:0] X,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX*(widthX+widthY)-1:0] PP
);

	// width of single part. prod.
	localparam widthP = widthX + widthY;

	logic [widthX*widthP-1:0] ppt;  // partial products

	always_comb begin : ppGen
		ppt = '0;  // partial products

		// partial products x(i)y(k)
		for (int i = 0; i < widthX; i++) begin
			for (int k = 0; k < widthY; k++) begin
				ppt[i*widthP+i+k] = X[i] & Y[k];
			end
		end

		PP = ppt;
	end

endmodule
