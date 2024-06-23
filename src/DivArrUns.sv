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
// Restoring array divider for unsigned numbers. Divisor must be normalized
// (i.e. Y(widthY-1) = '1')
// Q = floor(X/Y)
// R = X mod Y

module DivArrUns #(
	parameter int widthX = 16,  // word width of X
	parameter int widthY = 8    // word width of Y
) (
	input  logic [     widthX-1:0] X,  // dividend
	input  logic [     widthY-1:0] Y,  // divisor, normalized
	output logic [widthX-widthY:0] Q,  // quotient
	output logic [     widthY-1:0] R   // remainder
);

	localparam int widthQ = widthX - widthY + 1;  // word width of Q

	logic [                 widthY:0] YI;  // inverted Y
	logic [    widthQ*(widthY+1)-1:0] ST;  // sums
	logic [               widthQ-1:0] QT;  // sums
	logic [(widthQ+1)*(widthY+2)-1:0] RT;  // remainders
	logic [    widthQ*(widthY+2)-1:0] CT;  // carries

	// invert divisor Y for subtraction
	assign YI = {1'b1, ~Y};

	// first partial remainder is dividend X
	assign RT[(widthQ*(widthY+2)+1)+:widthY] = {1'b0, X[widthX-1:widthX-widthY+1]};

	// process one row for each quotient bit

	for (genvar k = widthQ - 1; k >= 0; k--) begin : row
		// carry-in = '1' for subtraction
		assign CT[k*(widthY+2)] = 1'b1;
		// attach next dividend bit to current remainder
		assign RT[((k+1)*(widthY+2))] = X[k];

		// perform subtraction using ripple-carry adder
		// (current partial remainder - divisor)
		for (genvar i = widthY; i >= 0; i--) begin : bits
			FullAdder #() fa (
				.A (YI[i]),
				.B (RT[((k+1)*(widthY+2))+i]),
				.CI(CT[(k*(widthY+2))+i]),
				.S (ST[(k*(widthY+1))+i]),
				.CO(CT[(k*(widthY+2))+i+1])
			);
		end

		always_comb begin
			// if subtraction result is negative => quotient bit = '0'
			QT[k] = CT[k*(widthY+2)+widthY+1];

			// restore previous partial remainder if quotient bit = '0'
			if (QT[k] == 1'b0) begin
				RT[k*(widthY+2)+1+:widthY+1] = RT[((k+1)*(widthY+2))+:widthY];
			end else begin
				RT[k*(widthY+2)+1+:widthY+1] = ST[k*(widthY+1)+:widthY];
			end
		end
	end

	assign Q = QT;
	// last partial remainder is division remainder
	assign R = RT[widthY:1];

endmodule



// X is widthX-bits wide and we have to make sure 
// the result is representable in widthY-bits
module behavioural_DivArrUns #(
	parameter int widthX = 16,  // word width of X
	parameter int widthY = 8    // word width of Y
) (
	input  logic [     widthX-1:0] X,  // dividend
	input  logic [     widthY-1:0] Y,  // divisor, normalized
	output logic [widthX-widthY:0] Q,  // quotient
	output logic [     widthY-1:0] R   // remainder
);
	localparam QMAX = 2**(widthY-1) -1;
	logic [widthX:0] Qtmp;
	always_comb begin
		Qtmp = X / Y;
		// Q < 2^n -> X<2^n *Y, where n is width of Y
		// -> Y in [2^(n-1), 2^n -1], ie Y must be normalized
		if(Qtmp > QMAX) begin
			R = 'x;
			Q = 'x;
		end else begin
			R = X % Y;
			Q = X / Y;
		end
	end
endmodule