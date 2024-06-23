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
// Partial-product generator for signed squarer.
//
// Partial products for 4-bit squaring:
//
//  ~x(7) ~x(2)y(3) ~x(1)y(3) ~x(0)y(3)  x(0)y(2)  x(0)y(1)         0  x(0)y(0)
//      1  x(3)y(3)         0  x(1)y(2)      x(7)  x(1)y(1)         0         0
//      0         0         0  x(2)y(2)      x(7)         0         0         0
////////////////////////////////////////////////////////////////////////////////
//   p(7)      p(6)      p(5)      p(4)      p(3)      p(2)      p(1)      p(0)
////////////////////////////////////////////////////////////////////////////////

module SqrPPGenSgn #(
	parameter width = 8
) (
	input logic [width-1:0] X,  // operand
	output logic [(width/2+1)*2*width-1:0] PP  // partial products
);

	localparam widthP = 2*width;
	logic [(width/2+1)*widthP-1:0] ppt;  // internal signal

	always_comb begin
		// Defaults
		ppt = '0;

		// Lower products x(i)x(k), i != k
		for (int i = 0; i < (width-1) /2; i++) begin
			for (int k = i + 1; k < width-i-1; k++) begin
				ppt[i*widthP +i+k+1] = X[i] & X[k];
			end
		end

		// Upper products x(i)x(k), i != k
		for (int k = 0; k < width-1; k++) begin
			ppt[width+k] = ~X[k] & X[width-1];
		end
		for (int i = 1; i < width/2; i++) begin
			for (int k = i; k < width -i-1; k++) begin
				ppt[i*widthP+width-i+k] = X[k] & X[width-i-1];
			end
		end

		// Lower products x(i)x(i)
		for (int i = 0; i <= (width-1) /2; i++) begin
			ppt[i*widthP+2*i] = X[i];
		end

		// Upper products x(i)x(i)
		for (int i = 1; i <= width/2; i++) begin
			ppt[i*widthP+2*width-2*i] = X[width-i];
		end

		// Correction terms
		ppt[widthP-1]   = ~X[width-1];
		ppt[2*widthP-1] = 1'b1;
		if (width % 2 == 0) begin
			ppt[(width/2-1)*widthP+width-1] = X[width-1];
			ppt[(width/2)*widthP+width-1]   = X[width-1];
		end else begin
			ppt[(width/2)*widthP+width] = X[width-1];
		end

		// Assign to output
		PP = ppt;
	end

endmodule
