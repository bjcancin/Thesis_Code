`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2015 08:57:28
// Design Name: 
// Module Name: Comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Comparator2(
    input [15:0] a,
    input [15:0] b,
    output reg equal,
    output reg lower,
    output reg greater
    );

    always @* 
    begin
      if (a < b) 
      begin
        equal = 0;
        lower = 1;
        greater = 0;
      end
      else if (a==b) 
      begin
        equal = 1;
        lower = 0;
        greater = 0;
      end
      else 
      begin
        equal = 0;
        lower = 0;
        greater = 1;
      end
    end

endmodule
