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
// Should force the compiler to use a full-adder cell instead of simple logic
// gates. Otherwise, a full-adder cell of the target library has to be
// instantiated at this point (see second architecture).
// {CO,S} = A + B +CI

module FullAdder (
	input  logic A,
	input  logic B,
	input  logic CI,  // operands
	output logic S,
	output logic CO  // sum and carry out
);

	logic [1:0] Auns, Buns, CIuns, Suns;  // unsigned temp

	// type conversion: std_logic -> 2-bit unsigned
	assign Auns  = {1'b0, A};
	assign Buns  = {1'b0, B};
	assign CIuns = {1'b0, CI};

	// should force the compiler to use a full-adder cell
	assign Suns = Auns + Buns + CIuns;

	// type conversion: 2-bit unsigned -> std_logic
	assign {CO, S} = Suns;

endmodule


module behavioural_FullAdder (
	input  logic A,
	input  logic B,
	input  logic CI,  // operands
	output logic S,
	output logic CO  // sum and carry out
);
	assign {CO, S} = A + B + CI;
endmodule