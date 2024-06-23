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
// Encodes the position of a '1' in the input vector into a binary number.
// Example: A = "00100000" -> Z = "101".
// Condition: exactly one bit of input vector A is '1'.

module Encode #(
	parameter int width = 8  // word width
) (
	input logic [width-1:0] A,  // input vector
	output logic [$clog2(width)-1:0] Z  // enc. output
);

	localparam int n = width;
	localparam int m = $clog2(width);

	logic zv;

	// example: n = 8, m = 3
	//   Z[0] = A[7] || A[5] || A[3] || A[1]
	//   Z[1] = A[7] || A[6] || A[3] || A[2]
	//   Z[2] = A[7] || A[6] || A[5] || A[4]
	// indices correspond to position of black nodes in Sklansky parallel-prefix
	// algorithm
	always_comb begin
		for (int l = 1; l <= m; l++) begin : outbit
			zv = 1'b0;
			for (int k = 0; k < 2**(m-l); k++) begin
				for (int i = 0; i < 2**(l-1); i++) begin
					if (k * 2**l + 2**(l-1) + i < n) begin
						zv |= A[k * 2**l + 2**(l-1) +i];
					end
				end
			end
			Z[l-1] = zv;
		end
	end

endmodule



module behavioural_Encode #(
	parameter int width = 8  // word width
) (
	input logic [width-1:0] A,  // input vector
	output logic [$clog2(width)-1:0] Z  // enc. output
);
	always_comb begin
		for (int i = 0; i < width; i++ ) begin
			if(A[i]) begin
				Z = i;
			end
		end
	end
endmodule