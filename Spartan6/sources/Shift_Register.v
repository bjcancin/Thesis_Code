`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2015 15:57:21
// Design Name: 
// Module Name: Shift_Register
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


module Shift_Register(
    input clk,
    input load,
    input [23:0] word,
    output out,
    //output reg en,
    output rst,
    output lclk,
    output sclk,
    output done,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // clk : Clock del Shift Register (<=10 MHz).
    // load: Carga la palabra en el flanco de subida y debe permanecer en 1 durante todo el proceso.
    // word : Palabra a escribir y setear en el shift register.
    // out : salida serial. Comienza con el LSB y termina con el MSB
    // en : enable de las salidas (negado) Esta señal sera externa.
    // rst: reset de los ff (negado).
    // lclk: latch que setea los latch de salida.
    // sclk: shift clock.
    // done: señal de terminado. Se activa cuando terminó el proceso o cuando el modulo esta inactivo
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    parameter state_aux = 6'd50;
    
    reg [5:0] state_next = 6'b0;
    reg [5:0] state = 6'b0;
    reg [23:0] s_reg = 24'b0;
    
    ////////////////////
    // Estados Iniciales
    ////////////////////
    
    initial
    begin
    
    end
   
   ///////////// 
   // Simulacion
   /////////////
   
   assign aux = {10'b0, state};
    
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    always @(posedge clk)
    begin
        if(load == 1)
        begin
            if(state == 6'b0)
            begin
                s_reg <= word;
                state_next <= 6'd1;
                state <= state_aux;
            end
            
            else if(state == 6'd1)
            begin
                s_reg <= s_reg;
                state_next <= state_next;
                state <= 6'd2;
            end
            
            else if((state> 6'b1) && (state < 6'd48) && (state[0] == 1'b0))
            begin
                s_reg <= {1'b0,s_reg[23:1]};
                state_next <= state + 6'b1;
                state <= state_aux;
            end
            
            else if((state> 6'b1) && (state < 6'd48) && (state[0] == 1'b1))
            begin
                s_reg <= s_reg;
                state_next <= state_next;
                state <= state + 6'b1;
            end
            
            else if(state == 6'd48)
            begin
                s_reg <= s_reg;
                state_next <= state_next;
                state <= 6'd49;
            end
            
            else if(state == state_aux)
            begin
                s_reg <= s_reg;
                state_next <= state_next;
                state <= state_next;
            end
            
            else
            begin
                s_reg <= s_reg;
                state_next <= state_next;
                state <= 6'd49;    
            end
        end
        
        else
        begin
            s_reg <= 24'b0;
            state_next <= 6'b0;
            state <= 6'd0;
        end
    end
    
    assign rst = 1;
    assign out = s_reg[0];
    assign sclk = ((state[0] == 1'b1) && (state < 6'd48))?  1'b1 : 1'b0;
    assign lclk = ((state == 6'd48) || (state == 6'd49))?     1'b1 : 1'b0;
    
    assign done =   (state == 6'd49)?   1'b1 : 1'b0;
endmodule
