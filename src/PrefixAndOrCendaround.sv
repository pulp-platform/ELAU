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
// Prefix AND-OR structure with
//   - fast carry-in (CI)
//   - carry-out (CO) independent of carry-in (for end-around carry adders)

module PrefixAndOrCendaround #(
	parameter int unsigned width = 8,    // word width
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic [width-1:0] GI,
	input  logic [width-1:0] PI,  // gen./prop. in
	input  logic             CI,  // carry in
	output logic [width-1:0] GO,
	output logic [width-1:0] PO,  // gen./prop. out
	output logic             CO   // carry out
);

	logic [width-1:0] GT, PT;  // gen./prop. temp

	// normal prefix calculation
	PrefixAndOr #(
		.width(width),
		.speed(speed)
	) prefix_inst (
		.GI(GI),
		.PI(PI),
		.GO(GT),
		.PO(PT)
	);

	// carry-out
	assign CO = GT[width-1];
	// additional prefix calculation level for fast carry-in
	assign GO = GT | (PT & {{width - 1{CI}}});
	assign PO = PT;

endmodule
