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
// Computes integer logarithm to base 2. 
// Z = floor(log A))
// Example: A = "00010110" -> Z = "100".

module Log2 #(
    parameter int width = 8,     // word width
    parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
    input logic [width-1:0] A,  // operand
    output logic [$clog2(width)-1:0] Z  // result
);

    logic [width-1:0] ZT;  // temp.

    // leading zero detection (i.e. most significant '1')
    LeadZeroDet #(width, speed) loz (
        .A(A),
        .Z(ZT)
    );

    // binary encode
    Encode #(width) enc (
        .A(ZT),
        .Z(Z)
    );

endmodule



module behavioural_Log2 #(
    parameter int width = 8,     // word width
    parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
    input logic [width-1:0] A,  // operand
    output logic [$clog2(width)-1:0] Z  // result
);
    always_comb begin
		Z = '0;
		for (int i = 0; i < width ; i++ ) begin
			if(A[i] == 1'b1) begin
				Z = i;
			end
		end
	end
endmodule