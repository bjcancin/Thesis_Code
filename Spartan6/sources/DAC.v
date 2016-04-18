`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2015 09:06:40
// Design Name: 
// Module Name: DAC
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


module DAC(
    input clk,
    input en,
    input set,
    input [79:0] up,
    input [79:0] down,
    input [7:0] up_states,
    input [7:0] down_states,
    input [7:0] IDLE,
    output [7:0] out,
    output [7:0] aux
    );
    
    ///////////////
    // Comentarios
    //////////////
    
    // clk : Clock de entrada. La salida sera escrita a esta tasa. Lo mejor seria que se escribiera en el negado.
    // en : Señal que activa la salida del dac. En caso de que este en 0 este se quedara en un valor IDLE
    // set: señal de entrada que desencadena el modulo.
    // up : Estados de subida definidos por el ususario (max 10).
    // down : Estados de bajada definidos por el ususario (max 10).
    // up_states: numero de estados de subida + bajada (1 estado -> 1)
    // down_states: numero de estados de bajada (1 estado -> 1)
    
    // out: salida del modulo
        
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    parameter mid = 8'd10;
    
    reg [7:0] state = 0;
    wire clk_en;
    wire [7:0] state_next;
    
    wire up_result;
    wire down_result;
    wire mid_result;
    
    wire [7:0] down_aux;
    wire [7:0] up_aux;
    
    //////////
    // Modulos
    //////////
    
    Comparator up_comp(
        .a(state),
        .b(up_aux),
        .lower(up_result)
        );
        
    Comparator down_comp(
        .a(state),
        .b(down_aux),
        .lower(down_result)
        );
    
    ////////////////////
    // Simulacion
    ////////////////////
    
    //assign aux = {5'b0 , down_result, mid_result, up_result};
    //assign aux = state;
    //assign aux = {7'b0, clk_en};
    assign aux = down_aux;
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign mid_result = (state < mid)?      1'b1 : 1'b0;
    
    assign up_aux = up_states - 8'b1;
    
    assign down_aux = down_states + 8'd9;  
    
    assign  state_next = ((up_result == 0) && (down_result == 0) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 0) && (mid_result == 1))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 1) && (mid_result == 0))?      (state + 8'b1)  :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 1) && (mid_result == 1))?      8'd10           :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 0) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 0) && (mid_result == 1))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 1) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 1) && (mid_result == 1))?      (state + 8'b1)  :   8'bzzzz_zzzz;
            
    assign  clk_en = ((up_result == 1) && (set == 0) && (en == 1))?                             1'b0 : 1'bz,
            clk_en = ((up_result == 1) && (set == 1) && (en == 1))?                             1'b1 : 1'bz,
            
            clk_en = ((up_result == 0) && (down_result == 1) && (set == 0) && (en == 1))?       1'b1 : 1'bz,
            clk_en = ((up_result == 0) && (down_result == 1) && (set == 1) && (en == 1))?       1'b0 : 1'bz,
            clk_en = ((up_result == 0) && (down_result == 0) && (set == 0) && (en == 1))?       1'b0 : 1'bz,
            clk_en = ((up_result == 0) && (down_result == 0) && (set == 1) && (en == 1))?       1'b1 : 1'bz,            
            
            clk_en = (en == 0)?                                                                 1'b0 : 1'bz;   
            
    assign  out = ((state == 8'd0) && (en == 1))?       up[7:0]         :       8'bzzzz_zzzz,
            out = ((state == 8'd1) && (en == 1))?       up[15:8]        :       8'bzzzz_zzzz,
            out = ((state == 8'd2) && (en == 1))?       up[23:16]       :       8'bzzzz_zzzz,
            out = ((state == 8'd3) && (en == 1))?       up[31:24]       :       8'bzzzz_zzzz,
            out = ((state == 8'd4) && (en == 1))?       up[39:32]       :       8'bzzzz_zzzz,
            out = ((state == 8'd5) && (en == 1))?       up[47:40]       :       8'bzzzz_zzzz,
            out = ((state == 8'd6) && (en == 1))?       up[55:48]       :       8'bzzzz_zzzz,
            out = ((state == 8'd7) && (en == 1))?       up[63:56]       :       8'bzzzz_zzzz,
            out = ((state == 8'd8) && (en == 1))?       up[71:64]       :       8'bzzzz_zzzz,
            out = ((state == 8'd9) && (en == 1))?       up[79:72]       :       8'bzzzz_zzzz,
            
            out = ((state == 8'd10) && (en == 1))?      down[7:0]       :       8'bzzzz_zzzz,
            out = ((state == 8'd11) && (en == 1))?      down[15:8]      :       8'bzzzz_zzzz,
            out = ((state == 8'd12) && (en == 1))?      down[23:16]     :       8'bzzzz_zzzz,
            out = ((state == 8'd13) && (en == 1))?      down[31:24]     :       8'bzzzz_zzzz,
            out = ((state == 8'd14) && (en == 1))?      down[39:32]     :       8'bzzzz_zzzz,
            out = ((state == 8'd15) && (en == 1))?      down[47:40]     :       8'bzzzz_zzzz,
            out = ((state == 8'd16) && (en == 1))?      down[55:48]     :       8'bzzzz_zzzz,
            out = ((state == 8'd17) && (en == 1))?      down[63:56]     :       8'bzzzz_zzzz,
            out = ((state == 8'd18) && (en == 1))?      down[71:64]     :       8'bzzzz_zzzz,
            out = ((state >= 8'd19) && (en == 1))?      down[79:72]     :       8'bzzzz_zzzz,
            
            out = (en == 0)?                            IDLE            :       8'bzzzz_zzzz;                            
                                       
    
    always @(posedge clk)
    begin
        if(clk_en)
            state <= state_next;
        else
            state <= state;
    end
    
    
endmodule
