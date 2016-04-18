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


module Clk_Divider4(
    input clk_in,
    input [15:0] divider,
    input en,
    output reg clk_out,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // divider debe ser mayor o igual a 2, sino la salida será nula.
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    reg [15:0] state_par = 16'b0;
    reg [15:0] state_impar = 16'b0;
    
    wire clk_en_par;
    wire clk_en_impar;
    
    wire result_par;
    wire result_par2;
    wire result_impar;
    wire result_impar2;
    
    wire [15:0] divdiv;
    
    ///////////
    // Modulos
    ///////////
    
    Comparator2 comparador_par(
        .a(state_par),
        .b(divider),
        .lower(result_par)    // a<b
    );
    
    Comparator2 comparador_par2(
        .a(state_par),
        .b(divdiv),
        .lower(result_par2)    // a<b
    );
    
    Comparator2 comparador_impar(
        .a(state_impar),
        .b(divider),
        .lower(result_impar)    // a < b
    );

    Comparator2 comparador_impar2(
        .a(state_impar),
        .b(divdiv),
        .lower(result_impar2)    // a < b
    );
    
    /////////////
    // Simulacion
    /////////////
    
    assign aux = {state_par[7:0], 7'b0, clk_out};
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign divdiv = {1'b0, divider[15:1]} + 16'b1; // division por 2

    assign clk_en_par = (result_par == 1'b0 || state_par == 16'b0)?     en  :   1'b1;
    assign clk_impar =  (result_impar == 1'b0 || state_impar == 16'b0)? en  :   1'b1; 
    
    always @(posedge clk_in)
    begin
        clk_out <= (divider[0])?    (result_par2 | result_impar2)   :   result_par2;
    end
    
    always @(posedge clk_in)
    begin
        if(clk_en_par)      state_par <= (result_par)?  (state_par + 16'b1) : 16'b1;
        else                state_par <= state_par;     
    end   

    always @(negedge clk_in)
    begin
        if(clk_en_impar)    state_impar <=  (result_impar)?  (state_impar + 16'b1) : 16'b1;
        else                state_impar <= state_impar;
    end
    
endmodule
