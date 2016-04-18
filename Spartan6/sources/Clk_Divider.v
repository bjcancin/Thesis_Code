`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2015 13:32:33
// Design Name: 
// Module Name: Clk_Divider
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


module Clk_Divider(
    input clk_in,
    input [7:0] divider,
    output clk_out,
    output [7:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // La division es 2*divider
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    reg [7:0] state_par = 8'b0;
    reg [7:0] state_impar = 8'b0;
    
    wire clk_par;
    wire clk_impar;
    
    wire result_par;
    wire result_par2;
    wire result_impar;
    wire result_impar2;
    
    wire [7:0] divdiv;
    
    ///////////
    // Modulos
    ///////////
    
    Comparator comparador_par(
        .a(state_par),
        .b(divider),
        .lower(result_par)    // a<b
    );
    
    Comparator comparador_par2(
        .a(state_par),
        .b(divdiv),
        .lower(result_par2)    // a<b
    );
    
    Comparator comparador_impar(
        .a(state_impar),
        .b(divider),
        .lower(result_impar)    // a < b
    );

    Comparator comparador_impar2(
        .a(state_impar),
        .b(divdiv),
        .lower(result_impar2)    // a < b
    );
    
    /////////////
    // Simulacion
    /////////////
    
    assign clk_impar =  (result_par2 || result_impar2)?     1'b1    :   1'b0;
    assign clk_par =    (result_par2)?     1'b1    :   1'b0;
    
    //assign aux = state_impar;
    //assign aux = {3'b0, result_par2, 3'b0, result_impar2};
    assign aux = {state_par[3:0], state_impar[3:0]};
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
   
    assign divdiv = {1'b0, divider[7:1]} + 8'b1; // division por 2
    
    
    
    assign  clk_out = (divider <= 8'd1)?                            clk_in      :   1'bz,
            clk_out = ((divider > 8'd1) && (divider[0] == 1'b0))?   clk_par     :   1'bz,
            clk_out = ((divider > 8'd1) && (divider[0] == 1'b1))?   clk_impar   :   1'bz;
            
    
    always @(posedge clk_in)
    begin
        state_par <= (result_par)?  (state_par + 8'b1) : 8'b1;     
    end

    always @(negedge clk_in)
    begin
        state_impar <=  (result_impar)?  (state_impar + 8'b1) : 8'b1;
    end
    
endmodule
