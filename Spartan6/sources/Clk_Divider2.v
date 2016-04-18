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


module Clk_Divider2(
    input clk_in,
    input [15:0] divider,
    input en,
    output clk_out,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // La division es 2*divider
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    reg [15:0] state_par = 16'b0;
    reg [15:0] state_impar = 16'b0;
    
    reg clk_en_par;
    reg clk_en_impar;
    
    reg clk_par = 1'b0;
    reg clk_impar = 1'b0;
    
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
   
    //assign clk_impar =  (result_par2 || result_impar2)?     1'b1    :   1'b0;
    //assign clk_par =    (result_par2)?     1'b1    :   1'b0;
    
    always @(posedge clk_in)
    begin
        clk_impar <= result_par2 | result_impar2;
        clk_par <= result_par2;
    end
    
        
    assign divdiv = {1'b0, divider[15:1]} + 16'b1; // division por 2
    
    always @*
    begin
        if(result_par == 1'b0 || state_par == 16'b0)    clk_en_par = en;
        else                                            clk_en_par = 1'b1;      
    end
    
    always @*
    begin
        if(result_impar == 1'b0 || state_impar == 16'b0)    clk_en_impar = en;
        else                                                clk_en_impar = 1'b1;      
    end
    
    assign  clk_out = (divider <= 16'd1)?                            (clk_in & en)      :   1'bz,
            clk_out = ((divider > 16'd1) && (divider[0] == 1'b0))?   clk_par            :   1'bz,
            clk_out = ((divider > 16'd1) && (divider[0] == 1'b1))?   clk_impar          :   1'bz;
            
    
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
