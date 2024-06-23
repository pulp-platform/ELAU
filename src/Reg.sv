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
// Register for pipelining.

module Reg #(
        parameter int width = 8  // word width
) (
        input logic CLK,  // clock
        input logic RST,  // reset
        input logic [width-1:0] D,  // data input
        output logic [width-1:0] Q  // data output
);

    // purpose: memorizing process to register inputs
    always_ff @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Q <= '0;
        end else begin
            Q <= D;
        end
    end

endmodule
