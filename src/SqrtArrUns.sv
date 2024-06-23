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
// Restoring array square-root extractor for unsigned numbers.
// Q = floor(sqrt(X))
// R = X - Q^2

module SqrtArrUns #(
	parameter int widthX = 8
) (
	input  logic [widthX-1:0] X,  // operand
	output logic [(widthX+1)/2-1:0] Q,  // square root
	output logic [(widthX+1)/2-1:0] R  // remainder
);

	// Word width of Q
	localparam widthQ = (widthX + 1) / 2;

	// Signals
	logic [widthX:0] XT;  // Extended operand
	logic [widthQ-1:0] QT;  // Temp quotient
	logic [widthQ*(widthQ+2)-1:0] QTI;  // Quotients
	logic [widthQ*(widthQ+2)-1:0] ST;  // Sums
	logic [(widthQ+1)*(widthQ+3)-1:0] RT;  // Remainders
	logic [widthQ*(widthQ+3)-1:0] CT;  // Carries

	// Extend operand X
	assign XT = {1'b0, X};

	// first partial remainder is operand X
	assign RT[widthQ*(widthQ+3)+1+:widthQ+1] = {1'b0, XT[widthQ+:widthQ]};

	// Process one row for each quotient bit
	for (genvar k = 0; k < widthQ; k++) begin : row

		// Carry-in = '1' for subtraction
		assign CT[k*(widthQ+3)] = 1'b1;
		// Attach next operand bit to current remainder
		assign RT[(k+1)*(widthQ+3)] = XT[k];

		logic [widthQ+1:0] qtv;
		always_comb begin : partQuot
			qtv[     k  :0  ] = '0;
			qtv[     k+1:k  ] = 2'b01;
			qtv[widthQ+1:k+2] = QT >> (k+1); // QT[widthQ-1 : k+1]

			QTI[k*(widthQ+2) +: widthQ+2] = ~qtv; 
		end

		// Form current partial quotient (inverted)
		for (genvar i = 0; i < widthQ+2; i++) begin : bits
			// Perform subtraction using ripple-carry adder
			// (partial remainder - partial quotient)
			FullAdder fa (
				.A (QTI[  k   * (widthQ+2) +i  ]),
				.B (RT [(k+1) * (widthQ+3) +i  ]),
				.CI(CT [  k   * (widthQ+3) +i  ]),
				.S (ST [  k   * (widthQ+2) +i  ]),
				.CO(CT [  k   * (widthQ+3) +i+1])
			);
		end

		always_comb begin
		   // If subtraction result is negative => quotient bit = '0'
			QT[k] = CT[k*(widthQ+3)+widthQ+2];

			// Restore previous partial remainder if quotient bit = '0'
			if (QT[k] == 1'b0) begin
				RT[k*(widthQ+3)+1+:widthQ+2] = RT[(k+1)*(widthQ+3)+:widthQ+2];
			end else begin
				RT[k*(widthQ+3)+1+:widthQ+2] = ST[k*(widthQ+2)+:widthQ+2];
			end 
		end
	end


	// Last partial remainder is division remainder
	assign Q = QT;
	assign R = RT[widthQ:1];

endmodule



module behavioural_SqrtArrUns #(
	parameter int widthX = 8
) (
	input  logic [widthX-1:0] X,  // operand
	output logic [(widthX+1)/2-1:0] Q,  // square root
	output logic [(widthX+1)/2-1:0] R  // remainder
);
	assign Q = $floor($sqrt(X));
	assign R = X - Q**2;
endmodule