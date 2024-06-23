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
// Decodes a binary number into a vector with a '1' at the according position.
// Z = 1'b1 << A
// Examples: A = "101" -> Z = "00100000".

module Decode #(
	parameter int width = 8  // word width
) (
	input  logic [($clog2(width)-1):0] A,  // encoded input
	output logic [          width-1:0] Z   // output vector
);

	integer Aint;  // integer

	// type conversion: std_logic_vector -> integer
	assign Aint = A;

	// decoding
	for (genvar i = 0; i < width; i++) begin : dec
		assign Z[i] = (Aint == i) ? 1'b1 : 1'b0;
	end

endmodule



module behavioural_Decode #(
	parameter int width = 8  // word width
) (
	input  logic [($clog2(width)-1):0] A,  // encoded input
	output logic [          width-1:0] Z   // output vector
);
	assign Z = 1 << A;
endmodule