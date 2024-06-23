////////////////////////////////////////////////////////////////////////////////
// Title       : Signed adder-multiplier
// Project     : VHDL Library of Arithmetic Units
////////////////////////////////////////////////////////////////////////////////
// File        : AddMulSgn.sv
// Author      : Reto Zimmermann  <zimmi@iis.ee.ethz.ch>
// Company     : Integrated Systems Laboratory, ETH Zurich
// Date        : 1997/11/19
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1998 Integrated Systems Laboratory, ETH Zurich
////////////////////////////////////////////////////////////////////////////////
// Description :
// Adder-multiplier for signed numbers (Brown). First adds two numbers, then
// multiplies the result with the multiplicand. Can be used for multiplication
// with an input operand in carry-save number format. Result is only valid if
// sum does not overflow.
// P = (XS+XC)*Y
////////////////////////////////////////////////////////////////////////////////

module AddMulSgn #(
	parameter int widthX = 8,     // word width of XS, XC (<= widthY)
	parameter int widthY = 8,     // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input logic [widthX-1:0] XS,  // multipliers
	input logic [widthX-1:0] XC,
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);

	logic [(widthX+1)*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthX+widthY-1:0] ST, CT;  // intermediate sum/carry bits

	// generation of partial products
	AddMulPPGenSgn #(
		.widthX(widthX),
		.widthY(widthY)
	) ppGen (
		.XS(XS),
		.XC(XC),
		.Y (Y),
		.PP(PP)
	);

	// carry-save addition of partial products
	AddMopCsv #(
		.width(widthX + widthY),
		.depth(widthX + 1),
		.speed(speed)
	) csvAdd (
		.A(PP),
		.S(ST),
		.C(CT)
	);

	// final carry-propagate addition
	Add #(
		.width(widthX + widthY),
		.speed(speed)
	) cpAdd (
		.A(ST),
		.B(CT),
		.S(P)
	);

endmodule



module behavioural_AddMulSgn #(
	parameter int widthX = 8,     // word width of XS, XC (<= widthY)
	parameter int widthY = 8,     // word width of Y
	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
) (
	input  logic signed [widthX-1:0] XS,  // multipliers
	input  logic signed [widthX-1:0] XC,
	input  logic signed [widthY-1:0] Y,  // multiplicand
	output logic signed [widthX+widthY-1:0] P  // product
);
	assign P = (XS + XC) * Y;
endmodule