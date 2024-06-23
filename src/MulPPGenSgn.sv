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
// Partial-product generator for signed multiplier (Baugh-Wooley).
//
// Partial products and correction terms for 4x4-bit signed multiplication:
//
//      0         0         0         0 ~x(0)y(3)  x(0)y(2)  x(0)y(1)  x(0)y(0)
//      0         0         0 ~x(1)y(3)  x(1)y(2)  x(1)y(1)  x(1)y(0)         0
//      0         0 ~x(2)y(3)  x(2)y(2)  x(2)y(1)  x(2)y(0)         0         0
//      0  x(3)y(3) x(3)~y(2) x(3)~y(1) x(3)~y(0)         0         0         0
//      0     ~x(3)         0         0      x(3)         0         0         0
//      1     ~y(3)         0         0      y(3)         0         0         0
////////////////////////////////////////////////////////////////////////////////
//   p(7)      p(6)      p(5)      p(4)      p(3)      p(2)      p(1)      p(0)
////////////////////////////////////////////////////////////////////////////////

module MulPPGenSgn #(
	parameter int widthX = 8,  // word width of X
	parameter int widthY = 8   // word width of Y
) (
	input logic [widthX-1:0] X,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [(widthX+2)*(widthX+widthY)-1:0] PP  // partial products
);

	localparam int unsigned widthP = widthX + widthY;  // width of single part. prod.

	always_comb begin
		logic [(widthX+2)*widthP-1:0] ppt;  // partial product vector

		// Initialize ppt to all zeros
		ppt = '0;

		// Generate partial products x(i)y(k)
		for (int i = 0; i < widthX-1; i++) begin
			for (int k = 0; k < widthY-1; k++) begin
				ppt[i*widthP+i+k] = X[i] & Y[k];
			end
			ppt[i*widthP+i+widthY-1] = ~X[i] & Y[widthY-1];
		end

		for (int k = 0; k < widthY-1; k++) begin
			ppt[(widthX-1)*widthP+(widthX-1)+k] = X[widthX-1] & ~Y[k];
		end
		ppt[(widthX-1)*widthP+(widthX-1)+widthY-1] = X[widthX-1] & Y[widthY-1];

		// Generate correction terms
		ppt[(widthX+1)*widthP-2] = ~X[widthX-1];
		ppt[widthX*widthP+widthX-1] = X[widthX-1];
		ppt[(widthX+2)*widthP-1] = 1'b1;
		ppt[(widthX+2)*widthP-2] = ~Y[widthY-1];
		ppt[(widthX+1)*widthP+widthY-1] = Y[widthY-1];

		// Assign output
		PP = ppt;
	end

endmodule
